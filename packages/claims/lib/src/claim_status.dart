/// Estados de la máquina de reclamos (SOP §6.3, `flujo-arrendamiento.md`).
///
/// ```text
/// CREADO ──► EN_REVISION ──► ACEPTADO ──► RESUELTO
///               │  ▲            (evidencia)
///               │  │ DISPUTADO ──► MEDIACION ──► RESUELTO
///               │  │                              └────► ESCALADO
///               └──┴──► ESCALADO ──► CALIFICACION_NEGATIVA (automática)
///                  (timeout 5 días / mediación fallida)
/// ```
///
/// Contrato compartido con HAB-40 (UI): los valores serializan con estos
/// mismos nombres.
enum ClaimStatus {
  /// Reclamo creado con fotos + descripción, aún no enviado a revisión.
  creado,

  /// Contraparte notificada. Tiene 5 días para responder.
  enRevision,

  /// La contraparte reconoce responsabilidad. Falta la reparación.
  aceptado,

  /// La contraparte rechaza. Pasa a mediación.
  disputado,

  /// Mediador neutral asignado.
  mediacion,

  /// Sin respuesta en plazo o mediación fallida. Penaliza reputación.
  escalado,

  /// Reparación/corrección verificada con evidencia fotográfica.
  resuelto,

  /// Calificación negativa automática tras escalamiento por silencio.
  calificacionNegativa,
}
