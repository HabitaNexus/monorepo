import 'claim_direction.dart';

/// Catálogos cerrados de causa por dirección (SOP §6.3).
abstract final class ClaimCauses {
  /// Inquilino → propietario (Cláusula DÉCIMA CUARTA, contrato tipo).
  static const List<String> inquilinoAPropietario = [
    'fugas_reventaduras',
    'fallas_electricas_breakers',
    'pintura_humedad_defecto',
    'ceramica_pisos',
    'plagas_sanitario',
    'filtraciones_techo_pared',
    'reparacion_estructural',
  ];

  /// Propietario → inquilino (Cláusula DÉCIMA TERCERA, contrato tipo).
  static const List<String> propietarioAInquilino = [
    'ruido',
    'limpieza_mantenimiento',
    'danos',
    'mascotas_no_autorizadas',
    'subarriendo_no_autorizado',
    'sustancias_peligrosas',
    'incumplimiento_pactado',
  ];

  /// Catálogo aplicable según la dirección del reclamo.
  static List<String> forDirection(ClaimDirection direction) {
    switch (direction) {
      case ClaimDirection.inquilinoAPropietario:
        return inquilinoAPropietario;
      case ClaimDirection.propietarioAInquilino:
        return propietarioAInquilino;
    }
  }

  /// `true` si [cause] pertenece al catálogo de [direction].
  static bool isValid(ClaimDirection direction, String cause) =>
      forDirection(direction).contains(cause);
}
