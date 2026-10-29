/**
 * AC de HAB-31: el dominio no importa la librería de PDF.
 *
 * El renderer vive detrás del port. Este test lee las fuentes para que
 * el resultado quede en el reporte de Jest, no solo en un grep manual.
 */

import { readdirSync, readFileSync, statSync } from 'node:fs';
import { join } from 'node:path';

function sourceFiles(dir: string): string[] {
  const found: string[] = [];
  for (const entry of readdirSync(dir)) {
    const path = join(dir, entry);
    if (statSync(path).isDirectory()) {
      found.push(...sourceFiles(path));
    } else if (path.endsWith('.ts') && !path.endsWith('.spec.ts')) {
      found.push(path);
    }
  }
  return found;
}

describe('corte hexagonal (HAB-31)', () => {
  it('domain y application no importan pdf-lib ni Nest ni Prisma', () => {
    const root = join(__dirname, '..');
    const files = [
      ...sourceFiles(join(root, 'domain')),
      ...sourceFiles(join(root, 'application')),
    ];
    expect(files.length).toBeGreaterThan(0);
    const forbidden = /from ['"](?:pdf-lib|pdfkit|puppeteer|jspdf|@nestjs\/|prisma)/;
    for (const file of files) {
      expect(readFileSync(file, 'utf8')).not.toMatch(forbidden);
    }
  });
});
