/**
 * Referencia estable del contrato (HAB-31).
 *
 * HN-CR- más 20 hex del SHA-256 del JSON canónico. No depende de los bytes
 * del PDF, así que no hay ciclo con el hash del documento.
 */

import { TEMPLATE_VERSION, type CanonicalPayload, type ContractInput } from './types.js';

export function canonicalPayload(input: ContractInput): CanonicalPayload {
  return {
    templateVersion: TEMPLATE_VERSION,
    negotiationId: input.negotiationId,
    terms: input.terms,
    facts: input.facts,
  };
}

export function canonicalJson(value: unknown): string {
  if (value === null || typeof value !== 'object') {
    return JSON.stringify(value);
  }
  if (Array.isArray(value)) {
    return `[${value.map((item) => canonicalJson(item)).join(',')}]`;
  }
  const record = value as Record<string, unknown>;
  const keys = Object.keys(record).sort();
  const body = keys
    .filter((key) => record[key] !== undefined)
    .map((key) => `${JSON.stringify(key)}:${canonicalJson(record[key])}`)
    .join(',');
  return `{${body}}`;
}

export function referenceFromDigest(hex: string): string {
  return `HN-CR-${hex.slice(0, 20)}`;
}

async function sha256Hex(value: string): Promise<string> {
  const bytes = new TextEncoder().encode(value);
  const digest = await crypto.subtle.digest('SHA-256', bytes);
  return [...new Uint8Array(digest)]
    .map((byte) => byte.toString(16).padStart(2, '0'))
    .join('');
}

export async function deriveReference(input: ContractInput): Promise<string> {
  const hex = await sha256Hex(canonicalJson(canonicalPayload(input)));
  return referenceFromDigest(hex);
}
