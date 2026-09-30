/**
 * Adapter Prisma del libro de renta (HAB-46).
 *
 * Guarda el modelo de dominio. No hay columnas de token ni de payload TRIBU-CR.
 * eventId y (ownerId, period) son únicos en la base.
 */

import { Injectable } from '@nestjs/common';
import { Prisma } from '../../../../generated/prisma/client.js';
import { PrismaService } from '../../../prisma/prisma.service.js';
import type { DeclarationStatus } from '../../domain/tax-reporting-port.js';
import type {
  RentalIncomeLedger,
  SignedContract,
  StoredDeclaration,
  StoredPayment,
} from '../../application/rental-income-ledger.js';

interface PaymentRow {
  eventId: string;
  contractId: string;
  ownerId: string;
  grossCrc: bigint;
  paidAt: Date;
  period: string;
  included: boolean;
}

interface DeclarationRow {
  ownerId: string;
  period: string;
  grossCrc: bigint;
  taxableBaseCrc: bigint;
  incomeTaxCrc: bigint;
  ivaCrc: bigint;
  status: string;
  late: boolean;
  notified: boolean;
}

@Injectable()
export class PrismaRentalIncomeLedger implements RentalIncomeLedger {
  constructor(private readonly prisma: PrismaService) {}

  async recordContractSigned(contract: SignedContract): Promise<void> {
    await this.prisma.signedRentalContract.upsert({
      where: { contractId: contract.contractId },
      create: {
        contractId: contract.contractId,
        ownerId: contract.ownerId,
        signedAt: new Date(contract.signedAt),
      },
      update: {
        ownerId: contract.ownerId,
        signedAt: new Date(contract.signedAt),
      },
    });
  }

  async isContractSigned(contractId: string): Promise<boolean> {
    const row = await this.prisma.signedRentalContract.findUnique({
      where: { contractId },
      select: { contractId: true },
    });
    return row !== null;
  }

  async findPayment(eventId: string): Promise<StoredPayment | null> {
    const row = await this.prisma.rentalIncomePayment.findUnique({ where: { eventId } });
    return row === null ? null : toPayment(row);
  }

  async insertPayment(payment: StoredPayment): Promise<'inserted' | 'duplicate'> {
    try {
      await this.prisma.rentalIncomePayment.create({
        data: {
          eventId: payment.eventId,
          contractId: payment.contractId,
          ownerId: payment.ownerId,
          grossCrc: payment.grossCrc,
          paidAt: new Date(payment.paidAt),
          period: payment.period,
          included: payment.included,
        },
      });
      return 'inserted';
    } catch (error) {
      if (error instanceof Prisma.PrismaClientKnownRequestError && error.code === 'P2002') {
        return 'duplicate';
      }
      throw error;
    }
  }

  async findDeclaration(ownerId: string, period: string): Promise<StoredDeclaration | null> {
    const row = await this.prisma.rentalIncomeDeclaration.findUnique({
      where: { ownerId_period: { ownerId, period } },
    });
    return row === null ? null : toDeclaration(row);
  }

  async saveDeclaration(declaration: StoredDeclaration): Promise<void> {
    const data = {
      grossCrc: declaration.grossCrc,
      taxableBaseCrc: declaration.taxableBaseCrc,
      incomeTaxCrc: declaration.incomeTaxCrc,
      ivaCrc: declaration.ivaCrc,
      status: declaration.status,
      late: declaration.late,
      notified: declaration.notified,
    };
    await this.prisma.rentalIncomeDeclaration.upsert({
      where: {
        ownerId_period: { ownerId: declaration.ownerId, period: declaration.period },
      },
      create: {
        ownerId: declaration.ownerId,
        period: declaration.period,
        ...data,
      },
      update: data,
    });
  }

  async listDraftDeclarations(period: string): Promise<readonly StoredDeclaration[]> {
    const rows = await this.prisma.rentalIncomeDeclaration.findMany({
      where: { period, status: 'draft' },
    });
    return rows.map(toDeclaration);
  }
}

function toPayment(row: PaymentRow): StoredPayment {
  return {
    eventId: row.eventId,
    contractId: row.contractId,
    ownerId: row.ownerId,
    grossCrc: row.grossCrc,
    paidAt: row.paidAt.toISOString(),
    period: row.period,
    included: row.included,
  };
}

function toDeclaration(row: DeclarationRow): StoredDeclaration {
  return {
    ownerId: row.ownerId,
    period: row.period,
    grossCrc: row.grossCrc,
    taxableBaseCrc: row.taxableBaseCrc,
    incomeTaxCrc: row.incomeTaxCrc,
    ivaCrc: row.ivaCrc,
    status: asStatus(row.status),
    late: row.late,
    notified: row.notified,
  };
}

function asStatus(status: string): DeclarationStatus {
  switch (status) {
    case 'draft':
    case 'pending_submission':
    case 'submitted':
      return status;
    default:
      throw new Error(`estado de declaración desconocido: ${status}`);
  }
}
