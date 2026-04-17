## 0.1.0-dev.1

- Initial scaffold: Riverpod providers for Trustless Work escrow operations.
- `trustlessWorkClientProvider` — override with your configured `TrustlessWorkClient`.
- `escrowProvider` / `multiReleaseEscrowProvider` — single-escrow queries.
- `escrowEventsProvider` — reactive event stream.
- Indexer query providers: `escrowsByRoleProvider`, `escrowsBySignerProvider`,
  `escrowsByContractIdsProvider`, `escrowBalancesProvider`.
