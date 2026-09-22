import {
  ArgumentsHost,
  Catch,
  ExceptionFilter,
  HttpStatus,
} from '@nestjs/common';
import { Response } from 'express';
import {
  InvalidNegotiationTransition,
  InvalidTermsDocument,
} from '../../domain/errors.js';

/**
 * Mapea errores de dominio a HTTP estructurado (HAB-26: transiciones
 * inválidas = error con código/from/event, nunca 500 ni estado corrupto).
 */
@Catch(InvalidNegotiationTransition, InvalidTermsDocument)
export class NegotiationExceptionFilter implements ExceptionFilter {
  catch(
    exception: InvalidNegotiationTransition | InvalidTermsDocument,
    host: ArgumentsHost,
  ): void {
    const response = host.switchToHttp().getResponse<Response>();
    if (exception instanceof InvalidNegotiationTransition) {
      response.status(HttpStatus.CONFLICT).json({
        statusCode: HttpStatus.CONFLICT,
        code: exception.code,
        message: exception.message,
        from: exception.from,
        event: exception.event,
      });
      return;
    }
    response.status(HttpStatus.BAD_REQUEST).json({
      statusCode: HttpStatus.BAD_REQUEST,
      code: exception.code,
      message: exception.message,
      issues: exception.issues,
    });
  }
}
