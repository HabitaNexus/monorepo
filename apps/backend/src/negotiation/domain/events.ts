/**
 * Eventos de la máquina de negociación (HAB-26).
 *
 * Dominio puro: sin imports de frameworks.
 * `at` es el timestamp ISO del intento; lo provee la capa de aplicación
 * con el clock inyectable para que `transition` siga siendo pura.
 */

import type { ExpiryReason, NegotiationParty } from './states.js';

export type NegotiationEventType =
  | 'COUNTER_PROPOSED'
  | 'ACCEPTED'
  | 'REJECTED'
  | 'ROUND_EXPIRED'
  | 'MAX_ROUNDS_REACHED'
  | 'SUMMARY_CONFIRMED';

export interface CounterProposed {
  readonly type: 'COUNTER_PROPOSED';
  readonly at: string;
}

export interface Accepted {
  readonly type: 'ACCEPTED';
  readonly at: string;
}

export interface Rejected {
  readonly type: 'REJECTED';
  readonly at: string;
  readonly reason: string;
}

export interface RoundExpired {
  readonly type: 'ROUND_EXPIRED';
  readonly at: string;
}

export interface MaxRoundsReached {
  readonly type: 'MAX_ROUNDS_REACHED';
  readonly at: string;
  readonly reason: ExpiryReason;
}

export interface SummaryConfirmed {
  readonly type: 'SUMMARY_CONFIRMED';
  readonly at: string;
  readonly party: NegotiationParty;
}

export type NegotiationEvent =
  | CounterProposed
  | Accepted
  | Rejected
  | RoundExpired
  | MaxRoundsReached
  | SummaryConfirmed;
