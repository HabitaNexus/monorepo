import 'dart:async';
import 'transaction_signer.dart';

typedef SignXdrFn = FutureOr<String> Function(String unsignedXdr);

/// Generic adapter that forwards signing to an arbitrary function.
///
/// Use when the signing happens outside the SDK's control — e.g. deep
/// link to an external wallet, a server-side HSM call, a WalletConnect
/// session, or a platform channel to native code.
class CallbackSigner implements TransactionSigner {
  const CallbackSigner({
    required this.publicKey,
    required SignXdrFn signXdr,
  }) : _signXdr = signXdr;

  @override
  final String publicKey;

  final SignXdrFn _signXdr;

  @override
  FutureOr<String> signXdr(String unsignedXdr) => _signXdr(unsignedXdr);
}
