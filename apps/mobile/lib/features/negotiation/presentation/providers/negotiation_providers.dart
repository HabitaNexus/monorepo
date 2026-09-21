/// Providers de la negociación (HAB-27) con flutter_riverpod.
///
/// Hand-written (sin `riverpod_generator`): el runner del repo
/// (analyzer 7.6.0) no soporta el SDK Dart 3.13
/// (`visitDotShorthandPropertyAccess`) y el upgrade de dependencias queda
/// fuera del alcance; se sigue el patrón de
/// `coworking_nearby_provider.dart`. Migrar a `@riverpod` tras el upgrade.
///
/// La UI nunca decide estado: la habilitación de acciones se deriva del
/// `state` del servidor (`status`, `round`, `deadline`). El provider de rol
/// demo (TENANT/OWNER) solo cambia el punto de vista y el `actor`/`party`
/// enviados al backend.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/demo_negotiation.dart';
import '../../data/negotiation_api_client.dart';
import '../../data/negotiation_repository_impl.dart';
import '../../data/terms_mapping.dart';
import '../../domain/negotiation.dart';
import '../../domain/negotiation_repository.dart';
import '../../domain/negotiation_rules.dart';

/// Especificaciones de fila para comparar (derivadas de la tabla de mapeo).
List<RowSpec> rowSpecs() => kTermsMapping
    .map((m) => RowSpec(
        number: m.number,
        apiKey: m.apiKey,
        lenient: DemoNegotiation.lenientRows.contains(m.number)))
    .toList();

/// Cliente HTTP (baseUrl configurable, default http://localhost:3000).
final negotiationApiClientProvider =
    Provider<NegotiationApiClient>((ref) => NegotiationApiClient());

final negotiationRepositoryProvider =
    Provider<NegotiationRepository>((ref) => NegotiationRepositoryImpl(
        ref.read(negotiationApiClientProvider)));

/// Rol demo conmutable para probar ambas caras (TENANT/OWNER) — solo debug.
final demoRoleProvider =
    StateProvider<NegotiationParty>((ref) => NegotiationParty.tenant);

/// Rol derivado del login — en prod viene del auth (JWT / SharedPreferences).
/// Si no hay sesión, default TENANT y UI muestra prompt para iniciar sesión.
final authRoleProvider = Provider<NegotiationParty>((ref) {
  // En debug, respeta el toggle demo para probar ambas caras.
  // En release, vendrá de authProvider; por ahora fallback a tenant.
  // TODO: cablear a authProvider cuando exista (ej. ref.watch(authProvider).role)
  return ref.watch(demoRoleProvider);
});

/// Filtro del comparador (Todos / Solo Diff / Acuerdo).
final termFilterProvider =
    StateProvider<TermFilter>((ref) => TermFilter.all);

/// Controlador del detalle: carga demo o backend y ejecuta las mutaciones
/// contra HAB-26. `negotiationId == null` → modo demo sin backend.
final negotiationControllerProvider = StateNotifierProvider.family<
    NegotiationController,
    AsyncValue<NegotiationDetail>,
    String?>((ref, negotiationId) {
  final controller = NegotiationController(ref, negotiationId);
  controller.refresh();
  return controller;
});

class NegotiationController
    extends StateNotifier<AsyncValue<NegotiationDetail>> {
  final Ref _ref;
  final String? _negotiationId;

  NegotiationController(this._ref, this._negotiationId)
      : super(const AsyncLoading());

  String _actor() {
    final role = _ref.read(authRoleProvider);
    return role == NegotiationParty.tenant
        ? 'demo-tenant-app'
        : 'demo-owner-app';
  }

  /// Carga o recarga el detalle (reintento tras error de red).
  Future<void> refresh() async {
    state = const AsyncLoading();
    final id = _negotiationId;
    if (id == null || id.isEmpty) {
      state = AsyncData(DemoNegotiation.detail());
      return;
    }
    state = await AsyncValue.guard(
        () => _ref.read(negotiationRepositoryProvider).fetch(id));
  }

  /// Envía contrapropuesta con los valores editados (número de fila → texto).
  /// En modo demo muta el estado local; con backend usa POST :id/counter.
  Future<void> counter(Map<int, String> editedRows) async {
    final current = state.value;
    if (current == null) return;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final byKey = <String, String>{};
      for (final entry in editedRows.entries) {
        final mapping = kTermsMapping.firstWhere(
          (m) => m.number == entry.key,
          orElse: () =>
              throw NegotiationException('Fila desconocida: ${entry.key}'),
        );
        if (mapping.isFixed) {
          throw const NegotiationException(
              'Las cláusulas fijas SOP son de solo lectura.');
        }
        byKey[mapping.apiKey] = entry.value;
      }
      final role = _ref.read(authRoleProvider);
      final id = _negotiationId;
      if (id == null || id.isEmpty || !current.fromBackend) {
        return _demoCounter(current, byKey, role);
      }
      final repo = _ref.read(negotiationRepositoryProvider);
      final merged = Map<String, Object?>.from(current.currentTerms)
        ..addAll(byKey);
      final updated = await repo.counter(
          id: id, terms: merged, actor: _actor());
      return updated.copyWith(
        baseTerms: Map<String, String>.from(current.currentTerms),
        baseOverrides: {},
        currentOverrides: {},
        lastAuthor: role,
      );
    });
  }

  NegotiationDetail _demoCounter(NegotiationDetail current,
      Map<String, String> byKey, NegotiationParty role) {
    if (current.state.round >= kMaxRounds) {
      return current.copyWith(
        state: NegotiationState(
          status: NegotiationStatus.expirada,
          round: current.state.round,
          deadline: current.state.deadline,
          reason: 'MAX_ROUNDS_REACHED',
        ),
      );
    }
    final next = Map<String, String>.from(current.currentTerms)
      ..addAll(byKey);
    return current.copyWith(
      state: NegotiationState(
        status: NegotiationStatus.contrapropuesta,
        round: current.state.round + 1,
        deadline: DateTime.now().add(DemoNegotiation.demoRemaining),
      ),
      baseTerms: Map<String, String>.from(current.currentTerms),
      currentTerms: next,
      lastAuthor: role,
    );
  }

  /// Acepta los términos vigentes (POST :id/accept).
  Future<void> accept() async {
    final current = state.value;
    if (current == null) return;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final id = _negotiationId;
      if (id == null || id.isEmpty || !current.fromBackend) {
        return current.copyWith(
          state: NegotiationState(
            status: NegotiationStatus.acuerdoAlcanzado,
            round: current.state.round,
            deadline: current.state.deadline,
          ),
          summaryTerms: Map<String, String>.from(current.currentTerms),
        );
      }
      final repo = _ref.read(negotiationRepositoryProvider);
      return repo.accept(id: id, actor: _actor());
    });
  }

  /// Desiste con motivo (POST :id/reject).
  Future<void> reject(String reason) async {
    final current = state.value;
    if (current == null) return;
    if (reason.trim().isEmpty) {
      state = AsyncError(const NegotiationException(
          'El motivo es obligatorio.'), StackTrace.current);
      return;
    }
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final id = _negotiationId;
      if (id == null || id.isEmpty || !current.fromBackend) {
        return current.copyWith(
          state: NegotiationState(
            status: NegotiationStatus.rechazada,
            round: current.state.round,
            deadline: current.state.deadline,
            reason: reason.trim(),
          ),
        );
      }
      final repo = _ref.read(negotiationRepositoryProvider);
      return repo.reject(id: id, reason: reason.trim(), actor: _actor());
    });
  }

  /// Confirma el resumen bilateral (POST :id/confirm-summary).
  Future<void> confirmSummary() async {
    final current = state.value;
    if (current == null) return;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final role = _ref.read(authRoleProvider);
      final id = _negotiationId;
      if (id == null || id.isEmpty || !current.fromBackend) {
        final tenantOk =
            current.state.tenantConfirmed || role == NegotiationParty.tenant;
        final ownerOk =
            current.state.ownerConfirmed || role == NegotiationParty.owner;
        final both = tenantOk && ownerOk;
        return current.copyWith(
          state: NegotiationState(
            status: both
                ? NegotiationStatus.pendienteFirma
                : NegotiationStatus.acuerdoAlcanzado,
            round: current.state.round,
            deadline: current.state.deadline,
            tenantConfirmed: tenantOk,
            ownerConfirmed: ownerOk,
          ),
        );
      }
      final repo = _ref.read(negotiationRepositoryProvider);
      return repo.confirmSummary(id: id, party: role, actor: _actor());
    });
  }
}
