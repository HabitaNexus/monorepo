/**
 * Adaptador TRIBU de reportRentalIncome (HAB-46).
 *
 * Implementa el puerto completo para que HAB-47 no defina otra interfaz.
 * Las otras dos operaciones lanzan fuera de alcance y no llaman al sidecar.
 *
 * Sender futuro, no cableado en este change. Cuando existan el esquema de
 * TRIBU-CR y un RPC de presentación (hacienda_auth.proto de HAB-45 solo tiene
 * GetAuthStatus y GetAccessToken):
 * 1. GetAuthStatus. Si authenticated es falso, la declaración sigue pendiente.
 * 2. GetAccessToken. El access_token se usa solo en esa llamada y no se guarda.
 * 3. El RPC de presentación, que hoy no existe. El token no lo sustituye.
 * Este archivo no abre un canal gRPC.
 */

import { recordRentPayment } from '../application/use-cases.js';
import type { RentalIncomeLedger } from '../application/rental-income-ledger.js';
import { TaxReportingOperationOutOfScope } from '../domain/errors.js';
import type {
  Invoice,
  PaymentEvent,
  RentalIncomeEvent,
  TaxDeclaration,
  TaxReportingPort,
  TaxStatus,
} from '../domain/tax-reporting-port.js';

export const FUTURE_HACIENDA_SUBMISSION_STEPS = [
  'GetAuthStatus',
  'GetAccessToken',
  'presentation-rpc-not-in-hacienda-auth-proto',
] as const;

export class TribuRentalIncomeAdapter implements TaxReportingPort {
  constructor(private readonly ledger: RentalIncomeLedger) {}

  reportRentalIncome(event: RentalIncomeEvent): Promise<TaxDeclaration> {
    return recordRentPayment({ ledger: this.ledger }, event);
  }

  generateElectronicInvoice(_event: PaymentEvent): Promise<Invoice> {
    return Promise.reject(new TaxReportingOperationOutOfScope('generateElectronicInvoice'));
  }

  checkComplianceStatus(_ownerId: string): Promise<TaxStatus> {
    return Promise.reject(new TaxReportingOperationOutOfScope('checkComplianceStatus'));
  }
}
