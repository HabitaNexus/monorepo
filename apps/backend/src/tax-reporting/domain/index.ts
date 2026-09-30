// ---------------------------------------------------------------------------
// Runtime — cálculo y período, sin adaptadores
// ---------------------------------------------------------------------------

export { FixedClock, SystemClock } from './clock.js';
export {
  InvalidRentalAmount,
  InvalidRentalInstant,
  TaxReportingOperationOutOfScope,
} from './errors.js';
export { calculateRentalIncomeTax, divRoundHalfUp, IVA_THRESHOLD_CRC } from './rental-income-tax.js';
export { costaRicaDayOfMonth, previousRentalPeriod, rentalPeriod } from './rental-period.js';

// ---------------------------------------------------------------------------
// Types — puerto y reloj que la aplicación implementa por fuera del dominio
// ---------------------------------------------------------------------------

export type { Clock } from './clock.js';
export type { TaxReportingOperation } from './errors.js';
export type { RentalIncomeTax } from './rental-income-tax.js';
export type {
  DeclarationStatus,
  Invoice,
  PaymentEvent,
  RentalIncomeEvent,
  TaxComplianceState,
  TaxDeclaration,
  TaxReportingPort,
  TaxStatus,
} from './tax-reporting-port.js';
