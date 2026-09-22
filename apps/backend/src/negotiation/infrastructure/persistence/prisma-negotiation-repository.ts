/**
 * Adapter Prisma del port `NegotiationRepository` (HAB-26).
 *
 * Mapea filas ↔ agregado de dominio. La idempotencia por `attemptId` tiene
 * respaldo a nivel DB (UNIQUE): ante carrera, P2002 → se retorna el registro
 * dueño del intento en vez de duplicar.
 */

import { Injectable } from '@nestjs/common';
import { Prisma } from '../../../../generated/prisma/client.js';
import type {
  Negotiation,
  NegotiationState,
  NegotiationStatus,
  TermsDocument,
} from '../../domain/index.js';
import type {
  NegotiationRecord,
  NegotiationRepository,
  TransitionAuditEntry,
} from '../../application/negotiation-repository.js';
import { PrismaService } from '../../../prisma/prisma.service.js';

interface NegotiationRow {
  id: string;
  listingId: string;
  tenantId: string;
  ownerId: string;
  status: string;
  round: number;
  deadline: Date;
  terms: Prisma.JsonValue;
  summary: Prisma.JsonValue | null;
  tenantConfirmed: boolean;
  ownerConfirmed: boolean;
  closeReason: string | null;
  createdAt: Date;
  updatedAt: Date;
}

interface AuditRow {
  id: string;
  negotiationId: string;
  actor: string;
  at: Date;
  from: string;
  to: string;
  round: number;
  attemptId: string;
}

function toState(row: NegotiationRow): NegotiationState {
  const base = {
    round: row.round,
    deadline: row.deadline.toISOString(),
  };
  switch (row.status) {
    case 'PROPUESTA_ENVIADA':
      return { status: 'PROPUESTA_ENVIADA', ...base };
    case 'CONTRAPROPUESTA':
      return { status: 'CONTRAPROPUESTA', ...base };
    case 'ACUERDO_ALCANZADO':
      return {
        status: 'ACUERDO_ALCANZADO',
        ...base,
        tenantConfirmed: row.tenantConfirmed,
        ownerConfirmed: row.ownerConfirmed,
      };
    case 'PENDIENTE_FIRMA':
      return { status: 'PENDIENTE_FIRMA', ...base };
    case 'RECHAZADA':
      return { status: 'RECHAZADA', ...base, reason: row.closeReason ?? '' };
    case 'EXPIRADA':
      return {
        status: 'EXPIRADA',
        ...base,
        reason:
          row.closeReason === 'MAX_ROUNDS_REACHED'
            ? 'MAX_ROUNDS_REACHED'
            : 'TIMEOUT_72H',
      };
    default:
      throw new Error(`Estado persistido desconocido: ${row.status}`);
  }
}

function toRecord(row: NegotiationRow): NegotiationRecord {
  const negotiation: Negotiation = {
    id: row.id,
    listingId: row.listingId,
    tenantId: row.tenantId,
    ownerId: row.ownerId,
    state: toState(row),
    createdAt: row.createdAt.toISOString(),
    updatedAt: row.updatedAt.toISOString(),
  };
  return {
    negotiation,
    terms: row.terms as unknown as TermsDocument,
    summary: (row.summary as unknown as TermsDocument | null) ?? null,
  };
}

function splitState(state: NegotiationState): {
  status: NegotiationStatus;
  closeReason: string | null;
} {
  if (state.status === 'RECHAZADA') {
    return { status: state.status, closeReason: state.reason };
  }
  if (state.status === 'EXPIRADA') {
    return { status: state.status, closeReason: state.reason };
  }
  return { status: state.status, closeReason: null };
}

@Injectable()
export class PrismaNegotiationRepository implements NegotiationRepository {
  constructor(private readonly prisma: PrismaService) {}

  async findById(id: string): Promise<NegotiationRecord | null> {
    const row = await this.prisma.negotiation.findUnique({ where: { id } });
    return row ? toRecord(row as unknown as NegotiationRow) : null;
  }

  async findByAttempt(attemptId: string): Promise<NegotiationRecord | null> {
    const audit = await this.prisma.transitionAudit.findUnique({
      where: { attemptId },
    });
    if (!audit) return null;
    return this.findById((audit as unknown as AuditRow).negotiationId);
  }

  async listOpenPastDeadline(nowIso: string): Promise<NegotiationRecord[]> {
    const rows = await this.prisma.negotiation.findMany({
      where: {
        status: { in: ['PROPUESTA_ENVIADA', 'CONTRAPROPUESTA'] },
        deadline: { lte: new Date(nowIso) },
      },
      orderBy: { deadline: 'asc' },
    });
    return rows.map((row) => toRecord(row as unknown as NegotiationRow));
  }

  async insert(
    record: NegotiationRecord,
    audit: TransitionAuditEntry,
  ): Promise<void> {
    await this.write(record, audit, 'insert');
  }

  async update(
    record: NegotiationRecord,
    audit: TransitionAuditEntry,
  ): Promise<void> {
    await this.write(record, audit, 'update');
  }

  private async write(
    record: NegotiationRecord,
    audit: TransitionAuditEntry,
    mode: 'insert' | 'update',
  ): Promise<void> {
    const { negotiation, terms, summary } = record;
    const { status, closeReason } = splitState(negotiation.state);
    const data = {
      listingId: negotiation.listingId,
      tenantId: negotiation.tenantId,
      ownerId: negotiation.ownerId,
      status,
      round: negotiation.state.round,
      deadline: new Date(negotiation.state.deadline),
      terms: terms as unknown as Prisma.InputJsonValue,
      ...(summary === null
        ? {}
        : { summary: summary as unknown as Prisma.InputJsonValue }),
      tenantConfirmed:
        negotiation.state.status === 'ACUERDO_ALCANZADO'
          ? negotiation.state.tenantConfirmed
          : false,
      ownerConfirmed:
        negotiation.state.status === 'ACUERDO_ALCANZADO'
          ? negotiation.state.ownerConfirmed
          : false,
      closeReason,
      updatedAt: new Date(negotiation.updatedAt),
    };
    try {
      await this.prisma.$transaction([
        mode === 'insert'
          ? this.prisma.negotiation.create({
              data: {
                id: negotiation.id,
                createdAt: new Date(negotiation.createdAt),
                ...data,
              },
            })
          : this.prisma.negotiation.update({
              where: { id: negotiation.id },
              data,
            }),
        this.prisma.transitionAudit.create({
          data: {
            id: audit.id,
            negotiationId: negotiation.id,
            actor: audit.actor,
            at: new Date(audit.at),
            from: audit.from,
            to: audit.to,
            round: audit.round,
            attemptId: audit.attemptId,
          },
        }),
      ]);
    } catch (error) {
      if (
        error instanceof Prisma.PrismaClientKnownRequestError &&
        error.code === 'P2002'
      ) {
        return;
      }
      throw error;
    }
  }
}
