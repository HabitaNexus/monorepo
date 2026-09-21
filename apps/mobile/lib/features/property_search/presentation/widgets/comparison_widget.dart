/// Widget de comparación de propiedades (HAB-18).
///
/// Muestra propiedades lado a lado para comparar.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/property.dart';
import '../providers/property_search_providers.dart';

class ComparisonWidget extends ConsumerWidget {
  const ComparisonWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final comparison = ref.watch(comparisonProvider);

    if (comparison.isEmpty) {
      return const SizedBox.shrink();
    }

    return Card(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Row(
              children: [
                Icon(
                  Icons.compare_arrows,
                  color: colors.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Comparar (${comparison.length}/${ComparisonNotifier.maxComparison})',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: colors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    ref.read(comparisonProvider.notifier).clearComparison();
                  },
                  child: const Text('Limpiar'),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Chips de propiedades seleccionadas
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: comparison.map((id) {
                return Chip(
                  label: Text(id),
                  deleteIcon: const Icon(Icons.close, size: 16),
                  onDeleted: () {
                    ref.read(comparisonProvider.notifier).toggleComparison(id);
                  },
                );
              }).toList(),
            ),

            // Botón de comparar
            if (comparison.length >= 2) ...[
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: () {
                  // Navegar a pantalla de comparación
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ComparisonPage(),
                    ),
                  );
                },
                icon: const Icon(Icons.compare_arrows),
                label: const Text('Comparar propiedades'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Página de comparación
class ComparisonPage extends ConsumerWidget {
  const ComparisonPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final comparisonAsync = ref.watch(comparisonPropertiesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Comparar Propiedades'),
        actions: [
          TextButton(
            onPressed: () {
              ref.read(comparisonProvider.notifier).clearComparison();
              Navigator.pop(context);
            },
            child: const Text('Limpiar'),
          ),
        ],
      ),
      body: comparisonAsync.when(
        data: (properties) {
          if (properties.isEmpty) {
            return const Center(
              child: Text('No hay propiedades seleccionadas'),
            );
          }

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: [
                const DataColumn(label: Text('Característica')),
                ...properties.map(
                  (p) => DataColumn(
                    label: Text(
                      p.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
              rows: [
                _buildDataRow('Precio', properties.map((p) => p.formattedPrice).toList()),
                _buildDataRow('Habitaciones', properties.map((p) => '${p.bedrooms}').toList()),
                _buildDataRow('Baños', properties.map((p) => '${p.bathrooms}').toList()),
                _buildDataRow('Área', properties.map((p) => '${p.areaM2.round()}m²').toList()),
                _buildDataRow('Provincia', properties.map((p) => p.province).toList()),
                _buildDataRow('Cantón', properties.map((p) => p.canton).toList()),
                _buildDataRow('Mascotas', properties.map((p) => p.petPolicy.label).toList()),
                _buildDataRow('Verificado', properties.map((p) =>
                    p.verificationStatus == VerificationStatus.verified ? '✓' : '✗').toList()),
                _buildDataRow('Estacionamiento', properties.map((p) =>
                    p.features['parking'] == true ? '✓' : '✗').toList()),
                _buildDataRow('Gimnasio', properties.map((p) =>
                    p.features['gym'] == true ? '✓' : '✗').toList()),
                _buildDataRow('Piscina', properties.map((p) =>
                    p.features['pool'] == true ? '✓' : '✗').toList()),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }

  DataRow _buildDataRow(String label, List<String> values) {
    return DataRow(
      cells: [
        DataCell(Text(label, style: const TextStyle(fontWeight: FontWeight.bold))),
        ...values.map((v) => DataCell(Text(v))),
      ],
    );
  }
}
