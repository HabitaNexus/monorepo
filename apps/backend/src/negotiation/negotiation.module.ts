import { Module } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service.js';
import { NegotiationController } from './infrastructure/http/negotiation.controller.js';
import { InMemoryNegotiationRepository } from './infrastructure/persistence/in-memory-negotiation-repository.js';
import { PrismaNegotiationRepository } from './infrastructure/persistence/prisma-negotiation-repository.js';
import { NEGOTIATION_REPOSITORY } from './negotiation.tokens.js';

/**
 * `USE_IN_MEMORY=true` usa el doble en memoria (HAB-26) en vez de Prisma.
 * Solo desarrollo local sin Postgres. Prohibido en producción: el módulo
 * falla al arrancar si se combina con `NODE_ENV=production`.
 */
const useInMemory = process.env['USE_IN_MEMORY'] === 'true';
if (useInMemory && process.env['NODE_ENV'] === 'production') {
  throw new Error('USE_IN_MEMORY=true prohibido en producción (HAB-26).');
}

@Module({
  controllers: [NegotiationController],
  providers: [
    PrismaService,
    {
      provide: NEGOTIATION_REPOSITORY,
      useClass: useInMemory
        ? InMemoryNegotiationRepository
        : PrismaNegotiationRepository,
    },
  ],
})
export class NegotiationModule {}
