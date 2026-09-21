import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/negotiation/presentation/pages/negotiation_detail_page.dart';
import '../features/negotiations/presentation/pages/digital_signature_page.dart';
import '../features/property_search/presentation/pages/property_search_page.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const PropertySearchPage(),
      ),
      GoRoute(
        path: '/firma-digital',
        name: 'firma-digital',
        builder: (context, state) => const DigitalSignaturePage(),
      ),
      GoRoute(
        path: '/negociacion',
        name: 'negociacion',
        builder: (context, state) =>
            const NegotiationDetailPage(),
      ),
      GoRoute(
        path: '/negociacion/:id',
        name: 'negociacion-detalle',
        builder: (context, state) => NegotiationDetailPage(
          negotiationId: state.pathParameters['id'],
        ),
      ),
    ],
  );
});
