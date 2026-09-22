/// Catálogo global de países y subdivisiones — HAB-18.
///
/// Fuente primaria: restcountries.com (https://restcountries.com/v3.1/all?fields=name,cca2)
//  + subdivisiones curadas para demo. Si no hay país logueado, se pregunta.
library;

import 'package:flutter/material.dart';

@immutable
class GlobalCountry {
  final String code; // ISO 3166-1 alpha-2, e.g. US
  final String name; // Nombre en español
  final String flag; // Emoji
  final List<String> regions; // Estados / provincias / departamentos
  const GlobalCountry({required this.code, required this.name, required this.flag, required this.regions});
}

/// 12 países demo (global) — se amplía vía API restcountries si hace falta.
const List<GlobalCountry> kGlobalCountries = [
  GlobalCountry(code: 'CR', name: 'Costa Rica', flag: '🇨🇷', regions: ['San José', 'Alajuela', 'Cartago', 'Heredia', 'Guanacaste', 'Puntarenas', 'Limón']),
  GlobalCountry(code: 'US', name: 'Estados Unidos', flag: '🇺🇸', regions: ['California', 'Texas', 'Florida', 'New York', 'Arizona', 'Washington', 'Colorado']),
  GlobalCountry(code: 'MX', name: 'México', flag: '🇲🇽', regions: ['Ciudad de México', 'Jalisco', 'Nuevo León', 'Quintana Roo', 'Yucatán', 'Baja California', 'Puebla']),
  GlobalCountry(code: 'ES', name: 'España', flag: '🇪🇸', regions: ['Madrid', 'Barcelona', 'Valencia', 'Sevilla', 'Málaga', 'Bilbao', 'Zaragoza']),
  GlobalCountry(code: 'CO', name: 'Colombia', flag: '🇨🇴', regions: ['Bogotá', 'Antioquia', 'Valle del Cauca', 'Atlántico', 'Santander', 'Bolívar', 'Cundinamarca']),
  GlobalCountry(code: 'AR', name: 'Argentina', flag: '🇦🇷', regions: ['Buenos Aires', 'Córdoba', 'Santa Fe', 'Mendoza', 'Tucumán', 'Entre Ríos', 'Salta']),
  GlobalCountry(code: 'CL', name: 'Chile', flag: '🇨🇱', regions: ['Santiago', 'Valparaíso', 'Biobío', 'Antofagasta', 'Araucanía', 'Coquimbo', 'Maule']),
  GlobalCountry(code: 'PE', name: 'Perú', flag: '🇵🇪', regions: ['Lima', 'Arequipa', 'Cusco', 'Piura', 'La Libertad', 'Lambayeque', 'Callao']),
  GlobalCountry(code: 'BR', name: 'Brasil', flag: '🇧🇷', regions: ['São Paulo', 'Río de Janeiro', 'Minas Gerais', 'Bahia', 'Paraná', 'Rio Grande do Sul', 'Pernambuco']),
  GlobalCountry(code: 'PA', name: 'Panamá', flag: '🇵🇦', regions: ['Panamá', 'Chiriquí', 'Colón', 'Coclé', 'Veraguas', 'Herrera', 'Los Santos']),
  GlobalCountry(code: 'DO', name: 'Rep. Dominicana', flag: '🇩🇴', regions: ['Distrito Nacional', 'Santiago', 'La Altagracia', 'Puerto Plata', 'La Vega', 'San Cristóbal', 'Duarte']),
  GlobalCountry(code: 'GT', name: 'Guatemala', flag: '🇬🇹', regions: ['Guatemala', 'Quetzaltenango', 'Sacatepéquez', 'Escuintla', 'Sololá', 'Chimaltenango', 'Alta Verapaz']),
];

GlobalCountry countryByCode(String code) =>
    kGlobalCountries.firstWhere((c) => c.code == code, orElse: () => kGlobalCountries.first);

List<GlobalCountry> searchCountries(String q) {
  final s = q.trim().toLowerCase();
  if (s.isEmpty) return kGlobalCountries;
  return kGlobalCountries.where((c) => c.name.toLowerCase().contains(s) || c.code.toLowerCase().contains(s)).toList();
}
