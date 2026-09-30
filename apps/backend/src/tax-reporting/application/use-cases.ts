/**
 * Casos de uso del libro mensual (HAB-46).
 *
 * El pago alimenta el borrador. El cierre entrega una declaración por
 * (ownerId, período) al sender. No importa PaymentRepository.
 */

import type { RentalIncomeEvent, TaxDeclaration } from '../domain/index.js';
import {
  calculateRentalIncomeTax,
  costaRicaDayOfMonth,
  previousRentalPeriod,
  rentalPeriod,
} from '../domain/index.js';
import type { OwnerNotificationPort } from './owner-notification.js';
import type { RentalIncomeLedger, SignedContract, StoredDeclaration } from './rental-income-ledger.js';
import type { SubmissionReceipt, TaxDeclarationSender } from './tax-declaration-sender.js';

export interface RecordContractSignedInput {
  readonly contractId: string;
  readonly ownerId: string;
  readonly signedAt: string;
}

export interface TaxReportingDeps {
  readonly ledger: RentalIncomeLedger;
  readonly sender: TaxDeclarationSender;
  readonly notifier: OwnerNotificationPort;
}

export async function recordContractSigned(
  deps: Pick<TaxReportingDeps, 'ledger'>,
  input: RecordContractSignedInput,
): Promise<void> {
  const contract: SignedContract = {
    contractId: input.contractId,
    ownerId: input.ownerId,
    signedAt: input.signedAt,
  };
  await deps.ledger.recordContractSigned(contract);
}

export async function recordRentPayment(
  deps: Pick<TaxReportingDeps, 'ledger'>,
  event: RentalIncomeEvent,
): Promise<TaxDeclaration> {
  const already = await deps.ledger.findPayment(event.eventId);
  if (already) {
    return currentDeclaration(deps.ledger, already.ownerId, already.period);
  }

  const period = rentalPeriod(new Date(event.paidAt));
  const included = await deps.ledger.isContractSigned(event.contractId);
  const inserted = await deps.ledger.insertPayment({
    eventId: event.eventId,
    contractId: event.contractId,
    ownerId: event.ownerId,
    grossCrc: event.grossCrc,
    paidAt: event.paidAt,
    period,
    included,
  });
  if (inserted === 'duplicate' || !included) {
    return currentDeclaration(deps.ledger, event.ownerId, period);
  }

  const current = await deps.ledger.findDeclaration(event.ownerId, period);
  if (current && current.status !== 'draft') {
    return toDeclaration(current);
  }

  const grossCrc = (current?.grossCrc ?? 0n) + event.grossCrc;
  const tax = calculateRentalIncomeTax(grossCrc);
  const draft: StoredDeclaration = {
    ownerId: event.ownerId,
    period,
    grossCrc,
    taxableBaseCrc: tax.taxableBaseCrc,
    incomeTaxCrc: tax.incomeTaxCrc,
    ivaCrc: tax.ivaCrc,
    status: 'draft',
    late: false,
    notified: false,
  };
  await deps.ledger.saveDeclaration(draft);
  return toDeclaration(draft);
}

export async function closePeriod(deps: TaxReportingDeps, now: Date): Promise<readonly TaxDeclaration[]> {
  const period = previousRentalPeriod(now);
  const late = costaRicaDayOfMonth(now) >= 15;
  const drafts = await deps.ledger.listDraftDeclarations(period);
  const closed: TaxDeclaration[] = [];

  for (const draft of drafts) {
    const receipt = await deps.sender.submit(toDeclaration(draft));
    const saved = await applyReceipt(deps, draft, receipt, late);
    closed.push(toDeclaration(saved));
  }

  return closed;
}

async function applyReceipt(
  deps: TaxReportingDeps,
  draft: StoredDeclaration,
  receipt: SubmissionReceipt,
  late: boolean,
): Promise<StoredDeclaration> {
  switch (receipt.status) {
    case 'pending_submission': {
      const pending: StoredDeclaration = {
        ...draft,
        status: 'pending_submission',
        late,
        notified: false,
      };
      await deps.ledger.saveDeclaration(pending);
      return pending;
    }
    case 'submitted': {
      const submitted: StoredDeclaration = {
        ...draft,
        status: 'submitted',
        late,
        notified: true,
      };
      await deps.ledger.saveDeclaration(submitted);
      if (!draft.notified) {
        await deps.notifier.notifyDeclarationSubmitted({
          ownerId: draft.ownerId,
          period: draft.period,
        });
      }
      return submitted;
    }
    default: {
      const unreachable: never = receipt;
      return unreachable;
    }
  }
}

async function currentDeclaration(
  ledger: RentalIncomeLedger,
  ownerId: string,
  period: string,
): Promise<TaxDeclaration> {
  const found = await ledger.findDeclaration(ownerId, period);
  if (found) {
    return toDeclaration(found);
  }
  const tax = calculateRentalIncomeTax(0n);
  return {
    ownerId,
    period,
    grossCrc: 0n,
    taxableBaseCrc: tax.taxableBaseCrc,
    incomeTaxCrc: tax.incomeTaxCrc,
    ivaCrc: tax.ivaCrc,
    status: 'draft',
    late: false,
  };
}

function toDeclaration(stored: StoredDeclaration): TaxDeclaration {
  return {
    ownerId: stored.ownerId,
    period: stored.period,
    grossCrc: stored.grossCrc,
    taxableBaseCrc: stored.taxableBaseCrc,
    incomeTaxCrc: stored.incomeTaxCrc,
    ivaCrc: stored.ivaCrc,
    status: stored.status,
    late: stored.late,
  };
}
