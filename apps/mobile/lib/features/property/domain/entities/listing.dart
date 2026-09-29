import 'package:equatable/equatable.dart';

import 'catalog_types.dart';

/// Publicación activa de un [Property] (fase 1, paso 3 + fase 2).
///
/// Contiene el precio publicado, los rangos negociables (precio mínimo,
/// duración mínima/máxima, depósito) y las condiciones no negociables
/// que el propietario fija al publicar. El estado de publicación
/// controla la visibilidad en descubrimiento.
class Listing extends Equatable {
  final String id;
  final String propertyId;
  final double monthlyRent;
  final double? minRent;
  final double depositAmount;
  final int? minDurationMonths;
  final int? maxDurationMonths;
  final List<String> nonNegotiableConditions;
  final ListingStatus status;
  final DateTime? publishedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Listing({
    required this.id,
    required this.propertyId,
    required this.monthlyRent,
    this.minRent,
    required this.depositAmount,
    this.minDurationMonths,
    this.maxDurationMonths,
    this.nonNegotiableConditions = const [],
    required this.status,
    this.publishedAt,
    this.createdAt,
    this.updatedAt,
  });

  Listing copyWith({
    String? id,
    String? propertyId,
    double? monthlyRent,
    double? minRent,
    double? depositAmount,
    int? minDurationMonths,
    int? maxDurationMonths,
    List<String>? nonNegotiableConditions,
    ListingStatus? status,
    DateTime? publishedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Listing(
      id: id ?? this.id,
      propertyId: propertyId ?? this.propertyId,
      monthlyRent: monthlyRent ?? this.monthlyRent,
      minRent: minRent ?? this.minRent,
      depositAmount: depositAmount ?? this.depositAmount,
      minDurationMonths: minDurationMonths ?? this.minDurationMonths,
      maxDurationMonths: maxDurationMonths ?? this.maxDurationMonths,
      nonNegotiableConditions:
          nonNegotiableConditions ?? this.nonNegotiableConditions,
      status: status ?? this.status,
      publishedAt: publishedAt ?? this.publishedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'property_id': propertyId,
      'monthly_rent': monthlyRent,
      'min_rent': minRent,
      'deposit_amount': depositAmount,
      'min_duration_months': minDurationMonths,
      'max_duration_months': maxDurationMonths,
      'non_negotiable_conditions': nonNegotiableConditions,
      'status': status.name,
      'published_at': publishedAt?.toIso8601String(),
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  factory Listing.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(Object? raw) {
      if (raw == null) return null;
      return DateTime.parse(raw as String);
    }

    return Listing(
      id: json['id'] as String,
      propertyId: json['property_id'] as String,
      monthlyRent: (json['monthly_rent'] as num).toDouble(),
      minRent: (json['min_rent'] as num?)?.toDouble(),
      depositAmount: (json['deposit_amount'] as num).toDouble(),
      minDurationMonths: (json['min_duration_months'] as num?)?.toInt(),
      maxDurationMonths: (json['max_duration_months'] as num?)?.toInt(),
      nonNegotiableConditions: (json['non_negotiable_conditions'] as List?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      status: ListingStatus.values.byName(json['status'] as String),
      publishedAt: parseDate(json['published_at']),
      createdAt: parseDate(json['created_at']),
      updatedAt: parseDate(json['updated_at']),
    );
  }

  @override
  List<Object?> get props => [
        id,
        propertyId,
        monthlyRent,
        minRent,
        depositAmount,
        minDurationMonths,
        maxDurationMonths,
        nonNegotiableConditions,
        status,
        publishedAt,
        createdAt,
        updatedAt,
      ];
}
