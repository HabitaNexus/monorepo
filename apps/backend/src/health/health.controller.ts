import { Controller, Get, HttpException, HttpStatus } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service.js';

/**
 * Probes para Kubernetes (ver `k8s/base/backend/deployment.yaml`).
 * `/health` (liveness, sin dependencias) y `/ready` (readiness, con ping a DB).
 */
@Controller()
export class HealthController {
  constructor(private readonly prisma: PrismaService) {}

  @Get('health')
  health(): Record<string, string> {
    return { status: 'ok' };
  }

  @Get('ready')
  async ready(): Promise<Record<string, string>> {
    try {
      await this.prisma.$queryRaw`SELECT 1`;
      return { status: 'ready' };
    } catch {
      throw new HttpException({ status: 'not-ready' }, HttpStatus.SERVICE_UNAVAILABLE);
    }
  }
}
