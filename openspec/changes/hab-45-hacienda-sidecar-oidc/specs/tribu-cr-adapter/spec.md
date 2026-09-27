# Spec Delta

## ADDED Requirements

### Requirement: Hacienda sidecar authentication

The hacienda sidecar SHALL obtain an access token from the Ministerio de Hacienda identity provider for the configured environment before any TRIBU-CR operation that requires authorization.

#### Scenario: Successful sandbox handshake

- **WHEN** the sidecar starts with valid sandbox taxpayer credentials
- **THEN** it obtains an access token from the sandbox identity provider
- **AND** an authentication status check reports success

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

The hacienda sidecar SHALL read the taxpayer id type, id number, and identity-provider password from the runtime secret store. It MUST NOT embed those values in source code or in the container image.

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
