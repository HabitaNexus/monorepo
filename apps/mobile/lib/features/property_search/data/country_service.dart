/// Servicio global de países/regiones — APIs reales.
///
/// Países: restcountries.com (https://restcountries.com/v3.1/all?fields=name,cca2,flags)
/// Estados: countriesnow.space (https://countriesnow.space/api/v0.1/countries/states)
library;

import 'package:dio/dio.dart';

class CountryService {
  final Dio _dio;
  CountryService({Dio? dio}) : _dio = dio ?? Dio();

  List<_ApiCountry>? _cacheCountries;
  Map<String, List<String>> _cacheStates = {};

  /// Fetch países reales (countriesnow) — 1 call trae países+estados. Cache.
  Future<List<_ApiCountry>?> fetchCountries() async {
    if (_cacheCountries != null) return _cacheCountries;
    try {
      final res = await _dio.get('https://countriesnow.space/api/v0.1/countries/states');
      final data = res.data as Map<String, dynamic>;
      if (data['error'] == true) return null;
      final List list = data['data'] as List;
      final out = <_ApiCountry>[];
      _cacheStates.clear();
      for (final e in list) {
        final m = e as Map<String, dynamic>;
        final name = m['name'] as String;
        final code = (m['iso2'] as String).toUpperCase();
        final flag = _flagFromCode(code);
        final states = (m['states'] as List).map((s) => (s as Map)['name'] as String).toList();
        _cacheStates[code] = states;
        out.add(_ApiCountry(code: code, name: name, flag: flag));
      }
      out.sort((a, b) => a.name.compareTo(b.name));
      _cacheCountries = out;
      return out;
    } catch (_) {
      return null;
    }
  }

  /// Fetch estados para un país (usa cache de fetchCountries si existe, si no fallback POST)
  Future<List<String>?> fetchStates(String countryCode, String countryNameEn) async {
    if (_cacheStates.containsKey(countryCode)) return _cacheStates[countryCode];
    try {
      final res = await _dio.post(
        'https://countriesnow.space/api/v0.1/countries/states',
        data: {'country': countryNameEn},
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
      final data = res.data as Map<String, dynamic>;
      if (data['error'] == true) return null;
      final states = (data['data'] as Map)['states'] as List;
      final list = states.map((e) => (e as Map)['name'] as String).toList();
      _cacheStates[countryCode] = list;
      return list;
    } catch (_) {
      return null;
    }
  }

  /// Fetch ciudades/barrios para un país+estado (countriesnow). Cache por país.
  final Map<String, List<String>> _cacheCities = {};
  Future<List<String>?> fetchCities(String country, String state) async {
    final key = '$country/$state';
    if (_cacheCities.containsKey(key)) return _cacheCities[key];
    try {
      final res = await _dio.post(
        'https://countriesnow.space/api/v0.1/countries/state/cities',
        data: {'country': country, 'state': state},
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
      final data = res.data as Map<String, dynamic>;
      if (data['error'] == true) return null;
      final list = (data['data'] as List).cast<String>();
      _cacheCities[key] = list;
      return list;
    } catch (_) {
      return null;
    }
  }

  static String _flagFromCode(String code) {
    // Convierte US -> 🇺🇸 (regional indicator)
    const base = 0x1F1E6;
    final c1 = code.codeUnitAt(0) - 0x41 + base;
    final c2 = code.codeUnitAt(1) - 0x41 + base;
    return String.fromCharCodes([c1, c2]);
  }
}

class _ApiCountry {
  final String code;
  final String name;
  final String flag;
  const _ApiCountry({required this.code, required this.name, required this.flag});
}
