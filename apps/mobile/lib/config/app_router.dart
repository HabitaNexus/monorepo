import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/negotiation/presentation/pages/negotiation_detail_page.dart';
import '../features/properties/presentation/pages/property_detail_page.dart';

/// Router mínimo que compila (fix QA): #35/#36 referenciaban
/// `demo_data.dart` y `negotiations/digital_signature_page.dart`, archivos que
/// nunca se commitearon y rompían `flutter build` en develop.
/// El producto real (HAB-15/HAB-27) reemplaza estos placeholders.
final goRouterProvider = Provider<GoRouter>((ref) {
  // Home = pantalla de negociación de HAB-27 (Naidelyn): sin id muestra
  // la demo local del diseño Stitch; con ?id= carga del backend HAB-26.
  return GoRouter(
    initialLocation: '/negociacion',
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        // Placeholder E2E: valores fijos hasta que exista el listado (HAB-15).
        builder: (context, state) => const PropertyDetailPage(
          propertyId: 'e2e-property',
          propertyName: 'Propiedad E2E',
          latitude: 9.936,
          longitude: -84.09,
          address: 'San José, Costa Rica',
        ),
      ),
      GoRoute(
        path: '/negociacion',
        name: 'negociacion',
        builder: (context, state) => NegotiationDetailPage(
          negotiationId: state.uri.queryParameters['id'],
        ),
      ),
    ],
  );
});
