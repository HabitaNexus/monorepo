import 'package:flutter_test/flutter_test.dart';
import 'package:habitanexus_mobile/features/negotiation/data/demo_negotiation.dart';
import 'package:habitanexus_mobile/features/negotiation/data/terms_mapping.dart';
import 'package:habitanexus_mobile/features/negotiation/domain/negotiation.dart';
import 'package:habitanexus_mobile/features/negotiation/domain/negotiation_rules.dart';

List<RowSpec> specs() => kTermsMapping
    .map((m) => RowSpec(
        number: m.number,
        apiKey: m.apiKey,
        lenient: DemoNegotiation.lenientRows.contains(m.number)))
    .toList();

void main() {
  group('terms_mapping', () {
    test('tiene 34 filas numeradas 1..34 sin duplicados', () {
      expect(kTermsMapping, hasLength(34));
      final numbers = kTermsMapping.map((m) => m.number).toList()
        ..sort();
      expect(numbers, List.generate(34, (i) => i + 1));
    });

    test('respeta los conteos por grupo 4/3/5/7/6/4/5', () {
      for (final g in NegotiationTermGroup.values) {
        final count =
            kTermsMapping.where((m) => m.group == g).length;
        expect(count, g.expectedTerms, reason: g.title);
      }
    });

    test('toda apiKey usada existe en el catálogo del backend', () {
      for (final m in kTermsMapping) {
        expect(kApiTermsCatalog, contains(m.apiKey),
            reason: 'fila ${m.number} (${m.uiLabel})');
      }
    });

    test('las 5 fijas SOP son de solo lectura con referencia', () {
      final fixed =
          kTermsMapping.where((m) => m.isFixed).toList();
      expect(fixed, hasLength(5));
      for (final m in fixed) {
        expect(m.sopRef, isNotNull);
        expect(m.group, NegotiationTermGroup.fijas);
      }
    });

    test('keys sin fila demo están documentadas', () {
      expect(kApiKeysWithoutDemoRow.keys,
          containsAll(['moneda', 'fecha_fin', 'penalidad_mora']));
    });
  });

  group('compareRows (demo del diseño)', () {
    test('detecta los 8 DIFF del HTML y 26 acuerdos', () {
      final detail = DemoNegotiation.detail();
      final rows = compareRows(detail, specs());
      final diffs =
          rows.where((r) => r.isDiff).map((r) => r.number).toSet();
      expect(diffs, {1, 2, 7, 8, 12, 13, 24, 27});
      expect(countDiffs(rows), 8);
    });

    test('filas 16 y 21 son acuerdo pese a textos distintos', () {
      final detail = DemoNegotiation.detail();
      final rows = compareRows(detail, specs());
      expect(rows.firstWhere((r) => r.number == 16).isDiff, isFalse);
      expect(rows.firstWhere((r) => r.number == 21).isDiff, isFalse);
    });
  });

  group('negotiation_rules', () {
    NegotiationState open({int round = 3, DateTime? deadline}) =>
        NegotiationState(
            status: NegotiationStatus.contrapropuesta,
            round: round,
            deadline: deadline ??
                DateTime.now().add(const Duration(hours: 1)));

    test('canActOnRound solo en ronda abierta y vigente', () {
      final now = DateTime.now();
      expect(canActOnRound(open(), now), isTrue);
      expect(
          canActOnRound(
              open(deadline: now.subtract(const Duration(minutes: 1))),
              now),
          isFalse);
      expect(
          canActOnRound(
              NegotiationState(
                  status: NegotiationStatus.acuerdoAlcanzado,
                  round: 3,
                  deadline:
                      DateTime.now().add(const Duration(hours: 1))),
              now),
          isFalse);
    });

    test('turnLabel no inventa turno sin último redactor', () {
      final label = turnLabel(
          state: open(),
          role: NegotiationParty.tenant,
          lastAuthor: null);
      expect(label, 'Turno: por responder');
      expect(
          turnLabel(
              state: open(),
              role: NegotiationParty.tenant,
              lastAuthor: NegotiationParty.owner),
          'Turno: Tu decisión');
    });

    test('computeEscrow: canon + 1 mes + 1.5%', () {
      final b = computeEscrow(canon: 495000);
      expect(b.deposito, 495000);
      expect(b.comision, 7425);
      expect(b.total, 997425);
    });

    test('shouldShowLegalNotice bajo 36 meses', () {
      expect(shouldShowLegalNotice(12), isTrue);
      expect(shouldShowLegalNotice(36), isFalse);
      expect(shouldShowLegalNotice(null), isFalse);
      expect(parsePlazoMeses('12 meses forzosos'), 12);
    });

    test('parseMonto y formatColones', () {
      expect(parseMonto('₡495,000'), 495000);
      expect(formatColones(997425), '₡997,425');
    });
  });
}
