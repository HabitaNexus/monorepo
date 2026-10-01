import { Module } from '@nestjs/common';
import { ContractModule } from './contract/contract.module.js';
import { NegotiationModule } from './negotiation/negotiation.module.js';

@Module({
  imports: [NegotiationModule, ContractModule],
})
export class AppModule {}
