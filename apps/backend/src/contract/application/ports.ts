/**
 * Puertos del generador (HAB-31).
 *
 * El dominio no ve pdf-lib ni el almacén. Los adapters viven en infrastructure.
 */

import type { ContractFacts, RentalContractDraft } from '../domain/types.js';

export interface AgreementSnapshot {
  readonly negotiationId: string;
  readonly status: string;
  readonly summary: { readonly version: number; readonly terms: Readonly<Record<string, unknown>> } | null;
}

export interface AgreementReader {
  findById(id: string): Promise<AgreementSnapshot | null>;
}

export interface PdfRenderer {
  render(draft: RentalContractDraft): Promise<Uint8Array>;
}

export interface StoredContractDocument {
  readonly negotiationId: string;
  readonly reference: string;
  readonly pdf: Uint8Array;
  readonly sha256: string;
}

export interface ContractDocumentStore {
  findByNegotiationId(id: string): Promise<StoredContractDocument | null>;
  save(document: StoredContractDocument): Promise<void>;
}

export interface GenerateContractInput {
  readonly negotiationId: string;
  readonly facts: ContractFacts;
}

export interface GeneratedContract {
  readonly negotiationId: string;
  readonly reference: string;
  readonly pdf: Uint8Array;
  readonly sha256: string;
  readonly status: 'PENDIENTE_FIRMA';
}
