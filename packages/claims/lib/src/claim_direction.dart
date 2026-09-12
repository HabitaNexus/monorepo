/// Dirección del reclamo. Ambas usan la misma máquina con catálogos
/// de causa distintos (Cláusulas DÉCIMA TERCERA vs DÉCIMA CUARTA).
enum ClaimDirection {
  /// Inquilino → propietario (Cláusula DÉCIMA CUARTA).
  inquilinoAPropietario,

  /// Propietario → inquilino (Cláusula DÉCIMA TERCERA).
  propietarioAInquilino,
}
