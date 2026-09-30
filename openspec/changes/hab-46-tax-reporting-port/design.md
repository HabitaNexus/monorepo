# Design

## Context

Ver `proposal.md` para el porqué. El living spec `openspec/specs/tribu-cr-adapter/spec.md` pide reporte automático, la fórmula fiscal y un `TaxReportingPort` hexagonal. No fija lenguaje ni carpeta.

`develop` tiene el backend Nest en `apps/backend/` (módulo `negotiation` en `src/negotiation/{domain,application,infrastructure}`). No hay `libs/domain` ni `libs/adapters`. `apps/hacienda-sidecar/` no está en `develop`; vive en el draft PR 50, rama `davidachoy/hab-45-auth-oidc-via-hacienda-cr-sidecar-grpc`.

El proto de esa rama, `apps/hacienda-sidecar/proto/hacienda_auth.proto`, paquete `habitanexus.hacienda.auth.v1`, servicio `HaciendaAuth`, expone solo:

- `GetAuthStatus(GetAuthStatusRequest) → { authenticated, environment }`
- `GetAccessToken(GetAccessTokenRequest) → { success, access_token, error }`

No hay RPC para presentar una declaración. El login OAuth2 ROPC queda dentro del sidecar (HAB-45). Este módulo no tiene client secret ni habla con el IdP.

`docs/architecture/eventbus-broker-analysis.md` (parte VI) constata que HabitaNexus no tiene bus interno. La decisión del intermediario sigue abierta (NATS JetStream a medio plazo, bandeja de salida en Postgres para un MVP). Este change no elige ni despliega ese intermediario.

DSMS (`docs/process/code-organization-standards.md`) corta por dominio y luego por capa. BrS (`docs/branching.md`) manda el PR a `develop`; el nombre de rama es el `gitBranchName` de Linear, no el prefijo `feature/` del diagrama.

Las tres decisiones del proposal esperan OK. No hay código de producto hasta ese OK.

## Goals / Non-Goals

**Goals:**

- Puerto de dominio único, sin I/O, con las tres operaciones del issue.
- Un adaptador que solo cumple `reportRentalIncome`.
- Función pura de impuesto, con IVA explícito, testeada sin red.
- Libro mensual idempotente por `(ownerId, período)` y por `eventId`.
- Un puerto de envío cuyo stub no toca la red y no marca la declaración como enviada.
- Notificación solo si el recibo de envío dice `submitted`.

**Non-Goals:**

- Elegir el broker, publicar `RentPaymentProcessed` desde pagos, o leer `PaymentRepository`.
- Implementar `generateElectronicInvoice` o `checkComplianceStatus` más allá de la firma.
- Añadir un RPC al sidecar, copiar `@dojocoding/hacienda-sdk`, o definir campos del payload de TRIBU-CR.
- Enviar correo, push o SMS. El puerto de notificación no elige canal.

## Decisions

### 1. Módulo Nest en `apps/backend/src/tax-reporting/`

El puerto vive en TypeScript, en el proceso que más adelante llamará al sidecar por gRPC. Un paquete Dart en `libs/` no tiene runtime de servidor en este repo y no puede ser el adaptador del sidecar Node.

Corte, igual que `negotiation`:

```text
apps/backend/src/tax-reporting/
  domain/            tipos, cálculo, período — sin Nest, Prisma ni gRPC
  application/       casos de uso y puertos
  infrastructure/    stub, ledger en memoria y Prisma, módulo Nest
```

DSMS documenta `apps/backend/apps/{contexto}/`. Este backend todavía no usa ese árbol (`negotiation` está en `src/`). Seguir `src/tax-reporting/` evita un segundo layout. No se mueve `negotiation`.

Alternativa descartada: paquetes Dart `libs/domain/ports` y `libs/adapters/tribu-cr`, como dice el texto del issue. El spec vivo no los nombra, y no hay un servidor Dart que los hospede.

### 2. El puerto se define una vez

```typescript
interface TaxReportingPort {
  reportRentalIncome(event: RentalIncomeEvent): Promise<TaxDeclaration>;
  generateElectronicInvoice(event: PaymentEvent): Promise<Invoice>;
  checkComplianceStatus(ownerId: string): Promise<TaxStatus>;
}
```

`TribuRentalIncomeAdapter` implementa la interfaz. `reportRentalIncome` registra el pago en el libro del período y devuelve la declaración borrador (totales recalculados, estado todavía no enviado). `generateElectronicInvoice` y `checkComplianceStatus` lanzan `TaxReportingOperationOutOfScope`. No consultan Hacienda ni arman XML. HAB-47 implementa la factura sobre esta misma interfaz, sin un segundo puerto.

El puerto no importa cliente gRPC, Prisma ni HTTP. Esas dependencias están en `infrastructure/`.

### 3. Cadencia: el pago alimenta el mes; el cierre presenta

El escenario original (“al procesar el pago, generar y enviar”) y el criterio de aceptación (“una declaración mensual por propietario, antes del día 15”) se reconcilian así:

| Momento | Qué pasa |
| --- | --- |
| `ContractSigned` | El contrato queda habilitado para declarar. No crea una declaración. |
| `RentPaymentProcessed` | Si el contrato está firmado, el pago entra al período `YYYY-MM` de `paidAt` en `America/Costa_Rica`. Se actualiza una sola declaración borrador de `(ownerId, período)`. No se llama al envío. |
| Cierre, días 1–14 del mes siguiente | `closePeriod` entrega cada declaración del mes anterior al puerto de envío. |

Un pago de un contrato no firmado se guarda aparte y no suma al bruto. Dos pagos del mismo dueño y mes suman un bruto. El mismo `eventId` por segunda vez no cambia el total.

`closePeriod` es un caso de uso con reloj inyectable, el mismo patrón que `clock.ts` de negociación. Un scheduler fino en infraestructura lo llama una vez al día. Si el reloj ya pasó el día 14 y la declaración sigue pendiente, igual se entrega al puerto de envío y el recibo puede marcarla `late`; el spec exige haberla entregado al llegar el 15. Los tests fijan el reloj y no esperan un cron real.

No hay suscriptor de NATS ni de `LISTEN/NOTIFY`. Los casos de uso son la API que un futuro suscriptor llamará. Nada en este módulo importa el repositorio de pagos.

### 4. Fórmula, en colones enteros

Base del impuesto sobre la renta: 85% del bruto. Impuesto: 15% de esa base. Redondeo half-up en cada paso, con enteros (sin `number` de punto flotante):

```text
taxableBase = divRoundHalfUp(gross * 85, 100)
incomeTax   = divRoundHalfUp(taxableBase * 15, 100)
iva         = gross > 693_300 ? divRoundHalfUp(gross * 13, 100) : 0
```

`divRoundHalfUp(n, d) = (n + d/2) / d` en división entera, solo montos positivos.

| Bruto mensual | Base | Renta | IVA |
| --- | --- | --- | --- |
| ₡500.000 | ₡425.000 | ₡63.750 | ₡0 |
| ₡693.300 | ₡589.305 | ₡88.396 | ₡0 |
| ₡800.000 | ₡680.000 | ₡102.000 | ₡104.000 |

El IVA es el 13% del bruto del período (la renta), sumado al impuesto sobre la renta. No es el 13% del impuesto. El spec dice “on top of the income tax” y no da la base; esta lectura es la que queda testeada. El umbral es estricto: ₡693.300 no lleva IVA. El bruto del umbral es el agregado del propietario en el mes, no cada pago por separado.

### 5. Envío: stub ahora, token después

Puerto de aplicación `TaxDeclarationSender.submit(declaration) → SubmissionReceipt`.

`StubTaxDeclarationSender` no abre socket, no llama gRPC y no construye un JSON de TRIBU-CR. Devuelve `pending_submission` con motivo `tribu_payload_schema_unknown`. La declaración no pasa a `submitted`. El notificador no corre.

El spike HAB-71 no dejó ADR con el esquema. Inventar campos sería un payload falso. El libro guarda solo el modelo de dominio: `ownerId`, `period`, `grossCrc`, `taxableBaseCrc`, `incomeTaxCrc`, `ivaCrc`, `status`.

Cuando existan las dos piezas que hoy faltan —el esquema de TRIBU-CR y un RPC de presentación que HAB-45 no define— el adaptador real hará esto y nada más con el token:

1. `GetAuthStatus`. Si `authenticated` es falso, no presenta; la declaración sigue pendiente.
2. `GetAccessToken`. Usa `access_token` como credencial de esa llamada de presentación. No lo persiste en el libro ni lo escribe en logs.
3. Llama al RPC de presentación que todavía no existe, con el payload que el esquema futuro indique. El token no sustituye ese RPC: el sidecar de hoy no acepta una declaración.

Ese adaptador real no entra en este change. El stub ocupa el puerto para que el cálculo y la idempotencia se prueben sin HAB-45 mergeado y sin red.

### 6. Idempotencia y notificación

- Un pago se identifica por `eventId`. La unicidad vive en el ledger.
- Una declaración se identifica por `(ownerId, period)`. `closePeriod` repetido no crea otra fila ni vuelve a notificar.
- `OwnerNotificationPort.notifyDeclarationSubmitted` corre solo con recibo `submitted`. El test de ese camino usa un sender falso que devuelve `submitted`. El stub de producción no lo hace.
- El notificador de infraestructura registra el aviso. No elige canal.

Ledger: puerto en aplicación, adaptador en memoria para los tests, adaptador Prisma para el proceso. Tablas nuevas, sin tocar las de negociación. No se guardan tokens ni un blob de TRIBU-CR.

## Risks / Trade-offs

- [La base del IVA (13% del bruto) no está en el spec, solo el umbral y el “on top”] → Queda en el delta y en la función pura. Cambiar la base no toca el puerto. El stub no presenta nada a Hacienda, así que un error de base no sale del proceso.
- [Decir “enviada” sin payload] → El stub devuelve `pending_submission` y no notifica.
- [Entrega al menos una vez, sin bus] → `eventId` único y declaración única por `(ownerId, período)`.
- [Nadie emite `ContractSigned` ni `RentPaymentProcessed` todavía] → El módulo se prueba por los casos de uso. No se bloquea este change en el broker de `eventbus-broker-analysis.md`.
- [El job no corre y se pasa el día 15] → El caso de uso igual entrega la declaración pendiente y puede marcarla `late`. La presentación real sigue bloqueada por el esquema.
- [HAB-47 define otro `TaxReportingPort`] → La firma de las tres operaciones queda en este change; la factura solo se añade como método ya declarado.

## Migration Plan

1. Migración Prisma solo con las tablas del libro de renta. Rollback: revertir esa migración; no hay datos de producción.
2. Registrar `TaxReportingModule` en `AppModule`. Sin el scheduler, el módulo no declara solo.
3. Un PR draft a `develop` desde `davidachoy/hab-46-taxreportingport-triburentalincomeadapter`, cuerpo de `.github/PULL_REQUEST_TEMPLATE.md`, `Fixes HAB-46`. Sin `.env` ni secretos. El sidecar de HAB-45 no se copia a esta rama.

## Open Questions

Ninguna que cambie el spec, el enfoque o las tareas. El esquema de TRIBU-CR y el RPC de presentación no se adivinan: bloquean el sender real y ya están fuera de estas tareas.
