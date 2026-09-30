# Proposal

## Why

Un propietario que cobra alquiler por HabitaNexus tiene que declarar renta de capital inmobiliario a TRIBU-CR sin armar el formulario a mano. El living spec `tribu-cr-adapter` ya exige ese reporte, la fórmula y un `TaxReportingPort` hexagonal, y `develop` ya tiene el backend Nest donde puede vivir. El envío real no puede salir en este change: no hay esquema del payload de TRIBU-CR (el spike HAB-71 no dejó ADR) y el sidecar de HAB-45, todavía fuera de `develop`, solo entrega un access token.

## What Changes

- Definir `TaxReportingPort` una sola vez, sin I/O, con `reportRentalIncome`, `generateElectronicInvoice` y `checkComplianceStatus`.
- Implementar solo `reportRentalIncome` en `TribuRentalIncomeAdapter`.
- Calcular renta de capital inmobiliario (15% sobre el 85% del ingreso bruto) y el IVA 13% cuando la renta mensual supera ₡693.300.
- Agregar la declaración por propietario y período, presentable antes del día 15 del mes siguiente, idempotente por `(ownerId, período)`.
- Consumir `RentPaymentProcessed` y `ContractSigned`. No llamar a `PaymentRepository`.
- Notificar al propietario solo cuando la declaración queda enviada.
- Detener el envío real detrás de un puerto con stub. El cálculo y la idempotencia se prueban sin red.

Fuera de este change: factura electrónica, XML, XAdES y `.p12` (HAB-47); la lógica de `checkComplianceStatus`; fork de `DojoCodingLabs/hacienda-cr` o de `@dojocoding/hacienda-sdk`; inventar el payload de TRIBU-CR; un RPC de “presentar declaración” que el sidecar de HAB-45 no tiene.

## Decisions

Estas tres quedan cerradas aquí y esperan OK antes de implementar.

1. **Dónde vive el código.** Módulo Nest en `apps/backend/src/tax-reporting/`, mismo corte dominio/aplicación/infraestructura que `negotiation`. El living spec exige el puerto hexagonal y no fija lenguaje ni ruta. El issue atribuye `libs/domain/ports` y `libs/adapters/tribu-cr` en Dart; esos paquetes no existen, y el servidor de `develop` es TypeScript. Un paquete Dart no puede llamar al sidecar gRPC desde el proceso que declara. DSMS pide el corte por dominio primero; se sigue el módulo ya presente en `src/`, no un árbol `apps/backend/apps/` que este backend todavía no usa.
2. **Cadencia.** Cada `RentPaymentProcessed` de un contrato firmado entra al libro del período. Se presenta una sola declaración por `(ownerId, período)`, antes del día 15 del mes siguiente. El escenario del spec que genera la declaración al procesar el pago se lee como “ese pago entra en la declaración del mes”, no como un envío a TRIBU-CR por pago.
3. **Envío.** Stub hasta tener el formato de TRIBU-CR y el sidecar de HAB-45 en `develop`. El cálculo y la idempotencia se implementan y se testean sin red. El stub no afirma que Hacienda aceptó la declaración, y por eso no dispara la notificación de “enviada”.

## Capabilities

### New Capabilities

- Ninguna. El comportamiento ya pertenece a `tribu-cr-adapter`.

### Modified Capabilities

- `tribu-cr-adapter`: la declaración de renta pasa de “al procesar el pago, enviarla por el sidecar” a un agregado mensual idempotente por propietario, con la fórmula (incluido IVA) explícita y el envío real detenido en un puerto hasta conocer el payload. La factura electrónica y `checkComplianceStatus` siguen en el spec y no se implementan aquí.

## Impact

- Nuevo módulo `apps/backend/src/tax-reporting/` (TypeScript, Nest). Sin cambios en mobile ni en `apps/hacienda-sidecar/` (ese sidecar está en el draft PR 50, no en `develop`).
- El adaptador futuro usará `GetAccessToken` de `habitanexus.hacienda.auth.v1`. Hoy no hay RPC para presentar la declaración.
- HAB-47 reutiliza el mismo `TaxReportingPort` para `generateElectronicInvoice`.
- Rama `davidachoy/hab-46-taxreportingport-triburentalincomeadapter`, un PR draft a `develop`, `Fixes HAB-46`.
