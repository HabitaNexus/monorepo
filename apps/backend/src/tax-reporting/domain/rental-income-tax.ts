/**
 * Cálculo de renta de capital inmobiliario (HAB-46).
 *
 * Enteros y half-up en cada paso. El IVA es 13% del bruto, no del impuesto,
 * y solo si el bruto del mes supera ₡693.300.
 */

import { InvalidRentalAmount } from './errors.js';

// ---------------------------------------------------------------------------
// Constants — umbral y tasas que el spec deja como oráculo de los tests
// ---------------------------------------------------------------------------

export const IVA_THRESHOLD_CRC = 693_300n;

const ONE_HUNDRED = 100n;
const TAXABLE_BASE_PERCENT = 85n;
const INCOME_TAX_PERCENT = 15n;
const IVA_PERCENT = 13n;

export interface RentalIncomeTax {
  readonly taxableBaseCrc: bigint;
  readonly incomeTaxCrc: bigint;
  readonly ivaCrc: bigint;
}

export function divRoundHalfUp(numerator: bigint, denominator: bigint): bigint {
  if (denominator <= 0n) {
    throw new Error('divRoundHalfUp requiere denominador positivo');
  }
  if (numerator < 0n) {
    throw new InvalidRentalAmount(numerator);
  }
  return (numerator + denominator / 2n) / denominator;
}

export function calculateRentalIncomeTax(grossCrc: bigint): RentalIncomeTax {
  if (grossCrc < 0n) {
    throw new InvalidRentalAmount(grossCrc);
  }
  const taxableBaseCrc = divRoundHalfUp(grossCrc * TAXABLE_BASE_PERCENT, ONE_HUNDRED);
  const incomeTaxCrc = divRoundHalfUp(taxableBaseCrc * INCOME_TAX_PERCENT, ONE_HUNDRED);
  const ivaCrc =
    grossCrc > IVA_THRESHOLD_CRC ? divRoundHalfUp(grossCrc * IVA_PERCENT, ONE_HUNDRED) : 0n;
  return { taxableBaseCrc, incomeTaxCrc, ivaCrc };
}
