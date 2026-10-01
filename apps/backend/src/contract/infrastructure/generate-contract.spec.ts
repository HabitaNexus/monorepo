import { inflateSync } from 'node:zlib';
import { generateContract } from '../application/generate-contract.js';
import type { AgreementReader, AgreementSnapshot, PdfRenderer } from '../application/ports.js';
import { sha256Hex } from '../application/hash.js';
import { exampleFacts, exampleInput, exampleTerms } from '../domain/example.js';
import { GeneracionNoPermitida } from '../domain/errors.js';
import { InMemoryContractDocumentStore } from './persistence/in-memory-contract-document-store.js';
import { PdfLibRenderer } from './pdf/pdf-lib-renderer.js';

function decodeHexStrings(content: string): string {
  return content.replace(/<([0-9A-Fa-f\s]+)>/g, (_match, hex: string) => {
    const compact = hex.replace(/\s/g, '');
    let text = '';
    for (let index = 0; index < compact.length; index += 2) {
      text += String.fromCharCode(Number.parseInt(compact.slice(index, index + 2), 16));
    }
    return text;
  });
}

function inflatePdfText(bytes: Uint8Array): string {
  const raw = Buffer.from(bytes).toString('latin1');
  return raw
    .split('stream\n')
    .slice(1)
    .map((part) => {
      const data = part.split('endstream')[0] ?? '';
      try {
        return decodeHexStrings(inflateSync(Buffer.from(data, 'latin1')).toString('latin1'));
      } catch {
        return '';
      }
    })
    .join('\n');
}

class FakeAgreements implements AgreementReader {
  constructor(private readonly snapshot: AgreementSnapshot) {}

  async findById(id: string): Promise<AgreementSnapshot | null> {
    if (id !== this.snapshot.negotiationId) return null;
    return this.snapshot;
  }
}

function pendingSnapshot(): AgreementSnapshot {
  const input = exampleInput();
  return {
    negotiationId: input.negotiationId,
    status: 'PENDIENTE_FIRMA',
    summary: { version: 1, terms: exampleTerms() },
  };
}

describe('generateContract (HAB-31)', () => {
  it('guarda el hash de los bytes y una segunda generación coincide', async () => {
    const agreements = new FakeAgreements(pendingSnapshot());
    const renderer = new PdfLibRenderer();
    const firstStore = new InMemoryContractDocumentStore();
    const secondStore = new InMemoryContractDocumentStore();
    const facts = exampleFacts();
    const negotiationId = pendingSnapshot().negotiationId;

    const first = await generateContract(
      { agreements, renderer, store: firstStore },
      { negotiationId, facts },
    );
    const again = await generateContract(
      { agreements, renderer, store: firstStore },
      { negotiationId, facts },
    );
    const fresh = await generateContract(
      { agreements, renderer, store: secondStore },
      { negotiationId, facts },
    );

    expect(await sha256Hex(first.pdf)).toBe(first.sha256);
    expect(again.sha256).toBe(first.sha256);
    expect(Buffer.from(again.pdf).equals(Buffer.from(first.pdf))).toBe(true);
    expect(fresh.sha256).toBe(first.sha256);
    expect(Buffer.from(fresh.pdf).equals(Buffer.from(first.pdf))).toBe(true);
    expect(first.status).toBe('PENDIENTE_FIRMA');
    expect(agreements).toBeDefined();
    const raw = Buffer.from(first.pdf).toString('latin1');
    expect(raw.startsWith('%PDF-')).toBe(true);
    expect(raw).not.toContain('CreationDate');
    const text = inflatePdfText(first.pdf);
    expect(text).toContain(first.reference);
    expect(text).toContain('Objeto del contrato');
  });

  it('no genera desde ACUERDO_ALCANZADO y no llama al renderer', async () => {
    const snapshot: AgreementSnapshot = {
      ...pendingSnapshot(),
      status: 'ACUERDO_ALCANZADO',
    };
    const agreements = new FakeAgreements(snapshot);
    const renderer: PdfRenderer = {
      render: () => {
        throw new Error('el renderer no debe ejecutarse');
      },
    };
    await expect(
      generateContract(
        { agreements, renderer, store: new InMemoryContractDocumentStore() },
        { negotiationId: snapshot.negotiationId, facts: exampleFacts() },
      ),
    ).rejects.toBeInstanceOf(GeneracionNoPermitida);
    expect(snapshot.status).toBe('ACUERDO_ALCANZADO');
  });

  it('deja la negociación en PENDIENTE_FIRMA', async () => {
    const snapshot = pendingSnapshot();
    const agreements = new FakeAgreements(snapshot);
    const generated = await generateContract(
      {
        agreements,
        renderer: new PdfLibRenderer(),
        store: new InMemoryContractDocumentStore(),
      },
      { negotiationId: snapshot.negotiationId, facts: exampleFacts() },
    );
    expect(generated.status).toBe('PENDIENTE_FIRMA');
    expect((await agreements.findById(snapshot.negotiationId))?.status).toBe('PENDIENTE_FIRMA');
  });
});
