/**
 * Módulo Nest del reporte de renta (HAB-46).
 *
 * El sender de producción es el stub. El ledger es Prisma. Los tests no
 * arrancan este módulo: usan el libro en memoria.
 */

import { Module } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service.js';
import type { RentalIncomeLedger } from './application/rental-income-ledger.js';
import { SystemClock } from './domain/clock.js';
import { LoggingOwnerNotifier } from './infrastructure/logging-owner-notifier.js';
import { PrismaRentalIncomeLedger } from './infrastructure/persistence/prisma-rental-income-ledger.js';
import { RentalIncomePeriodScheduler } from './infrastructure/rental-income-period-scheduler.js';
import { StubTaxDeclarationSender } from './infrastructure/stub-tax-declaration-sender.js';
import { TribuRentalIncomeAdapter } from './infrastructure/tribu-rental-income-adapter.js';
import {
  OWNER_NOTIFIER,
  RENTAL_INCOME_LEDGER,
  TAX_DECLARATION_SENDER,
  TAX_REPORTING_CLOCK,
} from './tax-reporting.tokens.js';

@Module({
  providers: [
    PrismaService,
    RentalIncomePeriodScheduler,
    { provide: RENTAL_INCOME_LEDGER, useClass: PrismaRentalIncomeLedger },
    {
      provide: TribuRentalIncomeAdapter,
      useFactory: (ledger: RentalIncomeLedger) => new TribuRentalIncomeAdapter(ledger),
      inject: [RENTAL_INCOME_LEDGER],
    },
    { provide: TAX_DECLARATION_SENDER, useFactory: () => new StubTaxDeclarationSender() },
    { provide: OWNER_NOTIFIER, useClass: LoggingOwnerNotifier },
    { provide: TAX_REPORTING_CLOCK, useFactory: () => new SystemClock() },
  ],
  exports: [TribuRentalIncomeAdapter],
})
export class TaxReportingModule {}
