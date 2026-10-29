import { buildDraft } from './clauses.js';
import { exampleInput } from './example.js';
import { SHORT_TERM_NOTICE } from './policy.js';
import { deriveReference } from './reference.js';

describe('plantilla de 21 cláusulas (HAB-31)', () => {
  it('el acuerdo de ejemplo produce las 21 cláusulas en orden', async () => {
    const input = exampleInput();
    const draft = buildDraft(input, await deriveReference(input));
    expect(draft.clauses).toHaveLength(21);
    expect(draft.clauses.map((clause) => clause.number)).toEqual(
      Array.from({ length: 21 }, (_, index) => index + 1),
    );
    expect(draft.clauses.map((clause) => clause.title)).toEqual([
      'Objeto del contrato',
      'Descripción del inmueble',
      'Precio de alquiler',
      'Depósito de garantía',
      'Duración del contrato',
      'Uso del inmueble',
      'Conservación',
      'Riesgos y daños',
      'Cambios y mejoras',
      'Inspección',
      'Pago de impuestos',
      'Pago de servicios',
      'Deberes del inquilino',
      'Deberes del propietario',
      'Terminación anticipada',
      'Incremento de renta',
      'Notificaciones',
      'Cláusula penal',
      'Responsabilidad civil',
      'Sistema de reclamos HabitaNexus',
      'Protocolización',
    ]);
    const body = draft.clauses.map((clause) => clause.body).join('\n');
    expect(body).toContain('350000');
    expect(body).toContain('vivienda');
    expect(body).toContain('2026-10-15');
    expect(draft.clauses[3]?.body).toContain('350000');
    expect(body).toContain('Jose Mora');
    expect(body).toContain('Ana Solis');
    expect(body).toContain('folio real 123456-000');
    expect(body).toContain('Barreal de Heredia');
    expect(body).toContain('transferencia');
    expect(body).toContain('12 meses');
    expect(body).toContain('Heredia, Costa Rica');
    expect(body).toContain('San Jose, Costa Rica');
    expect(draft.clauses[4]?.body).toContain(SHORT_TERM_NOTICE);
    expect(draft.clauses[1]?.body).toContain('cortinas y cocina');
  });
});
