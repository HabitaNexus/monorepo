import 'dart:async';

/// Signs unsigned Stellar/Soroban XDR envelopes returned by the Trustless
/// Work API.
///
/// Implementations receive the base64-encoded unsigned XDR, apply the
/// signature(s) required for the caller's role in the escrow, and return
/// the base64-encoded signed XDR ready to be submitted through
/// `POST /helper/send-transaction`.
///
/// The SDK does NOT assume how the signing happens — it may be a local
/// `KeyPair`, a delegate to an external wallet, an HSM, or a backend
/// service. See `KeyPairSigner` and `CallbackSigner` for bundled
/// implementations, or `SecureStorageKeyPairSigner` in
/// `trustless_work_flutter_storage` for persistent on-device wallets.
abstract class TransactionSigner {
  /// The Stellar public key (`G...` address) the signer will use.
  String get publicKey;

  /// Takes a base64-encoded unsigned XDR envelope and returns a base64-
  /// encoded signed XDR envelope.
  ///
  /// Throws [SigningError] if signing fails (invalid XDR, wrong network,
  /// mismatched roles, etc.).
  FutureOr<String> signXdr(String unsignedXdr);
}
