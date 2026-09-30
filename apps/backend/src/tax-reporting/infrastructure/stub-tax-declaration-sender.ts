/**
 * Sender stub (HAB-46).
 *
 * No abre socket, no arma un payload de TRIBU-CR y no marca la declaración
 * como aceptada por Hacienda. El esquema del payload no está en el repo.
 */

import type { TaxDeclaration } from '../domain/tax-reporting-port.js';
import type {
  SubmissionReceipt,
  TaxDeclarationSender,
} from '../application/tax-declaration-sender.js';

export class StubTaxDeclarationSender implements TaxDeclarationSender {
  async submit(_declaration: TaxDeclaration): Promise<SubmissionReceipt> {
    return {
      status: 'pending_submission',
      reason: 'tribu_payload_schema_unknown',
    };
  }
}
