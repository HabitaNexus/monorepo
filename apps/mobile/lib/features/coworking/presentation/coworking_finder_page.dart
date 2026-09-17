// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../data/providers/coworking_providers.dart';
import '../domain/entities/coworking_space.dart';
import '../domain/entities/coworking_filter.dart';

class CoworkingFinderPage extends ConsumerWidget {
  const CoworkingFinderPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spacesAsync = ref.watch(coworkingFilteredProvider);
    final filter = ref.watch(coworkingFilterProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Coworkings & Cafés'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterSheet(context, ref, filter),
          ),
        ],
      ),
      body: spacesAsync.when(
        data: (spaces) => _buildContent(context, ref, spaces),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }

  Widget _buildContent(BuildContext context, WidgetRef ref, List<CoworkingSpace> spaces) {
    if (spaces.isEmpty) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('No se encontraron espacios'),
            Text('Prueba con otros filtros', style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: spaces.length,
      itemBuilder: (context, index) => _CoworkingCard(space: spaces[index]),
    );
  }

  void _showFilterSheet(BuildContext context, WidgetRef ref, CoworkingFilter currentFilter) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => _CoworkingFilterSheet(currentFilter: currentFilter),
    );
  }
}

class _CoworkingCard extends StatelessWidget {
  final CoworkingSpace space;

  const _CoworkingCard({required this.space});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => context.push('/coworkings/${space.id}'),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _iconForType(space.type),
                  size: 32,
                  color: theme.colorScheme.onPrimaryContainer,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(space.name, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(space.address, style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _Tag(text: _typeLabel(space.type)),
                        if (space.wifiSpeedMbps != null) ...[
                          const SizedBox(width: 8),
                          _Tag(text: '${space.wifiSpeedMbps!.round()} Mbps'),
                        ],
                        if (space.dayPassPriceUsd != null) ...[
                          const SizedBox(width: 8),
                          _Tag(text: '\$${space.dayPassPriceUsd!.round()}'),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                children: [
                  Icon(space.hasFood ? Icons.restaurant : Icons.restaurant_outlined, size: 20),
                  const SizedBox(height: 4),
                  Icon(space.hasParking ? Icons.local_parking : Icons.local_parking_outlined, size: 20),
                ],
              ),
            ],
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

  String _typeLabel(SpaceType type) => switch (type) {
        SpaceType.cafe => 'Café',
        SpaceType.coworking => 'Coworking',
        SpaceType.ceci => 'CECI',
      };
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

class _CoworkingFilterSheet extends ConsumerWidget {
  final CoworkingFilter currentFilter;

  const _CoworkingFilterSheet({required this.currentFilter});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Filtros', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          DropdownButtonFormField<SpaceType?>(
            value: currentFilter.type,
            decoration: const InputDecoration(labelText: 'Tipo de espacio'),
            items: const [
              DropdownMenuItem(value: null, child: Text('Todos')),
              DropdownMenuItem(value: SpaceType.cafe, child: Text('Cafés')),
              DropdownMenuItem(value: SpaceType.coworking, child: Text('Coworkings')),
              DropdownMenuItem(value: SpaceType.ceci, child: Text('CECIs')),
            ],
            onChanged: (v) => ref.read(coworkingFilterProvider.notifier).state =
                currentFilter.copyWith(type: v),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<NoiseLevel?>(
            value: currentFilter.maxNoiseLevel,
            decoration: const InputDecoration(labelText: 'Ruido máximo'),
            items: const [
              DropdownMenuItem(value: null, child: Text('Cualquiera')),
              DropdownMenuItem(value: NoiseLevel.quiet, child: Text('Tranquilo')),
              DropdownMenuItem(value: NoiseLevel.moderate, child: Text('Moderado')),
            ],
            onChanged: (v) => ref.read(coworkingFilterProvider.notifier).state =
                currentFilter.copyWith(maxNoiseLevel: v),
          ),
          const SizedBox(height: 12),
          SwitchListTile(
            title: const Text('Solo con enchufes'),
            value: currentFilter.onlyWithOutlets,
            onChanged: (v) => ref.read(coworkingFilterProvider.notifier).state =
                currentFilter.copyWith(onlyWithOutlets: v),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Aplicar filtros'),
          ),
        ],
      ),
    );
  }
}
