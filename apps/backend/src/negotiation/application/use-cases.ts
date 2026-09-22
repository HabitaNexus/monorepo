/**
 * Casos de uso de negociación (HAB-26): propose, counterPropose, accept,
 * reject, confirmSummary, expireRound (+ expireRoundsSweep para el trigger).
 *
 * Funciones puras de infraestructura Nest: reciben el repositorio (port) y
 * el clock inyectable. La idempotencia es por UUID de intento: reintentos
 * desde mobile con el mismo `attemptId` no duplican rondas ni audit.
 * Los UUID se generan con WebCrypto (`crypto.randomUUID`, UUID v7).
 */

import {
  deadlineAfter,
  transition,
  validateTermsDocument,
  type Clock,
  type Negotiation,
  type NegotiationParty,
  type TermsDocument,
} from '../domain/index.js';
import {
  NegotiationNotFound,
  type NegotiationRecord,
  type NegotiationRepository,
  type TransitionAuditEntry,
} from './negotiation-repository.js';

export interface NegotiationDeps {
  readonly repository: NegotiationRepository;
  readonly clock: Clock;
}

export const EXPIRY_ACTOR = 'system:pg-cron';

export function newAttemptId(): string {
  return globalThis.crypto.randomUUID();
}

function isUuid(value: string): boolean {
  return /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i.test(
    value,
  );
}

function requireAttemptId(attemptId: string | undefined): string {
  const id = attemptId ?? newAttemptId();
  if (!isUuid(id)) {
    throw new Error(`attemptId debe ser UUID: ${id}`);
  }
  return id;
}

function auditFor(
  negotiationId: string,
  actor: string,
  at: string,
  from: NegotiationRecord['negotiation']['state']['status'],
  record: NegotiationRecord,
  attemptId: string,
): TransitionAuditEntry {
  return {
    id: newAttemptId(),
    negotiationId,
    actor,
    at,
    from,
    to: record.negotiation.state.status,
    round: record.negotiation.state.round,
    attemptId,
  };
}

function touch(negotiation: Negotiation, at: string): Negotiation {
  return { ...negotiation, updatedAt: at };
}

export interface ProposeInput {
  readonly listingId: string;
  readonly tenantId: string;
  readonly ownerId: string;
  readonly terms: unknown;
  readonly actor: string;
  readonly attemptId?: string;
  readonly id?: string;
}

export async function propose(
  deps: NegotiationDeps,
  input: ProposeInput,
): Promise<NegotiationRecord> {
  const attemptId = requireAttemptId(input.attemptId);
  const existing = await deps.repository.findByAttempt(attemptId);
  if (existing) return existing;
  const terms = validateTermsDocument(input.terms);
  const at = deps.clock.now().toISOString();
  const negotiation: Negotiation = {
    id: input.id ?? newAttemptId(),
    listingId: input.listingId,
    tenantId: input.tenantId,
    ownerId: input.ownerId,
    state: { status: 'PROPUESTA_ENVIADA', round: 1, deadline: deadlineAfter(at) },
    createdAt: at,
    updatedAt: at,
  };
  const record: NegotiationRecord = { negotiation, terms, summary: null };
  await deps.repository.insert(
    record,
    auditFor(negotiation.id, input.actor, at, 'PROPUESTA_ENVIADA', record, attemptId),
  );
  return record;
}

export interface CounterProposeInput {
  readonly id: string;
  readonly terms: unknown;
  readonly actor: string;
  readonly attemptId?: string;
}

async function mutate(
  deps: NegotiationDeps,
  id: string,
  actor: string,
  attemptId: string | undefined,
  eventAt: string,
  apply: (current: NegotiationRecord) => { record: NegotiationRecord },
): Promise<NegotiationRecord> {
  const attempt = requireAttemptId(attemptId);
  const replay = await deps.repository.findByAttempt(attempt);
  if (replay) return replay;
  const current = await deps.repository.findById(id);
  if (!current) throw new NegotiationNotFound(id);
  const from = current.negotiation.state.status;
  const { record } = apply(current);
  await deps.repository.update(record, auditFor(id, actor, eventAt, from, record, attempt));
  return record;
}

export async function counterPropose(
  deps: NegotiationDeps,
  input: CounterProposeInput,
): Promise<NegotiationRecord> {
  const terms = validateTermsDocument(input.terms);
  const at = deps.clock.now().toISOString();
  return mutate(deps, input.id, input.actor, input.attemptId, at, (current) => {
    const state = transition(current.negotiation.state, {
      type: 'COUNTER_PROPOSED',
      at,
    });
    const keptTerms = state.status === 'EXPIRADA' ? current.terms : terms;
    return {
      record: {
        negotiation: touch({ ...current.negotiation, state }, at),
        terms: keptTerms,
        summary: current.summary,
      },
    };
  });
}

export interface AcceptInput {
  readonly id: string;
  readonly actor: string;
  readonly attemptId?: string;
}

export async function accept(
  deps: NegotiationDeps,
  input: AcceptInput,
): Promise<NegotiationRecord> {
  const at = deps.clock.now().toISOString();
  return mutate(deps, input.id, input.actor, input.attemptId, at, (current) => {
    const state = transition(current.negotiation.state, { type: 'ACCEPTED', at });
    return {
      record: {
        negotiation: touch({ ...current.negotiation, state }, at),
        terms: current.terms,
        summary: { version: 1, terms: current.terms.terms },
      },
    };
  });
}

export interface RejectInput {
  readonly id: string;
  readonly reason: string;
  readonly actor: string;
  readonly attemptId?: string;
}

export async function reject(
  deps: NegotiationDeps,
  input: RejectInput,
): Promise<NegotiationRecord> {
  if (input.reason.trim().length === 0) {
    throw new Error('reject requiere un motivo explícito');
  }
  const at = deps.clock.now().toISOString();
  return mutate(deps, input.id, input.actor, input.attemptId, at, (current) => {
    const state = transition(current.negotiation.state, {
      type: 'REJECTED',
      at,
      reason: input.reason.trim(),
    });
    return {
      record: {
        negotiation: touch({ ...current.negotiation, state }, at),
        terms: current.terms,
        summary: current.summary,
      },
    };
  });
}

export interface ConfirmSummaryInput {
  readonly id: string;
  readonly party: NegotiationParty;
  readonly actor: string;
  readonly attemptId?: string;
}

export async function confirmSummary(
  deps: NegotiationDeps,
  input: ConfirmSummaryInput,
): Promise<NegotiationRecord> {
  const at = deps.clock.now().toISOString();
  return mutate(deps, input.id, input.actor, input.attemptId, at, (current) => {
    const state = transition(current.negotiation.state, {
      type: 'SUMMARY_CONFIRMED',
      at,
      party: input.party,
    });
    return {
      record: {
        negotiation: touch({ ...current.negotiation, state }, at),
        terms: current.terms,
        summary: current.summary,
      },
    };
  });
}

export interface ExpireRoundInput {
  readonly id: string;
  readonly actor?: string;
  readonly attemptId?: string;
}

export async function expireRound(
  deps: NegotiationDeps,
  input: ExpireRoundInput,
): Promise<NegotiationRecord> {
  const actor = input.actor ?? EXPIRY_ACTOR;
  const at = deps.clock.now().toISOString();
  const current = await deps.repository.findById(input.id);
  if (!current) throw new NegotiationNotFound(input.id);
  const status = current.negotiation.state.status;
  const due =
    (status === 'PROPUESTA_ENVIADA' || status === 'CONTRAPROPUESTA') &&
    current.negotiation.state.deadline <= at;
  if (!due) return current;
  return mutate(deps, input.id, actor, input.attemptId, at, (loaded) => {
    const state = transition(loaded.negotiation.state, { type: 'ROUND_EXPIRED', at });
    return {
      record: {
        negotiation: touch({ ...loaded.negotiation, state }, at),
        terms: loaded.terms,
        summary: loaded.summary,
      },
    };
  });
}

export interface ExpireSweepResult {
  readonly checked: number;
  readonly expired: number;
}

export async function expireRoundsSweep(
  deps: NegotiationDeps,
  actor = EXPIRY_ACTOR,
): Promise<ExpireSweepResult> {
  const at = deps.clock.now().toISOString();
  const due = await deps.repository.listOpenPastDeadline(at);
  let expired = 0;
  for (const record of due) {
    const before = record.negotiation.state.status;
    await expireRound(deps, { id: record.negotiation.id, actor });
    if (before !== 'EXPIRADA') expired += 1;
  }
  return { checked: due.length, expired };
}

export type { TermsDocument };
