// ---------------------------------------------------------------------------
// Runtime — casos de uso que el adaptador y el scheduler llaman
// ---------------------------------------------------------------------------

export { closePeriod, recordContractSigned, recordRentPayment } from './use-cases.js';

// ---------------------------------------------------------------------------
// Types — puertos de libro, envío y aviso
// ---------------------------------------------------------------------------

export type { DeclarationNotice, OwnerNotificationPort } from './owner-notification.js';
export type {
  RentalIncomeLedger,
  SignedContract,
  StoredDeclaration,
  StoredPayment,
} from './rental-income-ledger.js';
export type { SubmissionReceipt, TaxDeclarationSender } from './tax-declaration-sender.js';
export type { RecordContractSignedInput, TaxReportingDeps } from './use-cases.js';
