/// Providers de búsqueda de propiedades (HAB-18).
///
/// Estado con Riverpod para filtros, resultados y favoritos.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/property.dart';
import '../../domain/property_filter.dart';
import '../../domain/property_search_repository.dart';
import '../../data/property_search_repository_impl.dart';

/// Provider del repositorio
final propertySearchRepositoryProvider = Provider<PropertySearchRepository>(
  (ref) => PropertySearchRepositoryImpl(),
);

/// Provider del filtro actual
final propertyFilterProvider = StateProvider<PropertyFilter>(
  (ref) => const PropertyFilter(),
);

/// Provider de resultados de búsqueda
final searchResultsProvider = FutureProvider<List<Property>>((ref) async {
  final repository = ref.watch(propertySearchRepositoryProvider);
  final filter = ref.watch(propertyFilterProvider);
  return repository.searchProperties(filter);
});

/// Provider de favoritos
final favoritesProvider = StateNotifierProvider<FavoritesNotifier, Set<String>>(
  (ref) => FavoritesNotifier(ref),
);

/// Notificador de favoritos
class FavoritesNotifier extends StateNotifier<Set<String>> {
  final Ref _ref;

  FavoritesNotifier(this._ref) : super({}) {
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final repository = _ref.read(propertySearchRepositoryProvider);
    final favorites = await repository.getFavorites();
    state = favorites.map((p) => p.id).toSet();
  }

  Future<void> toggleFavorite(String propertyId) async {
    final repository = _ref.read(propertySearchRepositoryProvider);

    if (state.contains(propertyId)) {
      await repository.removeFromFavorites(propertyId);
      state = {...state}..remove(propertyId);
    } else {
      await repository.addToFavorites(propertyId);
      state = {...state, propertyId};
    }
  }

  bool isFavorite(String propertyId) {
    return state.contains(propertyId);
  }
}

/// Provider de propiedades seleccionadas para comparar
final comparisonProvider = StateNotifierProvider<ComparisonNotifier, List<String>>(
  (ref) => ComparisonNotifier(),
);

/// Notificador de comparación
class ComparisonNotifier extends StateNotifier<List<String>> {
  ComparisonNotifier() : super([]);

  static const int maxComparison = 3;

  void toggleComparison(String propertyId) {
    if (state.contains(propertyId)) {
      state = [...state]..remove(propertyId);
    } else if (state.length < maxComparison) {
      state = [...state, propertyId];
    }
  }

  void clearComparison() {
    state = [];
  }

  bool isSelected(String propertyId) {
    return state.contains(propertyId);
  }

  bool get canAddMore => state.length < maxComparison;
}

/// Provider de propiedades para comparar
final comparisonPropertiesProvider = FutureProvider<List<Property>>((ref) async {
  final repository = ref.watch(propertySearchRepositoryProvider);
  final comparisonIds = ref.watch(comparisonProvider);
  return repository.compareProperties(comparisonIds);
});

/// Provider de estadísticas de búsqueda
final searchStatsProvider = Provider<SearchStats>((ref) {
  final results = ref.watch(searchResultsProvider);
  return results.when(
    data: (properties) => SearchStats(
      totalCount: properties.length,
      verifiedCount: properties.where((p) => p.verificationStatus == VerificationStatus.verified).length,
      avgPrice: properties.isEmpty
          ? 0
          : properties.map((p) => p.priceMonthly).reduce((a, b) => a + b) ~/ properties.length,
    ),
    loading: () => const SearchStats(),
    error: (_, __) => const SearchStats(),
  );
});

/// Estadísticas de búsqueda
class SearchStats {
  final int totalCount;
  final int verifiedCount;
  final int avgPrice;

  const SearchStats({
    this.totalCount = 0,
    this.verifiedCount = 0,
    this.avgPrice = 0,
  });

  String get formattedAvgPrice {
    if (avgPrice == 0) return '₡0';
    return '₡${avgPrice.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        )}';
  }
}
