import { FixedClock } from '../../domain/index.js';
import {
  accept,
  confirmSummary,
  counterPropose,
  expireRoundsSweep,
  propose,
  reject,
  type NegotiationDeps,
} from '../../application/use-cases.js';
import { InMemoryNegotiationRepository } from './in-memory-negotiation-repository.js';

const TERMS = { version: 1, terms: { renta_mensual: 350000, moneda: 'CRC' } };

function setup() {
  const repository = new InMemoryNegotiationRepository();
  const clock = new FixedClock('2026-09-01T12:00:00.000Z');
  const deps: NegotiationDeps = { repository, clock };
  return { repository, clock, deps };
}

describe('negotiation use cases (HAB-26)', () => {
  it('recorre el ciclo completo hasta PENDIENTE_FIRMA con audit bilateral', async () => {
    const { repository, deps } = setup();
    const created = await propose(deps, {
      listingId: 'listing-1',
      tenantId: 'tenant-1',
      ownerId: 'owner-1',
      terms: TERMS,
      actor: 'tenant-1',
      attemptId: '11111111-1111-1111-1111-111111111111',
    });
    expect(created.negotiation.state.status).toBe('PROPUESTA_ENVIADA');

    const countered = await counterPropose(deps, {
      id: created.negotiation.id,
      terms: { version: 1, terms: { renta_mensual: 320000 } },
      actor: 'owner-1',
      attemptId: '22222222-2222-2222-2222-222222222222',
    });
    expect(countered.negotiation.state).toMatchObject({
      status: 'CONTRAPROPUESTA',
      round: 2,
    });

    const agreed = await accept(deps, {
      id: created.negotiation.id,
      actor: 'tenant-1',
    });
    expect(agreed.negotiation.state.status).toBe('ACUERDO_ALCANZADO');
    expect(agreed.summary?.terms).toEqual({ renta_mensual: 320000 });

    await confirmSummary(deps, {
      id: created.negotiation.id,
      party: 'TENANT',
      actor: 'tenant-1',
    });
    const pending = await confirmSummary(deps, {
      id: created.negotiation.id,
      party: 'OWNER',
      actor: 'owner-1',
    });
    expect(pending.negotiation.state.status).toBe('PENDIENTE_FIRMA');

    const audit = repository.auditsFor(created.negotiation.id);
    expect(audit).toHaveLength(5);
    expect(audit.map((entry) => entry.to)).toEqual([
      'PROPUESTA_ENVIADA',
      'CONTRAPROPUESTA',
      'ACUERDO_ALCANZADO',
      'ACUERDO_ALCANZADO',
      'PENDIENTE_FIRMA',
    ]);
  });

  it('el reintento con el mismo attemptId no duplica rondas ni audit', async () => {
    const { repository, deps } = setup();
    const attemptId = '33333333-3333-3333-3333-333333333333';
    const first = await propose(deps, {
      listingId: 'l',
      tenantId: 't',
      ownerId: 'o',
      terms: TERMS,
      actor: 't',
      attemptId,
    });
    const replay = await counterPropose(deps, {
      id: first.negotiation.id,
      terms: TERMS,
      actor: 'o',
      attemptId,
    });
    expect(replay.negotiation.id).toBe(first.negotiation.id);
    expect(repository.auditsFor(first.negotiation.id)).toHaveLength(1);
  });

  it('el barrido expira con clock fijo tras 72h sin respuesta', async () => {
    const { repository, clock, deps } = setup();
    const created = await propose(deps, {
      listingId: 'l',
      tenantId: 't',
      ownerId: 'o',
      terms: TERMS,
      actor: 't',
    });
    expect(await expireRoundsSweep(deps)).toEqual({ checked: 0, expired: 0 });
    clock.advanceByHours(73);
    const result = await expireRoundsSweep(deps);
    expect(result).toEqual({ checked: 1, expired: 1 });
    const record = await repository.findById(created.negotiation.id);
    expect(record?.negotiation.state.status).toBe('EXPIRADA');
    const audit = repository.auditsFor(created.negotiation.id);
    expect(audit[audit.length - 1]).toMatchObject({
      actor: 'system:pg-cron',
      from: 'PROPUESTA_ENVIADA',
      to: 'EXPIRADA',
    });
  });

  it('el rechazo exige motivo y cierra con audit', async () => {
    const { repository, deps } = setup();
    const created = await propose(deps, {
      listingId: 'l',
      tenantId: 't',
      ownerId: 'o',
      terms: TERMS,
      actor: 't',
    });
    await expect(
      reject(deps, { id: created.negotiation.id, reason: '  ', actor: 'o' }),
    ).rejects.toThrow('motivo');
    const rejected = await reject(deps, {
      id: created.negotiation.id,
      reason: 'plazo inaceptable',
      actor: 'o',
    });
    expect(rejected.negotiation.state).toMatchObject({
      status: 'RECHAZADA',
      reason: 'plazo inaceptable',
    });
    expect(repository.auditsFor(created.negotiation.id)).toHaveLength(2);
  });
});
