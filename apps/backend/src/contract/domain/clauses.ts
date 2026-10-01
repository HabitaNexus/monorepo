/**
 * Plantilla de las 21 cláusulas del SOP (HAB-31).
 *
 * Una tabla y un solo recorrido. No hay veintiún funciones exportadas.
 */

import { assessAgreement, SHORT_TERM_NOTICE, TACIT_RENEWAL, type AssessedAgreement } from './policy.js';
import type { ContractInput, RentalContractDraft } from './types.js';

interface Paragraph {
  readonly when?: (assessed: AssessedAgreement) => boolean;
  readonly text: (assessed: AssessedAgreement) => string;
}

interface ClauseTemplate {
  readonly number: number;
  readonly title: string;
  readonly paragraphs: readonly Paragraph[];
}

const CLAUSE_TITLES = [
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
] as const;

function fixed(text: string): Paragraph {
  return { text: () => text };
}

function paragraph(
  text: (assessed: AssessedAgreement) => string,
  when?: (assessed: AssessedAgreement) => boolean,
): Paragraph {
  if (when) return { text, when };
  return { text };
}

function show(value: unknown): string {
  if (typeof value === 'string' || typeof value === 'number' || typeof value === 'boolean') {
    return String(value);
  }
  return JSON.stringify(value);
}

function optionalLine(label: string, key: string): Paragraph {
  return paragraph(
    (assessed) => `${label}: ${show(assessed.optional[key])}.`,
    (assessed) => assessed.optional[key] !== undefined,
  );
}

function titleOf(value: PropertyFactsTitle): string {
  const cita = value.citaInscripcion?.trim() ?? '';
  if (cita.length > 0) return `Cita de inscripción: ${cita}.`;
  return `Documento fehaciente: ${value.documentoFehaciente?.trim() ?? ''}.`;
}

interface PropertyFactsTitle {
  readonly citaInscripcion?: string;
  readonly documentoFehaciente?: string;
}

const CLAUSE_TEMPLATES: readonly ClauseTemplate[] = [
  {
    number: 1,
    title: CLAUSE_TITLES[0],
    paragraphs: [
      paragraph(
        (a) =>
          `Fecha del contrato: ${a.facts.fechaContrato}. Arrendador: ${a.facts.arrendador.nombre}, ${a.facts.arrendador.calidades}, ${a.facts.arrendador.personeria}. Arrendatario: ${a.facts.arrendatario.nombre}, ${a.facts.arrendatario.calidades}, ${a.facts.arrendatario.personeria}.`,
      ),
      paragraph(
        (a) =>
          `El arrendador cede el uso del inmueble ubicado en ${a.facts.inmueble.ubicacion}, destinado a ${a.usoInmueble}.`,
      ),
    ],
  },
  {
    number: 2,
    title: CLAUSE_TITLES[1],
    paragraphs: [
      paragraph(
        (a) =>
          `${a.facts.inmueble.descripcion}. Estado de conservación: ${a.facts.inmueble.estadoConservacion}. ${titleOf(a.facts.inmueble)}`,
      ),
      paragraph(
        (a) => `Instalaciones: ${a.facts.inmueble.instalaciones}.`,
        (a) => (a.facts.inmueble.instalaciones?.trim().length ?? 0) > 0,
      ),
      paragraph(
        (a) => `Vicios o defectos: ${a.facts.inmueble.vicios}.`,
        (a) => (a.facts.inmueble.vicios?.trim().length ?? 0) > 0,
      ),
      optionalLine('Inventario', 'inventario'),
      optionalLine('Estado de pintura', 'estado_pintura'),
      optionalLine('Amueblado', 'amueblado'),
      optionalLine('Parqueo', 'parqueo'),
      optionalLine('Jardinería', 'jardineria'),
    ],
  },
  {
    number: 3,
    title: CLAUSE_TITLES[2],
    paragraphs: [
      paragraph(
        (a) =>
          `La renta mensual es ${a.rentaMensual} ${a.moneda}, pagadera el día ${a.diaPago} de cada mes, en ${a.facts.lugarPago}, mediante ${a.facts.formaPago}.`,
      ),
    ],
  },
  {
    number: 4,
    title: CLAUSE_TITLES[3],
    paragraphs: [
      paragraph(
        (a) =>
          `El depósito de garantía es ${a.depositoGarantia} ${a.moneda}. Cubre daños y obligaciones del contrato y se devuelve al finalizar, descontando los rubros acreditados. La custodia del depósito corresponde a la plataforma durante la vigencia.`,
      ),
    ],
  },
  {
    number: 5,
    title: CLAUSE_TITLES[4],
    paragraphs: [
      paragraph(
        (a) =>
          `El plazo pactado es de ${a.plazoMeses} meses, del ${a.fechaInicio} al ${a.fechaFin}.`,
      ),
      paragraph(() => SHORT_TERM_NOTICE, (a) => a.shortTerm),
      fixed(TACIT_RENEWAL),
      fixed('El aviso de no renovación es de al menos tres meses.'),
      paragraph(
        (a) =>
          `Las partes pactan un preaviso de ${a.preavisoEficaz} días, que no es inferior a tres meses.`,
        (a) => a.preavisoEficaz !== null,
      ),
    ],
  },
  {
    number: 6,
    title: CLAUSE_TITLES[5],
    paragraphs: [
      paragraph(
        (a) =>
          `El destino es ${a.usoInmueble}. Queda prohibido ceder o subarrendar sin autorización expresa del arrendador.`,
      ),
      optionalLine('Subarriendo', 'subarriendo'),
      optionalLine('Mascotas', 'mascotas_permitidas'),
      optionalLine('Ocupantes', 'numero_ocupantes'),
    ],
  },
  {
    number: 7,
    title: CLAUSE_TITLES[6],
    paragraphs: [
      paragraph(
        (a) =>
          `El arrendatario recibe el inmueble en estado ${a.facts.inmueble.estadoConservacion} y lo devuelve en el mismo estado, salvo desgaste normal.`,
      ),
      optionalLine('Pintura', 'estado_pintura'),
      optionalLine('Mantenimiento menor', 'mantenimiento_menor'),
    ],
  },
  {
    number: 8,
    title: CLAUSE_TITLES[7],
    paragraphs: [
      fixed(
        'El arrendatario debe avisar de inmediato los daños, vicios graves o peligros que aparezcan en el inmueble.',
      ),
      optionalLine('Mantenimiento mayor', 'mantenimiento_mayor'),
    ],
  },
  {
    number: 9,
    title: CLAUSE_TITLES[8],
    paragraphs: [
      fixed(
        'Las mejoras y reparaciones que haga el arrendatario quedan a favor del inmueble, salvo las que puedan retirarse sin menoscabo.',
      ),
      optionalLine('Mejoras', 'mejoras'),
    ],
  },
  {
    number: 10,
    title: CLAUSE_TITLES[9],
    paragraphs: [
      fixed(
        'El arrendador puede inspeccionar el inmueble en horas del día y con presencia de una persona mayor de edad. Ese derecho no se renuncia.',
      ),
      optionalLine('Visitas', 'visitas_propietario'),
    ],
  },
  {
    number: 11,
    title: CLAUSE_TITLES[10],
    paragraphs: [
      fixed(
        'Los impuestos municipales y el mantenimiento de áreas comunes corren por cuenta del arrendador.',
      ),
      optionalLine('Cuota de mantenimiento', 'cuota_mantenimiento'),
    ],
  },
  {
    number: 12,
    title: CLAUSE_TITLES[11],
    paragraphs: [
      fixed(
        'Los servicios de agua, electricidad e internet corren por cuenta del arrendatario, salvo el pacto que conste en esta cláusula.',
      ),
      optionalLine('Agua', 'servicios_agua'),
      optionalLine('Electricidad', 'servicios_luz'),
      optionalLine('Internet', 'servicios_internet'),
    ],
  },
  {
    number: 13,
    title: CLAUSE_TITLES[12],
    paragraphs: [
      fixed(
        'El arrendatario mantiene el inmueble limpio, no subarrienda, respeta el orden público y no introduce sustancias peligrosas.',
      ),
      optionalLine('Mascotas', 'mascotas_permitidas'),
      optionalLine('Ocupantes', 'numero_ocupantes'),
      optionalLine('Jardinería', 'jardineria'),
    ],
  },
  {
    number: 14,
    title: CLAUSE_TITLES[13],
    paragraphs: [
      fixed(
        'El arrendador atiende las reparaciones estructurales, tuberías y filtraciones, excepto cuando las cause el arrendatario.',
      ),
      optionalLine('Mantenimiento mayor', 'mantenimiento_mayor'),
    ],
  },
  {
    number: 15,
    title: CLAUSE_TITLES[14],
    paragraphs: [
      fixed(
        'El arrendatario puede dar por terminado el arrendamiento avisando con al menos tres meses de anticipación. La devolución del depósito sigue la cláusula 4.',
      ),
      optionalLine('Resolución temprana', 'resolucion_temprana'),
      optionalLine('Penalidad de mora', 'penalidad_mora'),
    ],
  },
  {
    number: 16,
    title: CLAUSE_TITLES[15],
    paragraphs: [
      paragraph(
        () =>
          'La renta está pactada en moneda extranjera y se mantiene por todo el plazo, sin reajuste.',
        (a) => a.incremento.kind === 'foreign',
      ),
      paragraph(
        () =>
          'El precio se actualiza al final de cada año conforme al índice oficial de precios al consumidor del INEC, sin exceder el tope aplicable. No se pacta una tasa numérica.',
        (a) => a.incremento.kind === 'formula',
      ),
      paragraph(
        (a) =>
          `Las partes pactan un incremento anual de ${a.incremento.kind === 'rate' ? a.incremento.percent : ''} por ciento, que no supera el tope aplicable.`,
        (a) => a.incremento.kind === 'rate',
      ),
    ],
  },
  {
    number: 17,
    title: CLAUSE_TITLES[16],
    paragraphs: [
      paragraph(
        (a) =>
          `Domicilio del arrendador: ${a.facts.arrendador.domicilio}. Domicilio del arrendatario: ${a.facts.arrendatario.domicilio}. También es medio válido la notificación por la plataforma.`,
      ),
    ],
  },
  {
    number: 18,
    title: CLAUSE_TITLES[17],
    paragraphs: [
      fixed(
        'Al terminar se entregan las llaves y se firma el acta de inspección final. La firma del contrato se hace en el acto previsto para ello.',
      ),
      optionalLine('Entrega de llaves', 'entrega_llaves'),
      optionalLine('Penalidad de mora', 'penalidad_mora'),
    ],
  },
  {
    number: 19,
    title: CLAUSE_TITLES[18],
    paragraphs: [
      fixed(
        'Este texto no renuncia los derechos irrenunciables del arrendatario. El arrendador no asume accidentes, robos o fenómenos naturales que no le sean imputables.',
      ),
      optionalLine('Seguro del inquilino', 'seguro_inquilino'),
    ],
  },
  {
    number: 20,
    title: CLAUSE_TITLES[19],
    paragraphs: [
      fixed(
        'Cualquier parte puede plantear un reclamo por la plataforma, con descripción y evidencia, y la otra debe responder.',
      ),
      optionalLine('Arbitraje', 'arbitraje'),
    ],
  },
  {
    number: 21,
    title: CLAUSE_TITLES[20],
    paragraphs: [
      fixed(
        'Las partes pueden protocolizar este contrato ante notario. Este documento no ejecuta esa protocolización.',
      ),
      optionalLine('Gastos notariales', 'gastos_notariales'),
    ],
  },
];

function renderClause(template: ClauseTemplate, assessed: AssessedAgreement): string {
  return template.paragraphs
    .filter((paragraph) => (paragraph.when ? paragraph.when(assessed) : true))
    .map((paragraph) => paragraph.text(assessed))
    .join('\n');
}

export function clauseTitles(): readonly string[] {
  return CLAUSE_TITLES;
}

export function buildDraft(input: ContractInput, reference: string): RentalContractDraft {
  const assessed = assessAgreement(input);
  return {
    reference,
    fechaContrato: assessed.facts.fechaContrato,
    clauses: CLAUSE_TEMPLATES.map((template) => ({
      number: template.number,
      title: template.title,
      body: renderClause(template, assessed),
    })),
  };
}
