/**
 * Almacén en memoria del PDF y su hash (HAB-31).
 *
 * Sirve a los tests y al módulo Nest de este change. No hay tabla Prisma.
 */

import type {
  ContractDocumentStore,
  StoredContractDocument,
} from '../../application/ports.js';

export class InMemoryContractDocumentStore implements ContractDocumentStore {
  private readonly documents = new Map<string, StoredContractDocument>();

  async findByNegotiationId(id: string): Promise<StoredContractDocument | null> {
    return this.documents.get(id) ?? null;
  }

  async save(document: StoredContractDocument): Promise<void> {
    this.documents.set(document.negotiationId, document);
  }
}
