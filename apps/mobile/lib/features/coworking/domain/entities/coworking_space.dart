enum SpaceType { cafe, coworking, ceci }

enum PartnershipStatus { none, pending, active, former }

enum NoiseLevel { quiet, moderate, lively }

class CoworkingSpace {
  final String id;
  final String name;
  final double latitude;
  final double longitude;
  final SpaceType type;
  final String address;
  final String description;
  final double? wifiSpeedMbps;
  final NoiseLevel noiseLevel;
  final String hours;
  final int outletsAvailable;
  final double? dayPassPriceUsd;
  final double? monthlyMembershipPriceUsd;
  final String photoUrl;
  final PartnershipStatus partnershipStatus;
  final bool hasParking;
  final bool hasFood;
  final double rating;
  final DateTime createdAt;
  final DateTime updatedAt;

  const CoworkingSpace({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.type,
    this.address = '',
    this.description = '',
    this.wifiSpeedMbps,
    this.noiseLevel = NoiseLevel.moderate,
    this.hours = '',
    this.outletsAvailable = 0,
    this.dayPassPriceUsd,
    this.monthlyMembershipPriceUsd,
    this.photoUrl = '',
    this.partnershipStatus = PartnershipStatus.none,
    this.hasParking = false,
    this.hasFood = false,
    this.rating = 0.0,
    required this.createdAt,
    required this.updatedAt,
  });

  CoworkingSpace copyWith({
    String? id,
    String? name,
    double? latitude,
    double? longitude,
    SpaceType? type,
    String? address,
    String? description,
    double? wifiSpeedMbps,
    NoiseLevel? noiseLevel,
    String? hours,
    int? outletsAvailable,
    double? dayPassPriceUsd,
    double? monthlyMembershipPriceUsd,
    String? photoUrl,
    PartnershipStatus? partnershipStatus,
    bool? hasParking,
    bool? hasFood,
    double? rating,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CoworkingSpace(
      id: id ?? this.id,
      name: name ?? this.name,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      type: type ?? this.type,
      address: address ?? this.address,
      description: description ?? this.description,
      wifiSpeedMbps: wifiSpeedMbps ?? this.wifiSpeedMbps,
      noiseLevel: noiseLevel ?? this.noiseLevel,
      hours: hours ?? this.hours,
      outletsAvailable: outletsAvailable ?? this.outletsAvailable,
      dayPassPriceUsd: dayPassPriceUsd ?? this.dayPassPriceUsd,
      monthlyMembershipPriceUsd:
          monthlyMembershipPriceUsd ?? this.monthlyMembershipPriceUsd,
      photoUrl: photoUrl ?? this.photoUrl,
      partnershipStatus: partnershipStatus ?? this.partnershipStatus,
      hasParking: hasParking ?? this.hasParking,
      hasFood: hasFood ?? this.hasFood,
      rating: rating ?? this.rating,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'latitude': latitude,
        'longitude': longitude,
        'type': type.name,
        'address': address,
        'description': description,
        'wifi_speed_mbps': wifiSpeedMbps,
        'noise_level': noiseLevel.name,
        'hours': hours,
        'outlets_available': outletsAvailable,
        'day_pass_price_usd': dayPassPriceUsd,
        'monthly_membership_price_usd': monthlyMembershipPriceUsd,
        'photo_url': photoUrl,
        'partnership_status': partnershipStatus.name,
        'has_parking': hasParking,
        'has_food': hasFood,
        'rating': rating,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
      };

  factory CoworkingSpace.fromJson(Map<String, dynamic> json) =>
      CoworkingSpace(
        id: json['id'] as String,
        name: json['name'] as String,
        latitude: (json['latitude'] as num).toDouble(),
        longitude: (json['longitude'] as num).toDouble(),
        type: SpaceType.values.byName(json['type'] as String),
        address: json['address'] as String? ?? '',
        description: json['description'] as String? ?? '',
        wifiSpeedMbps: (json['wifi_speed_mbps'] as num?)?.toDouble(),
        noiseLevel: json['noise_level'] != null
            ? NoiseLevel.values.byName(json['noise_level'] as String)
            : NoiseLevel.moderate,
        hours: json['hours'] as String? ?? '',
        outletsAvailable: json['outlets_available'] as int? ?? 0,
        dayPassPriceUsd:
            (json['day_pass_price_usd'] as num?)?.toDouble(),
        monthlyMembershipPriceUsd:
            (json['monthly_membership_price_usd'] as num?)?.toDouble(),
        photoUrl: json['photo_url'] as String? ?? '',
        partnershipStatus: json['partnership_status'] != null
            ? PartnershipStatus.values
                .byName(json['partnership_status'] as String)
            : PartnershipStatus.none,
        hasParking: json['has_parking'] as bool? ?? false,
        hasFood: json['has_food'] as bool? ?? false,
        rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
        createdAt: DateTime.parse(json['created_at'] as String),
        updatedAt: DateTime.parse(json['updated_at'] as String),
      );
}
