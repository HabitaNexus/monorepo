/// Barra de búsqueda estilo Airbnb — global, pill, dark (#0d1322 + #57f1db).
///
/// 1 pill compacta en mobile, 4 segmentos en tablet/desktop.
/// Cada segmento abre un BottomSheet espejando Stitch HAB-18 (6 secciones).
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/property.dart';
import '../../domain/property_filter.dart';
import '../providers/property_search_providers.dart';

class SearchBarWidget extends ConsumerStatefulWidget {
  final VoidCallback? onSearch;
  const SearchBarWidget({super.key, this.onSearch});
  @override
  ConsumerState<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends ConsumerState<SearchBarWidget> {
  final TextEditingController _controller = TextEditingController();
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
    final isDark = theme.brightness == Brightness.dark;

    // Resumen para el pill compacto (mobile)
    final whereLabel = filter.province?.label ?? 'Cualquier lugar';
    final priceLabel = filter.budgetRange == const RangeValues(100000, 500000)
        ? 'Cualquier precio'
        : '₡${(filter.budgetRange.start / 1000).round()}k–₡${(filter.budgetRange.end / 1000).round()}k';
    final roomsLabel = filter.minBedrooms == 1 && filter.maxBedrooms == 5
        ? 'Cualquier'
        : '${filter.minBedrooms}–${filter.maxBedrooms} hab';
    final petsLabel = filter.petPolicy == PetType.none ? 'Sin filtro' : filter.petPolicy.label;

    final compactSummary = '$whereLabel · $priceLabel · $roomsLabel';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ── Pill Airbnb (global) ──
        _AirbnbPill(
          compactSummary: compactSummary,
          filter: filter,
          onWhereTap: () => _showLocationSheet(filter),
          onPriceTap: () => _showBudgetSheet(filter),
          onRoomsTap: () => _showRoomsSheet(filter),
          onPetsTap: () => _showPetsSheet(filter),
          onSearch: () {
            if (_controller.text != filter.searchQuery) {
              ref.read(propertyFilterProvider.notifier).state =
                  filter.copyWith(searchQuery: _controller.text);
            }
            widget.onSearch?.call();
          },
        ),
        const SizedBox(height: 12),
        // ── Texto libre (opcional, estilo Airbnb "búsqueda flexible") ──
        TextField(
          controller: _controller,
          style: TextStyle(color: colors.onSurface),
          onChanged: (v) => ref.read(propertyFilterProvider.notifier).state =
              filter.copyWith(searchQuery: v),
          onSubmitted: (_) => widget.onSearch?.call(),
          decoration: InputDecoration(
            hintText: 'Busca por barrio, distrito o palabra clave…',
            hintStyle: TextStyle(color: colors.onSurfaceVariant.withValues(alpha: 0.7)),
            prefixIcon: Icon(Icons.search, color: colors.onSurfaceVariant, size: 20),
            suffixIcon: filter.searchQuery.isNotEmpty
                ? IconButton(
                    icon: Icon(Icons.clear, size: 18, color: colors.onSurfaceVariant),
                    onPressed: () {
                      _controller.clear();
                      ref.read(propertyFilterProvider.notifier).state =
                          filter.copyWith(searchQuery: '');
                    },
                  )
                : null,
            filled: true,
            fillColor: isDark ? colors.surfaceContainer : colors.surfaceContainerLow,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24),
              borderSide: BorderSide(color: colors.outlineVariant.withValues(alpha: 0.5)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24),
              borderSide: BorderSide(color: colors.outlineVariant.withValues(alpha: 0.5)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24),
              borderSide: BorderSide(color: colors.primary, width: 1.5),
            ),
          ),
        ),
        const SizedBox(height: 10),
        // ── Chips rápidos (Airbnb categories pill row) ──
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _QuickPill(
                icon: Icons.public,
                label: 'Global',
                selected: filter.province == null,
                onTap: () => _showLocationSheet(filter),
              ),
              const SizedBox(width: 8),
              _QuickPill(
                icon: Icons.account_balance_wallet_outlined,
                label: priceLabel,
                selected: filter.budgetRange != const RangeValues(100000, 500000),
                onTap: () => _showBudgetSheet(filter),
              ),
              const SizedBox(width: 8),
              _QuickPill(
                icon: Icons.bed_outlined,
                label: roomsLabel,
                selected: !(filter.minBedrooms == 1 && filter.maxBedrooms == 5),
                onTap: () => _showRoomsSheet(filter),
              ),
              const SizedBox(width: 8),
              _QuickPill(
                icon: Icons.pets_outlined,
                label: petsLabel,
                selected: filter.petPolicy != PetType.none,
                onTap: () => _showPetsSheet(filter),
              ),
              if (filter.activeFilterCount > 0) ...[
                const SizedBox(width: 8),
                TextButton.icon(
                  onPressed: () {
                    ref.read(propertyFilterProvider.notifier).state = const PropertyFilter();
                    _controller.clear();
                    widget.onSearch?.call();
                  },
                  icon: const Icon(Icons.restart_alt, size: 16),
                  label: const Text('Limpiar'),
                  style: TextButton.styleFrom(
                    foregroundColor: colors.primary,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    visualDensity: VisualDensity.compact,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  void _showLocationSheet(PropertyFilter f) => showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        builder: (_) => _LocationSheet(
          selected: f.province,
          onSelected: (p) {
            Navigator.pop(context);
            ref.read(propertyFilterProvider.notifier).state =
                f.copyWith(province: p, clearProvince: p == null);
            widget.onSearch?.call();
          },
        ),
      );

  void _showBudgetSheet(PropertyFilter f) => showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        builder: (_) => _BudgetSheet(
          range: f.budgetRange,
          onChanged: (r) {
            ref.read(propertyFilterProvider.notifier).state = f.copyWith(budgetRange: r);
          },
          onApply: () {
            Navigator.pop(context);
            widget.onSearch?.call();
          },
        ),
      );

  void _showRoomsSheet(PropertyFilter f) => showModalBottomSheet(
        context: context,
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        builder: (_) => _RoomsSheet(
          min: f.minBedrooms,
          max: f.maxBedrooms,
          onChanged: (a, b) {
            ref.read(propertyFilterProvider.notifier).state = f.copyWith(minBedrooms: a, maxBedrooms: b);
            Navigator.pop(context);
            widget.onSearch?.call();
          },
        ),
      );

  void _showPetsSheet(PropertyFilter f) => showModalBottomSheet(
        context: context,
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        builder: (_) => _PetsSheet(
          selected: f.petPolicy,
          onSelected: (p) {
            Navigator.pop(context);
            ref.read(propertyFilterProvider.notifier).state = f.copyWith(petPolicy: p);
            widget.onSearch?.call();
          },
        ),
      );
}

/// Pill Airbnb principal — 1 línea en mobile, 4 segmentos en ≥600px.
class _AirbnbPill extends StatelessWidget {
  final String compactSummary;
  final PropertyFilter filter;
  final VoidCallback onWhereTap;
  final VoidCallback onPriceTap;
  final VoidCallback onRoomsTap;
  final VoidCallback onPetsTap;
  final VoidCallback onSearch;
  const _AirbnbPill({
    required this.compactSummary,
    required this.filter,
    required this.onWhereTap,
    required this.onPriceTap,
    required this.onRoomsTap,
    required this.onPetsTap,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isWide = MediaQuery.of(context).size.width >= 700;

    return Container(
      decoration: BoxDecoration(
        color: colors.surfaceContainer,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: colors.outlineVariant.withValues(alpha: 0.6)),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.25), blurRadius: 16, offset: const Offset(0, 4)),
        ],
      ),
      child: isWide ? _wideLayout(colors) : _compactLayout(colors),
    );
  }

  Widget _wideLayout(ColorScheme c) {
    final where = filter.province?.label ?? 'Cualquier lugar';
    final price = filter.budgetRange == const RangeValues(100000, 500000)
        ? 'Cualquier precio'
        : '₡${(filter.budgetRange.start / 1000).round()}k – ₡${(filter.budgetRange.end / 1000).round()}k';
    final rooms = filter.minBedrooms == 1 && filter.maxBedrooms == 5
        ? 'Agregar'
        : '${filter.minBedrooms}–${filter.maxBedrooms}';
    final pets = filter.petPolicy == PetType.none ? 'Agregar' : filter.petPolicy.label;
    return Row(
      children: [
        _PillSegment(label: 'Dónde', value: where, icon: Icons.public, onTap: onWhereTap, colors: c),
        _VDiv(color: c.outlineVariant),
        _PillSegment(label: 'Precio', value: price, icon: Icons.payments_outlined, onTap: onPriceTap, colors: c),
        _VDiv(color: c.outlineVariant),
        _PillSegment(label: 'Habitaciones', value: rooms, icon: Icons.bed_outlined, onTap: onRoomsTap, colors: c),
        _VDiv(color: c.outlineVariant),
        _PillSegment(label: 'Mascotas', value: pets, icon: Icons.pets_outlined, onTap: onPetsTap, colors: c),
        Padding(
          padding: const EdgeInsets.all(6),
          child: _SearchFab(onTap: onSearch, colors: c),
        ),
      ],
    );
  }

  Widget _compactLayout(ColorScheme c) {
    return InkWell(
      onTap: onWhereTap,
      borderRadius: BorderRadius.circular(32),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(color: c.surfaceContainerHigh, shape: BoxShape.circle),
              child: Icon(Icons.search, size: 18, color: c.onSurfaceVariant),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('¿A dónde vas?',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: c.onSurface)),
                  const SizedBox(height: 1),
                  Text(compactSummary,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 12, color: c.onSurfaceVariant)),
                ],
              ),
            ),
            const SizedBox(width: 8),
            _SearchFab(onTap: onSearch, colors: c),
          ],
        ),
      ),
    );
  }
}

class _PillSegment extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final VoidCallback onTap;
  final ColorScheme colors;
  const _PillSegment({required this.label, required this.value, required this.icon, required this.onTap, required this.colors});
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(32),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Icon(icon, size: 12, color: colors.onSurfaceVariant),
                const SizedBox(width: 4),
                Text(label,
                    style: TextStyle(fontSize: 10, letterSpacing: 0.6, fontWeight: FontWeight.w700, color: colors.onSurfaceVariant)),
              ]),
              const SizedBox(height: 2),
              Text(value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: colors.onSurface)),
            ],
          ),
        ),
      ),
    );
  }
}

class _VDiv extends StatelessWidget {
  final Color color;
  const _VDiv({required this.color});
  @override
  Widget build(BuildContext context) => Container(width: 1, height: 32, color: color.withValues(alpha: 0.5));
}

class _SearchFab extends StatelessWidget {
  final VoidCallback onTap;
  final ColorScheme colors;
  const _SearchFab({required this.onTap, required this.colors});
  @override
  Widget build(BuildContext context) {
    return Material(
      color: colors.primary,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Icon(Icons.search, size: 18, color: colors.onPrimary),
        ),
      ),
    );
  }
}

class _QuickPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _QuickPill({required this.icon, required this.label, required this.selected, required this.onTap});
  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    return Material(
      color: selected ? c.primaryContainer : c.surfaceContainerHigh,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Icon(icon, size: 14, color: selected ? c.onPrimaryContainer : c.onSurfaceVariant),
            const SizedBox(width: 6),
            Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: selected ? c.onPrimaryContainer : c.onSurfaceVariant)),
          ]),
        ),
      ),
    );
  }
}

// ── Sheets ──────────────────────────────────────────────────────────

class _LocationSheet extends StatelessWidget {
  final CostaRicaProvince? selected;
  final ValueChanged<CostaRicaProvince?> onSelected;
  const _LocationSheet({required this.selected, required this.onSelected});
  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(width: 36, height: 4, decoration: BoxDecoration(color: c.outlineVariant, borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 12),
          Row(children: [
            Icon(Icons.public, size: 18, color: c.primary),
            const SizedBox(width: 8),
            Text('¿Dónde buscas?', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: c.onSurface, fontWeight: FontWeight.w700)),
            const Spacer(),
            Text('Global · CR', style: TextStyle(fontSize: 11, letterSpacing: 0.5, color: c.onSurfaceVariant)),
          ]),
          const SizedBox(height: 12),
          _SheetTile(title: 'Cualquier lugar — Búsqueda global', subtitle: 'Ver todas las provincias', selected: selected == null, onTap: () => onSelected(null)),
          ...CostaRicaProvince.values.map((p) => _SheetTile(title: p.label, subtitle: 'Provincia', selected: selected == p, onTap: () => onSelected(p))),
        ]),
      ),
    );
  }
}

class _SheetTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;
  const _SheetTile({required this.title, required this.subtitle, required this.selected, required this.onTap});
  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: selected ? c.primaryContainer.withValues(alpha: 0.25) : c.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Row(children: [
              Icon(selected ? Icons.check_circle : Icons.circle_outlined, size: 20, color: selected ? c.primary : c.onSurfaceVariant),
              const SizedBox(width: 10),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(title, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: c.onSurface)),
                  Text(subtitle, style: TextStyle(fontSize: 11, color: c.onSurfaceVariant)),
                ]),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}

class _BudgetSheet extends StatefulWidget {
  final RangeValues range;
  final ValueChanged<RangeValues> onChanged;
  final VoidCallback onApply;
  const _BudgetSheet({required this.range, required this.onChanged, required this.onApply});
  @override
  State<_BudgetSheet> createState() => _BudgetSheetState();
}
class _BudgetSheetState extends State<_BudgetSheet> {
  late RangeValues _v;
  @override
  void initState() {
    super.initState();
    _v = widget.range;
  }

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(width: 36, height: 4, decoration: BoxDecoration(color: c.outlineVariant, borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 12),
          Row(children: [
            Icon(Icons.payments_outlined, size: 18, color: c.primary),
            const SizedBox(width: 8),
            Text('Presupuesto', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: c.onSurface, fontWeight: FontWeight.w700)),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: c.surfaceContainerHigh, borderRadius: BorderRadius.circular(8)),
              child: Text('₡ ${( _v.start/1000).round()}k – ₡${(_v.end/1000).round()}k', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: c.onSurface)),
            ),
          ]),
          const SizedBox(height: 16),
          RangeSlider(values: _v, min: 50000, max: 1000000, divisions: 19, labels: RangeLabels('₡${(_v.start/1000).round()}k','₡${(_v.end/1000).round()}k'), onChanged: (nv){ setState(()=> _v=nv); widget.onChanged(nv);} ),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('₡75k', style: TextStyle(fontSize: 11, color: c.onSurfaceVariant)),
            Text('₡1.5M+', style: TextStyle(fontSize: 11, color: c.onSurfaceVariant)),
          ]),
          const SizedBox(height: 16),
          SizedBox(width: double.infinity, child: FilledButton(onPressed: widget.onApply, child: const Text('Aplicar'))),
        ]),
      ),
    );
  }
}

class _RoomsSheet extends StatefulWidget {
  final int min;
  final int max;
  final void Function(int,int) onChanged;
  const _RoomsSheet({required this.min, required this.max, required this.onChanged});
  @override
  State<_RoomsSheet> createState() => _RoomsSheetState();
}
class _RoomsSheetState extends State<_RoomsSheet> {
  late int _a, _b;
  @override
  void initState(){ super.initState(); _a=widget.min; _b=widget.max;}
  @override
  Widget build(BuildContext context){
    final c=Theme.of(context).colorScheme;
    return SafeArea(child: Padding(padding: const EdgeInsets.fromLTRB(16,12,16,24), child: Column(mainAxisSize: MainAxisSize.min, children: [
      Container(width:36,height:4,decoration:BoxDecoration(color:c.outlineVariant, borderRadius: BorderRadius.circular(2))),
      const SizedBox(height:12),
      Row(children:[Icon(Icons.bed_outlined,size:18,color:c.primary), const SizedBox(width:8), Text('Habitaciones', style: Theme.of(context).textTheme.titleMedium?.copyWith(color:c.onSurface, fontWeight: FontWeight.w700))]),
      const SizedBox(height:16),
      Row(children:[
        Expanded(child: _Step(label:'Mín', value:_a, onDec: _a>1 ? ()=> setState(()=>_a--) : null, onInc: _a<_b ? ()=> setState(()=>_a++) : null)),
        const SizedBox(width:12),
        Expanded(child: _Step(label:'Máx', value:_b, onDec: _b>_a ? ()=> setState(()=>_b--) : null, onInc: _b<5 ? ()=> setState(()=>_b++) : null)),
      ]),
      const SizedBox(height:16),
      SizedBox(width: double.infinity, child: FilledButton(onPressed: ()=> widget.onChanged(_a,_b), child: const Text('Aplicar'))),
    ])));
  }
}
class _Step extends StatelessWidget{
  final String label; final int value; final VoidCallback? onDec; final VoidCallback? onInc;
  const _Step({required this.label, required this.value, required this.onDec, required this.onInc});
  @override Widget build(BuildContext context){
    final c=Theme.of(context).colorScheme;
    return Container(padding: const EdgeInsets.symmetric(horizontal:12, vertical:12), decoration: BoxDecoration(color:c.surfaceContainer, borderRadius: BorderRadius.circular(12)), child: Column(children:[
      Text(label, style: TextStyle(fontSize:11, letterSpacing:0.5, color:c.onSurfaceVariant)),
      const SizedBox(height:8),
      Row(mainAxisAlignment: MainAxisAlignment.center, children:[
        IconButton.filledTonal(onPressed:onDec, icon: const Icon(Icons.remove, size:16)),
        Padding(padding: const EdgeInsets.symmetric(horizontal:12), child: Text('$value', style: TextStyle(fontSize:20, fontWeight: FontWeight.w700, color:c.onSurface))),
        IconButton.filledTonal(onPressed:onInc, icon: const Icon(Icons.add, size:16)),
      ])
    ]));
  }
}

class _PetsSheet extends StatelessWidget {
  final PetType selected; final ValueChanged<PetType> onSelected;
  const _PetsSheet({required this.selected, required this.onSelected});
  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 36, height: 4, decoration: BoxDecoration(color: c.outlineVariant, borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 12),
            Row(children: [
              Icon(Icons.pets_outlined, size: 18, color: c.primary),
              const SizedBox(width: 8),
              Text('Mascotas', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: c.onSurface, fontWeight: FontWeight.w700)),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: c.surfaceContainerHigh, borderRadius: BorderRadius.circular(8)),
                child: Text('HAB-14', style: TextStyle(fontSize: 11, color: c.onSurfaceVariant)),
              ),
            ]),
            const SizedBox(height: 12),
            ...PetType.values.map((p) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Material(
                    color: selected == p ? c.primaryContainer.withValues(alpha: 0.25) : c.surfaceContainer,
                    borderRadius: BorderRadius.circular(12),
                    child: InkWell(
                      onTap: () => onSelected(p),
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        child: Row(children: [
                          Icon(p == PetType.none ? Icons.block : Icons.pets, size: 18, color: selected == p ? c.primary : c.onSurfaceVariant),
                          const SizedBox(width: 10),
                          Expanded(child: Text(p.label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: c.onSurface))),
                          Icon(selected == p ? Icons.check_circle : Icons.circle_outlined, size: 20, color: selected == p ? c.primary : c.onSurfaceVariant),
                        ]),
                      ),
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
