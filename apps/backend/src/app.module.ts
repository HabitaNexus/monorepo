import { Module } from '@nestjs/common';
import { NegotiationModule } from './negotiation/negotiation.module.js';

@Module({
  imports: [NegotiationModule],
})
export class AppModule {}
