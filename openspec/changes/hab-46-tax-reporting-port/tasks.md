# Tasks

## 1. Cálculo fiscal puro

- [x] 1.1 Implementar `calculateRentalIncomeTax` en `apps/backend/src/tax-reporting/domain/` con enteros y half-up (15% del 85%; IVA 13% del bruto solo si el bruto es mayor que ₡693.300). Verificar con `npm test` en `apps/backend`: `rental-income-tax.spec.ts` cubre ₡500.000 → base ₡425.000, renta ₡63.750, IVA ₡0; ₡800.000 → base ₡680.000, renta ₡102.000, IVA ₡104.000; ₡693.300 → base ₡589.305, renta ₡88.396, IVA ₡0.
- [x] 1.2 Derivar el período `YYYY-MM` desde `paidAt` en `America/Costa_Rica`. Verificar con un test de dominio que un instante en el límite del mes cae en el período de Costa Rica y no en el del UTC.

## 2. Puerto único

- [x] 2.1 Definir `TaxReportingPort` en `domain/` con `reportRentalIncome`, `generateElectronicInvoice` y `checkComplianceStatus`, sin imports de `@nestjs/*`, `prisma` ni `@grpc/grpc-js`. Verificar con `rg` sobre `domain/` que esos imports no aparecen.
- [x] 2.2 Hacer que `TribuRentalIncomeAdapter` implemente el puerto y que las dos operaciones fuera de alcance lancen `TaxReportingOperationOutOfScope`. Verificar con un test que ambas lanzan y que no hay cliente gRPC en el adaptador.

## 3. Libro mensual e idempotencia

- [x] 3.1 Registrar `ContractSigned` y `RentPaymentProcessed` en un ledger en memoria, sin referenciar `PaymentRepository`. Verificar con un test que dos pagos del mismo propietario, contrato firmado y mes producen una sola declaración cuyo bruto es la suma.
- [x] 3.2 Deduplicar por `eventId` y por `(ownerId, período)`. Verificar con un test que repetir el mismo pago deja el bruto igual.
- [x] 3.3 Excluir pagos de contratos no firmados. Verificar con un test que ese monto no aparece en ninguna declaración mensual.

## 4. Cierre, stub y notificación

- [x] 4.1 Implementar `TaxDeclarationSender` y `StubTaxDeclarationSender`, que devuelve `pending_submission` / `tribu_payload_schema_unknown` sin red y sin armar un payload de TRIBU-CR. Verificar con un test que `closePeriod` (reloj fijo, antes del día 15) entrega la declaración del mes anterior y la deja pendiente.
- [x] 4.2 Notificar solo con recibo `submitted`. Verificar con un test de sender falso que el aviso sale una vez, y con el stub que un pendiente no avisa. Un segundo `closePeriod` no crea otra declaración ni otro aviso.
- [x] 4.3 Dejar escrito en el adaptador el contrato del sender futuro: `GetAuthStatus`, luego `GetAccessToken`, y un RPC de presentación que el proto de HAB-45 no tiene. Verificar leyendo el módulo que este change no añade cliente gRPC ni llama al sidecar.

## 5. Módulo Nest y ledger Prisma

- [x] 5.1 Añadir la migración Prisma del libro (unicidad de `eventId` y de `(ownerId, period)`) sin columnas de token ni de payload TRIBU-CR. Verificar que el SQL de la migración existe y no altera tablas de negociación.
- [x] 5.2 Registrar `TaxReportingModule` en `AppModule` y un scheduler que llama a `closePeriod`. Verificar con `npx tsc --noEmit` en `apps/backend`.

## 6. Integración del change

- [x] 6.1 Correr `npm test` en `apps/backend` y confirmar que los tests de los grupos 1–4 siguen en verde.
- [x] 6.2 Correr `openspec validate --strict` sobre `hab-46-tax-reporting-port` y confirmar que termina sin errores.

## QA traceability (four layers)

SSOT: `docs/process/qa-traceability.md`

| Capa | Artifacto |
| --- | --- |
| 1 — AC normativos | `openspec/changes/hab-46-tax-reporting-port/specs/tribu-cr-adapter/spec.md` |
| 2 — QA manual de stage | Sin SOP de dominio tributario. El stub no presenta a TRIBU-CR; no hay checklist de stage en este change. |
| 3 — Automatizada | `apps/backend/src/tax-reporting/**/*.spec.ts` (tabla abajo) |
| 4 — Ronda HITL | `docs/qa/rounds/tribu-cr-2026-09-30/round.md` (se abre en la ronda, no en este change) |

### Mapeo scenario → verificación

| Scenario de OpenSpec | Test automatizado | Manual (SOP / Kiwi) | Caso HITL ID | Storybook (solo UI) |
| --- | --- | --- | --- | --- |
| `Monthly rental income declaration` | `report-rental-income.spec.ts` agrega dos pagos del mismo dueño y mes | pendiente, sin SOP | `TRIBU-01` | — |
| `Declaration before deadline` | `close-period.spec.ts` entrega el mes anterior antes del día 15 y lo deja pendiente | pendiente, sin SOP | `TRIBU-02` | — |
| `Repeated payment does not change the period total` | `report-rental-income.spec.ts` ignora un `eventId` repetido | pendiente, sin SOP | `TRIBU-03` | — |
| `Owner is notified only after submission` | `close-period.spec.ts` avisa solo si el sender devuelve `submitted` | pendiente, sin SOP | `TRIBU-04` | — |
| `Unsigned contract payment is excluded` | `report-rental-income.spec.ts` excluye el pago de un contrato no firmado | pendiente, sin SOP | `TRIBU-05` | — |
| `Standard rental income tax` | `rental-income-tax.spec.ts` ₡500.000 → ₡425.000 / ₡63.750 / IVA ₡0 | pendiente, sin SOP | `TRIBU-06` | — |
| `IVA applicable` | `rental-income-tax.spec.ts` ₡800.000 → ₡680.000 / ₡102.000 / IVA ₡104.000 | pendiente, sin SOP | `TRIBU-07` | — |
| `IVA at the threshold` | `rental-income-tax.spec.ts` ₡693.300 → IVA ₡0, renta ₡88.396 | pendiente, sin SOP | `TRIBU-08` | — |

### Handoff

- [ ] Casos manuales desde SOP — no aplica hasta que exista envío real y un SOP tributario
- [ ] Ronda HITL con `round.md` y esta tabla pegada en Traceability
