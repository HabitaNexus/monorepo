/**
 * Entrada del generador (HAB-31).
 *
 * Los términos salen del resumen de negociación. ContractFacts cubre el
 * Art. 11 que ese JSON de 34 claves no trae. Dominio puro.
 */

export const TEMPLATE_VERSION = 'cr-ley-7527-v1';

export interface PartyFacts {
  readonly nombre: string;
  readonly calidades: string;
  readonly personeria: string;
  readonly domicilio: string;
}

export interface PropertyFacts {
  readonly citaInscripcion?: string;
  readonly documentoFehaciente?: string;
  readonly ubicacion: string;
  readonly descripcion: string;
  readonly estadoConservacion: string;
  readonly instalaciones?: string;
  readonly vicios?: string;
}

export interface ContractFacts {
  readonly fechaContrato: string;
  readonly arrendador: PartyFacts;
  readonly arrendatario: PartyFacts;
  readonly inmueble: PropertyFacts;
  readonly lugarPago: string;
  readonly formaPago: string;
  readonly ipcAnual?: number;
}

export interface ContractInput {
  readonly negotiationId: string;
  readonly terms: Readonly<Record<string, unknown>>;
  readonly facts: ContractFacts;
}

export interface RenderedClause {
  readonly number: number;
  readonly title: string;
  readonly body: string;
}

export interface RentalContractDraft {
  readonly reference: string;
  readonly fechaContrato: string;
  readonly clauses: readonly RenderedClause[];
}

export interface CanonicalPayload {
  readonly templateVersion: typeof TEMPLATE_VERSION;
  readonly negotiationId: string;
  readonly terms: Readonly<Record<string, unknown>>;
  readonly facts: ContractFacts;
}
