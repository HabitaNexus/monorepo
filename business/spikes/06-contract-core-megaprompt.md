# Spike 06 — contract-core: Mega-Prompt para HabitaNexus

**Fecha**: 2026-04-16
**Autor**: @lapc506 (Luis Andrés Peña Castillo)
**Estado**: Spike. Mega-prompt listo para handoff a sesión de implementación (Claude Code, otro agente, o developer humano).
**Relación con**: `business-model-toolkit:brainstorm`, ecosistema `-core` del autor.

---

## 0. Cómo usar este documento

Este es un **mega-prompt auto-contenido**. Está diseñado para ser pegado a una sesión fresca (Claude, GPT-5, Gemini, o cualquier agente con permisos de codebase) sin necesidad de contexto adicional. Produce output accionable: arquitectura + código + migración path.

**Uso típico**:

1. Copiar este archivo completo al prompt de una nueva sesión.
2. Añadir al final: "Procede a implementar la Fase 1 (§14) dentro del monorepo HabitaNexus".
3. El agente deberá hacer checkpoints con el autor antes de cada fase siguiente.

**Alternativa**: usar como referencia arquitectónica durante sesiones manuales; el autor copia fragmentos según la discusión.

---

## 1. Contexto del autor y del portafolio

El autor (@lapc506 / andres@dojocoding.io) mantiene un portafolio de **4 startups personales** + ecosistema de librerías compartidas:

**Startups**:

- **HabitaNexus** (este repo) — plataforma de alquiler de apartamentos con nómadas digitales. Escrow en CR; digital contract en CR/MX/CO.
- **AltruPets** — plataforma de bienestar animal + donaciones deducibles (modelo Vaki.co).
- **Vertivolatam** — hardware de agricultura vertical + marketplace hortalizas.
- **AduaNext** — SaaS para despacho aduanero, integrado con ATENA.

**Librerías `-core` compartidas** (patrón sidecar gRPC, hexagonal, dual deployment K8s/Docker):

| `-core` | Lenguaje | Licencia | Estado |
|---|---|---|---|
| `agentic-core` | Python 3.12+ | BSL 1.1 | Activo |
| `marketplace-core` | TypeScript | MIT | Activo |
| `invoice-core` | TypeScript | BSL 1.1 | En diseño (2026 Q2-Q3) |
| `compliance-core` | TypeScript | BSL 1.1 | Planeado (después de invoice-core) |

**Governance**: una rúbrica de 5 criterios decide cuándo un dominio merece `-core` propio. Documento: `/home/kvttvrsis/Escritorio/2026-04-16-core-governance-rubric.md`.

---

## 2. Verdicto de la rúbrica para `contract-core`

**Evaluación formal** (2026-04-16):

| Criterio | Resultado |
|---|:---:|
| 1. Reuso cross-startup | ⚠️ solo HabitaNexus hoy; reuso teórico en Vertivo/AltruPets/AduaNext pero **no confirmado en roadmap 12-18 meses** |
| 2. Dominio acotado | ✅ state machine contrato + multi-sig + evidencia + arbitraje + on-chain bridge |
| 3. Complejidad | ✅ notariado + Starknet/Madara bridge + IPFS + jurisdiction rules |
| 4. Aislamiento | ⚠️ depende |
| 5. Integraciones externas | ✅ notarios, appchain, IPFS |

**Score: 4/5 con falla crítica en criterio 1 (reuso actual)**.

**Decisión governance**:

- **NO** se crea `contract-core` como sidecar separado **ahora**.
- **SÍ** se implementa la capacidad dentro del backend de HabitaNexus, **diseñada extraction-ready**.
- **Extracción a `-core` se gatilla** cuando ≥1 startup adicional (Vertivo B2B contracts, AduaNext SaaS SLAs on-chain, AltruPets Foundation adoption agreements) muestre demanda real de los mismos ports.
- **Ventana estimada de extracción**: year 2-3 (2027-2028).

**Este spike produce el mega-prompt para la implementación interna extraction-ready.**

---

## 3. Por qué HabitaNexus necesita esto primero (re-framing del autor)

Durante el brainstorming de `invoice-core` el autor clarificó:

> "En HabitaNexus el escrow NO es el gran diferenciador (si nos salimos de Costa Rica), sino que todo el proceso de negociación del contrato de alquiler sea digital. Eventualmente podría inclusive almacenarse en un smart contract en Starknet/Madara en una appchain propia."

Esto cambia la prioridad arquitectónica:

- **Escrow**: viable solo en CR (Ley 8204 aplicable > USD 1000/mes → obliga a `compliance-core` AML).
- **MX y CO**: **NO** se ofrece escrow. Se ofrece **solo flujo contrato digital + retenciones fiscales** (invoice-core maneja retenciones; contract-core internal maneja contrato).
- Esta separación **reduce exposición al régimen 18-D MX "plataforma digital que intermedia hospedaje"** porque no hay pago intermediado — solo tech-license del contrato + constancia de retención como retenedor por art. 18-D.

**El diferenciador que vende HabitaNexus fuera de CR** = experiencia de negociación + firma + evidencia + arbitraje + preparación para ejecución on-chain. **Eso es exactamente el scope de contract-core internal**.

---

## 4. Scope del trabajo (IN / OUT)

### IN scope

- Ciclo de vida completo del contrato de alquiler (drafted → negotiated → signed → active → completed | disputed | terminated).
- Multi-party digital signatures: inquilino/nómada + arrendador/anfitrión + plataforma como testigo.
- Negociación estructurada (ofertas, contra-ofertas, amendments, redlines).
- Collection y sellado temporal de evidencia (fotos inspección, videos check-in, reportes de incidentes).
- Workflows de arbitraje / disputa (mediación → arbitraje → terminación).
- Bridge off-chain ↔ on-chain (eventos del dominio → eventos Cairo/Madara cuando esté listo).
- Reglas jurisdiction-aware: CR (Ley 7527) + CO (Ley 820 de 2003) + MX (Código Civil Federal art. 2398+ + códigos locales).
- Integración con notario digital (para CR-only; MX/CO tienen procesos distintos).
- Event bus interno (para que invoice-core y compliance-core reaccionen a eventos de contrato).

### OUT of scope

- **Pagos** — `invoice-core` + Kindo/Stripe/crypto por backend HabitaNexus.
- **Escrow** — servicio separado dentro de HabitaNexus backend (no es contract-core), trabaja con CR only.
- **Emisión de facturas / constancias de retención** — `invoice-core`.
- **KYC / AML / verificación identidad** — `compliance-core` (cuando exista; mientras tanto, stub).
- **Publicación de propiedades** — `marketplace-core`.
- **Comunicación entre partes** — chat/mensajería, out-of-scope (usa WhatsApp o similar por ahora).
- **Cálculo de rentabilidad / valuación del inmueble** — dominio separado de HabitaNexus, no contract-core.

---

## 5. Requisitos de extraction-readiness

Para que el código pueda extraerse a `contract-core` sidecar en año 2-3 sin rewrite:

1. **Hexagonal strict**: dominio puro (TypeScript, sin imports de Prisma/Drizzle/Express). Application layer con ports; infraestructura implementa adapters.
2. **Naming domain-neutral**: no usar `HabitaNexusContract`, usar `RentalContract` o `Contract`. Sin referencias a "apartment" en domain (usar "property" o "asset").
3. **Ports claros**: cada integración externa detrás de un port. Por ejemplo:
   - `ContractRepository`
   - `NotaryPort` (CR adapter inicial)
   - `OnChainBridgePort` (stub inicial, Cairo adapter futuro)
   - `SignaturePort`
   - `EvidencePort`
   - `JurisdictionRulesPort`
   - `EventBusPort`
4. **Event-sourced** (o al menos append-only audit log) desde día uno. Facilita migración a on-chain donde los eventos son inmutables.
5. **Entity IDs estables**: UUIDs que no dependen del schema de Postgres de HabitaNexus.
6. **Proto-ready**: definir tipos TypeScript alineados con cómo quedarían en proto `.proto` si se expusieran vía gRPC.
7. **Logs estructurados** con `trace_id` + `contract_id` + `party_id` en todas las operaciones.

---

## 6. Arquitectura propuesta

```
habitanexus/apps/backend/src/modules/contracts/         ← ubicación dentro del monorepo
├── domain/                                             ← puro, extraction-ready
│   ├── entities/
│   │   ├── Contract.ts                                 ← entidad raíz
│   │   ├── ContractAmendment.ts
│   │   ├── Evidence.ts
│   │   └── Dispute.ts
│   ├── value-objects/
│   │   ├── ContractTerms.ts                            ← rent, duration, deposit, utilities
│   │   ├── Party.ts                                    ← tenant, landlord, witness
│   │   ├── Signature.ts                                ← digital + timestamp
│   │   ├── Jurisdiction.ts                             ← CR, CO, MX + local code refs
│   │   └── ContractState.ts                            ← discriminated union del state machine
│   ├── services/
│   │   ├── ContractLifecycleService.ts                 ← transitions válidas
│   │   ├── ArbitrationService.ts                       ← mediation → arbitration workflow
│   │   └── JurisdictionValidator.ts                    ← verifica cláusulas vs ley local
│   └── events/
│       ├── ContractDrafted.ts
│       ├── ContractNegotiated.ts
│       ├── ContractSigned.ts
│       ├── ContractActivated.ts
│       ├── AmendmentProposed.ts
│       ├── EvidenceAttached.ts
│       ├── DisputeRaised.ts
│       ├── DisputeResolved.ts
│       └── ContractTerminated.ts
├── application/
│   ├── commands/
│   │   ├── DraftContract.ts
│   │   ├── ProposeAmendment.ts
│   │   ├── SignContract.ts
│   │   ├── AttachEvidence.ts
│   │   ├── RaiseDispute.ts
│   │   ├── ResolveDispute.ts
│   │   └── TerminateContract.ts
│   ├── queries/
│   │   ├── GetContract.ts
│   │   ├── ListContractsByParty.ts
│   │   └── GetContractAuditTrail.ts
│   └── ports/
│       ├── ContractRepository.ts
│       ├── NotaryPort.ts
│       ├── OnChainBridgePort.ts
│       ├── SignaturePort.ts
│       ├── EvidencePort.ts
│       ├── JurisdictionRulesPort.ts
│       ├── EventBusPort.ts
│       └── IdentityVerificationPort.ts                  ← stub hacia futuro compliance-core
├── infrastructure/
│   ├── persistence/
│   │   ├── PostgresContractRepository.ts
│   │   └── migrations/
│   ├── signature/
│   │   └── FirmaCRAdapter.ts                            ← firma digital CR (MICITT)
│   ├── notary/
│   │   └── NotarioDigitalCRAdapter.ts                   ← cuando haya proveedor
│   ├── onchain/
│   │   ├── StarknetBridgeAdapter.ts                     ← futuro, stub en Fase 1
│   │   └── MadaraBridgeAdapter.ts                       ← futuro
│   ├── evidence/
│   │   ├── S3EvidenceAdapter.ts                         ← blobs con checksum
│   │   └── IPFSEvidenceAdapter.ts                       ← futuro para evidencia on-chain
│   └── eventbus/
│       ├── InMemoryEventBus.ts                          ← dev
│       └── NATSEventBus.ts                              ← prod
└── interfaces/
    ├── http/
    │   ├── ContractController.ts                        ← REST para HabitaNexus UI
    │   └── routes.ts
    └── grpc/
        └── placeholder.ts                               ← para futura extracción
```

---

## 7. Domain model detallado

### Contract (root entity)

```ts
type ContractKind = "RENTAL_RESIDENTIAL" | "RENTAL_COMMERCIAL";
type ContractState =
  | { tag: "DRAFTED"; draftedAt: Date; by: PartyId }
  | { tag: "UNDER_NEGOTIATION"; version: number; lastProposalAt: Date }
  | { tag: "SIGNED"; signedAt: Date; signatures: Signature[] }
  | { tag: "ACTIVE"; activatedAt: Date; startsAt: Date; endsAt: Date }
  | { tag: "AMENDMENT_PENDING"; amendmentId: UUID; proposedAt: Date }
  | { tag: "IN_DISPUTE"; disputeId: UUID; raisedAt: Date }
  | { tag: "COMPLETED"; completedAt: Date; settlementRef?: URI }
  | { tag: "TERMINATED"; terminatedAt: Date; reason: TerminationReason };

interface Contract {
  id: UUID;
  kind: ContractKind;
  jurisdiction: Jurisdiction;             // CR / CO / MX + local code
  parties: Party[];                       // exactly 2 signatories + optional witness
  terms: ContractTerms;
  amendments: ContractAmendment[];
  evidenceRefs: URI[];                    // S3/IPFS
  state: ContractState;
  onChainAnchor?: {
    chain: "STARKNET" | "MADARA";
    contractAddress: string;
    txHash: string;
    anchoredAt: Date;
  };
  auditTrail: DomainEvent[];              // event-sourced
  createdAt: Date;
  updatedAt: Date;
}

interface ContractTerms {
  rent: {
    amount: Money;
    currency: "CRC" | "USD" | "COP" | "MXN";
    frequency: "MONTHLY" | "WEEKLY" | "DAILY";
    firstPaymentDue: Date;
  };
  duration: { startsAt: Date; endsAt: Date };
  deposit?: {
    amount: Money;
    heldBy: "ESCROW" | "LANDLORD";        // ESCROW solo en CR
  };
  utilitiesIncluded: UtilityType[];
  houseRules: string;                     // text
  terminationClauses: TerminationClause[];
  additionalClauses: CustomClause[];
}

interface Party {
  id: UUID;
  role: "TENANT" | "LANDLORD" | "PLATFORM_WITNESS" | "GUARANTOR";
  identity: {
    type: "NATIONAL_ID" | "PASSPORT" | "RUT_CO" | "RFC_MX" | "CEDULA_CR";
    value: string;
    country: CountryCode;
  };
  contact: { email: string; phone?: string };
  kycVerificationRef?: URI;               // stub inicial; compliance-core después
}

interface Signature {
  partyId: UUID;
  signedAt: Date;
  method: "FIRMA_DIGITAL_CR" | "ELECTRONIC_SIMPLE" | "NOTARIZED" | "ON_CHAIN_SIG";
  signatureData: string;                  // base64 o hash
  ipAddress?: string;
  geoLocation?: { lat: number; lng: number };
  deviceFingerprint?: string;
}

interface ContractAmendment {
  id: UUID;
  proposedBy: UUID;                       // partyId
  proposedAt: Date;
  changes: JSONPatch[];                   // RFC 6902
  status: "PROPOSED" | "ACCEPTED" | "REJECTED" | "COUNTERED";
  counterAmendmentId?: UUID;
}

interface Evidence {
  id: UUID;
  contractId: UUID;
  kind: "PHOTO" | "VIDEO" | "DOCUMENT" | "INSPECTION_REPORT" | "INCIDENT_LOG";
  uri: URI;                               // S3 hoy, IPFS eventual
  sha256: string;                         // checksum inmutable
  capturedAt: Date;
  capturedBy: UUID;                       // partyId
  geoLocation?: { lat: number; lng: number };
  metadata: Record<string, string>;
}

interface Dispute {
  id: UUID;
  contractId: UUID;
  raisedBy: UUID;
  raisedAt: Date;
  category: DisputeCategory;              // NON_PAYMENT | DAMAGE | EARLY_TERMINATION | ...
  description: string;
  evidenceRefs: URI[];
  stage: "MEDIATION" | "ARBITRATION" | "JUDICIAL_ESCALATED" | "RESOLVED";
  resolution?: {
    resolvedAt: Date;
    decision: string;
    arbiterId?: UUID;
    settlementAmount?: Money;
  };
}
```

### State machine transitions (enforced por `ContractLifecycleService`)

```
DRAFTED
  → UNDER_NEGOTIATION   (counterparty propone cambios)
  → SIGNED              (ambas partes firman sin cambios)

UNDER_NEGOTIATION
  → UNDER_NEGOTIATION   (nueva contra-oferta)
  → SIGNED              (acuerdo alcanzado + firmas)
  → TERMINATED          (abandono de negociación)

SIGNED
  → ACTIVE              (fecha startsAt alcanzada)

ACTIVE
  → AMENDMENT_PENDING   (alguna parte propone enmienda)
  → IN_DISPUTE          (alguna parte levanta disputa)
  → COMPLETED           (fecha endsAt alcanzada sin disputa)
  → TERMINATED          (terminación anticipada acordada o judicial)

AMENDMENT_PENDING
  → ACTIVE              (enmienda aceptada o rechazada)

IN_DISPUTE
  → ACTIVE              (disputa resuelta, contrato continúa)
  → TERMINATED          (disputa termina contrato)
  → COMPLETED           (disputa resuelta después de fin natural)

COMPLETED | TERMINATED → (terminal)
```

Transiciones inválidas deben lanzar `InvalidContractStateTransition` error.

---

## 8. Jurisdiction awareness

Cada jurisdicción tiene reglas distintas. `JurisdictionValidator` debe validar al firmar:

### Costa Rica (CR)

- **Ley 7527 de Arrendamientos Urbanos y Suburbanos**.
- Contrato mínimo 3 años en residencial (inquilino puede terminar antes; arrendador no sin causa).
- Depósito garantía **máximo 1 mes** de renta.
- Aumento anual **máximo IPC**.
- Escrow viable (con compliance-core + Ley 8204 cuando aplique).
- Firma: **Firma Digital CR (MICITT)** como opción no-notarial, o notario autenticado.

### Colombia (CO)

- **Ley 820 de 2003** de arrendamiento de vivienda urbana.
- Contrato puede ser verbal o escrito (escrito fuertemente recomendado).
- Depósito garantía **prohibido**; solo garantías alternativas (codeudor, póliza de cumplimiento).
- Aumento anual **máximo IPC del año anterior**.
- Sin escrow nativo; HabitaNexus opera solo digital-contract + retención DIAN.
- Firma: electrónica aceptada con Ley 527 de 1999.

### México (MX)

- **Código Civil Federal art. 2398+** + códigos civiles estatales (CDMX, Jalisco, QR, etc. tienen reglas propias).
- Plazos mínimos y máximos varían por estado (CDMX: 1 año mínimo residencial).
- Depósito garantía típicamente 1 mes (CDMX); varía.
- Aumento regulado por inflación en algunos estados.
- Sin escrow; HabitaNexus opera solo digital-contract + retención SAT (art. 18-D).
- Firma: **e.firma SAT** o electrónica simple con NOM-151-SCFI-2016.

### Cómo modelarlo

`JurisdictionRulesPort` provee:

```ts
interface JurisdictionRule {
  jurisdiction: Jurisdiction;
  validateTerms(terms: ContractTerms): ValidationResult;
  validateDeposit(deposit: Deposit | undefined): ValidationResult;
  minimumDurationResidential: Duration;
  maxAllowedAnnualIncrease: (cpiIndex: number) => number;
  requiresNotary: (kind: ContractKind) => boolean;
  acceptedSignatureMethods: SignatureMethod[];
}
```

Implementación inicial: `CRArrendamientoRule`, `COLey820Rule`, `MXCodigoCivilFederalRule`. Estados mexicanos se añaden como overrides cuando relevante.

---

## 9. Bridge off-chain ↔ on-chain (Starknet/Madara)

### Principio

En Fase 1 NO se escribe nada en blockchain. Se diseña event-sourced con posibilidad futura de **anchor** cada evento on-chain.

### `OnChainBridgePort`

```ts
interface OnChainBridgePort {
  isEnabled(): boolean;                          // feature flag
  anchorEvent(event: DomainEvent): Promise<OnChainReceipt>;
  deployContract(contract: Contract): Promise<ContractAddress>;
  syncContractState(contractId: UUID): Promise<OnChainState>;
  listenToOnChainEvents(contractAddress: string, callback: Handler): Unsubscribe;
}
```

Adapter Fase 1: `NullBridgeAdapter` — acepta todo y no hace nada. Loggea que está en modo off-chain.

Adapter Fase 3-4: `StarknetBridgeAdapter` usa `starknet.js` o similar; despliega contrato Cairo por cada Contract; cada evento domain → tx on-chain.

### Starknet/Madara primitives a aprovechar

- **Native Account Abstraction**: cada party firma con su propia cuenta AA sin wallet tradicional; la plataforma puede actuar como paymaster. Referencia: https://www.starknet.io/blog/account-abstraction/native-account-abstraction/
- **Paymaster**: HabitaNexus paga gas por nómadas (UX Web2). Referencia: https://www.starknet.io/blog/paymaster-the-secret-to-making-dapps-feel-like-web2/
- **Cairo contracts**: rental agreement.cairo con estado, parties, eventos. Referencia: https://www.starknet.io/cairo-book/ch101-00-building-starknet-smart-contracts.html
- **Madara appchain propia**: HabitaNexus puede desplegar su propia chain con reglas específicas. `marketplace-core` ya tiene `appchain/contracts/supply_chain.cairo` como referencia de cómo se estructura.

### Cairo contract esqueleto (Fase 3-4)

```cairo
// rental_agreement.cairo
#[starknet::contract]
mod RentalAgreement {
    #[storage]
    struct Storage {
        contract_id: felt252,
        tenant: ContractAddress,
        landlord: ContractAddress,
        platform_witness: ContractAddress,
        terms_hash: felt252,              // hash de ContractTerms off-chain
        state: u8,                        // enum ContractState
        signed_at: u64,
        evidence_anchors: LegacyMap<u32, felt252>,  // idx → IPFS CID
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        ContractSigned: ContractSigned,
        AmendmentProposed: AmendmentProposed,
        EvidenceAttached: EvidenceAttached,
        DisputeRaised: DisputeRaised,
        ContractTerminated: ContractTerminated,
    }

    // ... funciones sign, propose_amendment, attach_evidence, raise_dispute, etc.
}
```

---

## 10. Integración con otros `-core`

### marketplace-core

- HabitaNexus lista propiedades en marketplace-core (ProductRepository).
- Al aceptar una reserva, se instancia un Contract en contracts module (interno HabitaNexus).
- marketplace-core emite `ProductReserved` event → contracts module escucha → crea Contract en estado DRAFTED.

### invoice-core (próximo)

- Contracts module emite eventos:
  - `ContractSigned` → invoice-core emite factura anticipo (si aplica).
  - `ContractActivated` → invoice-core emite factura mes 1.
  - Pagos mensuales recurrentes → invoice-core emite factura periódica.
  - MX/CO: al recibir pago de nómada → invoice-core emite **Constancia de Retención** al anfitrión (art. 18-D / Dec. 1091).
- Contracts module **NO emite facturas directamente**. Invoice-core es dueño de eso.

### compliance-core (futuro)

- `IdentityVerificationPort` en contracts module es **stub** en Fase 1.
- Cuando compliance-core exista, implementar adapter `ComplianceCoreAdapter` que consume gRPC de compliance-core.
- En Fase 1: adapter stub retorna `verified: true` con warning log que esto es mock.

### agentic-core

- No integración directa day 1.
- Futuro: agentes de arbitraje asistido ("AI mediator" basado en agentic-core) para disputas menores.

---

## 11. Notarización CR

Costa Rica permite contratos de alquiler **sin notarización obligatoria** (Firma Digital MICITT es suficiente para residencial). Notarización se usa solo cuando:

- El arrendador lo exige.
- El monto mensual > 5 salarios base (para protección adicional).
- Es contrato comercial con condiciones no estándar.

`NotaryPort` soporta:

```ts
interface NotaryPort {
  isRequired(contract: Contract): boolean;
  requestNotarization(contract: Contract): Promise<NotarizationRequest>;
  pollNotarizationStatus(requestId: UUID): Promise<NotarizationStatus>;
  fetchNotarizedDocument(requestId: UUID): Promise<URI>;
}
```

Adapter Fase 1: manual. Genera PDF del contrato, sube a S3, marca como "pending manual notarization" — un operador humano coordina fuera del sistema. Futuro: integración con notarios digitales CR (cuando existan proveedores consolidados).

---

## 12. Evidencia y arbitraje

### Evidence collection

- Inquilino sube fotos check-in (móvil → app → S3).
- Arrendador sube inventario (app → S3).
- Ambos firman recibo digital del estado del inmueble.
- Durante la estadía: cualquier parte puede subir evidencia de incidente (goteras, daños, ruido, etc.).
- Al check-out: fotos comparativas. Discrepancias → posible `Dispute`.

Todas las evidencias con:
- SHA-256 checksum inmutable.
- Timestamp firmado digitalmente.
- Geo-location opcional (si el móvil lo permite).
- Device fingerprint.

### Arbitration workflow

```
Dispute raised
  ↓
MEDIATION (automated)
  - Sistema recolecta argumentos de ambas partes (plazo 48h)
  - Sistema muestra evidencia relevante
  - Sistema sugiere settlement (reglas + AI asistido futuro)
  ↓ (si ambas partes aceptan)
RESOLVED (settlement automático)
  ↓ (si alguna parte rechaza)
ARBITRATION (human or AI arbiter)
  - Árbitro designado por la plataforma (humano en Fase 1)
  - Plazo 7 días para decisión vinculante
  ↓ (si decisión es respetada)
RESOLVED
  ↓ (si alguna parte no respeta decisión)
JUDICIAL_ESCALATED
  - Plataforma entrega expediente completo (con firma digital y hashes on-chain cuando esté migrado)
  - Fuera del scope de contract-core
```

---

## 13. Anti-patterns a evitar

1. **NO hardcodear HabitaNexus-specific en domain**. Usar "rental", "property", "tenant" — no "apartment nomad user".
2. **NO mezclar pagos con contrato**. El evento `ContractSigned` NO llama al procesador de pagos. Invoice-core o payments module reaccionan al evento.
3. **NO validar jurisdicción en domain**. Validación en `JurisdictionValidator` como servicio dedicado; domain entities son agnósticos.
4. **NO acoplarse a Postgres**. Usar `ContractRepository` port; el adapter concreto (Postgres con Drizzle/Prisma) vive en infrastructure. Al extraer a sidecar, se puede cambiar a otro backend sin tocar domain.
5. **NO asumir Starknet desde día uno**. Fase 1 es 100% off-chain con `NullBridgeAdapter`. On-chain llega en Fase 3-4 cuando HabitaNexus valide tracción.
6. **NO escribir tests solo en HTTP/REST**. Tests unitarios en domain + application deben pasar sin levantar servidor. Tests integration contra Postgres real. Tests contract para ports (permiten swap de adapters).

---

## 14. Roadmap de implementación

### Fase 1 — MVP interno (5-7 semanas dedicadas)

Entregables:

- Domain layer completo con state machine, value objects, events.
- Application layer: commands + queries + ports.
- Infrastructure:
  - `PostgresContractRepository`.
  - `FirmaCRAdapter` para firma digital CR (Firma Digital MICITT).
  - `S3EvidenceAdapter`.
  - `InMemoryEventBus` para desarrollo.
  - `NullBridgeAdapter` (on-chain no habilitado).
  - `NotaryPort` manual.
  - `JurisdictionRule` para CR solamente.
  - Stub `IdentityVerificationPort`.
- HTTP controllers para HabitaNexus web/app.
- Tests: unit domain 95%+, integration contra Postgres, contract tests por port.
- Documentación interna: diagrama ports, ejemplos de uso.

Fin de Fase 1: HabitaNexus CR puede crear, firmar, activar, enmendar y cerrar contratos de alquiler con firma digital.

### Fase 2 — Expansion CO + MX (3-4 semanas)

Entregables:

- `COLey820Rule` + `MXCodigoCivilFederalRule`.
- Override estados mexicanos más relevantes (CDMX, Jalisco, QR).
- Ajuste de `Jurisdiction` value object con códigos locales.
- Sin escrow en CO/MX — validar que `ContractTerms.deposit` con `heldBy: ESCROW` falle validación fuera de CR.
- Tests de cross-border contracts (landlord MX, tenant nómada de cualquier país).

Fin de Fase 2: HabitaNexus opera en CR + CO + MX con reglas locales respetadas.

### Fase 3 — Arbitration + Disputes (3-4 semanas)

Entregables:

- `Dispute` entity completa.
- `ArbitrationService` con workflow mediation → arbitration.
- Dashboard interno para árbitros humanos.
- Integración con evidencia (Dispute puede referenciar Evidence[]).
- Notificaciones (cola de notificaciones interna; no contract-core responsabilidad).

Fin de Fase 3: HabitaNexus maneja disputas end-to-end dentro del sistema.

### Fase 4 — On-chain anchoring (6-8 semanas, depende de tracción)

Entregables:

- `StarknetBridgeAdapter` funcional.
- Cairo contract `rental_agreement.cairo` desplegado en testnet (Sepolia Starknet o Madara local).
- Feature flag `ENABLE_ONCHAIN_ANCHORING` — cuando true, eventos críticos (ContractSigned, AmendmentAccepted, DisputeRaised, ContractTerminated) se anclan on-chain.
- Account Abstraction + Paymaster: nómadas no necesitan ETH; HabitaNexus paga gas.
- Dashboard verificador: cualquier parte puede validar que el contrato off-chain coincide con hash on-chain.

Fin de Fase 4: contrato digital con prueba criptográfica inmutable en Starknet/Madara.

### Fase 5 — Extracción a `contract-core` sidecar (4-6 semanas)

**Gate de activación**: ≥1 startup adicional (Vertivo, AltruPets, AduaNext, Keiko) con caso de uso concreto solicitado.

Entregables:

- Nuevo repo `lapc506/contract-core` (TypeScript, BSL 1.1).
- Proto `contract_core.proto` con services.
- Migración del módulo `contracts/` desde HabitaNexus backend a sidecar.
- HabitaNexus consume vía gRPC — refactor mínimo porque domain ya es extracting-ready.
- Helm chart + observability + docs.
- La(s) startup(s) demandante(s) onboardean al sidecar.

---

## 15. Acceptance criteria por fase

### Fase 1 done cuando

- [ ] 100% de los tests unitarios de domain pasan.
- [ ] 100% de los commands/queries tienen test de integración.
- [ ] Usuario beta puede firmar un contrato CR end-to-end en < 15 minutos desde la app.
- [ ] Firma digital CR se valida correctamente contra certificado MICITT.
- [ ] Evidencia con geo+timestamp+hash se almacena en S3 con retrieval por hash.
- [ ] Audit trail del contrato es reconstructible desde el event log.
- [ ] Intento de transición inválida lanza error estructurado (no crash).
- [ ] Documentación explica: cómo añadir nueva jurisdicción, cómo añadir nuevo tipo de firma, cómo migrar a on-chain.

### Fase 2 done cuando

- [ ] Contrato CO con deposit ESCROW falla validación con mensaje claro.
- [ ] Contrato MX-CDMX valida duración mínima 1 año residencial.
- [ ] Contrato CR-residential con aumento > IPC lanza warning (no error, pero audit log).
- [ ] Tests cross-border pasan (landlord MX, tenant español via pasaporte).

### Fase 3 done cuando

- [ ] Disputa se puede levantar, pasa a mediation, si falla llega a arbitration, y si árbitro decide se aplica.
- [ ] Dashboard de árbitros humanos funcional.
- [ ] Tiempo de resolución mediation < 48h automático.
- [ ] Evidence attachment durante disputa no corrompe estado del contrato.

### Fase 4 done cuando

- [ ] Con feature flag activo, cada `ContractSigned` produce tx en Starknet testnet.
- [ ] Verificador puede consultar el hash on-chain y comparar con contrato off-chain.
- [ ] AA + Paymaster: nómada nuevo sin wallet puede firmar sin pagar gas.
- [ ] Apagar el flag no rompe contratos pre-existentes.

### Fase 5 (extracción) done cuando

- [ ] `contract-core` sidecar responde a proto de HabitaNexus backend idénticamente al módulo interno anterior.
- [ ] Migración de contratos existentes sin downtime.
- [ ] ≥1 startup adicional integrada en sandbox.

---

## 16. Riesgos y mitigaciones

| Riesgo | Probabilidad | Impacto | Mitigación |
|---|:---:|:---:|---|
| Firma digital CR (Firma Digital MICITT) tiene downtime | Media | Alto | Fallback a firma electrónica simple + notarización manual posterior |
| Jurisdicciones tienen reglas más complejas de lo modelado | Alta | Medio | `JurisdictionRule` extensible; documentar gaps y pedir revisión legal antes de producción por país |
| On-chain anchoring costa más de lo esperado | Media | Bajo | Paymaster + batch anchoring; Madara propia es más barato que Starknet L1 |
| Disputes escalan a judicial y faltan requisitos probatorios | Media | Alto | Evidence con hashes + timestamps + geo debe ser admisible; consultar abogado CR/CO/MX |
| Extracción a sidecar encuentra acoplamiento oculto | Baja | Medio | Code review estricto contra checklist de extraction-readiness (§5) en cada PR |
| Usuario nómada no entiende Firma Digital | Alta | Medio | Fallback a OTP + foto de ID para electronic simple; educación in-app |

---

## 17. Referencias

### Arquitectónicas

- Explicit Architecture — Herbert Graca: https://herbertograca.com/2017/11/16/explicit-architecture-01-ddd-hexagonal-onion-clean-cqrs-how-i-put-it-all-together/
- Hexagonal Architecture — Alistair Cockburn.
- Event Sourcing — Martin Fowler.

### Starknet / Cairo / Madara

- Native Account Abstraction: https://www.starknet.io/blog/account-abstraction/native-account-abstraction/
- Paymaster: Web2 feel: https://www.starknet.io/blog/paymaster-the-secret-to-making-dapps-feel-like-web2/
- Paymaster video: https://www.starknet.io/blog/paymaster-with-avnu-video/
- Cairo Book: https://www.starknet.io/cairo-book/ch101-00-building-starknet-smart-contracts.html
- Starknet Academy: https://academy.starknet.org/course/smart-contracts

### Legal / jurisdicciones

- CR — Ley 7527 de Arrendamientos Urbanos y Suburbanos (1995).
- CR — Firma Digital: https://www.firmadigital.go.cr/
- CO — Ley 820 de 2003.
- CO — Ley 527 de 1999 (firma electrónica).
- MX — Código Civil Federal art. 2398+.
- MX — NOM-151-SCFI-2016 (conservación de mensajes de datos).

### Codebase relevante

- `/home/kvttvrsis/Documentos/GitHub/habitanexus/` — este repo.
- `/home/kvttvrsis/Documentos/GitHub/marketplace-core/appchain/contracts/` — base Cairo para cadena de custodia (reusable patterns).
- `/home/kvttvrsis/Documentos/GitHub/agentic-core/` — patrones de arquitectura + observability + deployment.

### Documentos relacionados (escritorio del autor)

- `/home/kvttvrsis/Escritorio/2026-04-16-invoice-core-plan.md` — complementario, invoice-core es downstream consumer de eventos.
- `/home/kvttvrsis/Escritorio/2026-04-16-core-governance-rubric.md` — explica por qué contract-core NO es sidecar hoy.
- `/home/kvttvrsis/Escritorio/2026-04-16-invoice-core-hallazgos.md` — contexto del ecosistema.
- `/home/kvttvrsis/Escritorio/lapc506-personal-dogfood/liability-contagion-analysis.md` — análisis de estructura legal portfolio.

### Spikes previos en este repo

- `01-postmortem-kleberty.md`
- `02-oportunidad-b2g-municipalidades.md`
- `03-inventario-arcgis-municipalidades.md`
- `04-cruce-datos-altrupets.md`
- `05-plan-regulador-pitch.md`

---

## 18. Notas para la sesión de implementación

**Cuando retomes esto**:

1. Lee este documento completo antes de hacer cualquier cosa.
2. Revisa el repo HabitaNexus actual (`apps/`, `packages/`) para entender dónde vive el backend y cómo están organizados otros módulos.
3. Confirma con @lapc506 la Fase actual antes de comenzar.
4. Empieza por **domain layer** (puro TypeScript, cero imports de infraestructura).
5. Tests siempre primero — TDD es la regla en el ecosistema del autor.
6. Al completar cada fase, el autor revisa y da gate para la siguiente.

**Preguntas abiertas que probablemente emerjan y requieren consulta al autor**:

- ¿Qué ORM/DB layer se usa en HabitaNexus backend? (Prisma, Drizzle, TypeORM, raw pg)?
- ¿Qué framework HTTP? (Fastify, Express, Hono, NestJS)?
- ¿Ya hay event bus interno en HabitaNexus o se crea con este módulo?
- ¿S3 o MinIO en dev? ¿IPFS para evidencia desde v1 o solo post-Fase 4?
- ¿Qué notario digital proveedor se prioriza en CR?
- ¿Firma Digital MICITT: implementación propia o librería pre-existente?

Esas preguntas no tienen respuesta definitiva en el mega-prompt — son específicas del estado actual de HabitaNexus que cambia entre sesiones.

---

## 19. Cambios a este documento

- Si la rúbrica del ecosistema cambia y contract-core se aprueba como sidecar, actualizar §2 y mover Fase 5 al inicio.
- Si alguna jurisdicción cambia (reforma legal), actualizar §8.
- Si Starknet/Madara se descontinúa o el autor cambia de stack on-chain, actualizar §9 y §17.
- Mantener `Fecha` al inicio como "última actualización significativa".
