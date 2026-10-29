# Spec Delta

## ADDED Requirements

### Requirement: Hacienda sidecar authentication

The hacienda sidecar SHALL obtain an access token from the Ministerio de Hacienda identity provider for the configured environment before any TRIBU-CR operation that requires authorization.

#### Scenario: Successful sandbox handshake

- **WHEN** the sidecar starts with valid sandbox taxpayer credentials
- **THEN** it obtains an access token from the sandbox identity provider
- **AND** an authentication status check reports success

#### Scenario: Issued IDP username

- **WHEN** a full issued IDP username and password are configured
- **THEN** the sidecar passes that username unchanged to the SDK for authentication and re-authentication
- **AND** it preserves hyphens and the environment domain without reconstructing or padding an ID number
- **AND** an explicitly empty or whitespace-bearing username is rejected rather than falling back to an identification-based username

#### Scenario: Rejected credentials

- **WHEN** the identity provider rejects the taxpayer credentials
- **THEN** the sidecar does not expose an access token
- **AND** the authentication status check reports failure

### Requirement: Access token renewal

The hacienda sidecar SHALL renew the access token before it expires, without operator intervention.

#### Scenario: Token near expiry

- **WHEN** the current access token enters its renewal window
- **THEN** the next authorized operation uses a newly issued access token
- **AND** the caller does not supply a replacement token

### Requirement: Credential injection

The hacienda sidecar SHALL read the issued IDP username and identity-provider password from the runtime secret store. When no issued username is configured, it MAY use the legacy taxpayer id type and id number from that store as a compatibility fallback. It MUST NOT embed those values in source code or in the container image.

#### Scenario: Missing password

- **WHEN** the identity-provider password is absent at startup
- **THEN** the sidecar refuses to authenticate
- **AND** it does not fall back to a credential shipped with the image

### Requirement: Environment selection

The hacienda sidecar SHALL send authentication requests only to the identity provider that matches the configured environment, either sandbox or production.

#### Scenario: Sandbox configuration

- **WHEN** the environment is sandbox
- **THEN** authentication requests go to the sandbox identity provider

#### Scenario: Production configuration

- **WHEN** the environment is production
- **THEN** authentication requests go to the production identity provider

### Requirement: Internal token access boundary

The deployed sidecar SHALL restrict inbound TCP 50051 to backend pods in the same namespace through a NetworkPolicy. The cluster MUST enforce NetworkPolicy before real credentials are deployed.

#### Scenario: Unrelated pod requests a token

- **WHEN** a pod outside the allowed backend selector attempts to connect to the sidecar
- **THEN** the ingress policy denies TCP 50051
- **AND** only same-namespace pods labeled `app=backend` are selected as allowed clients

### Requirement: Health watch lifecycle

The sidecar SHALL publish health state transitions to active watchers and close their streams when shutting down.

#### Scenario: Authentication health changes

- **WHEN** authentication becomes unavailable while a health watch is open
- **THEN** the watcher receives `NOT_SERVING`
- **AND** shutdown closes the watch stream without waiting for client cancellation

### Requirement: Diagnostic handshake verdict

The diagnostic script SHALL report success only when all token-response checks pass.

#### Scenario: Invalid successful HTTP response

- **WHEN** the IDP returns HTTP 200 with missing or invalid token metadata
- **THEN** the script exits non-zero and reports `handshake_failed`
- **AND** the CSV records the failed checks without credentials or token values
