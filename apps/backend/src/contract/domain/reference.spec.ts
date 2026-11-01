import { exampleInput } from './example.js';
import { canonicalJson, canonicalPayload, deriveReference } from './reference.js';

describe('referencia del contrato (HAB-31)', () => {
  it('la misma entrada repite la referencia y otra negociación la cambia', async () => {
    const first = exampleInput();
    const again = exampleInput();
    const other = {
      ...exampleInput(),
      negotiationId: '22222222-2222-4222-8222-222222222222',
    };

    const left = await deriveReference(first);
    const right = await deriveReference(again);
    const changed = await deriveReference(other);

    expect(left).toBe(right);
    expect(left).toMatch(/^HN-CR-[0-9a-f]{20}$/);
    expect(changed).not.toBe(left);
    expect(canonicalJson(canonicalPayload(first))).toBe(canonicalJson(canonicalPayload(again)));
  });
});
