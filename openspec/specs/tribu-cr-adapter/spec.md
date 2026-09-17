# TRIBU-CR Adapter Specification

## Purpose

Integrate HabitaNexus with TRIBU-CR (the tax system that replaced ATV and D-125) to automatically report rental income to the Ministerio de Hacienda. Enables the B2G line and positions HabitaNexus as a tax compliance platform.

**Services affected**: Tax Reporting Service, Contract Service, Payment Service
**Architecture reference**: aduanext (Hexagonal / Ports & Adapters)
**Priority**: High (B2G)

---

## Requirements

### Requirement: Automatic Rental Income Reporting

The system SHALL automatically report rental income to TRIBU-CR for every signed contract, using the hacienda-cr gRPC sidecar.

#### Scenario: Monthly rental income declaration
- GIVEN an active signed contract
- WHEN a monthly rent payment is processed
- THEN the Tax Reporting Service generates a declaration
- AND the declaration is sent to TRIBU-CR via the hacienda-cr sidecar
- AND the owner is notified of the submitted declaration

#### Scenario: Declaration before deadline
- GIVEN a rental income event for the previous month
- WHEN the 15th of the current month arrives
- THEN the declaration MUST have been submitted to TRIBU-CR

### Requirement: Tax Rate Calculation

The system SHALL calculate taxes at 15% on 85% of gross rental income (capital inmobiliario) and 13% IVA when monthly rent exceeds ₡693,300.

#### Scenario: Standard rental income tax
- GIVEN a monthly rent of ₡500,000
- WHEN the tax declaration is generated
- THEN the taxable base is ₡425,000 (85% of gross)
- AND the tax is ₡63,750 (15% of taxable base)

#### Scenario: IVA applicable
- GIVEN a monthly rent of ₡800,000
- WHEN the tax declaration is generated
- THEN IVA of 13% is applied on top of the income tax

### Requirement: Electronic Invoice Generation

The system SHALL generate a electronic invoice (factura electrónica) for every payment received, as required by TRIBU-CR.

#### Scenario: Invoice for each payment
- GIVEN a processed rent payment
- WHEN the payment is confirmed
- THEN an electronic invoice is generated via the hacienda-cr sidecar
- AND the invoice is stored and linked to the payment record

### Requirement: Compliance Status Checking

The system SHALL allow checking the tax compliance status of any property owner.

#### Scenario: Owner checks compliance
- GIVEN an authenticated property owner
- WHEN the owner requests their compliance status
- THEN the system queries TRIBU-CR via the hacienda-cr sidecar
- AND returns current compliance status (compliant, pending, overdue)

### Requirement: Port-Based Architecture

The system SHALL use a `TaxReportingPort` interface following hexagonal architecture, with the TRIBU-CR implementation as a concrete adapter.

#### Scenario: Port abstraction
- GIVEN the TaxReportingPort interface
- WHEN a new tax authority integration is needed
- THEN a new adapter can implement the port without changing the core service
