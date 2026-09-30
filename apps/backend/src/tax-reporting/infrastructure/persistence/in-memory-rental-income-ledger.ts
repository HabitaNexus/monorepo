/**
 * Libro en memoria (HAB-46).
 *
 * Doble de tests. La unicidad de eventId y de (ownerId, período) se aplica
 * aquí igual que en la restricción de la base.
 */

import type {
  RentalIncomeLedger,
  SignedContract,
  StoredDeclaration,
  StoredPayment,
} from '../../application/rental-income-ledger.js';

export class InMemoryRentalIncomeLedger implements RentalIncomeLedger {
  private readonly contracts = new Map<string, SignedContract>();
  private readonly payments = new Map<string, StoredPayment>();
  private readonly declarations = new Map<string, StoredDeclaration>();

  async recordContractSigned(contract: SignedContract): Promise<void> {
    this.contracts.set(contract.contractId, contract);
  }

  async isContractSigned(contractId: string): Promise<boolean> {
    return this.contracts.has(contractId);
  }

  async findPayment(eventId: string): Promise<StoredPayment | null> {
    return this.payments.get(eventId) ?? null;
  }

  async insertPayment(payment: StoredPayment): Promise<'inserted' | 'duplicate'> {
    if (this.payments.has(payment.eventId)) {
      return 'duplicate';
    }
    this.payments.set(payment.eventId, payment);
    return 'inserted';
  }

  async findDeclaration(ownerId: string, period: string): Promise<StoredDeclaration | null> {
    return this.declarations.get(key(ownerId, period)) ?? null;
  }

  async saveDeclaration(declaration: StoredDeclaration): Promise<void> {
    this.declarations.set(key(declaration.ownerId, declaration.period), declaration);
  }

  async listDraftDeclarations(period: string): Promise<readonly StoredDeclaration[]> {
    return [...this.declarations.values()].filter(
      (declaration) => declaration.period === period && declaration.status === 'draft',
    );
  }

  declarationCount(): number {
    return this.declarations.size;
  }
}

function key(ownerId: string, period: string): string {
  return `${ownerId}|${period}`;
}
