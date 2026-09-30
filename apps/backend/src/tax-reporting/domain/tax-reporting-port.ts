/**
 * Puerto de dominio tributario (HAB-46).
 *
 * Una sola interfaz para las tres operaciones del spec. Este archivo no
 * importa Nest, Prisma ni gRPC: la I/O vive en el adaptador.
 */

// ---------------------------------------------------------------------------
// Types — eventos y resultados que el puerto expone sin transporte
// ---------------------------------------------------------------------------

export interface RentalIncomeEvent {
  readonly eventId: string;
  readonly contractId: string;
  readonly ownerId: string;
  readonly grossCrc: bigint;
  readonly paidAt: string;
}

export interface PaymentEvent {
  readonly paymentId: string;
}

export interface Invoice {
  readonly invoiceId: string;
}

export type TaxComplianceState = 'compliant' | 'pending' | 'overdue';

export interface TaxStatus {
  readonly ownerId: string;
  readonly status: TaxComplianceState;
}

export type DeclarationStatus = 'draft' | 'pending_submission' | 'submitted';

export interface TaxDeclaration {
  readonly ownerId: string;
  readonly period: string;
  readonly grossCrc: bigint;
  readonly taxableBaseCrc: bigint;
  readonly incomeTaxCrc: bigint;
  readonly ivaCrc: bigint;
  readonly status: DeclarationStatus;
  readonly late: boolean;
}

// ---------------------------------------------------------------------------
// Port — contrato hexagonal; solo reportRentalIncome se implementa aquí
// ---------------------------------------------------------------------------

export interface TaxReportingPort {
  reportRentalIncome(event: RentalIncomeEvent): Promise<TaxDeclaration>;
  generateElectronicInvoice(event: PaymentEvent): Promise<Invoice>;
  checkComplianceStatus(ownerId: string): Promise<TaxStatus>;
}
