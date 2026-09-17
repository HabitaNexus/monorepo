import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../data/providers/coworking_providers.dart';
import '../../domain/entities/coworking_space.dart';

class NearbyCoworkingsWidget extends ConsumerWidget {
  final double latitude;
  final double longitude;
  final double radiusKm;

  const NearbyCoworkingsWidget({
    super.key,
    required this.latitude,
    required this.longitude,
    this.radiusKm = 5.0,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nearbyAsync = ref.watch(coworkingNearbyProvider({
      'lat': latitude,
      'lng': longitude,
      'radiusKm': radiusKm,
    }));

    return nearbyAsync.when(
      data: (spaces) {
        if (spaces.isEmpty) return const SizedBox.shrink();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  const Icon(Icons.work, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Espacios de trabajo cerca',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 160,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: spaces.length,
                itemBuilder: (context, index) {
                  final space = spaces[index];
                  return _NearbySpaceCard(space: space);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: TextButton.icon(
                icon: const Icon(Icons.search, size: 18),
                label: const Text('Ver todos en el mapa'),
                onPressed: () => context.push('/coworkings'),
              ),
            ),
          ],
        );
      },
      loading: () => const SizedBox(
        height: 120,
        child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
      ),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}

class _NearbySpaceCard extends StatelessWidget {
  final CoworkingSpace space;

  const _NearbySpaceCard({required this.space});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => context.push('/coworkings/${space.id}'),
        child: SizedBox(
          width: 180,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      _iconForType(space.type),
                      size: 20,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        space.name,
                        style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                if (space.wifiSpeedMbps != null)
                  Text('WiFi ${space.wifiSpeedMbps!.round()} Mbps',
                      style: theme.textTheme.bodySmall),
                if (space.dayPassPriceUsd != null)
                  Text('Day-pass \$${space.dayPassPriceUsd!.round()}',
                      style: theme.textTheme.bodySmall),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _iconForType(SpaceType type) => switch (type) {
        SpaceType.cafe => Icons.local_cafe,
        SpaceType.coworking => Icons.meeting_room,
        SpaceType.ceci => Icons.apartment,
      };
}
