import 'coworking_space.dart';

class CoworkingFilter {
  final SpaceType? type;
  final double? minWifiSpeed;
  final NoiseLevel? maxNoiseLevel;
  final bool onlyWithOutlets;
  final bool onlyOpenNow;
  final double? latitude;
  final double? longitude;
  final double radiusKm;

  const CoworkingFilter({
    this.type,
    this.minWifiSpeed,
    this.maxNoiseLevel,
    this.onlyWithOutlets = false,
    this.onlyOpenNow = false,
    this.latitude,
    this.longitude,
    this.radiusKm = 5.0,
  });

  CoworkingFilter copyWith({
    SpaceType? type,
    double? minWifiSpeed,
    NoiseLevel? maxNoiseLevel,
    bool? onlyWithOutlets,
    bool? onlyOpenNow,
    double? latitude,
    double? longitude,
    double? radiusKm,
  }) {
    return CoworkingFilter(
      type: type ?? this.type,
      minWifiSpeed: minWifiSpeed ?? this.minWifiSpeed,
      maxNoiseLevel: maxNoiseLevel ?? this.maxNoiseLevel,
      onlyWithOutlets: onlyWithOutlets ?? this.onlyWithOutlets,
      onlyOpenNow: onlyOpenNow ?? this.onlyOpenNow,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      radiusKm: radiusKm ?? this.radiusKm,
    );
  }

  Map<String, dynamic> toQueryParams() {
    final params = <String, dynamic>{};
    if (type != null) params['type'] = type!.name;
    if (minWifiSpeed != null) params['min_wifi_speed'] = minWifiSpeed;
    if (maxNoiseLevel != null) params['max_noise_level'] = maxNoiseLevel!.name;
    if (onlyWithOutlets) params['only_with_outlets'] = true;
    if (onlyOpenNow) params['only_open_now'] = true;
    if (latitude != null) params['latitude'] = latitude;
    if (longitude != null) params['longitude'] = longitude;
    params['radius_km'] = radiusKm;
    return params;
  }
}
