/**
 * Período mensual de la declaración (HAB-46).
 *
 * America/Costa_Rica no usa horario de verano (UTC−6). El mes del pago es el
 * de ese huso, no el de UTC.
 */

import { InvalidRentalInstant } from './errors.js';

const COSTA_RICA = 'America/Costa_Rica';

export function rentalPeriod(paidAt: Date): string {
  assertInstant(paidAt);
  const year = part(paidAt, 'year');
  const month = part(paidAt, 'month');
  return `${year}-${month}`;
}

export function costaRicaDayOfMonth(instant: Date): number {
  assertInstant(instant);
  return Number(part(instant, 'day'));
}

export function previousRentalPeriod(instant: Date): string {
  const current = rentalPeriod(instant);
  const [yearText, monthText] = current.split('-');
  const year = Number(yearText);
  const month = Number(monthText);
  if (!Number.isInteger(year) || !Number.isInteger(month)) {
    throw new InvalidRentalInstant();
  }
  if (month === 1) {
    return `${year - 1}-12`;
  }
  return `${year}-${String(month - 1).padStart(2, '0')}`;
}

function assertInstant(instant: Date): void {
  if (Number.isNaN(instant.getTime())) {
    throw new InvalidRentalInstant();
  }
}

function part(instant: Date, type: 'year' | 'month' | 'day'): string {
  const match = new Intl.DateTimeFormat('en-CA', {
    timeZone: COSTA_RICA,
    year: 'numeric',
    month: '2-digit',
    day: '2-digit',
  })
    .formatToParts(instant)
    .find((entry) => entry.type === type);
  if (match === undefined) {
    throw new InvalidRentalInstant();
  }
  return match.value;
}
