import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/providers/coworking_providers.dart';
import '../domain/entities/coworking_space.dart';

class CoworkingDetailPage extends ConsumerWidget {
  final String spaceId;

  const CoworkingDetailPage({super.key, required this.spaceId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spaceAsync = ref.watch(coworkingDetailProvider(spaceId));
    final theme = Theme.of(context);

    return spaceAsync.when(
      data: (space) => Scaffold(
        appBar: AppBar(title: Text(space.name)),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _iconForType(space.type),
                  size: 64,
                  color: theme.colorScheme.onPrimaryContainer,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Text(space.name, style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                  ),
                  _PartnershipBadge(status: space.partnershipStatus),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.location_on, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(space.address, style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey)),
                ],
              ),
              const SizedBox(height: 8),
              _Tag(text: _typeLabel(space.type)),
              if (space.description.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text(space.description, style: theme.textTheme.bodyLarge),
              ],
              const Divider(height: 32),
              _InfoRow(icon: Icons.wifi, label: 'Velocidad WiFi', value: space.wifiSpeedMbps != null ? '${space.wifiSpeedMbps!.round()} Mbps' : 'No reportado'),
              _InfoRow(icon: Icons.volume_up, label: 'Nivel ruido', value: _noiseLabel(space.noiseLevel)),
              _InfoRow(icon: Icons.access_time, label: 'Horario', value: space.hours.isNotEmpty ? space.hours : 'No especificado'),
              _InfoRow(icon: Icons.power, label: 'Enchufes', value: '${space.outletsAvailable} disponibles'),
              if (space.dayPassPriceUsd != null)
                _InfoRow(icon: Icons.attach_money, label: 'Day pass', value: '\$${space.dayPassPriceUsd!.toStringAsFixed(0)}'),
              if (space.monthlyMembershipPriceUsd != null)
                _InfoRow(icon: Icons.card_membership, label: 'Membresía mensual', value: '\$${space.monthlyMembershipPriceUsd!.toStringAsFixed(0)}'),
              const Divider(height: 32),
              Row(
                children: [
                  _AmenityChip(icon: Icons.restaurant, label: 'Comida', active: space.hasFood),
                  const SizedBox(width: 8),
                  _AmenityChip(icon: Icons.local_parking, label: 'Parqueo', active: space.hasParking),
                ],
              ),
              if (space.rating > 0) ...[
                const SizedBox(height: 16),
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 20),
                    const SizedBox(width: 4),
                    Text(space.rating.toStringAsFixed(1), style: theme.textTheme.titleMedium),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
      loading: () => Scaffold(
        appBar: AppBar(),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(
        appBar: AppBar(),
        body: Center(child: Text('Error: $e')),
      ),
    );
  }

  IconData _iconForType(SpaceType type) => switch (type) {
        SpaceType.cafe => Icons.local_cafe,
        SpaceType.coworking => Icons.meeting_room,
        SpaceType.ceci => Icons.apartment,
      };

  String _typeLabel(SpaceType type) => switch (type) {
        SpaceType.cafe => 'Café',
        SpaceType.coworking => 'Coworking',
        SpaceType.ceci => 'CECI',
      };

  String _noiseLabel(NoiseLevel level) => switch (level) {
        NoiseLevel.quiet => 'Tranquilo',
        NoiseLevel.moderate => 'Moderado',
        NoiseLevel.lively => 'Animado',
      };
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey),
          const SizedBox(width: 12),
          SizedBox(width: 120, child: Text(label, style: const TextStyle(color: Colors.grey))),
          Expanded(child: Text(value, style: const TextStyle(fontWeight: FontWeight.w500))),
        ],
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final String text;

  const _Tag({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(text, style: const TextStyle(fontSize: 12)),
    );
  }
}

class _PartnershipBadge extends StatelessWidget {
  final PartnershipStatus status;

  const _PartnershipBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    if (status == PartnershipStatus.none) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: status == PartnershipStatus.active ? Colors.green.shade100 : Colors.orange.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status == PartnershipStatus.active ? 'Partner' : status == PartnershipStatus.pending ? 'En gestión' : 'Ex-partner',
        style: TextStyle(
          fontSize: 12,
          color: status == PartnershipStatus.active ? Colors.green.shade800 : Colors.orange.shade800,
        ),
      ),
    );
  }
}

class _AmenityChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;

  const _AmenityChip({required this.icon, required this.label, required this.active});

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(icon, size: 18),
      label: Text(label),
      backgroundColor: active ? null : Colors.grey.shade100,
    );
  }
}
