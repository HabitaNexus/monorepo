/**
 * Puertos de la capa de aplicación (HAB-26).
 *
 * El repositorio es el único acceso a persistencia de los casos de uso.
 * Sin imports de frameworks: el adapter Prisma vive en infrastructure/.
 */

import type {
  Negotiation,
  NegotiationStatus,
  TermsDocument,
} from '../domain/index.js';

export interface NegotiationRecord {
  readonly negotiation: Negotiation;
  readonly terms: TermsDocument;
  readonly summary: TermsDocument | null;
}

export interface TransitionAuditEntry {
  readonly id: string;
  readonly negotiationId: string;
  readonly actor: string;
  readonly at: string;
  readonly from: NegotiationStatus;
  readonly to: NegotiationStatus;
  readonly round: number;
  readonly attemptId: string;
}

export interface NegotiationRepository {
  findById(id: string): Promise<NegotiationRecord | null>;
  findByAttempt(attemptId: string): Promise<NegotiationRecord | null>;
  listOpenPastDeadline(nowIso: string): Promise<NegotiationRecord[]>;
  insert(record: NegotiationRecord, audit: TransitionAuditEntry): Promise<void>;
  update(record: NegotiationRecord, audit: TransitionAuditEntry): Promise<void>;
}

export class NegotiationNotFound extends Error {
  readonly code = 'NEGOTIATION_NOT_FOUND';
  readonly negotiationId: string;

  constructor(negotiationId: string) {
    super(`Negociación no encontrada: ${negotiationId}`);
    this.name = 'NegotiationNotFound';
    this.negotiationId = negotiationId;
  }
}
