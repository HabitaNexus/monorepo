/**
 * Repositorio en memoria del port `NegotiationRepository` (HAB-26).
 *
 * Doble de test para los casos de uso: reproduce la semántica de
 * idempotencia por `attemptId` y el barrido de rondas vencidas sin DB.
 */

import type {
  NegotiationRecord,
  NegotiationRepository,
  TransitionAuditEntry,
} from '../../application/negotiation-repository.js';

export class InMemoryNegotiationRepository implements NegotiationRepository {
  private readonly records = new Map<string, NegotiationRecord>();
  private readonly attempts = new Map<string, string>();
  private readonly audits: TransitionAuditEntry[] = [];

  async findById(id: string): Promise<NegotiationRecord | null> {
    return this.records.get(id) ?? null;
  }

  async findByAttempt(attemptId: string): Promise<NegotiationRecord | null> {
    const id = this.attempts.get(attemptId);
    if (!id) return null;
    return this.records.get(id) ?? null;
  }

  async listOpenPastDeadline(nowIso: string): Promise<NegotiationRecord[]> {
    return [...this.records.values()].filter((record) => {
      const state = record.negotiation.state;
      return (
        (state.status === 'PROPUESTA_ENVIADA' ||
          state.status === 'CONTRAPROPUESTA') &&
        state.deadline <= nowIso
      );
    });
  }

  async insert(
    record: NegotiationRecord,
    audit: TransitionAuditEntry,
  ): Promise<void> {
    this.records.set(record.negotiation.id, record);
    this.attempts.set(audit.attemptId, record.negotiation.id);
    this.audits.push(audit);
  }

  async update(
    record: NegotiationRecord,
    audit: TransitionAuditEntry,
  ): Promise<void> {
    this.records.set(record.negotiation.id, record);
    this.attempts.set(audit.attemptId, record.negotiation.id);
    this.audits.push(audit);
  }

  auditsFor(negotiationId: string): TransitionAuditEntry[] {
    return this.audits.filter((entry) => entry.negotiationId === negotiationId);
  }
}
