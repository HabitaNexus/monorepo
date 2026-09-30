import { previousRentalPeriod, rentalPeriod } from './rental-period.js';

describe('rentalPeriod (HAB-46)', () => {
  it('asigna el mes de Costa Rica y no el de UTC en el límite', () => {
    const boundary = new Date('2026-10-01T05:59:59.000Z');
    expect(boundary.getUTCMonth()).toBe(9);
    expect(rentalPeriod(boundary)).toBe('2026-09');
    expect(rentalPeriod(new Date('2026-10-01T06:00:00.000Z'))).toBe('2026-10');
  });

  it('el mes anterior de enero es diciembre del año previo', () => {
    expect(previousRentalPeriod(new Date('2026-01-01T06:00:00.000Z'))).toBe('2025-12');
  });
});
