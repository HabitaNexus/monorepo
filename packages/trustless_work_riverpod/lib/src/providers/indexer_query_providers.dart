import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trustless_work_dart/trustless_work_dart.dart';

import 'trustless_work_client_provider.dart';

/// Parameter type for [escrowsByRoleProvider].
typedef EscrowsByRoleParams = ({IndexerRole role, String user});

/// Lists escrows where [role] is held by address [user].
///
/// ```dart
/// final result = ref.watch(
///   escrowsByRoleProvider((role: IndexerRole.approver, user: myKey)),
/// );
/// ```
final escrowsByRoleProvider =
    FutureProvider.family<GetEscrowsFromIndexerResponse, EscrowsByRoleParams>(
  (ref, params) => ref
      .watch(trustlessWorkClientProvider)
      .getEscrowsFromIndexerByRole(role: params.role, user: params.user),
);

/// Lists escrows where [signer] acted as ANY signer on the contract.
///
/// ```dart
/// final result = ref.watch(escrowsBySignerProvider('GABC...'));
/// ```
final escrowsBySignerProvider =
    FutureProvider.family<GetEscrowsFromIndexerResponse, String>(
  (ref, signer) => ref
      .watch(trustlessWorkClientProvider)
      .getEscrowsFromIndexerBySigner(signer),
);

/// Parameter type for [escrowsByContractIdsProvider].
typedef EscrowsByContractIdsParams = ({
  List<String> contractIds,
  bool validateOnChain,
});

/// Batch-fetches escrows by contract id.
///
/// Note: Dart records use structural equality, but the nested
/// `List<String>` uses reference equality. Two calls with identical
/// list *contents* but different list *instances* create separate
/// provider instances. Hold a single list reference if deduplication
/// matters.
///
/// ```dart
/// final result = ref.watch(
///   escrowsByContractIdsProvider(
///     (contractIds: ['CABC', 'CDEF'], validateOnChain: false),
///   ),
/// );
/// ```
final escrowsByContractIdsProvider = FutureProvider.family<
    GetEscrowsFromIndexerResponse, EscrowsByContractIdsParams>(
  (ref, params) =>
      ref.watch(trustlessWorkClientProvider).getEscrowFromIndexerByContractIds(
            params.contractIds,
            validateOnChain: params.validateOnChain,
          ),
);

/// Batch-fetches USDC balances for a list of escrow contract addresses.
///
/// Note: `List<String>` uses reference equality by default. Two calls
/// with identical list *contents* but different list *instances* create
/// separate provider instances. If deduplication matters, sort and
/// reuse a single list reference.
///
/// ```dart
/// final result = ref.watch(escrowBalancesProvider(['CABC', 'CDEF']));
/// ```
final escrowBalancesProvider =
    FutureProvider.family<GetEscrowBalancesResponse, List<String>>(
  (ref, addresses) => ref
      .watch(trustlessWorkClientProvider)
      .getMultipleEscrowBalances(addresses),
);
