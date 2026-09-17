# Bounded Contexts — Monolito Modular de HabitaNexus

> Documento vivo. Define los límites de contexto del dominio antes de cualquier
> extracción a microservicios. Cada contexto debe poder extraerse a un servicio
> independiente sin arrastrar acoplamiento implícito.

## Reglas del monolito modular

1. Un contexto = un módulo en `apps/backend` (NestJS) o un paquete en `packages/`.
2. Comunicación entre contextos **solo vía interfaces públicas** (ports) o eventos de dominio.
3. No se comparte la capa de persistencia entre contextos (tablas/colecciones propias).
4. Un bounded context nuevo comienza como módulo; **ningún microservicio** hasta que
   un contexto se valide como candidato (frecuencia de deployment independiente,
   escalado diferenciado, equipo propio).

## Mapa de contextos

| Contexto | Dominio | Módulo/Paquete propuesto | Gato/DBs propias | Eventos que emite |
|----------|---------|--------------------------|------------------|-------------------|
| **Marketplace** | Publicación de listados, catálogo, búsqueda, verificación de propietario (RNP) | `apps/backend/apps/marketplace` | `habitanexus_marketplace` | `ListingPublished`, `PropertyVerified` |
| **Visitas & Tours** | Video tours, tours 360°, agendamiento, notificaciones de visita | `apps/backend/apps/visits` + `apps/mobile/features/visits` | `habitanexus_visits` | `VisitScheduled`, `VisitCompleted` |
| **Negociación** | Propuestas/contrapropuestas, máquina de estados, rangos por propietario | `apps/backend/apps/negotiation` | `habitanexus_negotiation` | `NegotiationStarted`, `DealReached` |
| **Contrato** | Generador de contrato (Ley 7527), firma digital, acta de entrega, renovación | `apps/backend/apps/contract-core` | `habitanexus_contract` | `ContractSigned`, `ContractRenewed` |
| **Pagos & Ledger** | Escrow (Trustless Work), SINPE/Kindo, suscripciones, escalamiento de mora, asientos contables | `packages/trustless_work_*` + `apps/backend/apps/payments` | `habitanexus_ledger` | `PaymentProcessed`, `EscrowReleased`, `InvoiceIssued` |
| **Cumplimiento Fiscal** | TRIBU-CR, factura electrónica, reportes de renta, convenios municipales | `apps/backend/apps/tax` | `habitanexus_tax` | `TaxReportFiled` |
| **Identidad & Acceso** | Auth OIDC (Hacienda CR sidecar), roles propietario/inquilino/admin | `apps/backend/apps/iam` | `habitanexus_iam` | `UserVerified`, `OwnerVerified` |
| **Notificaciones** | Push, email, recordatorios (visitas, propuestas, mora) | `apps/backend/apps/notifications` | `habitanexus_notifications` | (consume eventos) |

## Puentes entre contextos (contratos explícitos)

```
Marketplace ──ListingPublished──► Visitas ──VisitCompleted──► Negociación
Negociación ──DealReached───────► Contrato ──ContractSigned──► Pagos
Pagos ────────PaymentProcessed──► Cumplimiento Fiscal
IAM ──────────OwnerVerified──────► Marketplace ──PropertyVerified──► Notificaciones
```

## Extracción a microservicios (criterios)

Un contexto se extrae del monolito cuando cumple **al menos dos** de:

- [ ] Requiere frecuencia de deploy independiente (>1/semana solo para ese contexto)
- [ ] Escala distinta al resto (picos de pagos/fiscal vs marketplace)
- [ ] Equipo dedicado trabajando en paralelo sin coordinar al monolito
- [ ] Fallo aislado requerido (ej. pagos no debe caer al concurren marketplace)

Extender el contexto en el monolito con módulo acotado **no** requiere este checklist;
solo la extracción del proceso.

## Estado actual

- Monolito modular: estructura en `apps/backend` y `packages/` en evolución.
- Specs OpenSpec por dominio en `openspec/specs/{rental-flow,tribu-cr-adapter,municipal-dashboard}`.
- Los events se modelan primero como eventos de dominio en los specs; transporte
  (event bus / outbox) se decide por contexto.