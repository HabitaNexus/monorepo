import 'package:equatable/equatable.dart';

import 'catalog_types.dart';

/// Espacio individual de la distribución desglosada del inmueble.
///
/// Cada espacio declara sus dimensiones en metros (largo × ancho).
/// El área se deriva como `lengthM * widthM`. Obligatorio para
/// dormitorios (SOP Fase 1), recomendado para el resto de espacios.
class RoomSpace extends Equatable {
  final RoomSpaceType type;
  final String label;
  final double lengthM;
  final double widthM;
  final String? capacityNotes;

  const RoomSpace({
    required this.type,
    required this.label,
    required this.lengthM,
    required this.widthM,
    this.capacityNotes,
  });

  double get areaM2 => lengthM * widthM;

  RoomSpace copyWith({
    RoomSpaceType? type,
    String? label,
    double? lengthM,
    double? widthM,
    String? capacityNotes,
  }) {
    return RoomSpace(
      type: type ?? this.type,
      label: label ?? this.label,
      lengthM: lengthM ?? this.lengthM,
      widthM: widthM ?? this.widthM,
      capacityNotes: capacityNotes ?? this.capacityNotes,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type.name,
      'label': label,
      'length_m': lengthM,
      'width_m': widthM,
      'area_m2': areaM2,
      'capacity_notes': capacityNotes,
    };
  }

  factory RoomSpace.fromJson(Map<String, dynamic> json) {
    return RoomSpace(
      type: RoomSpaceType.values.byName(json['type'] as String),
      label: json['label'] as String,
      lengthM: (json['length_m'] as num).toDouble(),
      widthM: (json['width_m'] as num).toDouble(),
      capacityNotes: json['capacity_notes'] as String?,
    );
  }

  @override
  List<Object?> get props => [type, label, lengthM, widthM, capacityNotes];
}
