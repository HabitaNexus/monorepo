/**
 * Errores estructurados del dominio de negociación (HAB-26).
 *
 * Dominio puro: Error estándar, sin dependencias.
 */

import type { NegotiationStatus } from './states.js';
import type { NegotiationEventType } from './events.js';

export const INVALID_TRANSITION_CODE = 'INVALID_NEGOTIATION_TRANSITION';
export const INVALID_TERMS_CODE = 'INVALID_TERMS_DOCUMENT';

export class InvalidNegotiationTransition extends Error {
  readonly code = INVALID_TRANSITION_CODE;
  readonly from: NegotiationStatus;
  readonly event: NegotiationEventType;

  constructor(from: NegotiationStatus, event: NegotiationEventType, detail?: string) {
    super(
      detail ??
        `Transición inválida: evento ${event} no permitido desde ${from}`,
    );
    this.name = 'InvalidNegotiationTransition';
    this.from = from;
    this.event = event;
  }
}

export class InvalidTermsDocument extends Error {
  readonly code = INVALID_TERMS_CODE;
  readonly issues: readonly string[];

  constructor(issues: readonly string[]) {
    super(`Documento de términos inválido: ${issues.join('; ')}`);
    this.name = 'InvalidTermsDocument';
    this.issues = issues;
  }
}
