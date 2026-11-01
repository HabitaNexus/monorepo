/**
 * Caso de uso: generar el contrato desde PENDIENTE_FIRMA (HAB-31).
 *
 * No llama a la máquina de negociación ni emite firma. Si el estado no
 * autoriza la generación, no hay bytes.
 */

import { buildDraft } from '../domain/clauses.js';
import {
  ContratoYaGenerado,
  DatoMinimoAusente,
  GeneracionNoPermitida,
  NegociacionNoEncontrada,
} from '../domain/errors.js';
import { deriveReference } from '../domain/reference.js';
import { sha256Hex } from './hash.js';
import type {
  AgreementReader,
  ContractDocumentStore,
  GenerateContractInput,
  GeneratedContract,
  PdfRenderer,
} from './ports.js';

export interface GenerateContractDeps {
  readonly agreements: AgreementReader;
  readonly renderer: PdfRenderer;
  readonly store: ContractDocumentStore;
}

export async function generateContract(
  deps: GenerateContractDeps,
  input: GenerateContractInput,
): Promise<GeneratedContract> {
  const agreement = await deps.agreements.findById(input.negotiationId);
  if (!agreement) throw new NegociacionNoEncontrada(input.negotiationId);
  if (agreement.status !== 'PENDIENTE_FIRMA') {
    throw new GeneracionNoPermitida(agreement.status);
  }
  if (!agreement.summary) {
    throw new DatoMinimoAusente(['falta el resumen confirmado']);
  }

  const contractInput = {
    negotiationId: agreement.negotiationId,
    terms: agreement.summary.terms,
    facts: input.facts,
  };
  const reference = await deriveReference(contractInput);
  const draft = buildDraft(contractInput, reference);
  const pdf = await deps.renderer.render(draft);
  const digest = await sha256Hex(pdf);

  const existing = await deps.store.findByNegotiationId(agreement.negotiationId);
  if (existing) {
    if (existing.sha256 !== digest) throw new ContratoYaGenerado(agreement.negotiationId);
    return {
      negotiationId: existing.negotiationId,
      reference: existing.reference,
      pdf: existing.pdf,
      sha256: existing.sha256,
      status: 'PENDIENTE_FIRMA',
    };
  }

  const stored = {
    negotiationId: agreement.negotiationId,
    reference,
    pdf,
    sha256: digest,
  };
  await deps.store.save(stored);
  return { ...stored, status: 'PENDIENTE_FIRMA' };
}
