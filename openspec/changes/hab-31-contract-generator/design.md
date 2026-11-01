# Design

## Context

El backend ya es NestJS 12 + Prisma 7. `apps/backend/src/negotiation/` llega a `PENDIENTE_FIRMA` y congela el acuerdo en `summary` (34 claves, `TERMS_CATALOG`). La máquina de estados no se toca. See proposal.md (Why, decisiones) y los deltas `contract-generator` y `rental-flow`.

El spike 06 pide `apps/backend/src/modules/contracts/` y una máquina `DRAFTED → SIGNED → ACTIVE`. Este diseño no la copia. Copia el corte que ya usa negociación: `domain` / `application` / `infrastructure`, con el PDF detrás de un port.

## Goals / Non-Goals

**Goals:**

- Un caso de uso que, dada una negociación en `PENDIENTE_FIRMA`, arma las 21 cláusulas, pinta un PDF determinista y guarda bytes + SHA-256.
- Dominio sin `pdf-lib`, sin `@nestjs/*` y sin Prisma.
- Las cláusulas son una tabla de plantillas, no veintiún funciones exportadas.
- La misma entrada canónica produce los mismos bytes.

**Non-Goals:**

- Firma, timestamp, IP, orden inquilino → propietario, estado `FIRMADO` (HAB-32).
- Emitir o consumir `ContractSigned`. Ese evento no regenera el PDF ni llama pagos.
- Pagos, SINPE, escrow, Trustless Work, reclamos, inspecciones, protocolización real, S3, event bus, anclaje on-chain.
- CO y MX. Sin `COLey820Rule` ni `MXCodigoCivilFederalRule`.
- Validación de rangos de la negociación (HAB-30). Aquí solo se rehúsa escribir un depósito ilegal o un incremento sobre el tope.
- Migración Prisma y ruta HTTP.

## Decisions

- **Módulo `apps/backend/src/contract/`, no `src/modules/contracts/`.** El árbol queda así:
  - `domain/`: plantilla de cláusulas, política (depósito, plazo, IPC), borrador `RentalContractDraft`, errores. Cero imports de infraestructura.
  - `application/`: caso de uso `generateContract` y los ports `PdfRenderer` y `ContractDocumentStore`.
  - `infrastructure/pdf/`: adapter `pdf-lib`.
  - `infrastructure/persistence/`: adapter en memoria.
  - `contract.module.ts` lo compone en Nest. `AppModule` lo importa. No hay controller.
  Alternativa descartada: el árbol del spike (§6). Mezcla entidades de disputa, notario y bridge que este change no construye, y no coincide con el corte de `negotiation/`.

- **El borrador no es una segunda máquina de estados.** `RentalContractDraft` es el texto: referencia, encabezado y las 21 cláusulas ya resueltas. No tiene `DRAFTED` ni `SIGNED`. El estado que autoriza la generación se lee de la negociación y no se escribe.

- **Disparo.** `generateContract` carga la negociación por id. Exige `state.status === 'PENDIENTE_FIRMA'` y `summary` no nulo. Otro estado, o `summary` nulo, devuelve error de dominio y cero bytes. No importa `transition` ni `machine.ts`.

- **Entrada canónica.** La forman, en un objeto de claves ordenadas: `templateVersion` (`cr-ley-7527-v1`), `negotiationId`, `summary.terms` y `ContractFacts`. El JSON canónico es UTF-8, claves ordenadas de forma recursiva, sin espacios. La referencia es `HN-CR-` más los primeros 20 hex del SHA-256 de ese JSON. Va en el encabezado del PDF, así que entra en los bytes. El hash del documento es otro SHA-256, el de los bytes finales. No hay ciclo: la referencia no depende del PDF.

- **`ContractFacts`, porque el catálogo no trae el Art. 11.** Obligatorios: fecha del contrato (ISO `YYYY-MM-DD`, no el reloj), arrendador y arrendatario (nombre, calidades, personería, domicilio), inmueble (cita de inscripción o documento fehaciente, ubicación, descripción, estado de conservación), lugar de pago, forma de pago (texto) y, si la moneda es `CRC`, el tope `ipcAnual` aplicable a ese período. Opcionales: instalaciones y vicios. Si falta un obligatorio, no hay PDF. La forma de pago no abre un riel SINPE. La custodia del depósito se enuncia en la cláusula 4 y no llama a escrow.

- **Plantilla.** Un arreglo ordenado de 21 entradas `{ number, title, paragraphs }`. Cada párrafo es texto fijo o un hueco que lee una clave del resumen o un campo de `ContractFacts`. Un solo recorrido pinta el cuerpo. Los términos opcionales que vienen se escriben en la cláusula de la tabla del proposal. Si no vienen, queda la frase legal fija de esa cláusula (subarriendo solo con autorización, impuestos municipales a cargo del propietario, servicios por cuenta del inquilino, deber de avisar daños, mejoras a favor del inmueble). No se inventan montos.

- **Política, aparte de la entidad.** Una función evalúa el resumen antes de pintar. No vive dentro de veintiún renderers.
  - Depósito: `deposito_garantia` y `renta_mensual` son enteros de la misma moneda. Si el depósito es menor, error `DepositoInferiorAlMinimo` y no hay PDF. Si es igual o mayor, la cláusula 4 escribe el monto. No se aplica el techo de un mes del spike: el Art. 92 es solo vivienda de interés social (Art. 89) y el acuerdo no trae ese dato.
  - Plazo: `plazo_meses` entero. `fecha_fin` tiene que ser `fecha_inicio` más esos meses de calendario en UTC. Si no cuadra, error `PlazoInconsistente`. Bajo 36 meses, la cláusula 5 incluye el aviso del SOP, el párrafo que empieza «Aviso legal (Art. 70 y 71, Ley 7527)», no el texto provisional de la UI móvil («renuncia tácita»). La prórroga tácita de tres años se escribe siempre, aunque `renovacion_automatica` sea falso. `preaviso_dias` menor a 90 no se escribe como plazo eficaz; la cláusula dice tres meses. Si es 90 o más, se escribe junto al mínimo legal.
  - Incremento: `CRC` es colón; cualquier otra moneda es extranjera y la cláusula 16 dice que la renta no se reajusta (Art. 67, último párrafo), sin aplicar `incremento_anual`. En colones, el tope es `ipcAnual` recibido (el llamador trae el porcentaje aplicable, IPC o el que fije el MIVAH cuando la inflación supere 10 %; este módulo no consulta al INEC). Si `incremento_anual` es un número mayor que el tope, error `IncrementoSobreTope` y no hay PDF. Si es menor o igual, se escribe. Si falta o es la cadena `IPC`, se escribe la fórmula legal sin una tasa numérica. No se recorta el número al tope.

- **Renderer.** Port `PdfRenderer.render(draft) → Uint8Array`. El adapter es el único archivo que importa `pdf-lib` en `1.17.1` exacto. Política de bytes estables, medida en la tarea de prueba y no antes:
  - `PDFDocument.create({ updateMetadata: false })`, para no estampar `CreationDate` ni `ModDate` con `new Date()`.
  - No se llama `setCreationDate` ni `setModificationDate`. La fecha del Art. 11 j va en el cuerpo, desde `fechaContrato`.
  - Solo `StandardFonts.Helvetica` (WinAnsi cubre el español de las cláusulas). Sin fontkit: un subset de fuente embebida lleva un tag aleatorio.
  - Sin imágenes, formularios ni anotaciones.
  - `save({ useObjectStreams: false, addDefaultPage: false, updateFieldAppearances: false })`.
  - Si el trailer trae `/ID`, se sustituye por 16 bytes tomados del SHA-256 de la entrada canónica. Si la versión pineada no lo escribe, se deja ausente.
  - Márgenes, tamaño de letra y orden de dibujo fijos. El adapter no lee el reloj ni `randomUUID`.
  Alternativa descartada: pdfkit y pdfmake, porque el file ID mezcla tiempo y azar. Chromium, porque la impresión a PDF no es estable byte a byte.

- **Hash y almacén.** La aplicación calcula el SHA-256 con WebCrypto sobre los bytes que devolvió el renderer, en hex minúsculas. El port `ContractDocumentStore` guarda `{ negotiationId, reference, pdf, sha256 }`. `findByNegotiationId` + `save`. El adapter en memoria es el único de este change. Si ya hay un documento de esa negociación con el mismo hash, se devuelve. Si el hash difiere, error `ContratoYaGenerado` y no se sobrescribe. La segunda generación de la prueba es la función pura: dos `render` de la misma entrada, mismos bytes, sin pasar por el reloj.

- **Nombres.** La entidad de texto se llama `RentalContractDraft`. El inmueble es property en los tipos, no apartment. No aparece `HabitaNexusContract`.

## Risks / Trade-offs

- [pdf-lib 1.17.1 deja de ser determinista en un parche] → El pin es exacto. La primera tarea de apply compara dos renders. Si el hash cambia, se detiene el apply.
- [Art. 92 y el spike limitan el depósito a un mes; este diseño no] → Queda explícito en el proposal para el OK. Un inmueble de interés social con depósito mayor no se detecta aquí.
- [El tope IPC lo trae el llamador] → Un tope mal cargado se escribe como válido. Este change no consulta al INEC.
- [Sin Prisma el PDF muere con el proceso] → Alcanza para los tests. La persistencia durable es otro change, detrás del mismo port.
- [WinAnsi no cubre algún carácter] → La plantilla se escribe en español cubierto por WinAnsi. Un carácter fuera de esa codificación falla el render en el test, no se sustituye por una fuente embebida.

## Migration Plan

No hay migración. Rollback de este change es no importar `ContractModule`. No se altera el schema de `negotiations`.

## Open Questions

Ninguna que cambie el spec, el enfoque o las tareas. Las tres decisiones del proposal (librería, disparo, almacén en memoria) esperan OK antes de implementar.
