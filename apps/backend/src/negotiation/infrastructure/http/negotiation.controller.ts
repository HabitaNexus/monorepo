import {
  Body,
  Controller,
  Get,
  Headers,
  HttpCode,
  HttpStatus,
  Inject,
  NotFoundException,
  Param,
  Post,
  UnauthorizedException,
} from '@nestjs/common';
import { SystemClock, type Clock } from '../../domain/index.js';
import {
  accept,
  confirmSummary,
  counterPropose,
  expireRoundsSweep,
  propose,
  reject,
  type NegotiationDeps,
} from '../../application/index.js';
import { NegotiationNotFound } from '../../application/negotiation-repository.js';
import type { NegotiationRepository } from '../../application/negotiation-repository.js';
import { NEGOTIATION_REPOSITORY } from '../../negotiation.tokens.js';
import {
  AcceptDto,
  ConfirmSummaryDto,
  CounterProposeDto,
  ProposeDto,
  RejectDto,
} from './dtos.js';

const CLOCK: Clock = new SystemClock();

@Controller('negotiations')
export class NegotiationController {
  constructor(
    @Inject(NEGOTIATION_REPOSITORY)
    private readonly repository: NegotiationRepository,
  ) {}

  private get deps(): NegotiationDeps {
    return { repository: this.repository, clock: CLOCK };
  }

  @Post()
  async propose(@Body() dto: ProposeDto) {
    return (await propose(this.deps, dto)).negotiation;
  }

  @Post(':id/counter')
  async counter(@Param('id') id: string, @Body() dto: CounterProposeDto) {
    try {
      return (await counterPropose(this.deps, { ...dto, id })).negotiation;
    } catch (error) {
      this.rethrow(error);
    }
  }

  @Post(':id/accept')
  async accept(@Param('id') id: string, @Body() dto: AcceptDto) {
    try {
      return (await accept(this.deps, { ...dto, id })).negotiation;
    } catch (error) {
      this.rethrow(error);
    }
  }

  @Post(':id/reject')
  async reject(@Param('id') id: string, @Body() dto: RejectDto) {
    try {
      return (await reject(this.deps, { ...dto, id })).negotiation;
    } catch (error) {
      this.rethrow(error);
    }
  }

  @Post(':id/confirm-summary')
  async confirm(@Param('id') id: string, @Body() dto: ConfirmSummaryDto) {
    try {
      return (await confirmSummary(this.deps, { ...dto, id })).negotiation;
    } catch (error) {
      this.rethrow(error);
    }
  }

  @Get(':id')
  async find(@Param('id') id: string) {
    const record = await this.repository.findById(id);
    if (!record) throw new NotFoundException(`Negociación no encontrada: ${id}`);
    return { ...record.negotiation, terms: record.terms, summary: record.summary };
  }

  /**
   * Trigger del job pg-cron: ejecuta el barrido de rondas vencidas con la
   * máquina de dominio. Protegido por secreto compartido (ver EXPIRY.md).
   */
  @Post('expire-rounds')
  @HttpCode(HttpStatus.OK)
  async expireRounds(@Headers('x-cron-secret') secret: string | undefined) {
    if (!process.env['CRON_SECRET'] || secret !== process.env['CRON_SECRET']) {
      throw new UnauthorizedException('cron secret inválido');
    }
    return expireRoundsSweep(this.deps);
  }

  private rethrow(error: unknown): never {
    if (error instanceof NegotiationNotFound) {
      throw new NotFoundException(error.message);
    }
    throw error;
  }
}
