import { buildDraft } from './clauses.js';
import { exampleInput } from './example.js';
import {
  DatoMinimoAusente,
  DepositoInferiorAlMinimo,
  IncrementoSobreTope,
  PlazoInconsistente,
} from './errors.js';
import { SHORT_TERM_NOTICE, TACIT_RENEWAL, addCalendarMonths } from './policy.js';
import type { ContractInput } from './types.js';

const REFERENCE = 'HN-CR-test';

function draftFrom(input: ContractInput) {
  return buildDraft(input, REFERENCE);
}

describe('política del contrato (HAB-31)', () => {
  it('rechaza un depósito inferior a un mes y no arma cláusulas', () => {
    const input = exampleInput();
    expect(() =>
      draftFrom({ ...input, terms: { ...input.terms, deposito_garantia: 100000 } }),
    ).toThrow(DepositoInferiorAlMinimo);
  });

  it('escribe un depósito de un mes y uno mayor', () => {
    const equal = draftFrom(exampleInput());
    expect(equal.clauses[3]?.body).toContain('350000');
    const base = exampleInput();
    const higher = draftFrom({
      ...base,
      terms: { ...base.terms, deposito_garantia: 400000 },
    });
    expect(higher.clauses[3]?.body).toContain('400000');
  });

  it('incluye el aviso del SOP solo si el plazo es menor a 36 meses', () => {
    const short = draftFrom(exampleInput());
    expect(short.clauses[4]?.body).toContain(SHORT_TERM_NOTICE);
    expect(short.clauses[4]?.body).toContain(TACIT_RENEWAL);
    const base = exampleInput();
    const long = draftFrom({
      ...base,
      terms: { ...base.terms, plazo_meses: 36, fecha_fin: '2029-11-01' },
    });
    expect(long.clauses[4]?.body).not.toContain(SHORT_TERM_NOTICE);
    expect(long.clauses[4]?.body).toContain(TACIT_RENEWAL);
  });

  it('mantiene la prórroga tácita aunque la renovación automática sea falsa', () => {
    const base = exampleInput();
    const draft = draftFrom({
      ...base,
      terms: { ...base.terms, renovacion_automatica: false },
    });
    expect(draft.clauses[4]?.body).toContain(TACIT_RENEWAL);
  });

  it('no escribe como eficaz un preaviso menor a 90 días', () => {
    const base = exampleInput();
    const draft = draftFrom({
      ...base,
      terms: { ...base.terms, preaviso_dias: 30 },
    });
    const body = draft.clauses[4]?.body ?? '';
    expect(body).toContain('tres meses');
    expect(body).not.toContain('30 días');
  });

  it('escribe un preaviso de 90 días o más junto al mínimo legal', () => {
    const base = exampleInput();
    const draft = draftFrom({
      ...base,
      terms: { ...base.terms, preaviso_dias: 120 },
    });
    const body = draft.clauses[4]?.body ?? '';
    expect(body).toContain('120 días');
    expect(body).toContain('tres meses');
  });

  it('sin preaviso pactado enuncia tres meses', () => {
    const draft = draftFrom(exampleInput());
    expect(draft.clauses[4]?.body).toContain('tres meses');
    expect(draft.clauses[4]?.body).not.toContain('días, que no es inferior');
  });

  it('rechaza un incremento mayor al tope', () => {
    const input = exampleInput();
    expect(() =>
      draftFrom({ ...input, terms: { ...input.terms, incremento_anual: 10 } }),
    ).toThrow(IncrementoSobreTope);
  });

  it('escribe un incremento dentro del tope', () => {
    const draft = draftFrom(exampleInput());
    expect(draft.clauses[15]?.body).toContain('2 por ciento');
  });

  it('sin porcentaje pactado enuncia la fórmula y no una tasa', () => {
    const base = exampleInput();
    const terms = { ...base.terms };
    delete terms['incremento_anual'];
    const draft = draftFrom({ ...base, terms });
    const body = draft.clauses[15]?.body ?? '';
    expect(body).toContain('índice oficial de precios al consumidor');
    expect(body).not.toMatch(/\d/);
  });

  it('en moneda extranjera no aplica el incremento', () => {
    const base = exampleInput();
    const { ipcAnual: _removed, ...facts } = base.facts;
    const draft = draftFrom({
      ...base,
      terms: { ...base.terms, moneda: 'USD', incremento_anual: 9 },
      facts,
    });
    const body = draft.clauses[15]?.body ?? '';
    expect(body).toContain('sin reajuste');
    expect(body).not.toContain('9');
  });

  it('rechaza un dato mínimo ausente', () => {
    const base = exampleInput();
    expect(() =>
      draftFrom({ ...base, facts: { ...base.facts, formaPago: ' ' } }),
    ).toThrow(DatoMinimoAusente);
  });

  it('rechaza una fecha fin que no cuadra con el plazo', () => {
    const base = exampleInput();
    expect(() =>
      draftFrom({ ...base, terms: { ...base.terms, fecha_fin: '2027-12-01' } }),
    ).toThrow(PlazoInconsistente);
  });

  it('suma meses de calendario en UTC', () => {
    expect(addCalendarMonths('2026-11-01', 12)).toBe('2027-11-01');
    expect(addCalendarMonths('2026-11-01', 36)).toBe('2029-11-01');
  });
});
