import { Injectable, OnModuleDestroy, OnModuleInit } from '@nestjs/common';
import { PrismaPg } from '@prisma/adapter-pg';
import { PrismaClient } from '../../generated/prisma/client.js';

function createAdapter(): PrismaPg {
  // Sin DATABASE_URL el $connect de onModuleInit falla alto en el arranque;
  // los tests unitarios nunca instancian PrismaService (usan el doble en memoria).
  const connectionString =
    process.env['DATABASE_URL'] ?? 'postgresql://localhost:5432/postgres';
  return new PrismaPg({ connectionString });
}

@Injectable()
export class PrismaService extends PrismaClient implements OnModuleInit, OnModuleDestroy {
  constructor() {
    super({ adapter: createAdapter() });
  }

  async onModuleInit(): Promise<void> {
    await this.$connect();
  }

  async onModuleDestroy(): Promise<void> {
    await this.$disconnect();
  }
}
