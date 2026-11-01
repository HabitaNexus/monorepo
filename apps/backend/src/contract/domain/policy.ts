/**
 * Política legal del contrato antes de pintar cláusulas (HAB-31).
 *
 * Depósito, plazo y techo de incremento viven aquí, no en cada cláusula.
 * Si la política rechaza, no hay borrador.
 */

import {
  DatoMinimoAusente,
  DepositoInferiorAlMinimo,
  IncrementoSobreTope,
  PlazoInconsistente,
} from './errors.js';
import type { ContractFacts, ContractInput, PartyFacts, PropertyFacts } from './types.js';

export const SHORT_TERM_NOTICE =
  'Aviso legal (Art. 70 y 71, Ley 7527): La Ley General de Arrendamientos establece un plazo mínimo de 3 años. Los contratos con plazo inferior se entienden legalmente como contratos de 3 años. Si el propietario no notifica su voluntad de no renovar con al menos 3 meses de anticipación, el contrato se renueva automáticamente por 3 años más. Ambas partes aceptan conocer esta disposición.';

export const TACIT_RENEWAL =
  'Opera la prórroga tácita por tres años si el arrendador no notifica la no renovación con al menos tres meses de anticipación.';

const REQUIRED_TERM_KEYS = [
  'renta_mensual',
  'deposito_garantia',
  'plazo_meses',
  'fecha_inicio',
  'fecha_fin',
  'dia_pago',
  'moneda',
  'uso_inmueble',
] as const;

const OPTIONAL_KEYS = [
  'inventario',
  'estado_pintura',
  'amueblado',
  'parqueo',
  'jardineria',
  'subarriendo',
  'mascotas_permitidas',
  'numero_ocupantes',
  'mantenimiento_menor',
  'mantenimiento_mayor',
  'mejoras',
  'visitas_propietario',
  'cuota_mantenimiento',
  'servicios_agua',
  'servicios_luz',
  'servicios_internet',
  'resolucion_temprana',
  'penalidad_mora',
  'entrega_llaves',
  'seguro_inquilino',
  'arbitraje',
  'gastos_notariales',
] as const;

export type IncrementoPactado =
  | { readonly kind: 'formula' }
  | { readonly kind: 'rate'; readonly percent: number }
  | { readonly kind: 'foreign' };

export interface AssessedAgreement {
  readonly facts: ContractFacts;
  readonly rentaMensual: number;
  readonly depositoGarantia: number;
  readonly plazoMeses: number;
  readonly fechaInicio: string;
  readonly fechaFin: string;
  readonly diaPago: number;
  readonly moneda: string;
  readonly usoInmueble: string;
  readonly shortTerm: boolean;
  readonly preavisoEficaz: number | null;
  readonly incremento: IncrementoPactado;
  readonly optional: Readonly<Record<string, unknown>>;
}

export function assessAgreement(input: ContractInput): AssessedAgreement {
  const issues: string[] = [];
  const facts = input.facts;
  requireParty(facts.arrendador, 'arrendador', issues);
  requireParty(facts.arrendatario, 'arrendatario', issues);
  requireProperty(facts.inmueble, issues);
  requireText(facts.fechaContrato, 'fechaContrato', issues);
  if (!isIsoDate(facts.fechaContrato)) issues.push('fechaContrato debe ser YYYY-MM-DD');
  requireText(facts.lugarPago, 'lugarPago', issues);
  requireText(facts.formaPago, 'formaPago', issues);
  requireText(input.negotiationId, 'negotiationId', issues);

  const terms = input.terms;
  for (const key of REQUIRED_TERM_KEYS) {
    if (terms[key] === undefined || terms[key] === null || terms[key] === '') {
      issues.push(`falta ${key}`);
    }
  }

  const moneda = typeof terms['moneda'] === 'string' ? terms['moneda'].trim() : '';
  if (moneda.length === 0) issues.push('moneda vacía');
  const foreign = moneda !== 'CRC';
  if (!foreign && !isFiniteNumber(facts.ipcAnual)) {
    issues.push('falta ipcAnual para moneda CRC');
  }

  const renta = readInt(terms['renta_mensual'], 'renta_mensual', issues);
  const deposito = readInt(terms['deposito_garantia'], 'deposito_garantia', issues);
  const plazo = readInt(terms['plazo_meses'], 'plazo_meses', issues);
  const diaPago = readInt(terms['dia_pago'], 'dia_pago', issues);
  const fechaInicio = readDate(terms['fecha_inicio'], 'fecha_inicio', issues);
  const fechaFin = readDate(terms['fecha_fin'], 'fecha_fin', issues);
  const uso = typeof terms['uso_inmueble'] === 'string' ? terms['uso_inmueble'].trim() : '';
  if (uso.length === 0) issues.push('uso_inmueble vacío');

  if (issues.length > 0) throw new DatoMinimoAusente(issues);

  const expectedEnd = addCalendarMonths(fechaInicio, plazo);
  if (expectedEnd === null || expectedEnd !== fechaFin) {
    throw new PlazoInconsistente(
      `fecha_fin ${fechaFin} no coincide con ${fechaInicio} más ${plazo} meses`,
    );
  }

  if (deposito < renta) throw new DepositoInferiorAlMinimo();

  const incremento = resolveIncremento(terms['incremento_anual'], foreign, facts.ipcAnual);
  const preaviso = readPreaviso(terms['preaviso_dias']);

  const optional: Record<string, unknown> = {};
  for (const key of OPTIONAL_KEYS) {
    if (terms[key] !== undefined) optional[key] = terms[key];
  }

  return {
    facts,
    rentaMensual: renta,
    depositoGarantia: deposito,
    plazoMeses: plazo,
    fechaInicio,
    fechaFin,
    diaPago,
    moneda,
    usoInmueble: uso,
    shortTerm: plazo < 36,
    preavisoEficaz: preaviso,
    incremento,
    optional,
  };
}

function resolveIncremento(
  raw: unknown,
  foreign: boolean,
  ipcAnual: number | undefined,
): IncrementoPactado {
  if (foreign) return { kind: 'foreign' };
  if (raw === undefined || raw === null || raw === 'IPC') return { kind: 'formula' };
  if (typeof raw === 'string' && raw.trim() === 'IPC') return { kind: 'formula' };
  if (typeof raw !== 'number' || !Number.isFinite(raw)) {
    throw new DatoMinimoAusente(['incremento_anual debe ser un número o IPC']);
  }
  const tope = ipcAnual as number;
  if (raw > tope) throw new IncrementoSobreTope(raw, tope);
  return { kind: 'rate', percent: raw };
}

function readPreaviso(raw: unknown): number | null {
  if (raw === undefined || raw === null) return null;
  if (typeof raw !== 'number' || !Number.isInteger(raw)) {
    throw new DatoMinimoAusente(['preaviso_dias debe ser un entero de días']);
  }
  if (raw < 90) return null;
  return raw;
}

function requireParty(party: PartyFacts, label: string, issues: string[]): void {
  requireText(party.nombre, `${label}.nombre`, issues);
  requireText(party.calidades, `${label}.calidades`, issues);
  requireText(party.personeria, `${label}.personeria`, issues);
  requireText(party.domicilio, `${label}.domicilio`, issues);
}

function requireProperty(property: PropertyFacts, issues: string[]): void {
  requireText(property.ubicacion, 'inmueble.ubicacion', issues);
  requireText(property.descripcion, 'inmueble.descripcion', issues);
  requireText(property.estadoConservacion, 'inmueble.estadoConservacion', issues);
  const cita = property.citaInscripcion?.trim() ?? '';
  const titulo = property.documentoFehaciente?.trim() ?? '';
  if (cita.length === 0 && titulo.length === 0) {
    issues.push('falta cita de inscripción o documento fehaciente');
  }
}

function requireText(value: string, label: string, issues: string[]): void {
  if (value.trim().length === 0) issues.push(`${label} vacío`);
}

function readInt(value: unknown, label: string, issues: string[]): number {
  if (typeof value !== 'number' || !Number.isInteger(value)) {
    issues.push(`${label} debe ser un entero`);
    return 0;
  }
  return value;
}

function readDate(value: unknown, label: string, issues: string[]): string {
  if (typeof value !== 'string' || !isIsoDate(value)) {
    issues.push(`${label} debe ser YYYY-MM-DD`);
    return '';
  }
  return value;
}

function isIsoDate(value: string): boolean {
  if (!/^\d{4}-\d{2}-\d{2}$/.test(value)) return false;
  const [year, month, day] = value.split('-').map((part) => Number(part));
  if (year === undefined || month === undefined || day === undefined) return false;
  const date = new Date(Date.UTC(year, month - 1, day));
  return (
    date.getUTCFullYear() === year &&
    date.getUTCMonth() === month - 1 &&
    date.getUTCDate() === day
  );
}

function isFiniteNumber(value: number | undefined): value is number {
  return typeof value === 'number' && Number.isFinite(value);
}

export function addCalendarMonths(isoDate: string, months: number): string | null {
  if (!isIsoDate(isoDate) || !Number.isInteger(months)) return null;
  const [year, month, day] = isoDate.split('-').map((part) => Number(part)) as [
    number,
    number,
    number,
  ];
  const target = new Date(Date.UTC(year, month - 1 + months, day));
  if (target.getUTCDate() !== day) return null;
  const mm = String(target.getUTCMonth() + 1).padStart(2, '0');
  const dd = String(target.getUTCDate()).padStart(2, '0');
  return `${target.getUTCFullYear()}-${mm}-${dd}`;
}
