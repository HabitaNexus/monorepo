/// Barra de búsqueda de propiedades (HAB-18).
///
/// Elemento principal del diseño minimalista.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/property.dart';
import '../../domain/property_filter.dart';
import '../providers/property_search_providers.dart';

class SearchBarWidget extends ConsumerStatefulWidget {
  const SearchBarWidget({super.key});

  @override
  ConsumerState<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends ConsumerState<SearchBarWidget> {
  final TextEditingController _controller = TextEditingController();
  bool _isExpanded = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final filter = ref.watch(propertyFilterProvider);

    return Card(
      elevation: _isExpanded ? 4 : 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Barra de búsqueda principal
            TextField(
              controller: _controller,
              onTap: () => setState(() => _isExpanded = true),
              onChanged: (value) {
                ref.read(propertyFilterProvider.notifier).state =
                    filter.copyWith(searchQuery: value);
              },
              decoration: InputDecoration(
                hintText: '¿Qué buscas?',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: filter.searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _controller.clear();
                          ref.read(propertyFilterProvider.notifier).state =
                              filter.copyWith(searchQuery: '');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: colors.surfaceContainerLow,
              ),
            ),

            // Filtros rápidos (se muestran expandidos)
            if (_isExpanded) ...[
              const SizedBox(height: 16),
              _buildQuickFilters(filter, colors),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildQuickFilters(PropertyFilter filter, ColorScheme colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Filtro de zona
        _FilterChip(
          icon: Icons.location_on,
          label: filter.province?.label ?? 'Zona',
          isActive: filter.province != null,
          onTap: () => _showProvincePicker(filter),
        ),
        const SizedBox(height: 8),

        // Filtro de presupuesto
        _FilterChip(
          icon: Icons.attach_money,
          label: '₡${(filter.budgetRange.start / 1000).round()}K - '
              '₡${(filter.budgetRange.end / 1000).round()}K',
          isActive: filter.budgetRange != const RangeValues(100000, 500000),
          onTap: () => _showBudgetPicker(filter),
        ),
        const SizedBox(height: 8),

        // Filtro de habitaciones
        _FilterChip(
          icon: Icons.bed,
          label: '${filter.minBedrooms} - ${filter.maxBedrooms} hab',
          isActive: filter.minBedrooms != 1 || filter.maxBedrooms != 5,
          onTap: () => _showBedroomsPicker(filter),
        ),
        const SizedBox(height: 8),

        // Filtro de mascotas
        _FilterChip(
          icon: Icons.pets,
          label: filter.petPolicy.label,
          isActive: filter.petPolicy != PetType.none,
          onTap: () => _showPetPolicyPicker(filter),
        ),
        const SizedBox(height: 16),

        // Botón de buscar
        FilledButton.icon(
          onPressed: () {
            setState(() => _isExpanded = false);
            // Refrescar resultados
            ref.invalidate(searchResultsProvider);
          },
          icon: const Icon(Icons.search),
          label: const Text('Buscar propiedades'),
        ),
      ],
    );
  }

  void _showProvincePicker(PropertyFilter filter) {
    showModalBottomSheet(
      context: context,
      builder: (context) => _ProvincePickerSheet(
        selected: filter.province,
        onSelected: (province) {
          ref.read(propertyFilterProvider.notifier).state =
              filter.copyWith(province: province);
          Navigator.pop(context);
        },
      ),
    );
  }

  void _showBudgetPicker(PropertyFilter filter) {
    showModalBottomSheet(
      context: context,
      builder: (context) => _BudgetPickerSheet(
        range: filter.budgetRange,
        onChanged: (range) {
          ref.read(propertyFilterProvider.notifier).state =
              filter.copyWith(budgetRange: range);
        },
      ),
    );
  }

  void _showBedroomsPicker(PropertyFilter filter) {
    showModalBottomSheet(
      context: context,
      builder: (context) => _BedroomsPickerSheet(
        min: filter.minBedrooms,
        max: filter.maxBedrooms,
        onChanged: (min, max) {
          ref.read(propertyFilterProvider.notifier).state =
              filter.copyWith(minBedrooms: min, maxBedrooms: max);
        },
      ),
    );
  }

  void _showPetPolicyPicker(PropertyFilter filter) {
    showModalBottomSheet(
      context: context,
      builder: (context) => _PetPolicyPickerSheet(
        selected: filter.petPolicy,
        onSelected: (policy) {
          ref.read(propertyFilterProvider.notifier).state =
              filter.copyWith(petPolicy: policy);
          Navigator.pop(context);
        },
      ),
    );
  }
}

/// Chip de filtro rápido
class _FilterChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _FilterChip({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isActive
              ? colors.primaryContainer.withValues(alpha: 0.3)
              : colors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isActive ? colors.primary : colors.outline.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 18,
              color: isActive ? colors.primary : colors.onSurfaceVariant,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: isActive ? colors.primary : colors.onSurfaceVariant,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              size: 18,
              color: colors.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}

/// Sheet de selección de provincia
class _ProvincePickerSheet extends StatelessWidget {
  final CostaRicaProvince? selected;
  final ValueChanged<CostaRicaProvince?> onSelected;

  const _ProvincePickerSheet({
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Seleccionar provincia',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          ListTile(
            title: const Text('Todas'),
            leading: Radio<CostaRicaProvince?>(
              value: null,
              groupValue: selected,
              onChanged: (value) => onSelected(value),
            ),
            onTap: () => onSelected(null),
          ),
          ...CostaRicaProvince.values.map(
            (province) => ListTile(
              title: Text(province.label),
              leading: Radio<CostaRicaProvince?>(
                value: province,
                groupValue: selected,
                onChanged: (value) => onSelected(value),
              ),
              onTap: () => onSelected(province),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

/// Sheet de selección de presupuesto
class _BudgetPickerSheet extends StatefulWidget {
  final RangeValues range;
  final ValueChanged<RangeValues> onChanged;

  const _BudgetPickerSheet({
    required this.range,
    required this.onChanged,
  });

  @override
  State<_BudgetPickerSheet> createState() => _BudgetPickerSheetState();
}

class _BudgetPickerSheetState extends State<_BudgetPickerSheet> {
  late RangeValues _currentRange;

  @override
  void initState() {
    super.initState();
    _currentRange = widget.range;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Rango de presupuesto',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            RangeSlider(
              values: _currentRange,
              min: 50000,
              max: 1000000,
              divisions: 19,
              labels: RangeLabels(
                '₡${(_currentRange.start / 1000).round()}K',
                '₡${(_currentRange.end / 1000).round()}K',
              ),
              onChanged: (values) {
                setState(() => _currentRange = values);
                widget.onChanged(values);
              },
            ),
            const SizedBox(height: 8),
            Text(
              '₡${(_currentRange.start / 1000).round()}K - ₡${(_currentRange.end / 1000).round()}K',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

/// Sheet de selección de habitaciones
class _BedroomsPickerSheet extends StatefulWidget {
  final int min;
  final int max;
  final void Function(int min, int max) onChanged;

  const _BedroomsPickerSheet({
    required this.min,
    required this.max,
    required this.onChanged,
  });

  @override
  State<_BedroomsPickerSheet> createState() => _BedroomsPickerSheetState();
}

class _BedroomsPickerSheetState extends State<_BedroomsPickerSheet> {
  late int _min;
  late int _max;

  @override
  void initState() {
    super.initState();
    _min = widget.min;
    _max = widget.max;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Número de habitaciones',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<int>(
                    initialValue: _min,
                    decoration: const InputDecoration(
                      labelText: 'Mínimo',
                      border: OutlineInputBorder(),
                    ),
                    items: List.generate(5, (i) => DropdownMenuItem(
                      value: i + 1,
                      child: Text('${i + 1}'),
                    )),
                    onChanged: (value) {
                      if (value != null && value <= _max) {
                        setState(() => _min = value);
                        widget.onChanged(value, _max);
                      }
                    },
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('a'),
                ),
                Expanded(
                  child: DropdownButtonFormField<int>(
                    initialValue: _max,
                    decoration: const InputDecoration(
                      labelText: 'Máximo',
                      border: OutlineInputBorder(),
                    ),
                    items: List.generate(5, (i) => DropdownMenuItem(
                      value: i + 1,
                      child: Text('${i + 1}'),
                    )),
                    onChanged: (value) {
                      if (value != null && value >= _min) {
                        setState(() => _max = value);
                        widget.onChanged(_min, value);
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

/// Sheet de selección de política de mascotas
class _PetPolicyPickerSheet extends StatelessWidget {
  final PetType selected;
  final ValueChanged<PetType> onSelected;

  const _PetPolicyPickerSheet({
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Política de mascotas',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          ...PetType.values.map(
            (policy) => ListTile(
              title: Text(policy.label),
              leading: Radio<PetType>(
                value: policy,
                groupValue: selected,
                onChanged: (value) {
                  if (value != null) onSelected(value);
                },
              ),
              onTap: () => onSelected(policy),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
