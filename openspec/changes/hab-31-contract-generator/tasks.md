# Tasks

## 1. Prueba de determinismo del renderer

- [x] 1.1 Agregar `pdf-lib` en `1.17.1` exacto a `apps/backend` y verificar que el lock queda en `1.17.1` y que `src/contract/domain/` no importa `pdf-lib` (el directorio puede no existir todavía; el grep del dominio se repite en 3.1).
- [x] 1.2 Escribir un test Jest que construye dos PDF con la política del design (tres líneas fijas, `PDFDocument.create({ updateMetadata: false })`, solo Helvetica, sin fontkit, `save({ useObjectStreams: false })`, sin fechas de metadata) y compara el SHA-256 de ambos buffers en el mismo proceso. Verificar que `npm test -- pdf-lib-determinism` pasa. Si los hash difieren, detener el apply: no seguir a la plantilla ni cambiar de librería en silencio.

## 2. Dominio: plantilla y política

- [x] 2.1 Crear `apps/backend/src/contract/domain/` con una tabla de 21 plantillas en el orden del SOP y un acuerdo de ejemplo (`renta_mensual` 350000, `deposito_garantia` 350000, `plazo_meses` 12, `fecha_inicio` 2026-11-01, `fecha_fin` 2027-11-01, `dia_pago` 1, `moneda` CRC, `incremento_anual` 2, `uso_inmueble` vivienda, más `ContractFacts` con partes, inmueble, domicilios, lugar y forma de pago, `fechaContrato` 2026-10-15 e `ipcAnual` 3.5). Verificar con un test de dominio que el borrador tiene las cláusulas 1 a 21 en ese orden y que el texto incluye renta, depósito, destino y la fecha del contrato.
- [x] 2.2 Implementar la política del design (depósito menor rechazado, depósito mayor escrito, aviso del SOP solo si `plazo_meses` < 36, prórroga tácita aunque `renovacion_automatica` sea falso, preaviso < 90 no se escribe como eficaz, incremento sobre `ipcAnual` rechazado, moneda distinta de CRC sin reajuste, dato mínimo ausente rechazado, `fecha_fin` incoherente rechazada). Verificar que el test de dominio cubre esos casos y no produce cláusulas cuando la política rechaza.
- [x] 2.3 Derivar la referencia `HN-CR-` + 20 hex del SHA-256 del JSON canónico (claves ordenadas, `templateVersion` `cr-ley-7527-v1`, `negotiationId`, resumen y facts). Verificar que la misma entrada repite la referencia y que otro `negotiationId` la cambia.

## 3. Caso de uso, hash y almacén

- [x] 3.1 Implementar el adapter `PdfRenderer` con la política de 1.2, pintando el borrador en orden fijo. Verificar con grep que `src/contract/domain/` y `src/contract/application/` no importan `pdf-lib`, `@nestjs/*` ni `prisma`.
- [x] 3.2 Implementar `generateContract`: solo `PENDIENTE_FIRMA` con `summary`, SHA-256 de los bytes finales guardado junto al PDF en `ContractDocumentStore` en memoria, segunda generación de la misma entrada con los mismos bytes y el mismo hash, `ACUERDO_ALCANZADO` sin bytes y sin cambiar el estado, y el estado sigue en `PENDIENTE_FIRMA` tras generar. Verificar que el test del caso de uso cubre esos cuatro resultados y que no llama a `transition`.
- [x] 3.3 Componer `ContractModule` con el adapter en memoria y el renderer, e importarlo desde `AppModule`, sin controller y sin tocar `prisma/schema.prisma` ni `negotiation/domain/machine.ts`. Verificar con `npm run typecheck` en `apps/backend` y con un diff que no modifica el schema ni la máquina.

## 4. Verificación de integración

- [x] 4.1 Correr `openspec validate --strict` del change `hab-31-contract-generator` y verificar que termina en cero.
- [x] 4.2 Correr `npm test` en `apps/backend` y verificar que pasan los tests de `contract/` y los de `negotiation/` que ya existían.

## QA traceability (four layers)

SSOT: `docs/process/qa-traceability.md`

| Capa | Artifacto |
| --- | --- |
| 1 — AC normativos | `openspec/changes/hab-31-contract-generator/specs/contract-generator/spec.md` y `specs/rental-flow/spec.md` |
| 2 — QA manual de stage | `docs/site/content/docs/how-to/flujo-arrendamiento.md` § Fase 5, tabla de las 21 cláusulas y reglas de negocio |
| 3 — Automatizada | `apps/backend/src/contract/` (tabla abajo) |
| 4 — Ronda HITL | `docs/qa/rounds/contract-generator-2026-10-01/round.md` |

### Mapeo scenario → verificación

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

### Handoff

- [x] 5.1 Armar los casos manuales desde el SOP de Fase 5 y verificar que cada fila de la tabla tiene un paso reproducible en stage.
- [x] 5.2 Abrir la ronda HITL en `docs/qa/rounds/contract-generator-2026-10-01/round.md` con esta tabla pegada en Traceability, y verificar que el archivo existe.
