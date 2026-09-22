import { FixedClock, SystemClock } from './clock.js';
import { InvalidTermsDocument } from './errors.js';
import { TERMS_CATALOG, validateTermsDocument } from './terms.js';

describe('terms document (HAB-26)', () => {
  it('el catálogo expone 34 términos', () => {
    expect(TERMS_CATALOG).toHaveLength(34);
    expect(new Set(TERMS_CATALOG).size).toBe(34);
  });

  it('acepta un documento versionado con términos conocidos', () => {
    expect(
      validateTermsDocument({
        version: 1,
        terms: { renta_mensual: 350000, moneda: 'CRC' },
      }),
    ).toEqual({
      version: 1,
      terms: { renta_mensual: 350000, moneda: 'CRC' },
    });
  });

  it('rechaza versión, catálogo, vacío y valores no JSON', () => {
    expect(() =>
      validateTermsDocument({ version: 2, terms: { renta_mensual: 1 } }),
    ).toThrow(InvalidTermsDocument);
    expect(() =>
      validateTermsDocument({ version: 1, terms: { inventado: 1 } }),
    ).toThrow(InvalidTermsDocument);
    expect(() => validateTermsDocument({ version: 1, terms: {} })).toThrow(
      InvalidTermsDocument,
    );
    expect(() =>
      validateTermsDocument({
        version: 1,
        terms: { renta_mensual: undefined },
      }),
    ).toThrow(InvalidTermsDocument);
  });
});

describe('clock (HAB-26)', () => {
  it('FixedClock es determinista y avanza por horas', () => {
    const clock = new FixedClock('2026-09-01T12:00:00.000Z');
    clock.advanceByHours(72);
    expect(clock.now().toISOString()).toBe('2026-09-04T12:00:00.000Z');
  });

  it('SystemClock devuelve la hora real', () => {
    const before = Date.now();
    const now = new SystemClock().now().getTime();
    expect(now).toBeGreaterThanOrEqual(before);
    expect(now).toBeLessThanOrEqual(Date.now());
  });
});
