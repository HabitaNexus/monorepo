/**
 * Máquina de estados de negociación (HAB-26).
 *
 * Función pura `transition(state, event)`: sin reloj, sin I/O, sin frameworks.
 * El timestamp `at` de cada evento lo provee la capa de aplicación con el
 * clock inyectable; el deadline de ronda se deriva como `at + 72h`.
 *
 * Diagrama válido:
 * - PROPUESTA_ENVIADA → CONTRAPROPUESTA | ACUERDO_ALCANZADO | RECHAZADA | EXPIRADA
 * - CONTRAPROPUESTA   → CONTRAPROPUESTA | ACUERDO_ALCANZADO | RECHAZADA | EXPIRADA
 * - ACUERDO_ALCANZADO → PENDIENTE_FIRMA (solo confirmación bilateral)
 * - Terminales (PENDIENTE_FIRMA, RECHAZADA, EXPIRADA): sin salidas.
 *
 * Cierre a 5 rondas: una contrapropuesta con `round === MAX_ROUNDS` no abre
 * ronda 6; la negociación se cierra como EXPIRADA (a confirmar con @lapc506).
 */

import { InvalidNegotiationTransition } from './errors.js';
import type { NegotiationEvent } from './events.js';
import {
  MAX_ROUNDS,
  ROUND_TTL_HOURS,
  type ExpiryReason,
  type NegotiationState,
} from './states.js';

const MS_PER_HOUR = 3_600_000;

export function deadlineAfter(at: string, hours = ROUND_TTL_HOURS): string {
  return new Date(new Date(at).getTime() + hours * MS_PER_HOUR).toISOString();
}

export function transition(
  state: NegotiationState,
  event: NegotiationEvent,
): NegotiationState {
  switch (state.status) {
    case 'PROPUESTA_ENVIADA':
    case 'CONTRAPROPUESTA':
      return transitionFromOpenRound(state, event);
    case 'ACUERDO_ALCANZADO':
      return transitionFromAgreement(state, event);
    case 'PENDIENTE_FIRMA':
    case 'RECHAZADA':
    case 'EXPIRADA':
      throw new InvalidNegotiationTransition(state.status, event.type);
  }
}

function transitionFromOpenRound(
  state: Extract<
    NegotiationState,
    { status: 'PROPUESTA_ENVIADA' | 'CONTRAPROPUESTA' }
  >,
  event: NegotiationEvent,
): NegotiationState {
  switch (event.type) {
    case 'COUNTER_PROPOSED': {
      if (state.round >= MAX_ROUNDS) {
        return {
          status: 'EXPIRADA',
          round: state.round,
          deadline: state.deadline,
          reason: 'MAX_ROUNDS_REACHED',
        };
      }
      return {
        status: 'CONTRAPROPUESTA',
        round: state.round + 1,
        deadline: deadlineAfter(event.at),
      };
    }
    case 'ACCEPTED':
      return {
        status: 'ACUERDO_ALCANZADO',
        round: state.round,
        deadline: state.deadline,
        tenantConfirmed: false,
        ownerConfirmed: false,
      };
    case 'REJECTED':
      return {
        status: 'RECHAZADA',
        round: state.round,
        deadline: state.deadline,
        reason: event.reason,
      };
    case 'ROUND_EXPIRED':
      return closeExpired(state.round, state.deadline, 'TIMEOUT_72H');
    case 'MAX_ROUNDS_REACHED':
      return closeExpired(state.round, state.deadline, event.reason);
    case 'SUMMARY_CONFIRMED':
      throw new InvalidNegotiationTransition(state.status, event.type);
  }
}

function transitionFromAgreement(
  state: Extract<NegotiationState, { status: 'ACUERDO_ALCANZADO' }>,
  event: NegotiationEvent,
): NegotiationState {
  if (event.type !== 'SUMMARY_CONFIRMED') {
    throw new InvalidNegotiationTransition(state.status, event.type);
  }
  const tenantConfirmed =
    state.tenantConfirmed || event.party === 'TENANT';
  const ownerConfirmed = state.ownerConfirmed || event.party === 'OWNER';
  if (tenantConfirmed && ownerConfirmed) {
    return {
      status: 'PENDIENTE_FIRMA',
      round: state.round,
      deadline: state.deadline,
    };
  }
  return { ...state, tenantConfirmed, ownerConfirmed };
}

function closeExpired(
  round: number,
  deadline: string,
  reason: ExpiryReason,
): NegotiationState {
  return { status: 'EXPIRADA', round, deadline, reason };
}
