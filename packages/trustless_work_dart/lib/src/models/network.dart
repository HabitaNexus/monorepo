/// Which Stellar/Soroban network the SDK is talking to.
///
/// Keep this disjoint from `stellar_flutter_sdk.Network` to avoid leaking
/// the SDK's type into consumers that only want the TW abstraction.
enum Network {
  testnet,
  mainnet;
}
