import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/negotiations/presentation/pages/digital_signature_page.dart';
import '../features/properties/presentation/pages/property_detail_page.dart';
import 'demo_data.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const PropertyDetailPage(
          propertyId: DemoProperty.id,
          propertyName: DemoProperty.name,
          latitude: DemoProperty.latitude,
          longitude: DemoProperty.longitude,
          address: DemoProperty.address,
        ),
      ),
      GoRoute(
        path: '/firma-digital',
        name: 'firma-digital',
        builder: (context, state) => const DigitalSignaturePage(),
      ),
    ],
  );
});
