/**
 * Puerto del libro de renta (HAB-46).
 *
 * La aplicación no conoce Prisma. La unicidad de eventId y de
 * (ownerId, período) la garantizan el adaptador y la base.
 */

import type { DeclarationStatus } from '../domain/index.js';

export interface SignedContract {
  readonly contractId: string;
  readonly ownerId: string;
  readonly signedAt: string;
}

export interface StoredPayment {
  readonly eventId: string;
  readonly contractId: string;
  readonly ownerId: string;
  readonly grossCrc: bigint;
  readonly paidAt: string;
  readonly period: string;
  readonly included: boolean;
}

export interface StoredDeclaration {
  readonly ownerId: string;
  readonly period: string;
  readonly grossCrc: bigint;
  readonly taxableBaseCrc: bigint;
  readonly incomeTaxCrc: bigint;
  readonly ivaCrc: bigint;
  readonly status: DeclarationStatus;
  readonly late: boolean;
  readonly notified: boolean;
}

export interface RentalIncomeLedger {
  recordContractSigned(contract: SignedContract): Promise<void>;
  isContractSigned(contractId: string): Promise<boolean>;
  findPayment(eventId: string): Promise<StoredPayment | null>;
  insertPayment(payment: StoredPayment): Promise<'inserted' | 'duplicate'>;
  findDeclaration(ownerId: string, period: string): Promise<StoredDeclaration | null>;
  saveDeclaration(declaration: StoredDeclaration): Promise<void>;
  listDraftDeclarations(period: string): Promise<readonly StoredDeclaration[]>;
}
