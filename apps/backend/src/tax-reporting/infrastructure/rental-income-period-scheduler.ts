/**
 * Scheduler del cierre mensual (HAB-46).
 *
 * Un tick al día llama a closePeriod. El caso de uso es idempotente: repetir
 * el tick no vuelve a notificar ni crea otra fila. No usa @nestjs/schedule.
 */

import { Inject, Injectable, type OnModuleDestroy, type OnModuleInit } from '@nestjs/common';
import type { OwnerNotificationPort } from '../application/owner-notification.js';
import type { TaxDeclarationSender } from '../application/tax-declaration-sender.js';
import type { RentalIncomeLedger } from '../application/rental-income-ledger.js';
import { closePeriod } from '../application/use-cases.js';
import type { Clock } from '../domain/clock.js';
import {
  OWNER_NOTIFIER,
  RENTAL_INCOME_LEDGER,
  TAX_DECLARATION_SENDER,
  TAX_REPORTING_CLOCK,
} from '../tax-reporting.tokens.js';

const ONE_DAY_MS = 24 * 60 * 60 * 1000;

@Injectable()
export class RentalIncomePeriodScheduler implements OnModuleInit, OnModuleDestroy {
  private timer: ReturnType<typeof setInterval> | undefined;

  constructor(
    @Inject(RENTAL_INCOME_LEDGER) private readonly ledger: RentalIncomeLedger,
    @Inject(TAX_DECLARATION_SENDER) private readonly sender: TaxDeclarationSender,
    @Inject(OWNER_NOTIFIER) private readonly notifier: OwnerNotificationPort,
    @Inject(TAX_REPORTING_CLOCK) private readonly clock: Clock,
  ) {}

  onModuleInit(): void {
    void this.tick();
    this.timer = setInterval(() => {
      void this.tick();
    }, ONE_DAY_MS);
    this.timer.unref();
  }

  onModuleDestroy(): void {
    if (this.timer !== undefined) {
      clearInterval(this.timer);
    }
  }

  async tick(): Promise<void> {
    try {
      await closePeriod(
        {
          ledger: this.ledger,
          sender: this.sender,
          notifier: this.notifier,
        },
        this.clock.now(),
      );
    } catch (error) {
      console.error('tax-reporting closePeriod failed', error);
    }
  }
}
