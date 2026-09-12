import 'dart:math';

import 'package:claims/claims.dart';
import 'package:test/test.dart';

Claim _baseClaim({DateTime? now}) => ClaimMachine.create(
      id: 'test-1',
      direction: ClaimDirection.inquilinoAPropietario,
      cause: 'fugas_reventaduras',
      description: 'Fuga bajo el lavamanos',
      photos: const ['foto1.jpg'],
      now: now ?? DateTime.utc(2026, 1, 1),
      trackingCode: 'RCL-ABCDEF',
    );

Claim _inReview({DateTime? now}) {
  final DateTime at = now ?? DateTime.utc(2026, 1, 1);
  return ClaimMachine.transition(_baseClaim(now: at), ClaimStatus.enRevision,
      now: at, actor: ClaimActor.reclamante);
}

void main() {
  group('create', () {
    test('crea en CREADO con código y fotos', () {
      final Claim claim = _baseClaim();
      expect(claim.status, ClaimStatus.creado);
      expect(claim.trackingCode, 'RCL-ABCDEF');
      expect(claim.photos, ['foto1.jpg']);
      expect(claim.history, isEmpty);
      expect(claim.isClosed, isFalse);
    });

    test('rechaza causa fuera del catálogo de la dirección', () {
      expect(
        () => ClaimMachine.create(
          id: 'x',
          direction: ClaimDirection.inquilinoAPropietario,
          cause: 'ruido', // causa de la dirección contraria
          description: 'd',
          photos: const ['f.jpg'],
          now: DateTime.utc(2026, 1, 1),
        ),
        throwsArgumentError,
      );
    });

    test('rechaza sin fotos y sin descripción', () {
      expect(
        () => ClaimMachine.create(
          id: 'x',
          direction: ClaimDirection.propietarioAInquilino,
          cause: 'ruido',
          description: '  ',
          photos: const ['f.jpg'],
          now: DateTime.utc(2026, 1, 1),
        ),
        throwsArgumentError,
      );
      expect(
        () => ClaimMachine.create(
          id: 'x',
          direction: ClaimDirection.propietarioAInquilino,
          cause: 'ruido',
          description: 'Ruido nocturno',
          photos: const [],
          now: DateTime.utc(2026, 1, 1),
        ),
        throwsArgumentError,
      );
    });
  });

  group('happy paths (SOP §6.3)', () {
    test('CREADO → EN_REVISION → ACEPTADO → RESUELTO', () {
      final DateTime t0 = DateTime.utc(2026, 1, 1);
      Claim claim = ClaimMachine.transition(
        _baseClaim(now: t0),
        ClaimStatus.enRevision,
        now: t0,
        actor: ClaimActor.reclamante,
      );
      expect(claim.status, ClaimStatus.enRevision);
      expect(claim.reviewStartedAt, t0);
      expect(claim.responseDueDate, t0.add(const Duration(days: 5)));
      expect(claim.history, hasLength(1));

      claim = ClaimMachine.transition(claim, ClaimStatus.aceptado,
          now: t0.add(const Duration(days: 1)));
      expect(claim.status, ClaimStatus.aceptado);

      claim = ClaimMachine.transition(
        claim,
        ClaimStatus.resuelto,
        now: t0.add(const Duration(days: 2)),
        resolutionPhotos: const ['reparacion.jpg'],
      );
      expect(claim.status, ClaimStatus.resuelto);
      expect(claim.resolutionPhotos, ['reparacion.jpg']);
      expect(claim.isClosed, isTrue);
      expect(claim.history, hasLength(3));
    });

    test('EN_REVISION → DISPUTADO → MEDIACION → RESUELTO', () {
      final DateTime t0 = DateTime.utc(2026, 1, 1);
      Claim claim = _inReview(now: t0);
      claim = ClaimMachine.transition(claim, ClaimStatus.disputado,
          now: t0.add(const Duration(days: 1)), reason: 'No reconoce');
      claim = ClaimMachine.transition(claim, ClaimStatus.mediacion,
          now: t0.add(const Duration(days: 2)),
          actor: ClaimActor.sistema,
          reason: 'mediador asignado');
      claim = ClaimMachine.transition(
        claim,
        ClaimStatus.resuelto,
        now: t0.add(const Duration(days: 3)),
        actor: ClaimActor.mediador,
        resolutionPhotos: const ['acuerdo.jpg'],
      );
      expect(claim.status, ClaimStatus.resuelto);
      expect(claim.history.map((ClaimTransition t) => t.to).toList(), [
        ClaimStatus.enRevision,
        ClaimStatus.disputado,
        ClaimStatus.mediacion,
        ClaimStatus.resuelto,
      ]);
    });

    test('MEDIACION fallida → ESCALADO (sistema) → CALIFICACION_NEGATIVA', () {
      final DateTime t0 = DateTime.utc(2026, 1, 1);
      Claim claim = _inReview(now: t0);
      claim = ClaimMachine.transition(claim, ClaimStatus.disputado,
          now: t0.add(const Duration(days: 1)));
      claim = ClaimMachine.transition(claim, ClaimStatus.mediacion,
          now: t0.add(const Duration(days: 2)), actor: ClaimActor.sistema);
      // La contraparte no puede escalar directamente.
      expect(
        () => ClaimMachine.transition(claim, ClaimStatus.escalado,
            now: t0.add(const Duration(days: 3))),
        throwsArgumentError,
      );
      claim = ClaimMachine.transition(claim, ClaimStatus.escalado,
          now: t0.add(const Duration(days: 3)),
          actor: ClaimActor.sistema,
          reason: 'mediación no exitosa');
      claim = ClaimMachine.transition(
        claim,
        ClaimStatus.calificacionNegativa,
        now: t0.add(const Duration(days: 3)),
        actor: ClaimActor.sistema,
      );
      expect(claim.status, ClaimStatus.calificacionNegativa);
      expect(claim.isClosed, isTrue);
    });
  });

  group('transiciones ilegales', () {
    test('todas las combinaciones fuera de la tabla lanzan StateError', () {
      const Map<ClaimStatus, Set<ClaimStatus>> legal = {
        ClaimStatus.creado: {ClaimStatus.enRevision},
        ClaimStatus.enRevision: {
          ClaimStatus.aceptado,
          ClaimStatus.disputado,
          ClaimStatus.escalado,
        },
        ClaimStatus.aceptado: {ClaimStatus.resuelto},
        ClaimStatus.disputado: {ClaimStatus.mediacion},
        ClaimStatus.mediacion: {ClaimStatus.resuelto, ClaimStatus.escalado},
        ClaimStatus.escalado: {ClaimStatus.calificacionNegativa},
        ClaimStatus.resuelto: {},
        ClaimStatus.calificacionNegativa: {},
      };
      for (final ClaimStatus from in ClaimStatus.values) {
        for (final ClaimStatus to in ClaimStatus.values) {
          expect(
            ClaimMachine.canTransition(from, to),
            legal[from]!.contains(to),
            reason: '${from.name} → ${to.name}',
          );
        }
      }
      // Casos representativos del SOP: sin saltos.
      expect(
          ClaimMachine.canTransition(ClaimStatus.creado, ClaimStatus.resuelto),
          isFalse);
      expect(
          ClaimMachine.canTransition(
              ClaimStatus.aceptado, ClaimStatus.mediacion),
          isFalse);
      expect(
          ClaimMachine.canTransition(
              ClaimStatus.resuelto, ClaimStatus.enRevision),
          isFalse);
    });

    test('resolver sin evidencia fotográfica lanza ArgumentError', () {
      final Claim claim = ClaimMachine.transition(
        _inReview(),
        ClaimStatus.aceptado,
        now: DateTime.utc(2026, 1, 2),
      );
      expect(
        () => ClaimMachine.transition(claim, ClaimStatus.resuelto,
            now: DateTime.utc(2026, 1, 3)),
        throwsArgumentError,
      );
    });
  });

  group('timeout de 5 días', () {
    test('vence a los 5 días exactos y escala con historial completo', () {
      final DateTime t0 = DateTime.utc(2026, 1, 1);
      final Claim claim = _inReview(now: t0);
      expect(claim.isResponseOverdue(t0.add(const Duration(days: 5))), isFalse);
      final DateTime late = t0.add(const Duration(days: 5, seconds: 1));
      expect(claim.isResponseOverdue(late), isTrue);

      final Claim closed = ClaimMachine.applyTimeout(claim, now: late);
      expect(closed.status, ClaimStatus.calificacionNegativa);
      expect(closed.isClosed, isTrue);
      expect(
        closed.history.map((ClaimTransition t) => t.to).toList(),
        [
          ClaimStatus.enRevision,
          ClaimStatus.escalado,
          ClaimStatus.calificacionNegativa,
        ],
      );
      expect(
        closed.history
            .every((ClaimTransition t) => t.actor == ClaimActor.sistema),
        // la primera transición (a revisión) la hizo el reclamante
        isFalse,
      );
      expect(closed.history.last.actor, ClaimActor.sistema);
    });

    test('idempotente: sin vencimiento devuelve el mismo reclamo', () {
      final DateTime t0 = DateTime.utc(2026, 1, 1);
      final Claim claim = _inReview(now: t0);
      final Claim same = ClaimMachine.applyTimeout(
        claim,
        now: t0.add(const Duration(days: 2)),
      );
      expect(identical(same, claim), isTrue);
    });

    test('idempotente: ya cerrado no cambia', () {
      final DateTime t0 = DateTime.utc(2026, 1, 1);
      final Claim closed = ClaimMachine.applyTimeout(
        _inReview(now: t0),
        now: t0.add(const Duration(days: 10)),
      );
      final Claim again = ClaimMachine.applyTimeout(closed,
          now: t0.add(const Duration(days: 20)));
      expect(identical(again, closed), isTrue);
    });
  });

  group('tracking code', () {
    test('formato RCL-XXXXXX sin caracteres ambiguos', () {
      final Random rng = Random(42);
      for (int i = 0; i < 200; i++) {
        final String code = ClaimTrackingCode.generate(random: rng);
        expect(ClaimTrackingCode.isValid(code), isTrue, reason: code);
        expect(code.substring(4).contains(RegExp('[01ILO]')), isFalse);
      }
    });

    test('unicidad en la práctica', () {
      final Set<String> codes = {
        for (int i = 0; i < 1000; i++) ClaimTrackingCode.generate()
      };
      expect(codes, hasLength(1000));
    });
  });

  group('serialización (contrato HAB-40)', () {
    test('round-trip JSON preserva estados con nombres del SOP', () {
      final Claim claim = ClaimMachine.transition(
        _inReview(),
        ClaimStatus.disputado,
        now: DateTime.utc(2026, 1, 2),
        reason: 'rechaza',
      );
      final Map<String, dynamic> json = claim.toJson();
      expect(json['status'], 'disputado');
      expect(json['direction'], 'inquilinoAPropietario');
      final Claim restored = Claim.fromJson(json);
      expect(restored.status, ClaimStatus.disputado);
      expect(restored.history, hasLength(2));
    });
  });
}
