/**
 * Adapter pdf-lib 1.17.1 (HAB-31).
 *
 * Único archivo que importa la librería. La política de bytes estables es:
 * sin metadata de fechas, solo Helvetica, sin object streams. El /ID del
 * trailer se fija solo si la librería lo escribió.
 */

import {
  PDFDocument,
  PDFHexString,
  StandardFonts,
  type PDFFont,
  type PDFPage,
} from 'pdf-lib';
import type { PdfRenderer } from '../../application/ports.js';
import type { RentalContractDraft } from '../../domain/types.js';

const PAGE_WIDTH = 595;
const PAGE_HEIGHT = 842;
const MARGIN = 50;
const FONT_SIZE = 11;
const LEADING = 14;

const PROBE_LINES = [
  'Contrato de arrendamiento',
  'Linea fija dos',
  'Linea fija tres',
] as const;

export async function renderProbeLines(
  lines: readonly string[] = PROBE_LINES,
): Promise<Uint8Array> {
  const doc = await PDFDocument.create({ updateMetadata: false });
  const page = doc.addPage([PAGE_WIDTH, PAGE_HEIGHT]);
  const font = await doc.embedFont(StandardFonts.Helvetica);
  let y = PAGE_HEIGHT - MARGIN;
  for (const line of lines) {
    page.drawText(line, { x: MARGIN, y, size: 12, font });
    y -= 16;
  }
  return saveDeterministic(doc, lines.join('\n'));
}

export async function renderDraft(draft: RentalContractDraft): Promise<Uint8Array> {
  const doc = await PDFDocument.create({ updateMetadata: false });
  const font = await doc.embedFont(StandardFonts.Helvetica);
  const bold = await doc.embedFont(StandardFonts.HelveticaBold);
  const cursor = new PageCursor(doc);
  cursor.draw('CONTRATO DE ARRENDAMIENTO DE VIVIENDA', bold);
  cursor.draw(`Referencia: ${draft.reference}`, font);
  cursor.draw(`Fecha: ${draft.fechaContrato}`, font);
  cursor.draw('', font);
  for (const clause of draft.clauses) {
    cursor.draw(`${clause.number}. ${clause.title}`, bold);
    for (const block of clause.body.split('\n')) {
      cursor.draw(block, font);
    }
    cursor.draw('', font);
  }
  const seed = [draft.reference, draft.fechaContrato, ...draft.clauses.map((clause) => clause.body)].join(
    '\n',
  );
  return saveDeterministic(doc, seed);
}

async function saveDeterministic(doc: PDFDocument, idSeed: string): Promise<Uint8Array> {
  if (doc.context.trailerInfo.ID) {
    const digest = await crypto.subtle.digest('SHA-256', new TextEncoder().encode(idSeed));
    const hex = [...new Uint8Array(digest)]
      .map((byte) => byte.toString(16).padStart(2, '0'))
      .join('')
      .slice(0, 32);
    doc.context.trailerInfo.ID = doc.context.obj([PDFHexString.of(hex), PDFHexString.of(hex)]);
  }
  return doc.save({
    useObjectStreams: false,
    addDefaultPage: false,
    updateFieldAppearances: false,
  });
}

class PageCursor {
  private page: PDFPage;
  private y: number;
  private current: PDFFont | null = null;

  constructor(private readonly doc: PDFDocument) {
    this.page = doc.addPage([PAGE_WIDTH, PAGE_HEIGHT]);
    this.y = PAGE_HEIGHT - MARGIN;
  }

  draw(text: string, font: PDFFont): void {
    const lines = wrap(text, font, FONT_SIZE, PAGE_WIDTH - MARGIN * 2);
    const rendered = lines.length === 0 ? [''] : lines;
    for (const line of rendered) {
      if (this.y < MARGIN + LEADING) {
        this.page = this.doc.addPage([PAGE_WIDTH, PAGE_HEIGHT]);
        this.y = PAGE_HEIGHT - MARGIN;
        this.current = null;
      }
      if (this.current !== font) {
        // pdf-lib nombra la fuente con un RNG de semilla fija por documento.
        // Cambiar de fuente solo en el corte evita una clave nueva por línea.
        this.page.setFont(font);
        this.current = font;
      }
      if (line.length > 0) {
        this.page.drawText(line, { x: MARGIN, y: this.y, size: FONT_SIZE });
      }
      this.y -= LEADING;
    }
  }
}

function wrap(text: string, font: PDFFont, size: number, maxWidth: number): string[] {
  if (text.length === 0) return [''];
  const words = text.split(' ');
  const lines: string[] = [];
  let current = '';
  for (const word of words) {
    const next = current.length === 0 ? word : `${current} ${word}`;
    if (font.widthOfTextAtSize(next, size) <= maxWidth) {
      current = next;
    } else {
      if (current.length > 0) lines.push(current);
      current = word;
    }
  }
  if (current.length > 0) lines.push(current);
  return lines;
}

export class PdfLibRenderer implements PdfRenderer {
  render(draft: RentalContractDraft): Promise<Uint8Array> {
    return renderDraft(draft);
  }
}
