/**
 * Errores del dominio tributario (HAB-46).
 *
 * Sin I/O: el adaptador los lanza antes de tocar un sidecar.
 */

export const TAX_REPORTING_OUT_OF_SCOPE = 'TAX_REPORTING_OPERATION_OUT_OF_SCOPE';
export const INVALID_RENTAL_AMOUNT = 'INVALID_RENTAL_AMOUNT';
export const INVALID_RENTAL_INSTANT = 'INVALID_RENTAL_INSTANT';

export type TaxReportingOperation =
  | 'reportRentalIncome'
  | 'generateElectronicInvoice'
  | 'checkComplianceStatus';

export class TaxReportingOperationOutOfScope extends Error {
  readonly code = TAX_REPORTING_OUT_OF_SCOPE;
  readonly operation: TaxReportingOperation;

  constructor(operation: TaxReportingOperation) {
    super(
      `${operation} no está en el alcance de HAB-46. La factura es HAB-47; el estado de cumplimiento queda solo en la firma del puerto.`,
    );
    this.name = 'TaxReportingOperationOutOfScope';
    this.operation = operation;
  }
}

export class InvalidRentalAmount extends Error {
  readonly code = INVALID_RENTAL_AMOUNT;

  constructor(grossCrc: bigint) {
    super(`El bruto de la renta debe ser un entero de colones >= 0. Recibido: ${grossCrc}`);
    this.name = 'InvalidRentalAmount';
  }
}

export class InvalidRentalInstant extends Error {
  readonly code = INVALID_RENTAL_INSTANT;

  constructor() {
    super('paidAt no es un instante válido');
    this.name = 'InvalidRentalInstant';
  }
}
