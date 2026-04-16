import 'dart:async';

import 'package:stellar_flutter_sdk/stellar_flutter_sdk.dart'
    as stellar;

import '../models/network.dart';
import 'hybrid_event_stream.dart';

/// Default [SorobanEventSource] backed by a real `SorobanServer`.
///
/// Picks the canonical RPC URL for the network unless an override is
/// provided. Dedupe / adaptive cadence live in `HybridEventStream`;
/// this adapter is intentionally thin.
class SorobanRpcEventSource implements SorobanEventSource {
  SorobanRpcEventSource({
    required Network network,
    stellar.SorobanServer? server,
    String? rpcUrl,
  }) : _server = server ??
            stellar.SorobanServer(rpcUrl ?? _defaultRpcUrl(network));

  final stellar.SorobanServer _server;

  static String _defaultRpcUrl(Network network) {
    switch (network) {
      case Network.testnet:
        return 'https://soroban-testnet.stellar.org';
      case Network.mainnet:
        return 'https://mainnet.sorobanrpc.com';
    }
  }

  @override
  Future<SorobanEventPage> fetch({
    required String contractId,
    String? cursor,
  }) async {
    final filter = stellar.EventFilter(
      type: 'contract',
      contractIds: [contractId],
    );
    // When a cursor is supplied, RPC requires startLedger to be
    // omitted. When it isn't, we pass null startLedger and let the
    // RPC use its default (latest ledger window), which is the right
    // behaviour for a fresh subscription.
    final request = stellar.GetEventsRequest(
      cursor == null ? null : null,
      filters: [filter],
      paginationOptions:
          cursor != null ? stellar.PaginationOptions(cursor: cursor) : null,
    );
    final response = await _server.getEvents(request);
    if (response.error != null) {
      throw StateError(
        'getEvents failed: ${response.error!.code} ${response.error!.message}',
      );
    }
    return SorobanEventPage(
      events: response.events ?? const [],
      cursor: response.cursor ?? cursor,
    );
  }
}

/// Default [HorizonEffectsSource] backed by a real `StellarSDK`.
class HorizonSseEffectsSource implements HorizonEffectsSource {
  HorizonSseEffectsSource({
    required Network network,
    stellar.StellarSDK? sdk,
  }) : _sdk = sdk ??
            (network == Network.mainnet
                ? stellar.StellarSDK.PUBLIC
                : stellar.StellarSDK.TESTNET);

  final stellar.StellarSDK _sdk;

  @override
  Stream<stellar.EffectResponse> streamForContractAccount(
    String contractAccount,
  ) {
    return _sdk.effects.forAccount(contractAccount).stream();
  }
}
