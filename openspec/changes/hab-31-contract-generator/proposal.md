# Proposal

## Why

La Fase 5 del flujo de arrendamiento tiene que entregar el contrato escrito a partir del acuerdo ya negociado. HAB-26 deja la negociación en `PENDIENTE_FIRMA` con el resumen congelado en `summary`, y el spec vivo todavía pide generar el PDF en un estado `ACUERDO` que el código no tiene. Este change define el generador (HAB-31) y deja la firma para HAB-32.

El issue de Linear sigue diciendo que `apps/backend/` está vacío. No lo está: NestJS 12 y Prisma 7 ya viven ahí, con el módulo `apps/backend/src/negotiation/`. Las 21 cláusulas salen de la tabla de Fase 5 del SOP. El spike `spikes/06-contract-core-megaprompt.md` (2026-04-16, @lapc506) se leyó aparte: no está en este monorepo. De ahí se toman el nombre `RentalContract`, el corte hexagonal extraction-ready y la prohibición de que la firma dispare pagos. No se toma su máquina de estados, su árbol `src/modules/contracts/`, ni el techo de depósito de un mes como regla general.

## What Changes

- Un generador en `apps/backend/src/contract/` que arma el PDF del contrato de arrendamiento de vivienda en Costa Rica, con las 21 cláusulas del SOP en ese orden, rellenadas con el `summary` de la negociación más los datos del Art. 11 que el JSON de 34 claves no trae.
- El texto cubre el contenido mínimo del Art. 11 (partes, inmueble, destino, precio y forma de pago, plazo, domicilios, fecha). No se pega la ley dentro del PDF: los artículos solo impiden escribir una cláusula que los contradiga.
- Cláusula 4: el depósito se escribe solo si es al menos un mes de renta. Cláusula 5: aviso del SOP (Art. 70 y 71) cuando `plazo_meses` es menor a 36, y la prórroga tácita de tres años en todo contrato. Cláusula 16: el techo es el IPC (Art. 67 y 68); un incremento mayor no se emite como pacto válido.
- Número de referencia estable, derivado de la entrada canónica. SHA-256 sobre los bytes finales del PDF, guardado junto al documento. La misma entrada produce los mismos bytes y el mismo hash.
- La librería de PDF queda detrás de un port. El dominio no la importa. No se reescribe la máquina de HAB-26 y el generador no mueve la negociación a `FIRMADO`.

### Decisiones cerradas (pendientes de OK)

1. **Librería: `pdf-lib` 1.17.1, pin exacto, solo en el adapter.** En esa versión `PDFString.fromDate` formatea en UTC con sufijo `Z`, y `PDFDocument.create({ updateMetadata: false })` no estampa `CreationDate` ni `ModDate` con `new Date()`. El adapter no registra fontkit, usa solo una fuente estándar (Helvetica / WinAnsi, que cubre el español de las cláusulas), no embebe imágenes ni formularios, y guarda con `useObjectStreams: false`. El `/ID` del trailer no se deja al azar: si la versión pineada no lo escribe, se omite; si aparece, el adapter lo fija con el SHA-256 de la entrada canónica. Se descarta pdfkit (el file ID mezcla tiempo y aleatoriedad), pdfmake (envuelve pdfkit) y Chromium (fecha, fuentes e IDs no son estables byte a byte). La prueba de “dos renders, mismo hash” está descrita en `tasks.md` y no se implementa en este change. Si esa prueba falla al aplicar, se detiene el apply: no se cambia de librería en silencio.

2. **Disparo: `PENDIENTE_FIRMA`, leyendo `summary`, sin transicionar.** El spec vivo dice `ACUERDO`. El código no tiene ese estado: `accept` congela `summary` y pasa a `ACUERDO_ALCANZADO`; la confirmación bilateral pasa a `PENDIENTE_FIRMA` y deja `summary` intacto. HAB-26 ya llama a `PENDIENTE_FIRMA` la frontera con la Fase 5. Generar en `ACUERDO_ALCANZADO` sellaría un PDF antes de que ambas partes confirmen el resumen. El generador exige `status === 'PENDIENTE_FIRMA'` y un `summary` presente. Cualquier otro estado no produce PDF. No llama a `transition` y no introduce `FIRMADO`.

   El JSON que alimenta cada cláusula es el de `summary.terms` (las mismas 34 claves de `TERMS_CATALOG`). Lo que el Art. 11 pide y el catálogo no tiene entra como `ContractFacts` (nombres, calidades, personerías, domicilios, cita registral, ubicación, descripción, lugar y forma de pago, fecha del contrato, IPC del período). Esos hechos forman parte de la entrada canónica. No se inventan.

   | # | Cláusula | Claves del JSON | Fuera del JSON |
   | --- | --- | --- | --- |
   | 1 | Objeto | `uso_inmueble` | partes, ubicación |
   | 2 | Descripción | `inventario`, `estado_pintura`, `amueblado`, `parqueo`, `jardineria` | descripción, instalaciones, estado, vicios, cita de inscripción |
   | 3 | Precio | `renta_mensual`, `dia_pago`, `moneda` | lugar de pago, forma de pago (texto; sin riel SINPE) |
   | 4 | Depósito | `deposito_garantia` comparado con `renta_mensual` | custodia descrita en el texto; sin escrow |
   | 5 | Duración | `plazo_meses`, `fecha_inicio`, `fecha_fin`, `preaviso_dias`, `renovacion_automatica` | el aviso es el párrafo del SOP, no el copy provisional de la UI |
   | 6 | Uso | `uso_inmueble`, `subarriendo`, `mascotas_permitidas`, `numero_ocupantes` | prohibición de ceder o subarrendar sin autorización (Art. 78) como texto fijo |
   | 7 | Conservación | `estado_pintura`, `mantenimiento_menor` | estado de conservación recibido |
   | 8 | Riesgos y daños | `mantenimiento_mayor` si viene | deber de avisar, texto fijo |
   | 9 | Cambios y mejoras | `mejoras` | las mejoras quedan a favor del inmueble (Art. 37) |
   | 10 | Inspección | `visitas_propietario` | el derecho de inspeccionar no se suprime (Art. 51) |
   | 11 | Impuestos | `cuota_mantenimiento` | impuestos municipales y áreas comunes a cargo del propietario, texto fijo del SOP |
   | 12 | Servicios | `servicios_agua`, `servicios_luz`, `servicios_internet` | si la clave falta, el texto dice que el servicio corre por cuenta del inquilino |
   | 13 | Deberes del inquilino | `mascotas_permitidas`, `numero_ocupantes`, `subarriendo`, `jardineria` | deberes fijos del SOP |
   | 14 | Deberes del propietario | `mantenimiento_mayor` | reparaciones estructurales, texto fijo del SOP |
   | 15 | Terminación anticipada | `resolucion_temprana`, `preaviso_dias`, `penalidad_mora`, `deposito_garantia` | el aviso del arrendatario no se escribe por debajo de tres meses (Art. 72) |
   | 16 | Incremento | `incremento_anual`, `moneda` | `ipcAnual` en `ContractFacts` |
   | 17 | Notificaciones | ninguna clave obliga el domicilio | domicilios de ambas partes; vía plataforma como texto |
   | 18 | Cláusula penal | `entrega_llaves`, `penalidad_mora` | entrega de llaves y acta final; la firma no se ejecuta aquí |
   | 19 | Responsabilidad civil | `seguro_inquilino` | el texto no renuncia derechos del arrendatario (Art. 3) |
   | 20 | Reclamos | `arbitraje` si viene | descripción contractual del canal; sin módulo de reclamos |
   | 21 | Protocolización | `gastos_notariales` | opción de protocolizar; sin notario |

   `firma_digital` no abre una cláusula 22. El cierre dice que la firma será digital, y HAB-32 la ejecuta.

3. **Persistencia: port `ContractDocumentStore`, adapter en memoria, sin Prisma en este change.** El PDF y el SHA-256 se guardan juntos detrás del port. Los tests usan el adapter en memoria. No hay migración, no hay tabla nueva y no se abre otro scaffold de backend. Un adapter Prisma queda fuera hasta un change posterior. El módulo Nest solo compone el caso de uso con el adapter en memoria; no hay ruta HTTP en HAB-31. El spike pide `PostgresContractRepository` y subir el PDF a S3 en la Fase 1 completa; eso no entra aquí.

### Qué se toma del spike y qué no

- Se toma: dominio puro, PDF detrás de un port, nombre `RentalContract` (no `HabitaNexusContract`), Costa Rica primero, y el anti-patrón de que `ContractSigned` no llama pagos ni regenera el PDF. Este change no emite ese evento.
- No se toma: la máquina `DRAFTED → UNDER_NEGOTIATION → SIGNED → ACTIVE` (§7). La negociación sigue siendo la de HAB-26. No se toma `apps/backend/src/modules/contracts/` (§6); el módulo queda en `apps/backend/src/contract/`, el mismo corte que `negotiation/`.
- No se toma el `ContractTerms` del spike (renta, duración, depósito, CO/MX). Los valores salen del `summary` de 34 claves.
- Depósito: el spike (§8) dice máximo un mes para todo Costa Rica. El Art. 92 fija ese máximo solo para vivienda de interés social (capítulo que abre el Art. 89). El SOP y este ticket piden al menos un mes. El generador rechaza un depósito menor y escribe uno mayor. No aplica el techo del Art. 92 porque el acuerdo no dice si el inmueble es de interés social.
- Incremento: la Fase 2 del spike registra un aumento sobre el IPC como warning. Aquí no se escribe como pacto válido: si supera el tope recibido, no hay PDF. El Art. 68 lo declara nulo.
- El spike no elige librería de PDF. La decisión 1 no cambia. La protocolización real, Firma Digital MICITT, S3, el event bus y CO/MX quedan fuera.

## Capabilities

### New Capabilities

- `contract-generator`: armar el contrato de arrendamiento (21 cláusulas, referencia, PDF determinista y hash) desde una negociación en `PENDIENTE_FIRMA`, sin firmarlo y sin mover la máquina de estados.

### Modified Capabilities

- `rental-flow`: el requirement `Contract Generation and Digital Signature` deja de generar con la negociación en `ACUERDO`. La generación ocurre en `PENDIENTE_FIRMA`, guarda el SHA-256 y no saca la negociación de ese estado. El scenario de firma digital permanece para HAB-32.

## Impact

- Código nuevo bajo `apps/backend/src/contract/` (`domain` / `application` / `infrastructure`), el mismo corte que `negotiation/`. `AppModule` importa el módulo. No se editan `machine.ts`, `states.ts` ni `terms.ts`.
- Dependencia nueva de producción: `pdf-lib` en `1.17.1`, importada solo desde infrastructure.
- Sin migración Prisma, sin endpoint, sin mobile, sin CO/MX, sin pagos, SINPE, escrow, Trustless Work, reclamos, inspecciones, protocolización real ni anclaje on-chain.
- El delta de spec es el contrato de comportamiento. La implementación espera el OK de este proposal, de `design.md`, de `tasks.md` y del delta.
