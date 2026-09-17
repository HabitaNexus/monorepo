import '../../domain/entities/coworking_space.dart';

class CoworkingLocalDataSource {
  static final List<CoworkingSpace> _mockSpaces = [
    CoworkingSpace(
      id: 'cow-001',
      name: 'Selina San José',
      latitude: 9.9333,
      longitude: -84.0833,
      type: SpaceType.coworking,
      address: 'San José, Barrio Escalante',
      description: 'Coworking y hostel en el corazón de Escalante. Café, rooftop y comunidad nómada digital.',
      wifiSpeedMbps: 50.0,
      noiseLevel: NoiseLevel.moderate,
      hours: '7:00 - 22:00',
      outletsAvailable: 40,
      dayPassPriceUsd: 15.0,
      monthlyMembershipPriceUsd: 200.0,
      photoUrl: '',
      partnershipStatus: PartnershipStatus.none,
      hasParking: false,
      hasFood: true,
      rating: 4.3,
      createdAt: DateTime(2025, 1, 1),
      updatedAt: DateTime(2025, 1, 1),
    ),
    CoworkingSpace(
      id: 'cow-002',
      name: 'Impact Hub San José',
      latitude: 9.9360,
      longitude: -84.0800,
      type: SpaceType.coworking,
      address: 'San José, Los Yoses',
      description: 'Red global de coworking con enfoque de impacto social. Salas de reunión y eventos.',
      wifiSpeedMbps: 80.0,
      noiseLevel: NoiseLevel.quiet,
      hours: '8:00 - 18:00',
      outletsAvailable: 60,
      dayPassPriceUsd: 12.0,
      monthlyMembershipPriceUsd: 180.0,
      photoUrl: '',
      partnershipStatus: PartnershipStatus.none,
      hasParking: false,
      hasFood: true,
      rating: 4.5,
      createdAt: DateTime(2025, 1, 1),
      updatedAt: DateTime(2025, 1, 1),
    ),
    CoworkingSpace(
      id: 'cow-003',
      name: 'Café del Barista',
      latitude: 9.9345,
      longitude: -84.0710,
      type: SpaceType.cafe,
      address: 'San José, Barrio Escalante',
      description: 'Cafetería de especialidad con WiFi rápido y ambiente tranquilo. Ideal para freelancers.',
      wifiSpeedMbps: 35.0,
      noiseLevel: NoiseLevel.quiet,
      hours: '7:00 - 19:00',
      outletsAvailable: 12,
      dayPassPriceUsd: null,
      monthlyMembershipPriceUsd: null,
      photoUrl: '',
      partnershipStatus: PartnershipStatus.none,
      hasParking: false,
      hasFood: true,
      rating: 4.6,
      createdAt: DateTime(2025, 1, 1),
      updatedAt: DateTime(2025, 1, 1),
    ),
    CoworkingSpace(
      id: 'cow-004',
      name: 'Starbucks Escazú',
      latitude: 9.9400,
      longitude: -84.1400,
      type: SpaceType.cafe,
      address: 'Escazú, Multiplaza',
      description: 'Starbucks con amplio espacio de mesas y WiFi gratuito.',
      wifiSpeedMbps: 20.0,
      noiseLevel: NoiseLevel.lively,
      hours: '6:00 - 21:00',
      outletsAvailable: 20,
      dayPassPriceUsd: null,
      monthlyMembershipPriceUsd: null,
      photoUrl: '',
      partnershipStatus: PartnershipStatus.none,
      hasParking: true,
      hasFood: true,
      rating: 4.0,
      createdAt: DateTime(2025, 1, 1),
      updatedAt: DateTime(2025, 1, 1),
    ),
    CoworkingSpace(
      id: 'cow-005',
      name: 'CECI San José',
      latitude: 9.9310,
      longitude: -84.0750,
      type: SpaceType.ceci,
      address: 'San José, Centro',
      description: 'Centro Comunitario Inteligente del MICITT. Espacio con computadoras, WiFi y salas de reunión. Gratuito.',
      wifiSpeedMbps: 40.0,
      noiseLevel: NoiseLevel.moderate,
      hours: '8:00 - 16:00',
      outletsAvailable: 30,
      dayPassPriceUsd: 0.0,
      monthlyMembershipPriceUsd: 0.0,
      photoUrl: '',
      partnershipStatus: PartnershipStatus.pending,
      hasParking: false,
      hasFood: false,
      rating: 3.8,
      createdAt: DateTime(2025, 1, 1),
      updatedAt: DateTime(2025, 1, 1),
    ),
  ];

  Future<List<CoworkingSpace>> getAll({Map<String, dynamic>? params}) async {
    await Future.delayed(const Duration(milliseconds: 300));
    var result = _mockSpaces;

    if (params != null) {
      if (params['type'] != null) {
        result = result.where((s) => s.type.name == params['type']).toList();
      }
      if (params['min_wifi_speed'] != null) {
        final min = params['min_wifi_speed'] as num;
        result = result.where((s) => (s.wifiSpeedMbps ?? 0) >= min).toList();
      }
      if (params['only_with_outlets'] == true) {
        result = result.where((s) => s.outletsAvailable > 0).toList();
      }
    }

    return result;
  }

  Future<CoworkingSpace> getById(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _mockSpaces.firstWhere((s) => s.id == id);
  }

  Future<List<CoworkingSpace>> getNearby(
    double latitude,
    double longitude, {
    double radiusKm = 5.0,
    Map<String, dynamic>? extraParams,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _mockSpaces;
  }
}
