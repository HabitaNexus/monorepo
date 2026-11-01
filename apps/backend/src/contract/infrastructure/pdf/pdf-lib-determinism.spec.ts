import { sha256Hex } from '../../application/hash.js';
import { renderProbeLines } from './pdf-lib-renderer.js';

describe('pdf-lib determinism (HAB-31)', () => {
  it('dos renders en el mismo proceso producen el mismo hash', async () => {
    const lines = ['Contrato de arrendamiento', 'Linea fija dos', 'Linea fija tres'];
    const first = await renderProbeLines(lines);
    const second = await renderProbeLines(lines);
    const firstHash = await sha256Hex(first);
    const secondHash = await sha256Hex(second);
    expect(secondHash).toBe(firstHash);
    expect(Buffer.from(second).equals(Buffer.from(first))).toBe(true);
    const text = Buffer.from(first).toString('latin1');
    expect(text).not.toContain('CreationDate');
    expect(text).not.toContain('ModDate');
  });
});
