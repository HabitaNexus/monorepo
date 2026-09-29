import { Module } from '@nestjs/common';
import { HealthController } from '../health/health.controller.js';
import { PrismaService } from '../prisma/prisma.service.js';
import { NegotiationController } from './infrastructure/http/negotiation.controller.js';
import { PrismaNegotiationRepository } from './infrastructure/persistence/prisma-negotiation-repository.js';
import { NEGOTIATION_REPOSITORY } from './negotiation.tokens.js';

@Module({
  controllers: [HealthController, NegotiationController],
  providers: [
    PrismaService,
    {
      provide: NEGOTIATION_REPOSITORY,
      useClass: PrismaNegotiationRepository,
    },
  ],
})
export class NegotiationModule {}
