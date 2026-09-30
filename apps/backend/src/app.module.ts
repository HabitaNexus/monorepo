import { Module } from '@nestjs/common';
import { NegotiationModule } from './negotiation/negotiation.module.js';
import { TaxReportingModule } from './tax-reporting/tax-reporting.module.js';

@Module({
  imports: [NegotiationModule, TaxReportingModule],
})
export class AppModule {}
