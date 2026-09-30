import type { RentalIncomeEvent } from '../../domain/tax-reporting-port.js';
import { recordContractSigned, recordRentPayment } from '../../application/use-cases.js';
import { InMemoryRentalIncomeLedger } from './in-memory-rental-income-ledger.js';

const OWNER = 'owner-1';
const CONTRACT = 'contract-1';

function payment(overrides: Partial<RentalIncomeEvent> = {}): RentalIncomeEvent {
  return {
    eventId: 'pay-1',
    contractId: CONTRACT,
    ownerId: OWNER,
    grossCrc: 200_000n,
    paidAt: '2026-09-10T18:00:00.000Z',
    ...overrides,
  };
}

async function signedLedger(): Promise<InMemoryRentalIncomeLedger> {
  const ledger = new InMemoryRentalIncomeLedger();
  await recordContractSigned(
    { ledger },
    { contractId: CONTRACT, ownerId: OWNER, signedAt: '2026-09-01T15:00:00.000Z' },
  );
  return ledger;
}

describe('report rental income (HAB-46)', () => {
  it('aggregates two payments for the same owner and month', async () => {
    const ledger = await signedLedger();
    await recordRentPayment({ ledger }, payment({ eventId: 'pay-1', grossCrc: 200_000n }));
    const declaration = await recordRentPayment(
      { ledger },
      payment({ eventId: 'pay-2', grossCrc: 300_000n }),
    );

    expect(declaration.grossCrc).toBe(500_000n);
    expect(declaration.ownerId).toBe(OWNER);
    expect(declaration.period).toBe('2026-09');
    expect(declaration.status).toBe('draft');
    expect(ledger.declarationCount()).toBe(1);
  });

  it('ignores a repeated eventId', async () => {
    const ledger = await signedLedger();
    await recordRentPayment({ ledger }, payment({ grossCrc: 200_000n }));
    const again = await recordRentPayment({ ledger }, payment({ grossCrc: 200_000n }));

    expect(again.grossCrc).toBe(200_000n);
    expect(ledger.declarationCount()).toBe(1);
  });

  it('excludes a payment for an unsigned contract', async () => {
    const ledger = new InMemoryRentalIncomeLedger();
    const declaration = await recordRentPayment(
      { ledger },
      payment({ eventId: 'pay-unsigned', grossCrc: 450_000n }),
    );

    expect(declaration.grossCrc).toBe(0n);
    expect(await ledger.findDeclaration(OWNER, '2026-09')).toBeNull();
    expect(ledger.declarationCount()).toBe(0);
  });
});
