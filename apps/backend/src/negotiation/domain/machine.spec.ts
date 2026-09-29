import { FixedClock } from './clock.js';
import { InvalidNegotiationTransition } from './errors.js';
import { deadlineAfter, transition } from './machine.js';
import {
  MAX_ROUNDS,
  type Contrapropuesta,
  type NegotiationState,
  type PropuestaEnviada,
} from './states.js';

const T0 = '2026-09-01T12:00:00.000Z';

function propuesta(): PropuestaEnviada {
  return {
    status: 'PROPUESTA_ENVIADA',
    round: 1,
    deadline: deadlineAfter(T0),
  };
}

describe('negotiation machine (HAB-26)', () => {
  it('acepta directo la propuesta inicial y genera acuerdo sin confirmaciones', () => {
    const next = transition(propuesta(), { type: 'ACCEPTED', at: T0 });
    expect(next).toEqual({
      status: 'ACUERDO_ALCANZADO',
      round: 1,
      deadline: deadlineAfter(T0),
      tenantConfirmed: false,
      ownerConfirmed: false,
    });
  });

  it('la contrapropuesta incrementa la ronda y reinicia el deadline a 72h', () => {
    const clock = new FixedClock(T0);
    clock.advanceByHours(10);
    const at = clock.now().toISOString();
    const next = transition(propuesta(), { type: 'COUNTER_PROPOSED', at });
    expect(next.status).toBe('CONTRAPROPUESTA');
    if (next.status === 'CONTRAPROPUESTA') {
      expect(next.round).toBe(2);
      expect(next.deadline).toBe(deadlineAfter(at));
    }
  });

  it('itera contrapropuestas hasta el tope y cierra la quinta como EXPIRADA', () => {
    let state: NegotiationState = {
      status: 'CONTRAPROPUESTA',
      round: MAX_ROUNDS,
      deadline: deadlineAfter(T0),
    };
    state = transition(state, { type: 'COUNTER_PROPOSED', at: T0 });
    expect(state).toEqual({
      status: 'EXPIRADA',
      round: MAX_ROUNDS,
      deadline: deadlineAfter(T0),
      reason: 'MAX_ROUNDS_REACHED',
    });
  });

  it('expira la ronda por silencio de 72h', () => {
    const state: Contrapropuesta = {
      status: 'CONTRAPROPUESTA',
      round: 2,
      deadline: deadlineAfter(T0),
    };
    expect(transition(state, { type: 'ROUND_EXPIRED', at: T0 })).toEqual({
      status: 'EXPIRADA',
      round: 2,
      deadline: deadlineAfter(T0),
      reason: 'TIMEOUT_72H',
    });
  });

  it('el rechazo explícito conserva el motivo', () => {
    const next = transition(propuesta(), {
      type: 'REJECTED',
      at: T0,
      reason: 'precio fuera de rango',
    });
    expect(next).toEqual({
      status: 'RECHAZADA',
      round: 1,
      deadline: deadlineAfter(T0),
      reason: 'precio fuera de rango',
    });
  });

  it('una sola confirmación mantiene ACUERDO_ALCANZADO; la bilateral firma', () => {
    const agreed = transition(propuesta(), { type: 'ACCEPTED', at: T0 });
    const parcial = transition(agreed, {
      type: 'SUMMARY_CONFIRMED',
      at: T0,
      party: 'TENANT',
    });
    expect(parcial.status).toBe('ACUERDO_ALCANZADO');
    const final = transition(parcial, {
      type: 'SUMMARY_CONFIRMED',
      at: T0,
      party: 'OWNER',
    });
    expect(final.status).toBe('PENDIENTE_FIRMA');
  });

  it('la confirmación duplicada de la misma parte es idempotente', () => {
    const agreed = transition(propuesta(), { type: 'ACCEPTED', at: T0 });
    const once = transition(agreed, {
      type: 'SUMMARY_CONFIRMED',
      at: T0,
      party: 'TENANT',
    });
    expect(() =>
      transition(once, {
        type: 'SUMMARY_CONFIRMED',
        at: T0,
        party: 'TENANT',
      }),
    ).not.toThrow();
    expect(
      transition(once, {
        type: 'SUMMARY_CONFIRMED',
        at: T0,
        party: 'TENANT',
      }).status,
    ).toBe('ACUERDO_ALCANZADO');
  });

  it.each([
    ['PENDIENTE_FIRMA', { status: 'PENDIENTE_FIRMA', round: 2, deadline: T0 }],
    ['RECHAZADA', { status: 'RECHAZADA', round: 1, deadline: T0, reason: 'x' }],
    ['EXPIRADA', { status: 'EXPIRADA', round: 1, deadline: T0, reason: 'TIMEOUT_72H' as const }],
  ])('el estado terminal %s no tiene salidas', (_name, state) => {
    expect(() =>
      transition(state as NegotiationState, { type: 'ACCEPTED', at: T0 }),
    ).toThrow(InvalidNegotiationTransition);
  });

  it('aceptar desde RECHAZADA retorna error estructurado sin mutar', () => {
    const rejected: NegotiationState = {
      status: 'RECHAZADA',
      round: 1,
      deadline: T0,
      reason: 'x',
    };
    const snapshot = { ...rejected };
    expect(() =>
      transition(rejected, { type: 'ACCEPTED', at: T0 }),
    ).toThrow(InvalidNegotiationTransition);
    try {
      transition(rejected, { type: 'ACCEPTED', at: T0 });
    } catch (error) {
      expect(error).toBeInstanceOf(InvalidNegotiationTransition);
      const structured = error as InvalidNegotiationTransition;
      expect(structured.code).toBe('INVALID_NEGOTIATION_TRANSITION');
      expect(structured.from).toBe('RECHAZADA');
      expect(structured.event).toBe('ACCEPTED');
    }
    expect(rejected).toEqual(snapshot);
  });

  it('ROUND_EXPIRED no aplica sobre ACUERDO_ALCANZADO (sin turno pendiente)', () => {
    const agreed = transition(propuesta(), { type: 'ACCEPTED', at: T0 });
    expect(() => transition(agreed, { type: 'ROUND_EXPIRED', at: T0 })).toThrow(
      InvalidNegotiationTransition,
    );
  });
});
