# Ronda HITL — generador de contrato (HAB-31)

Fecha: 2026-10-01
Dominio: contract-generator
Automatizado en esta ronda: `cd apps/backend && npm test -- src/contract` y `npm test -- src/negotiation`

El stage desplegado no se recorrió en esta sesión. Los pasos de abajo se ejecutan sobre el PDF del acuerdo de ejemplo (`exampleInput` en `apps/backend/src/contract/domain/example.ts`): renta 350000 CRC, depósito 350000, plazo 12 meses, inicio 2026-11-01, fin 2027-11-01, incremento 2, tope IPC 3.5, fecha de contrato 2026-10-15.

## Casos manuales — cláusulas del SOP

Abrir el PDF generado y confirmar, en este orden:

1. Objeto: ubicación Barreal de Heredia y destino vivienda.
2. Descripción: apartamento de dos habitaciones, buen estado, folio real 123456-000, inventario cortinas y cocina.
3. Precio: 350000 CRC, día 1, lugar domicilio del arrendador, forma transferencia.
4. Depósito: 350000 y custodia de la plataforma, sin llamada a escrow.
5. Duración: 12 meses, del 2026-11-01 al 2027-11-01, aviso «Aviso legal (Art. 70 y 71, Ley 7527)» y prórroga tácita de tres años.
6. Uso: vivienda y prohibición de ceder o subarrendar sin autorización.
7. Conservación: se recibe y se devuelve en el mismo estado, salvo desgaste normal.
8. Riesgos y daños: deber de avisar de inmediato.
9. Cambios y mejoras: quedan a favor del inmueble.
10. Inspección: el derecho no se renuncia.
11. Impuestos: municipales y áreas comunes a cargo del arrendador.
12. Servicios: agua, electricidad e internet a cargo del arrendatario salvo pacto.
13. Deberes del inquilino: limpieza, no subarrendar, orden público, no sustancias peligrosas.
14. Deberes del propietario: reparaciones estructurales, tuberías y filtraciones.
15. Terminación anticipada: aviso de al menos tres meses y devolución del depósito según la cláusula 4.
16. Incremento: 2 por ciento, dentro del tope.
17. Notificaciones: domicilios de Jose Mora y Ana Solis, y la plataforma como medio.
18. Cláusula penal: llaves y acta final. La firma no queda ejecutada.
19. Responsabilidad civil: no renuncia derechos del arrendatario.
20. Reclamos: canal por la plataforma. No hay módulo de reclamos en este cambio.
21. Protocolización: opción ante notario, sin ejecutarla.

Encabezado: referencia `HN-CR-` de 20 hex y fecha 2026-10-15. El archivo no trae `CreationDate`.

## Casos manuales — reglas

- CTR-03: forma de pago en blanco. No hay PDF.
- CTR-04: depósito 100000. No hay PDF.
- CTR-06: depósito 400000. La cláusula 4 dice 400000.
- CTR-08: plazo 36 meses, fin 2029-11-01. Hay prórroga tácita y no está el aviso de plazo inferior.
- CTR-09: `renovacion_automatica` falso. La prórroga tácita sigue.
- CTR-10: preaviso 30. No aparece «30 días» como plazo eficaz.
- CTR-11: preaviso 120. Aparece «120 días» y «tres meses».
- CTR-13: incremento 10 con tope 3.5. No hay PDF.
- CTR-15: sin `incremento_anual`. La cláusula 16 describe el índice y no trae una tasa.
- CTR-16: moneda USD e incremento 9. La cláusula 16 dice sin reajuste y no aplica el 9.
- CTR-18: otro `negotiationId`. Otra referencia.
- CTR-20: generar dos veces la misma entrada. Mismos bytes y mismo SHA-256.
- CTR-22: estado `ACUERDO_ALCANZADO`. No hay PDF y el estado no cambia.
- CTR-23: después de generar, el estado sigue `PENDIENTE_FIRMA`.
- CTR-32: firma digital. Fuera de esta ronda. Lo cubre HAB-32.

## Traceability

| Scenario de OpenSpec | Test automatizado | Manual (SOP / Kiwi) | Caso HITL ID | Storybook (solo UI) |
| --- | --- | --- | --- | --- |
| Acuerdo de ejemplo produce las 21 cláusulas en orden | `clauses.spec.ts` acuerdo de ejemplo | SOP Fase 5, tabla 1–21 | CTR-01 | — |
| El documento enuncia el contenido mínimo | `clauses.spec.ts` acuerdo de ejemplo | SOP Fase 5 + Art. 11 | CTR-02 | — |
| Falta un dato mínimo | `policy.spec.ts` dato mínimo ausente | SOP Fase 5, reglas de negocio | CTR-03 | — |
| Depósito inferior a un mes | `policy.spec.ts` depósito inferior | SOP Fase 4, depósito mínimo 1 mes | CTR-04 | — |
| Depósito de un mes | `policy.spec.ts` depósito de un mes y uno mayor | SOP Fase 5, cláusula 4 | CTR-05 | — |
| Depósito mayor a un mes | `policy.spec.ts` depósito de un mes y uno mayor | SOP Fase 5, cláusula 4 | CTR-06 | — |
| Plazo menor a 36 meses | `policy.spec.ts` aviso del SOP | SOP Fase 4, aviso Art. 70 y 71 | CTR-07 | — |
| Plazo de 36 meses o más | `policy.spec.ts` aviso del SOP | SOP Fase 5, cláusula 5 | CTR-08 | — |
| Renovación automática en falso | `policy.spec.ts` prórroga tácita | SOP Fase 5, cláusula 5 | CTR-09 | — |
| Preaviso inferior a tres meses | `policy.spec.ts` preaviso menor a 90 días | SOP Fase 5, cláusula 5 | CTR-10 | — |
| Preaviso de tres meses o más | `policy.spec.ts` preaviso de 90 días o más | SOP Fase 5, cláusula 5 | CTR-11 | — |
| Sin preaviso pactado | `policy.spec.ts` sin preaviso pactado | SOP Fase 5, cláusula 5 | CTR-12 | — |
| Incremento mayor al tope | `policy.spec.ts` incremento mayor al tope | SOP Fase 4, incremento ≤ IPC | CTR-13 | — |
| Incremento dentro del tope | `policy.spec.ts` incremento dentro del tope | SOP Fase 5, cláusula 16 | CTR-14 | — |
| Sin porcentaje pactado | `policy.spec.ts` sin porcentaje pactado | SOP Fase 5, cláusula 16 | CTR-15 | — |
| Moneda extranjera | `policy.spec.ts` moneda extranjera | SOP Fase 4, renta en moneda extranjera | CTR-16 | — |
| Misma entrada, misma referencia | `reference.spec.ts` misma entrada | SOP Fase 5, número único de referencia | CTR-17 | — |
| Otra negociación, otra referencia | `reference.spec.ts` misma entrada | SOP Fase 5, número único de referencia | CTR-18 | — |
| El hash coincide con los bytes | `generate-contract.spec.ts` hash de los bytes | SOP Fase 5, hash SHA-256 | CTR-19 | — |
| Segunda generación idéntica | `generate-contract.spec.ts` hash de los bytes | SOP Fase 5, documento inmodificable | CTR-20 | — |
| PENDIENTE_FIRMA genera | `generate-contract.spec.ts` hash de los bytes | SOP Fase 4, paso 7, frontera Fase 5 | CTR-21 | — |
| ACUERDO_ALCANZADO no genera | `generate-contract.spec.ts` ACUERDO_ALCANZADO | SOP Fase 4, confirmación bilateral | CTR-22 | — |
| No pasa a firmado | `generate-contract.spec.ts` deja la negociación en PENDIENTE_FIRMA | SOP Fase 5, firma es el paso 5 | CTR-23 | — |
| Contract auto-generation | `generate-contract.spec.ts` hash de los bytes | SOP Fase 5, pasos 1 y reglas de negocio | CTR-24 | — |
| Digital signature | `(pending HAB-32)` | SOP Fase 5, paso 5 de firma | CTR-32 | — |
