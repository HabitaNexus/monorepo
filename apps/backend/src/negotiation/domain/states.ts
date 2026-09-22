/**
 * Estados de la máquina de negociación (HAB-26).
 *
 * Dominio puro: este módulo no importa frameworks, ORM ni HTTP.
 * La unión discriminada por `status` representa los 6 estados del SOP.
 */

export const MAX_ROUNDS = 5;
export const ROUND_TTL_HOURS = 72;
export const SUPPORTED_TERMS_VERSION = 1;

export type NegotiationStatus =
  | 'PROPUESTA_ENVIADA'
  | 'CONTRAPROPUESTA'
  | 'ACUERDO_ALCANZADO'
  | 'PENDIENTE_FIRMA'
  | 'RECHAZADA'
  | 'EXPIRADA';

export type NegotiationParty = 'TENANT' | 'OWNER';

export type ExpiryReason = 'TIMEOUT_72H' | 'MAX_ROUNDS_REACHED';

interface BaseState {
  readonly round: number;
  readonly deadline: string;
}

export interface PropuestaEnviada extends BaseState {
  readonly status: 'PROPUESTA_ENVIADA';
}

export interface Contrapropuesta extends BaseState {
  readonly status: 'CONTRAPROPUESTA';
}

export interface AcuerdoAlcanzado extends BaseState {
  readonly status: 'ACUERDO_ALCANZADO';
  readonly tenantConfirmed: boolean;
  readonly ownerConfirmed: boolean;
}

export interface PendienteFirma {
  readonly status: 'PENDIENTE_FIRMA';
  readonly round: number;
  readonly deadline: string;
}

export interface Rechazada {
  readonly status: 'RECHAZADA';
  readonly round: number;
  readonly deadline: string;
  readonly reason: string;
}

export interface Expirada {
  readonly status: 'EXPIRADA';
  readonly round: number;
  readonly deadline: string;
  readonly reason: ExpiryReason;
}

export type NegotiationState =
  | PropuestaEnviada
  | Contrapropuesta
  | AcuerdoAlcanzado
  | PendienteFirma
  | Rechazada
  | Expirada;

export interface Negotiation {
  readonly id: string;
  readonly listingId: string;
  readonly tenantId: string;
  readonly ownerId: string;
  readonly state: NegotiationState;
  readonly createdAt: string;
  readonly updatedAt: string;
}

const TERMINAL: ReadonlySet<NegotiationStatus> = new Set([
  'PENDIENTE_FIRMA',
  'RECHAZADA',
  'EXPIRADA',
]);

export function isTerminal(status: NegotiationStatus): boolean {
  return TERMINAL.has(status);
}
