import type { TaxDeclaration } from '../../domain/tax-reporting-port.js';
import { FixedClock } from '../../domain/clock.js';
import type { SubmissionReceipt, TaxDeclarationSender } from '../../application/tax-declaration-sender.js';
import { closePeriod, recordContractSigned, recordRentPayment } from '../../application/use-cases.js';
import { RecordingOwnerNotifier } from '../recording-owner-notifier.js';
import { StubTaxDeclarationSender } from '../stub-tax-declaration-sender.js';
import { InMemoryRentalIncomeLedger } from './in-memory-rental-income-ledger.js';

class CountingStub extends StubTaxDeclarationSender {
  calls = 0;

  override async submit(declaration: TaxDeclaration): Promise<SubmissionReceipt> {
    this.calls += 1;
    return super.submit(declaration);
  }
}

class SubmittedSender implements TaxDeclarationSender {
  calls = 0;

  async submit(_declaration: TaxDeclaration): Promise<SubmissionReceipt> {
    this.calls += 1;
    return { status: 'submitted' };
  }
}

async function septemberRent(ledger: InMemoryRentalIncomeLedger): Promise<void> {
  await recordContractSigned(
    { ledger },
    { contractId: 'contract-1', ownerId: 'owner-1', signedAt: '2026-09-01T15:00:00.000Z' },
  );
  await recordRentPayment(
    { ledger },
    {
      eventId: 'pay-sept',
      contractId: 'contract-1',
      ownerId: 'owner-1',
      grossCrc: 500_000n,
      paidAt: '2026-09-20T18:00:00.000Z',
    },
  );
}

describe('closePeriod (HAB-46)', () => {
  it('hands the previous month to the sender before the 15th and leaves it pending', async () => {
    const ledger = new InMemoryRentalIncomeLedger();
    await septemberRent(ledger);
    const sender = new CountingStub();
    const notifier = new RecordingOwnerNotifier();
    const clock = new FixedClock('2026-10-01T18:00:00.000Z');

    const closed = await closePeriod({ ledger, sender, notifier }, clock.now());
    const declaration = closed[0];
    if (declaration === undefined) {
      throw new Error('se esperaba la declaración de septiembre');
    }

    expect(closed).toHaveLength(1);
    expect(declaration).toMatchObject({
      ownerId: 'owner-1',
      period: '2026-09',
      grossCrc: 500_000n,
      status: 'pending_submission',
      late: false,
    });
    expect(sender.calls).toBe(1);
    expect(notifier.notices).toEqual([]);
    expect(await ledger.findDeclaration('owner-1', '2026-09')).toMatchObject({
      status: 'pending_submission',
      notified: false,
    });
  });

  it('notifies only when the sender returns submitted', async () => {
    const ledger = new InMemoryRentalIncomeLedger();
    await septemberRent(ledger);
    const sender = new SubmittedSender();
    const notifier = new RecordingOwnerNotifier();
    const now = new Date('2026-10-02T18:00:00.000Z');

    await closePeriod({ ledger, sender, notifier }, now);
    await closePeriod({ ledger, sender, notifier }, now);

    expect(sender.calls).toBe(1);
    expect(notifier.notices).toEqual([{ ownerId: 'owner-1', period: '2026-09' }]);
    expect(ledger.declarationCount()).toBe(1);
  });

  it('a pending stub close does not notify and a second close stays quiet', async () => {
    const ledger = new InMemoryRentalIncomeLedger();
    await septemberRent(ledger);
    const sender = new CountingStub();
    const notifier = new RecordingOwnerNotifier();
    const now = new Date('2026-10-01T18:00:00.000Z');

    await closePeriod({ ledger, sender, notifier }, now);
    await closePeriod({ ledger, sender, notifier }, now);

    expect(sender.calls).toBe(1);
    expect(notifier.notices).toEqual([]);
    expect(ledger.declarationCount()).toBe(1);
  });
});
