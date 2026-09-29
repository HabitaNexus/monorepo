import { Module } from '@nestjs/common';
import { NegotiationModule } from './negotiation/negotiation.module.js';
import { PropertyModule } from './modules/property/property.module.js';

@Module({
  imports: [NegotiationModule, PropertyModule],
})
export class AppModule {}
