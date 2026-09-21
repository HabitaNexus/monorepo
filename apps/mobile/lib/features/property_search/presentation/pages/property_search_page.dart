/// Página principal de búsqueda de propiedades (HAB-18).
///
/// Diseño minimalista: barra de búsqueda como elemento principal,
/// resultados se muestran al interactuar.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher_string.dart';

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

  static const String _hab26Url = 'https://github.com/HabitaNexus/monorepo/pull/35';
  static const String _hab27Url = 'https://github.com/HabitaNexus/monorepo/pull/36';
  static const String _hab26Linear = 'https://linear.app/habitanexus/issue/HAB-26/negotiation-state-machine';

  Future<void> _launchUrl(String url) async {
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    }
  }

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
                        const SizedBox(height: 32),
                        // Demo: Accesos a HAB-26/27
                        _DemoIssueButtons(
                          onHab26Tap: () => _launchUrl(_hab26Linear),
                          onHab27Tap: () => context.go('/negociacion'),
                          onHab26PrTap: () => _launchUrl(_hab26Url),
                          onHab27PrTap: () => _launchUrl(_hab27Url),
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
              context.go('/contrato');
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

/// Botones de acceso a issues HAB-26 y HAB-27
class _DemoIssueButtons extends StatelessWidget {
  final VoidCallback onHab26Tap;
  final VoidCallback onHab27Tap;
  final VoidCallback onHab26PrTap;
  final VoidCallback onHab27PrTap;

  const _DemoIssueButtons({
    required this.onHab26Tap,
    required this.onHab27Tap,
    required this.onHab26PrTap,
    required this.onHab27PrTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Column(
      children: [
        Text(
          'Funcionalidades relacionadas',
          style: theme.textTheme.labelMedium?.copyWith(
            color: colors.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          alignment: WrapAlignment.center,
          children: [
            // HAB-26: Negotiation State Machine (Backend)
            _IssueButton(
              icon: Icons.storage_outlined,
              label: 'HAB-26\nState Machine',
              subtitle: 'Backend + Tests',
              color: colors.tertiary,
              onTap: onHab26Tap,
              onSecondaryTap: onHab26PrTap,
              secondaryLabel: 'Ver PR #35',
            ),
            // HAB-27: Negotiation UI
            _IssueButton(
              icon: Icons.handshake_outlined,
              label: 'HAB-27\nNegociación UI',
              subtitle: 'Flutter + Riverpod',
              color: colors.secondary,
              onTap: onHab27Tap,
              onSecondaryTap: onHab27PrTap,
              secondaryLabel: 'Ver PR #36',
            ),
          ],
        ),
      ],
    );
  }
}

class _IssueButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;
  final VoidCallback onSecondaryTap;
  final String secondaryLabel;

  const _IssueButton({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.color,
    required this.onTap,
    required this.onSecondaryTap,
    required this.secondaryLabel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 160, maxWidth: 180),
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: color.withValues(alpha: 0.3)),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, size: 28, color: color),
                ),
                const SizedBox(height: 10),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colors.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 12),
                Divider(height: 1, color: colors.outline.withValues(alpha: 0.3)),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: onSecondaryTap,
                  style: TextButton.styleFrom(
                    foregroundColor: color,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    secondaryLabel,
                    style: theme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
