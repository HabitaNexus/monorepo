/**
 * Errores de generación del contrato (HAB-31).
 *
 * Dominio puro: el caso de uso no produce bytes cuando uno de estos se lanza.
 */

export class DepositoInferiorAlMinimo extends Error {
  readonly code = 'DEPOSITO_INFERIOR_AL_MINIMO' as const;

  constructor() {
    super('El depósito de garantía es menor a un mes de renta');
    this.name = 'DepositoInferiorAlMinimo';
  }
}

export class PlazoInconsistente extends Error {
  readonly code = 'PLAZO_INCONSISTENTE' as const;

  constructor(detail: string) {
    super(detail);
    this.name = 'PlazoInconsistente';
  }
}

export class IncrementoSobreTope extends Error {
  readonly code = 'INCREMENTO_SOBRE_TOPE' as const;
  readonly incremento: number;
  readonly tope: number;

  constructor(incremento: number, tope: number) {
    super(`El incremento anual ${incremento} supera el tope ${tope}`);
    this.name = 'IncrementoSobreTope';
    this.incremento = incremento;
    this.tope = tope;
  }
}

export class DatoMinimoAusente extends Error {
  readonly code = 'DATO_MINIMO_AUSENTE' as const;
  readonly issues: readonly string[];

  constructor(issues: readonly string[]) {
    super(`Faltan datos mínimos del contrato: ${issues.join('; ')}`);
    this.name = 'DatoMinimoAusente';
    this.issues = issues;
  }
}

export class GeneracionNoPermitida extends Error {
  readonly code = 'GENERACION_NO_PERMITIDA' as const;
  readonly status: string;

  constructor(status: string) {
    super(`No se genera el contrato desde el estado ${status}`);
    this.name = 'GeneracionNoPermitida';
    this.status = status;
  }
}

export class ContratoYaGenerado extends Error {
  readonly code = 'CONTRATO_YA_GENERADO' as const;
  readonly negotiationId: string;

  constructor(negotiationId: string) {
    super(`Ya hay un contrato con otros bytes para ${negotiationId}`);
    this.name = 'ContratoYaGenerado';
    this.negotiationId = negotiationId;
  }
}

export class NegociacionNoEncontrada extends Error {
  readonly code = 'NEGOCIACION_NO_ENCONTRADA' as const;
  readonly negotiationId: string;

  constructor(negotiationId: string) {
    super(`Negociación no encontrada: ${negotiationId}`);
    this.name = 'NegociacionNoEncontrada';
    this.negotiationId = negotiationId;
  }
}
