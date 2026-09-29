/// Implementación del repositorio contra el backend HAB-26.
library;

import '../domain/negotiation.dart';
import '../domain/negotiation_repository.dart';
import 'models/negotiation_models.dart';
import 'negotiation_api_client.dart';

class NegotiationRepositoryImpl implements NegotiationRepository {
  final NegotiationApiClient _client;

  NegotiationRepositoryImpl(this._client);

  @override
  Future<NegotiationDetail> fetch(String id) async {
    try {
      return _toDetail(await _client.fetch(id));
    } on NegotiationApiException catch (e) {
      throw NegotiationException(e.message);
    }
  }

  @override
  Future<NegotiationDetail> propose({
    required String listingId,
    required String tenantId,
    required String ownerId,
    required Map<String, Object?> terms,
    required String actor,
  }) async {
    try {
      return _toDetail(await _client.propose(
        listingId: listingId,
        tenantId: tenantId,
        ownerId: ownerId,
        terms: terms,
        actor: actor,
      ));
    } on NegotiationApiException catch (e) {
      throw NegotiationException(e.message);
    }
  }

  @override
  Future<NegotiationDetail> counter({
    required String id,
    required Map<String, Object?> terms,
    required String actor,
  }) async {
    try {
      return _toDetail(await _client.counter(
        id: id,
        terms: terms,
        actor: actor,
      ));
    } on NegotiationApiException catch (e) {
      throw NegotiationException(e.message);
    }
  }

  @override
  Future<NegotiationDetail> accept({
    required String id,
    required String actor,
  }) async {
    try {
      return _toDetail(await _client.accept(id: id, actor: actor));
    } on NegotiationApiException catch (e) {
      throw NegotiationException(e.message);
    }
  }

  @override
  Future<NegotiationDetail> reject({
    required String id,
    required String reason,
    required String actor,
  }) async {
    try {
      return _toDetail(
          await _client.reject(id: id, reason: reason, actor: actor));
    } on NegotiationApiException catch (e) {
      throw NegotiationException(e.message);
    }
  }

  @override
  Future<NegotiationDetail> confirmSummary({
    required String id,
    required NegotiationParty party,
    required String actor,
  }) async {
    try {
      return _toDetail(await _client.confirmSummary(
        id: id,
        party: negotiationPartyToApi(party),
        actor: actor,
      ));
    } on NegotiationApiException catch (e) {
      throw NegotiationException(e.message);
    }
  }

  /// Mapea el DTO del servidor al agregado de dominio.
  ///
  /// El `GET` devuelve un único documento vigente (`terms`): ese es el lado
  /// "Contrapropuesta". El lado base se inicializa con el mismo documento
  /// (todo ACUERDO) y el controlador lo reemplaza con el resumen confirmado
  /// o con el snapshot previo a una contrapropuesta local.
  NegotiationDetail _toDetail(NegotiationDto dto) {
    final current = _stringTerms(dto.terms?['terms']);
    final summary = dto.summary == null
        ? null
        : _stringTerms(dto.summary!['terms']);
    DateTime deadline;
    try {
      deadline = DateTime.parse(dto.state.deadline);
    } catch (_) {
      deadline = DateTime.now().add(const Duration(hours: 72));
    }
    return NegotiationDetail(
      id: dto.id,
      listingId: dto.listingId,
      tenantId: dto.tenantId,
      ownerId: dto.ownerId,
      state: NegotiationState(
        status: negotiationStatusFromApi(dto.state.status),
        round: dto.state.round,
        deadline: deadline,
        tenantConfirmed: dto.state.tenantConfirmed ?? false,
        ownerConfirmed: dto.state.ownerConfirmed ?? false,
        reason: dto.state.reason,
      ),
      baseTerms: summary ?? Map<String, String>.from(current),
      currentTerms: current,
      summaryTerms: summary,
      fromBackend: true,
    );
  }

  Map<String, String> _stringTerms(Object? raw) {
    if (raw is! Map) return {};
    return raw.map((k, v) => MapEntry(k.toString(), v?.toString() ?? ''));
  }
}

/// Fábrica con el baseUrl por defecto (http://localhost:3000).
NegotiationRepositoryImpl createNegotiationRepository({String? baseUrl}) {
  return NegotiationRepositoryImpl(
    NegotiationApiClient(baseUrl: baseUrl ?? 'http://localhost:3000'),
  );
}
