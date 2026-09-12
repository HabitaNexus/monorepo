import 'package:freezed_annotation/freezed_annotation.dart';

import 'claim_direction.dart';
import 'claim_status.dart';

export 'claim_causes.dart';
export 'claim_direction.dart';
export 'claim_status.dart';

part 'claim.freezed.dart';
part 'claim.g.dart';

/// Actor que ejecuta una transición.
enum ClaimActor {
  /// Quien abrió el reclamo.
  reclamante,

  /// La contraparte notificada.
  contraparte,

  /// Evento del sistema (timeout, calificación automática).
  sistema,

  /// Mediador neutral asignado.
  mediador,
}

/// Registro inmutable de una transición aplicada.
@freezed
class ClaimTransition with _$ClaimTransition {
  const factory ClaimTransition({
    required ClaimStatus from,
    required ClaimStatus to,
    required DateTime at,
    required ClaimActor actor,
    String? reason,
  }) = _ClaimTransition;

  factory ClaimTransition.fromJson(Map<String, dynamic> json) =>
      _$ClaimTransitionFromJson(json);
}

/// Entidad `Claim`: reclamo bidireccional con máquina de estados (HAB-39).
///
/// Invariantes que valida [ClaimMachine]:
/// - la causa pertenece al catálogo de la dirección;
/// - hay fotos al crear y evidencia al resolver;
/// - solo se permiten las transiciones del SOP §6.3.
@freezed
class Claim with _$Claim {
  const Claim._();

  @JsonSerializable(explicitToJson: true)
  const factory Claim({
    /// Identificador interno (uuid de la capa de persistencia).
    required String id,

    /// Código de seguimiento único y legible ([ClaimTrackingCode]).
    required String trackingCode,

    /// Dirección del reclamo.
    required ClaimDirection direction,

    /// Causa del catálogo correspondiente a [direction].
    required String cause,

    /// Descripción del problema.
    required String description,

    /// Estado actual de la máquina.
    @Default(ClaimStatus.creado) ClaimStatus status,

    /// Fotos adjuntadas al crear (obligatorias).
    @Default([]) List<String> photos,

    /// Evidencia fotográfica de la reparación (obligatoria al resolver).
    @Default([]) List<String> resolutionPhotos,

    /// Creación del reclamo.
    required DateTime createdAt,

    /// Inicio de EN_REVISION (contraparte notificada). Base del plazo.
    DateTime? reviewStartedAt,

    /// Cierre (RESUELTO o CALIFICACION_NEGATIVA).
    DateTime? closedAt,

    /// Historial de transiciones aplicadas, en orden.
    @Default([]) List<ClaimTransition> history,
  }) = _Claim;

  factory Claim.fromJson(Map<String, dynamic> json) => _$ClaimFromJson(json);

  /// Días de plazo de respuesta una vez notificada la contraparte (SOP §6.3).
  static const int responseDeadlineDays = 5;

  /// Fecha límite de respuesta, o `null` si aún no entró a revisión.
  DateTime? get responseDueDate =>
      reviewStartedAt?.add(const Duration(days: responseDeadlineDays));

  /// `true` si está en revisión y venció el plazo a las [now].
  bool isResponseOverdue(DateTime now) {
    final DateTime? due = responseDueDate;
    return status == ClaimStatus.enRevision && due != null && now.isAfter(due);
  }

  /// `true` si el reclamo está cerrado (terminal).
  bool get isClosed =>
      status == ClaimStatus.resuelto ||
      status == ClaimStatus.calificacionNegativa;
}
