/// Providers globales de país/región — restcountries + countriesnow + login.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/country_service.dart';
import '../../domain/global_countries.dart';

final countryServiceProvider = Provider((ref) => CountryService());

/// Lista real de países (restcountries). Fallback a kGlobalCountries si falla/offline.
final globalCountriesRealProvider = FutureProvider<List<GlobalCountry>>((ref) async {
  final svc = ref.watch(countryServiceProvider);
  final api = await svc.fetchCountries();
  if (api == null || api.isEmpty) return kGlobalCountries;
  // Mapea API -> GlobalCountry conservando regiones curadas si existen, si no vacío (se fetcheará luego)
  return api.map((a) {
    GlobalCountry? curated;
    for (final k in kGlobalCountries) {
      if (k.code == a.code) { curated = k; break; }
    }
    return GlobalCountry(code: a.code, name: a.name, flag: a.flag, regions: curated?.regions ?? []);
  }).toList();
});

/// País del usuario (login). null = no logueado -> sheet pregunta país.
/// Persiste en SharedPreferences `user_country_code`.
final userCountryProvider = StateNotifierProvider<UserCountryNotifier, String?>((ref) => UserCountryNotifier());

class UserCountryNotifier extends StateNotifier<String?> {
  UserCountryNotifier() : super(null) {
    _load();
  }
  Future<void> _load() async {
    final sp = await SharedPreferences.getInstance();
    state = sp.getString('user_country_code');
    // Fallback: intenta detectar por locale si aún null? Se deja null para que sheet pregunte.
  }

  Future<void> setCountry(String? code) async {
    state = code;
    final sp = await SharedPreferences.getInstance();
    if (code == null) {
      await sp.remove('user_country_code');
    } else {
      await sp.setString('user_country_code', code);
    }
  }
}

/// Regiones reales para un país (countriesnow). Usa nombre inglés del país.
final countryRegionsProvider = FutureProvider.family<List<String>, String>((ref, countryCode) async {
  // Busca nombre inglés via API o curado
  final countries = await ref.watch(globalCountriesRealProvider.future);
  final country = countries.firstWhere((c) => c.code == countryCode, orElse: () => countryByCode(countryCode));
  // Si el curado ya tiene regiones, úsalas como fallback inmediato
  final curatedRegions = country.regions;
  final svc = ref.watch(countryServiceProvider);
  // Intenta fetch real (countriesnow usa nombre inglés; restcountries name ya es inglés)
  final real = await svc.fetchStates(countryCode, country.name);
  if (real != null && real.isNotEmpty) return real;
  return curatedRegions;
});
