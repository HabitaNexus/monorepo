/**
 * Términos negociables como documento JSON versionado (HAB-26).
 *
 * Los 34 términos viajan como documento, no como 34 columnas: el catálogo
 * legal puede crecer sin migrar. Los slots HAB-28/29/30 leen este documento.
 * La validación de rangos/valores vive en HAB-30; aquí solo forma y catálogo.
 *
 * Dominio puro: sin imports de frameworks.
 */

import { InvalidTermsDocument } from './errors.js';
import { SUPPORTED_TERMS_VERSION } from './states.js';

export const TERMS_CATALOG = [
  'renta_mensual',
  'deposito_garantia',
  'plazo_meses',
  'fecha_inicio',
  'fecha_fin',
  'dia_pago',
  'moneda',
  'incremento_anual',
  'mascotas_permitidas',
  'numero_ocupantes',
  'uso_inmueble',
  'mantenimiento_menor',
  'mantenimiento_mayor',
  'servicios_agua',
  'servicios_luz',
  'servicios_internet',
  'cuota_mantenimiento',
  'parqueo',
  'amueblado',
  'inventario',
  'penalidad_mora',
  'preaviso_dias',
  'renovacion_automatica',
  'subarriendo',
  'mejoras',
  'visitas_propietario',
  'seguro_inquilino',
  'gastos_notariales',
  'firma_digital',
  'entrega_llaves',
  'estado_pintura',
  'jardineria',
  'arbitraje',
  'resolucion_temprana',
] as const;

export type TermKey = (typeof TERMS_CATALOG)[number];

export interface TermsDocument {
  readonly version: 1;
  readonly terms: Partial<Record<TermKey, unknown>>;
}

const KNOWN_KEYS: ReadonlySet<string> = new Set<string>(TERMS_CATALOG);

function isJsonValue(value: unknown): boolean {
  if (value === null) return true;
  const kind = typeof value;
  if (kind === 'string' || kind === 'number' || kind === 'boolean') return true;
  if (Array.isArray(value)) return value.every(isJsonValue);
  if (kind === 'object') {
    return Object.values(value as Record<string, unknown>).every(isJsonValue);
  }
  return false;
}

export function validateTermsDocument(doc: unknown): TermsDocument {
  const issues: string[] = [];
  if (typeof doc !== 'object' || doc === null || Array.isArray(doc)) {
    throw new InvalidTermsDocument(['el documento debe ser un objeto']);
  }
  const record = doc as Record<string, unknown>;
  if (record['version'] !== SUPPORTED_TERMS_VERSION) {
    issues.push(
      `version debe ser ${SUPPORTED_TERMS_VERSION} (recibido: ${String(record['version'])})`,
    );
  }
  const terms = record['terms'];
  if (typeof terms !== 'object' || terms === null || Array.isArray(terms)) {
    issues.push('terms debe ser un objeto');
  } else {
    const entries = Object.entries(terms as Record<string, unknown>);
    if (entries.length === 0) {
      issues.push('terms debe incluir al menos un término modificado');
    }
    for (const [key, value] of entries) {
      if (!KNOWN_KEYS.has(key)) {
        issues.push(`término desconocido: ${key}`);
      } else if (value === undefined) {
        issues.push(`término sin valor: ${key}`);
      } else if (!isJsonValue(value)) {
        issues.push(`valor no serializable como JSON: ${key}`);
      }
    }
  }
  if (issues.length > 0) {
    throw new InvalidTermsDocument(issues);
  }
  return doc as TermsDocument;
}
