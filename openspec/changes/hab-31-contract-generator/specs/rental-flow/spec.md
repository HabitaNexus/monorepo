# Spec Delta

## MODIFIED Requirements

### Requirement: Contract Generation and Digital Signature

The system SHALL auto-generate contracts compliant with Ley 7527 (21 mandatory clauses) and support digital signature with SHA-256 hash.

#### Scenario: Contract auto-generation
- **GIVEN** a negotiation in `PENDIENTE_FIRMA` state
- **WHEN** the system generates the contract
- **THEN** a PDF with all 21 mandatory clauses is created
- **AND** the contract hash (SHA-256) is stored
- **AND** the negotiation remains in `PENDIENTE_FIRMA`

#### Scenario: Digital signature
- **GIVEN** a generated contract in `PENDIENTE_FIRMA` state
- **WHEN** both parties sign the contract
- **THEN** the contract status changes to `FIRMADO`
- **AND** the escrow is activated via Trustless Worker
