# Rental Flow Specification

## Purpose

Core digital rental flow for HabitaNexus: 7 phases guiding a property from listing to deposit return. Replaces the informal WhatsApp + paper contract process with a guided, legally compliant flow under Ley 7527, with escrow for deposits and a bidirectional claims system.

**Services affected**: Contract Service, Payment Service, Notification Service, User Service
**Priority**: High (MVP)

---

## Requirements

### Requirement: Property Listing

The system SHALL allow owners to publish properties with mandatory data, video tour, dimensions, and an options catalog.

#### Scenario: Owner publishes a property
- GIVEN an authenticated property owner
- WHEN the owner submits the property listing form with all mandatory fields
- THEN the listing is created with a unique ID
- AND the property appears in search results

#### Scenario: Mandatory fields validation
- GIVEN an owner submitting a property listing
- WHEN required fields (address, price, dimensions, video tour) are missing
- THEN the system rejects the submission with specific field-level errors

### Requirement: Property Discovery

The system SHALL allow tenants to search properties with filters for budget, zone, bedrooms, and pet policy.

#### Scenario: Tenant searches with filters
- GIVEN an active tenant account
- WHEN the tenant applies budget and zone filters
- THEN only matching listings are returned
- AND results are sorted by relevance

### Requirement: Video Tour and Visit Scheduling

The system SHALL require a remote video tour (phase 3.1) as a mandatory pre-filter before scheduling an in-person visit (phase 3.2).

#### Scenario: Video tour before visit
- GIVEN a tenant interested in a property
- WHEN the tenant requests an in-person visit without completing a video tour
- THEN the system blocks the request and prompts for a video tour first

#### Scenario: In-person visit after video tour
- GIVEN a tenant who completed a video tour
- WHEN the tenant requests an in-person visit
- THEN the system creates a visit appointment with the owner

### Requirement: Structured Negotiation

The system SHALL support structured proposals and counter-proposals with up to 34 negotiable terms.

#### Scenario: Tenant submits proposal
- GIVEN a tenant who completed a visit
- WHEN the tenant submits a proposal with negotiable terms
- THEN a Negotiation entity is created in PROPUESTA state

#### Scenario: Owner responds with counter-proposal
- GIVEN a Negotiation in PROPUESTA state
- WHEN the owner submits a counter-proposal
- THEN the state transitions to CONTRAPROPUESTA
- AND both parties are notified

### Requirement: Contract Generation and Digital Signature

The system SHALL auto-generate contracts compliant with Ley 7527 (21 mandatory clauses) and support digital signature with SHA-256 hash.

#### Scenario: Contract auto-generation
- GIVEN a negotiation in ACUERDO state
- WHEN the system generates the contract
- THEN a PDF with all 21 mandatory clauses is created
- AND the contract hash (SHA-256) is stored

#### Scenario: Digital signature
- GIVEN a generated contract in PENDIENTE_FIRMA state
- WHEN both parties sign the contract
- THEN the contract status changes to FIRMADO
- AND the escrow is activated via Trustless Worker

### Requirement: Rent Payment via SINPE

The system SHALL process monthly rent payments via Kindo SINPE integration.

#### Scenario: Tenant makes monthly payment
- GIVEN an active contract with a due payment
- WHEN the tenant initiates a SINPE payment
- THEN the payment is recorded in the Payment entity
- AND the owner receives notification of receipt

### Requirement: Bidirectional Claims

The system SHALL support bidirectional claims between tenants and owners with a state machine.

#### Scenario: Tenant files a claim
- GIVEN an active contract
- WHEN the tenant submits a claim with description and evidence
- THEN a Claim entity is created
- AND the owner is notified

#### Scenario: Owner responds to claim
- GIVEN an active claim
- WHEN the owner responds with resolution
- THEN the claim state is updated
- AND the tenant is notified

### Requirement: Periodic Inspections

The system SHALL support periodic inspections with photos, compliant with Art. 51 of Ley 7527.

#### Scenario: Scheduled inspection
- GIVEN an active contract
- WHEN an inspection date arrives
- THEN the inspector is notified
- AND inspection form with photo upload is presented

### Requirement: Contract Renewal or Termination

The system SHALL handle tacit renewal (Art. 71), final inspection, and escrow liquidation on termination.

#### Scenario: Tacit renewal
- GIVEN a contract approaching end date
- WHEN neither party objects within the legal period
- THEN the contract renews automatically per Art. 71

#### Scenario: Contract termination with escrow liquidation
- GIVEN an active contract
- WHEN the contract is terminated
- THEN a final inspection is triggered
- AND the escrow is liquidated (deposits returned minus deductions)
- AND mutual ratings are solicited

### Requirement: Mutual Rating

The system SHALL allow tenants and owners to rate each other after contract completion.

#### Scenario: Post-contract rating
- GIVEN a terminated contract
- WHEN both parties submit ratings
- THEN ratings are stored and visible to future counterparties
