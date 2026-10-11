import 'dotenv/config';
import 'reflect-metadata';
import { ValidationPipe } from '@nestjs/common';
import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module.js';
import { NegotiationExceptionFilter } from './negotiation/infrastructure/http/negotiation-exception.filter.js';

async function bootstrap(): Promise<void> {
  const app = await NestFactory.create(AppModule);
  app.useGlobalPipes(
    new ValidationPipe({ whitelist: true, forbidNonWhitelisted: true, transform: true }),
  );
  app.useGlobalFilters(new NegotiationExceptionFilter());
  // Web Flutter local (HAB-27): sin CORS el browser bloquea :3000.
  app.enableCors({
    origin: [
      'http://localhost:8080',
      'http://127.0.0.1:8080',
      'http://localhost:8082',
      'http://127.0.0.1:8082',
    ],
  });
  const port = Number(process.env['PORT'] ?? 3000);
  await app.listen(port);
}

void bootstrap();
