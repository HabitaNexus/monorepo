/**
 * Puerto de envío de la declaración (HAB-46).
 *
 * El stub no abre red. El sender real, cuando exista, usa el token del
 * sidecar y un RPC de presentación que HAB-45 todavía no define.
 */

import type { TaxDeclaration } from '../domain/index.js';

export type SubmissionReceipt =
  | { readonly status: 'pending_submission'; readonly reason: 'tribu_payload_schema_unknown' }
  | { readonly status: 'submitted' };

export interface TaxDeclarationSender {
  submit(declaration: TaxDeclaration): Promise<SubmissionReceipt>;
}
