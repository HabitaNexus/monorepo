import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitanexus_mobile/features/properties/domain/entities/workspace_nearby.dart';
import 'package:habitanexus_mobile/features/properties/domain/repositories/workspace_nearby_repository.dart';
import 'package:habitanexus_mobile/features/properties/presentation/widgets/nearby_coworkings_widget.dart';
import 'package:habitanexus_mobile/features/properties/presentation/providers/coworking_nearby_provider.dart';

@widgetbook.UseCase(
  name: 'Default',
  type: NearbyCoworkingsWidget,
  path: '[organisms]',
)
Widget nearbyCoworkingsWidgetUseCase(BuildContext context) {
  return ProviderScope(
    overrides: [
      coworkingNearbyProvider.overrideWith(
        (ref) => CoworkingNearbyNotifier(
          MockWorkspaceNearbyRepository(),
        ),
      ),
    ],
    child: NearbyCoworkingsWidget(
      propertyLatitude: 9.9281,
      propertyLongitude: -84.0907,
      searchRadius: 2000,
      onViewFullSearch: () {},
    ),
  );
}

/// Mock del repositorio para widgetbook.
class MockWorkspaceNearbyRepository implements WorkspaceNearbyRepository {
  @override
  Future<List<WorkspaceNearby>> getNearby({
    required double latitude,
    required double longitude,
    required double radius,
  }) async {
    return [
      WorkspaceNearby(
        id: '1',
        name: 'WeWork Escazú',
        category: 'coworking',
        distanceKm: 0.5,
        hasWifi: true,
      ),
      WorkspaceNearby(
        id: '2',
        name: 'Café Avellaneda',
        category: 'cafe',
        distanceKm: 0.3,
        hasWifi: true,
      ),
      WorkspaceNearby(
        id: '3',
        name: 'Coworking Central',
        category: 'coworking',
        distanceKm: 1.2,
        hasWifi: true,
      ),
    ];
  }
}