/**
 * Acuerdo de ejemplo de HAB-31.
 *
 * Plazo de 12 meses para que la cláusula 5 lleve el aviso del SOP, depósito
 * de un mes e incremento por debajo del tope.
 */

import type { ContractFacts, ContractInput } from './types.js';

export const EXAMPLE_NEGOTIATION_ID = '11111111-1111-4111-8111-111111111111';

export function exampleTerms(): Record<string, unknown> {
  return {
    renta_mensual: 350000,
    deposito_garantia: 350000,
    plazo_meses: 12,
    fecha_inicio: '2026-11-01',
    fecha_fin: '2027-11-01',
    dia_pago: 1,
    moneda: 'CRC',
    incremento_anual: 2,
    uso_inmueble: 'vivienda',
    inventario: 'cortinas y cocina',
  };
}

export function exampleFacts(): ContractFacts {
  return {
    fechaContrato: '2026-10-15',
    arrendador: {
      nombre: 'Jose Mora',
      calidades: 'propietario',
      personeria: 'cedula 1-1111-1111',
      domicilio: 'Heredia, Costa Rica',
    },
    arrendatario: {
      nombre: 'Ana Solis',
      calidades: 'inquilina',
      personeria: 'cedula 2-2222-2222',
      domicilio: 'San Jose, Costa Rica',
    },
    inmueble: {
      citaInscripcion: 'folio real 123456-000',
      ubicacion: 'Barreal de Heredia',
      descripcion: 'apartamento de dos habitaciones',
      estadoConservacion: 'buen estado',
    },
    lugarPago: 'domicilio del arrendador',
    formaPago: 'transferencia',
    ipcAnual: 3.5,
  };
}

export function exampleInput(): ContractInput {
  return {
    negotiationId: EXAMPLE_NEGOTIATION_ID,
    terms: exampleTerms(),
    facts: exampleFacts(),
  };
}
