import { Module } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service.js';
import { NegotiationController } from './infrastructure/http/negotiation.controller.js';
import { PrismaNegotiationRepository } from './infrastructure/persistence/prisma-negotiation-repository.js';
import { NEGOTIATION_REPOSITORY } from './negotiation.tokens.js';

@Module({
  controllers: [NegotiationController],
  providers: [
    PrismaService,
    {
      provide: NEGOTIATION_REPOSITORY,
      useClass: PrismaNegotiationRepository,
    },
  ],
})
export class NegotiationModule {}
