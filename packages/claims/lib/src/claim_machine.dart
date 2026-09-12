import 'claim.dart';
import 'claim_tracking_code.dart';

/// Máquina de estados de reclamos (SOP §6.3). Funciones puras: el reloj
/// se inyecta como [now] para que el timeout sea testeable y el job
/// de escalamiento sea idempotente.
abstract final class ClaimMachine {
  /// Transiciones permitidas por estado.
  static const Map<ClaimStatus, Set<ClaimStatus>> allowed = {
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

  /// `true` si la transición [from] → [to] es legal.
  static bool canTransition(ClaimStatus from, ClaimStatus to) =>
      allowed[from]?.contains(to) ?? false;

  /// Crea un reclamo en CREADO validando causa, descripción y fotos.
  static Claim create({
    required String id,
    required ClaimDirection direction,
    required String cause,
    required String description,
    required List<String> photos,
    required DateTime now,
    String? trackingCode,
  }) {
    if (!ClaimCauses.isValid(direction, cause)) {
      throw ArgumentError.value(
        cause,
        'cause',
        'no pertenece al catálogo de $direction',
      );
    }
    if (description.trim().isEmpty) {
      throw ArgumentError.value(
        description,
        'description',
        'la descripción es obligatoria',
      );
    }
    if (photos.isEmpty) {
      throw ArgumentError.value(
        photos,
        'photos',
        'se requiere al menos una foto al crear',
      );
    }
    return Claim(
      id: id,
      trackingCode: trackingCode ?? ClaimTrackingCode.generate(),
      direction: direction,
      cause: cause,
      description: description,
      photos: List.unmodifiable(photos),
      createdAt: now,
    );
  }

  /// Aplica la transición [to] sobre [claim] validando guardas del dominio.
  ///
  /// Lanza [StateError] si la transición es ilegal y [ArgumentError] si
  /// faltan requisitos (evidencia de resolución, mediador, etc.).
  /// [actor] por defecto es la contraparte; las transiciones del sistema
  /// (timeout) deben pasar [ClaimActor.sistema] explícitamente.
  static Claim transition(
    Claim claim,
    ClaimStatus to, {
    required DateTime now,
    ClaimActor actor = ClaimActor.contraparte,
    String? reason,
    List<String>? resolutionPhotos,
  }) {
    if (!canTransition(claim.status, to)) {
      throw StateError(
        'Transición ilegal: ${claim.status.name} → ${to.name}',
      );
    }
    if (to == ClaimStatus.resuelto) {
      final List<String> evidence = resolutionPhotos ?? claim.resolutionPhotos;
      if (evidence.isEmpty) {
        throw ArgumentError.value(
          resolutionPhotos,
          'resolutionPhotos',
          'resolver exige evidencia fotográfica de la reparación',
        );
      }
      return _apply(
        claim,
        to,
        now: now,
        actor: actor,
        reason: reason,
        resolutionPhotos: List.unmodifiable(evidence),
        closedAt: now,
      );
    }
    if (to == ClaimStatus.escalado && actor != ClaimActor.sistema) {
      throw ArgumentError.value(
        actor,
        'actor',
        'escalar exige actor de sistema (timeout o mediación fallida)',
      );
    }
    return _apply(
      claim,
      to,
      now: now,
      actor: actor,
      reason: reason,
      reviewStartedAt:
          to == ClaimStatus.enRevision ? now : claim.reviewStartedAt,
      closedAt: to == ClaimStatus.calificacionNegativa ? now : claim.closedAt,
    );
  }

  /// Escalamiento por timeout: EN_REVISION vencido → ESCALADO →
  /// CALIFICACION_NEGATIVA en un paso atómico con historial completo.
  ///
  /// Idempotente: si [claim] no está vencido en revisión, lo devuelve
  /// sin cambios.
  static Claim applyTimeout(Claim claim, {required DateTime now}) {
    if (!claim.isResponseOverdue(now)) {
      return claim;
    }
    Claim escalated = _apply(
      claim,
      ClaimStatus.escalado,
      now: now,
      actor: ClaimActor.sistema,
      reason: 'timeout de ${Claim.responseDeadlineDays} días sin respuesta',
    );
    escalated = _apply(
      escalated,
      ClaimStatus.calificacionNegativa,
      now: now,
      actor: ClaimActor.sistema,
      reason: 'calificación negativa automática por silencio',
      closedAt: now,
    );
    return escalated;
  }

  static Claim _apply(
    Claim claim,
    ClaimStatus to, {
    required DateTime now,
    required ClaimActor actor,
    String? reason,
    List<String>? resolutionPhotos,
    DateTime? reviewStartedAt,
    DateTime? closedAt,
  }) {
    return claim.copyWith(
      status: to,
      resolutionPhotos: resolutionPhotos ?? claim.resolutionPhotos,
      reviewStartedAt: reviewStartedAt ?? claim.reviewStartedAt,
      closedAt: closedAt ?? claim.closedAt,
      history: [
        ...claim.history,
        ClaimTransition(
          from: claim.status,
          to: to,
          at: now,
          actor: actor,
          reason: reason,
        ),
      ],
    );
  }
}
