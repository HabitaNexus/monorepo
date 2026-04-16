# Spec — `trustless_work_dart` + `trustless_work_flutter_storage`

**Fecha**: 2026-04-15
**Autor**: Andrés Peña (HabitaNexus / Dojo Coding)
**Estado**: Draft inicial post-brainstorming
**Versión**: 1.0

---

## 1. Contexto

HabitaNexus es un marketplace de alquiler long-term en Costa Rica construido en Flutter. El escrow digital del depósito de garantía es central a la propuesta de valor: evita estafas, supera el límite de SINPE Móvil (¢100k/día), y habilita custodia no-bancaria. La startup está clasificada **🔴 URGENTE** en el análisis de estructura corporativa: no puede operar comercialmente sin entity legal formal + SDK técnico funcional.

El SDK de Trustless Work existe solo en React/TypeScript (`@trustless-work/escrow`). No hay equivalente Dart/Flutter. Sin él, no hay forma limpia de integrar escrows desde la app móvil de HabitaNexus.

**Este spec documenta el diseño del spike que porta el SDK a Dart**, vive inicialmente dentro del monorepo, y eventualmente se extrae como paquete OSS mantenido conjuntamente con Trustless Work bajo Dojo Coding como incubador.

## 2. Goals

- Portar el SDK de Trustless Work al ecosistema Dart con paridad a nivel de **API gateway** y **naming de entidades**, no de surface SDK.
- Mantener el core Dart puro (reusable desde Flutter mobile, Flutter Web, Jaspr, Dart server, CLI).
- Habilitar wallet embebida transparente al usuario final (HabitaNexus abstrae la blockchain).
- Preparar el camino para publicación en pub.dev bajo verified publisher de Trustless Work.
- Desbloquear integración de escrows en `apps/mobile` de HabitaNexus en el menor tiempo posible.

## 3. Non-Goals

- **No** ser un cliente Soroban directo. El SDK habla al gateway de TW, no a Soroban RPC ni Horizon (excepto para firma XDR local vía `stellar_flutter_sdk`).
- **No** replicar 1:1 el surface del SDK React. Los hooks React no tienen análogo idiomático en Dart; se expone funciones puras `Future<T>`.
- **No** gestionar fondos fiat. El SDK NO se encarga de on-ramp ni off-ramp colones↔USDC (ver §9).
- **No** convertir a HabitaNexus en intermediario financiero. La custodia vive on-chain; la app es plataforma de coordinación.
- **No** incluir disputas, multi-release, indexer queries, o update de escrows en v0.1 (ver roadmap §11).
- **No** incluir una UI de wallet visual. La wallet es embebida y transparente.

## 4. Decisiones arquitectónicas

| Decisión | Elección | Razonamiento |
|---|---|---|
| Alcance del spike | Esqueleto en `packages/`, sin publicar a pub.dev aún | Time-flexible; validar arquitectura antes de commitment con TW |
| Capa de integración | Cliente HTTP 1:1 del API gateway de TW | No reimplementar Soroban; reusar abstracción ya auditada |
| Ownership del repo | `packages/` → `github.com/DojoCodingLabs/trustless-work-dart` → pub.dev bajo Trustless Work verified publisher | Iteración local, extracción cuando madura, publicación bajo identidad correcta |
| Naming del paquete core | `trustless_work_dart` | Sufijo `_dart` desambigua para devs que lo importan sin contexto |
| Naming del hermano | `trustless_work_flutter_storage` | Aisla deps Flutter del core Dart puro |
| Arquitectura del signer | `TransactionSigner` interface + `KeyPairSigner` + `CallbackSigner` en el core; `SecureStorageKeyPairSigner` en el hermano | Core reusable desde cualquier contexto Dart |
| Alcance funcional v0.1 | `initializeEscrow` + `fundEscrow` + `getEscrow` + `releaseFunds` + `sendTransaction` helper | Cubre ciclo completo del caso de uso HabitaNexus (single-release) |
| Generación de tipos | Hand-written con `freezed` + `json_serializable` | TW no publica OpenAPI bundle unificado; fragments por endpoint no viables para codegen |
| Licencia | MIT | Matcheo con declaración del SDK React + convención pub.dev |
| Reactividad | `Future<T>` puro + `Stream<EscrowEvent>` `@experimental` (polling) | HabitaNexus urgente; shape del API público estable al reemplazar implementación en v0.2 |

## 5. Arquitectura

### 5.1 Diagrama de capas

```
┌─────────────────────────────────────────────────────────────┐
│  API pública: TrustlessWorkClient                           │
│  initializeEscrow, fundEscrow, getEscrow, releaseFunds,     │
│  escrowEvents (Stream, @experimental)                       │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│  Endpoints (operaciones por dominio)                        │
│  SingleReleaseDeployer, SingleReleaseOperations,            │
│  TransactionHelper, EscrowQueries                           │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│  Transversales                                              │
│  HttpClient (dio/http), TransactionSigner abstraction,      │
│  TrustlessWorkError sealed class, Result<T, E>,             │
│  EscrowEvent sealed class (7 variantes)                     │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│  Modelos (freezed + json_serializable, hand-written)        │
│  Escrow, Milestone, Role, Trustline, Flags, payloads/       │
└─────────────────────────────────────────────────────────────┘
```

### 5.2 Estructura de directorios — `packages/trustless_work_dart/`

```
packages/trustless_work_dart/
├── lib/
│   ├── src/
│   │   ├── client/
│   │   │   ├── trustless_work_client.dart      # API pública principal
│   │   │   ├── trustless_work_config.dart      # baseUrl, apiKey, network
│   │   │   └── http_client.dart                # wrapper sobre dio o http
│   │   ├── signer/
│   │   │   ├── transaction_signer.dart         # abstract class
│   │   │   ├── keypair_signer.dart             # wallet embebida con stellar_flutter_sdk
│   │   │   └── callback_signer.dart            # adapter genérico
│   │   ├── endpoints/
│   │   │   ├── deployer.dart                   # POST /deployer/single-release
│   │   │   ├── single_release_operations.dart  # fund, release
│   │   │   ├── helpers.dart                    # POST /helper/send-transaction
│   │   │   └── queries.dart                    # getEscrow — endpoint exacto pendiente de confirmar con TW (ver §13.5)
│   │   ├── models/
│   │   │   ├── escrow.dart                     # freezed
│   │   │   ├── milestone.dart
│   │   │   ├── role.dart
│   │   │   ├── trustline.dart
│   │   │   ├── flags.dart
│   │   │   └── payloads/
│   │   │       ├── single_release_contract.dart
│   │   │       ├── fund_escrow_payload.dart
│   │   │       └── release_funds_payload.dart
│   │   ├── events/
│   │   │   ├── escrow_event.dart               # sealed class, 7 variantes
│   │   │   └── polling_event_stream.dart       # @experimental
│   │   └── errors/
│   │       ├── trustless_work_error.dart       # sealed class
│   │       └── result.dart                     # Result<T, E> idiomático
│   └── trustless_work_dart.dart                # barrel export
├── test/
│   ├── client_test.dart
│   ├── signer/
│   ├── endpoints/
│   └── integration/
│       └── testnet_e2e_test.dart               # end-to-end real testnet
├── example/
│   └── simple_escrow.dart                      # crear → fondear → consultar → liberar
├── pubspec.yaml
├── analysis_options.yaml
├── README.md                                    # incluye "Qué ES y qué NO ES"
├── CHANGELOG.md
└── LICENSE                                      # MIT
```

### 5.3 Estructura de directorios — `packages/trustless_work_flutter_storage/`

```
packages/trustless_work_flutter_storage/
├── lib/
│   ├── src/
│   │   └── secure_storage_keypair_signer.dart  # wallet embebida persistente
│   └── trustless_work_flutter_storage.dart     # barrel export
├── test/
├── example/
├── pubspec.yaml                                # deps: trustless_work_dart + flutter_secure_storage
├── README.md
├── CHANGELOG.md
└── LICENSE                                     # MIT
```

## 6. Módulos detallados

### 6.1 `TrustlessWorkClient`

API pública principal. Puntos de entrada para todos los flujos.

```dart
class TrustlessWorkClient {
  TrustlessWorkClient({
    required TrustlessWorkConfig config,
    required TransactionSigner signer,
    HttpClient? httpClient,
  });

  Future<Escrow> initializeEscrow(SingleReleaseContract contract);
  Future<Escrow> fundEscrow(FundEscrowPayload payload);
  Future<Escrow> getEscrow(String contractId);
  Future<Escrow> releaseFunds(ReleaseFundsPayload payload);

  @experimental
  Stream<EscrowEvent> escrowEvents(String contractId, {Duration pollInterval = const Duration(seconds: 15)});
}
```

### 6.2 `TransactionSigner`

Abstracción del signing. Delega firma a implementación concreta.

```dart
abstract class TransactionSigner {
  Future<String> signXdr(String unsignedXdr);
  String get publicKey;
}

class KeyPairSigner implements TransactionSigner {
  KeyPairSigner(this._keyPair, {required Network network});
  final KeyPair _keyPair;
  final Network _network;
  // implementación con stellar_flutter_sdk
}

class CallbackSigner implements TransactionSigner {
  CallbackSigner({
    required this.publicKey,
    required Future<String> Function(String unsignedXdr) signFn,
  });
  final Future<String> Function(String) _signFn;
  // delega todo al callback
}
```

### 6.3 `EscrowEvent` (sealed class)

```dart
sealed class EscrowEvent {
  String get contractId;
  DateTime get observedAt;
}

class Initialized extends EscrowEvent { /* ... */ }
class Funded extends EscrowEvent { /* ... */ }
class MilestoneStatusChanged extends EscrowEvent { /* ... */ }
class MilestoneApproved extends EscrowEvent { /* ... */ }
class Released extends EscrowEvent { /* ... */ }
class DisputeStarted extends EscrowEvent { /* ... */ }
class DisputeResolved extends EscrowEvent { /* ... */ }
```

**v0.1**: `MilestoneStatusChanged`, `MilestoneApproved`, `DisputeStarted`, `DisputeResolved` quedan definidos pero no se emiten (milestones y disputas diferidos). API público estable desde el inicio.

### 6.4 `TrustlessWorkError` (sealed class)

```dart
sealed class TrustlessWorkError implements Exception {
  String get message;
}

class BadRequest extends TrustlessWorkError { /* 400 */ }
class Unauthorized extends TrustlessWorkError { /* 401 */ }
class TooManyRequests extends TrustlessWorkError { /* 429 */ }
class ServerError extends TrustlessWorkError { /* 500 con lista de possible errors */ }
class NetworkError extends TrustlessWorkError { /* timeouts, DNS */ }
class SigningError extends TrustlessWorkError { /* error del TransactionSigner */ }
```

### 6.5 `SecureStorageKeyPairSigner` (en el hermano)

```dart
class SecureStorageKeyPairSigner implements TransactionSigner {
  SecureStorageKeyPairSigner({
    required FlutterSecureStorage storage,
    required String storageKey,
    required Network network,
  });

  static Future<SecureStorageKeyPairSigner> generate({ /* ... */ });
  static Future<SecureStorageKeyPairSigner?> load({ /* ... */ });

  Future<void> clear();
  // Encapsula generación, persistencia, recovery
}
```

## 7. Data flow — ejemplo `initializeEscrow` + `fundEscrow`

```
HabitaNexus app                SDK Dart              TW gateway          Stellar
────────────────────           ──────────            ──────────          ───────
  initializeEscrow(contract) ──▶ POST /deployer ──▶
                                                    (valida +
                                                     construye XDR)
                                 {transactionXdr} ◀──
                                 signer.signXdr(xdr)
                                 ──(signing local)──▶
                                 {signedXdr}
                                 POST /helper/send ──▶
                                                     (submits to Soroban) ──▶
                                                                             (deploy)
                                                                              contractId
                                                    ◀── response ────────────
                                 ◀── Escrow ────────
  ◀── Escrow ────────────

  fundEscrow(payload)        ──▶ POST /escrow/single-release/fund ──▶
                                                    (valida +
                                                     construye XDR)
                                 {transactionXdr} ◀──
                                 signer.signXdr(xdr)
                                 POST /helper/send ──▶
                                                     (submits transfer) ──▶
                                                                             (USDC → escrow)
                                                    ◀── confirmed ───────────
                                 ◀── Escrow ────────
  ◀── Escrow funded ──────
```

## 8. Error handling

- Cada endpoint devuelve `Future<Escrow>` en happy path, lanza `TrustlessWorkError` (sealed class) en fallo.
- El consumidor puede hacer pattern matching con `switch` exhaustivo.
- `Result<T, E>` se expone como alternativa opcional para consumidores que prefieran estilo funcional.
- `NetworkError` incluye retry logic opcional configurable (exponential backoff con jitter).
- `ServerError.500` incluye lista de "possible errors" documentada por TW para que consumidor muestre mensaje user-friendly.

## 9. Dependencias externas al SDK

### 9.1 On-ramp colones → USDC

**Patrón**: WebView embebido (`flutter_inappwebview` o `webview_flutter`). No librería Dart. Ver `docs/sop-escrow-deposito-garantia.md`.

Candidato principal: **Onramper**. Pendiente de validar via su API que soporte USDC-Stellar + método de pago CR adecuado (ideal SINPE Móvil).

### 9.2 Kindo (pagos mensuales SINPE)

Vive en `apps/backend/` (NestJS), no en el SDK Dart. Integración B2B bajo contrato con Prosoft CR. HabitaNexus recibe webhooks de confirmación y actualiza el expediente digital. NO custodia fondos fiat.

### 9.3 Fee sponsorship

Stellar fees son ~$0.0000012/op. Abierto: ¿TW absorbe XLM fees vía `FeeBumpTransaction`? ¿Espera que la platform (HabitaNexus) sponsoree? Preguntar a Alberto Chaves. v0.1 no incluye fee-bump; potencialmente v0.2.

## 10. Testing

### 10.1 Unit tests (HTTP mocks)

- HTTP client: **`package:http`** (standard library Dart). Consistente con `stellar_flutter_sdk`, cero deps adicionales.
- Mocks vía `package:http/testing.dart` (`MockClient`).
- Cada endpoint tiene tests de: happy path, bad request, unauthorized, server error, network timeout.
- Signers tests: firma correcta de XDR de testnet, error si XDR malformado.
- `EscrowEvent` polling: emite eventos correctos cuando cambia el estado simulado.

### 10.2 Integration tests (testnet real)

Archivo `test/integration/testnet_e2e_test.dart`:
1. Genera KeyPair con `stellar_flutter_sdk` → fondea vía Friendbot.
2. Crea escrow vía `initializeEscrow` con testnet TW gateway.
3. Fondea escrow con USDC testnet.
4. Consulta `getEscrow` y valida estado.
5. Ejecuta `releaseFunds`.
6. Valida que el balance regresó al receiver.

Gated por `--tags=integration`; no corre en CI default, sí en CI scheduled (diario).

### 10.3 Static analysis

- `dart analyze` sin warnings.
- `dart format --set-exit-if-changed .` pasa.
- `pana` (pub score) baseline: **130/160** al cierre de HAB-57 (spike). Brechas conocidas: falta `example/` (0/10) y dependencias con constraints debajo del último stable (`freezed_annotation ^2.4.4` vs 3.0.0, `stellar_flutter_sdk ^1.9.0` vs 2.0.0 — 0/10), y algunos lints/formato menores surgidos de la versión más nueva del formatter (40/50). Se cierran antes de publish en v0.2.

## 11. Roadmap

**v0.1 (spike)**:
- Alcance funcional descrito en §4.
- Consumible desde `apps/mobile` vía path dependency.
- Integration test testnet pasa.

**v0.2**:
- Reemplazar `PollingEventStream` por implementación híbrida: Horizon SSE (effects classic) + Soroban `getEvents` con cursor (contract events). API público estable.
- `updateEscrow`.
- Milestones: `changeMilestoneStatus`, `approveMilestone`.
- Disputas: `startDispute`, `resolveDispute`.

**v0.3**:
- Multi-release escrows.
- Indexer queries: `getEscrowsFromIndexerByRole`, `getEscrowsFromIndexerBySigner`, `getEscrowFromIndexerByContractIds`.
- Multiple balance queries: `getMultipleEscrowBalances`.

**v0.4+**:
- Migrar tipos a codegen desde OpenAPI bundle (si TW publica).
- Paquetes opcionales: `trustless_work_riverpod`, `trustless_work_bloc`.
- Fee-bump transaction support si TW no lo absorbe upstream.

## 12. Gobernanza

- **Licencia**: MIT (matcheo con declaración del SDK React).
- **Incubación**: repo inicial bajo `github.com/DojoCodingLabs/trustless-work-dart` (Dojo Coding como incubador OSS).
- **Publicación futura**: pub.dev bajo verified publisher de Trustless Work cuando el paquete esté estable y TW acepte co-mantenimiento.
- **HabitaNexus** es la primera consumer y justificación de negocio, no el owner del paquete.

## 13. Dependencias bilaterales con Trustless Work

Ya pedido a Alberto Chaves vía WhatsApp (2026-04-15):

1. **Formalizar `LICENSE` file con MIT** en `Trustless-Work/react-library-trustless-work`. El README lo declara, pero no hay file canónico.
2. **Bundle OpenAPI unificado** vía `@nestjs/swagger` `/api-json`. Nice-to-have para habilitar codegen en v0.4+.

Pendiente de preguntar en call de alineación:

3. **Verified publisher en pub.dev** bajo `Trustless Work`. Aceptación formal vía Slack/email/contrato de colaboración antes de mover el repo a `github.com/Trustless-Work/` o publicar.
4. **Fee sponsorship**: ¿TW absorbe XLM fees vía `FeeBumpTransaction`? ¿Espera que la platform sponsoree?
5. **Endpoint `getEscrow`**: el research mostró endpoints del indexer (`POST /escrows/contracts`, `GET /escrows`) pero no un `GET` directo por `contractId` en el gateway principal. Confirmar cuál es la ruta idiomática para "dame el estado actual de un escrow por contractId" y si requiere el indexer como dependencia separada.

## 14. Verificación de completitud del spec

- [x] Contexto y urgencia claros
- [x] Goals y Non-Goals explícitos
- [x] Arquitectura descrita con diagramas
- [x] Módulos con signatures de API
- [x] Data flow ejemplificado
- [x] Error handling definido
- [x] Dependencias externas identificadas (y cuáles NO resuelve el SDK)
- [x] Testing strategy
- [x] Roadmap incremental
- [x] Gobernanza y licencia

## 15. Archivos a crear después de aprobar el spec

1. `packages/trustless_work_dart/` con la estructura de §5.2.
2. `packages/trustless_work_flutter_storage/` con la estructura de §5.3.
3. Consumir ambos desde `apps/mobile/pubspec.yaml` como path deps.
4. Integration test testnet pasando.

## 16. Referencias

- [`docs/sop-escrow-deposito-garantia.md`](../../sop-escrow-deposito-garantia.md) — SOP de negocio con diagrama Mermaid.
- [`docs/sop-flujo-arrendamiento.md`](../../sop-flujo-arrendamiento.md) — flujo general del arrendamiento.
- [Trustless Work React SDK](https://github.com/Trustless-Work/react-library-trustless-work) — referencia de API.
- [Trustless Work docs](https://docs.trustlesswork.com/trustless-work) — API reference con OpenAPI fragments.
- [`stellar_flutter_sdk`](https://pub.dev/packages/stellar_flutter_sdk) — XDR signing + network primitives.
- `~/Escritorio/lapc506-personal-dogfood/structure-decision.md` — urgencia legal.
- `~/.claude/plans/resilient-marinating-token.md` — plan del spike aprobado.
