/// Página principal de búsqueda de propiedades (HAB-18).
///
/// Diseño minimalista: barra de búsqueda como elemento principal,
/// resultados se muestran al interactuar.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/property_search_providers.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/property_card.dart';
import '../widgets/comparison_widget.dart';

class PropertySearchPage extends ConsumerStatefulWidget {
  const PropertySearchPage({super.key});

  @override
  ConsumerState<PropertySearchPage> createState() => _PropertySearchPageState();
}

class _PropertySearchPageState extends ConsumerState<PropertySearchPage> {
  int _navIndex = 1;
  bool _showResults = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final searchResults = ref.watch(searchResultsProvider);
    final stats = ref.watch(searchStatsProvider);
    final comparison = ref.watch(comparisonProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('HabitaNexus'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Barra de búsqueda
          Padding(
            padding: const EdgeInsets.all(16),
            child: SearchBarWidget(
              onSearch: () {
                setState(() => _showResults = true);
                ref.invalidate(searchResultsProvider);
              },
            ),
          ),

          // Estadísticas de búsqueda (se muestran cuando hay resultados)
          if (_showResults && searchResults.hasValue)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: colors.surfaceContainerLow,
              child: Row(
                children: [
                  Text(
                    '${stats.totalCount} propiedades encontradas',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    'Promedio: ${stats.formattedAvgPrice}/mes',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${stats.verifiedCount} verificadas',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),

          // Resultados de búsqueda
          Expanded(
            child: _showResults
                ? searchResults.when(
                    data: (properties) {
                      if (properties.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.search_off,
                                size: 64,
                                color: colors.onSurfaceVariant,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No se encontraron propiedades',
                                style: theme.textTheme.titleMedium,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Intenta ajustar tus filtros',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: colors.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      return ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: properties.length,
                        itemBuilder: (context, index) {
                          final property = properties[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: PropertyCard(
                              property: property,
                              onTap: () {
                                // TODO: Navegar a detalle de propiedad
                              },
                            ),
                          );
                        },
                      );
                    },
                    loading: () => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    error: (e, _) => Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 64,
                            color: colors.error,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Error al buscar propiedades',
                            style: theme.textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            e.toString(),
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: colors.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search,
                          size: 64,
                          color: colors.onSurfaceVariant.withValues(alpha: 0.5),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '¿Qué tipo de propiedad buscas?',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: colors.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Usa los filtros para encontrar tu hogar ideal',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colors.onSurfaceVariant.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
          ),

          // Barra de comparación (se muestra cuando hay selecciones)
          if (comparison.isNotEmpty) const ComparisonWidget(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _navIndex,
        onTap: (i) {
          switch (i) {
            case 0:
              context.go('/');
              break;
            case 1:
              // Already on search
              break;
            case 2:
              context.go('/negociacion');
              break;
            case 3:
              // context.go('/contratos');
              break;
          }
          setState(() => _navIndex = i);
        },
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined), label: 'Inicio'),
          BottomNavigationBarItem(
              icon: Icon(Icons.explore_outlined), label: 'Buscar'),
          BottomNavigationBarItem(
              icon: Icon(Icons.handshake_outlined), label: 'Pactos'),
          BottomNavigationBarItem(
              icon: Icon(Icons.verified_user_outlined),
              label: 'Contratos'),
        ],
      ),
    );
  }
}
