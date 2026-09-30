# Spec Delta

## MODIFIED Requirements

### Requirement: Automatic Rental Income Reporting

The system SHALL build one rental-income declaration per property owner and calendar month (America/Costa_Rica) for rent on signed contracts, and SHALL submit that declaration to TRIBU-CR through the hacienda-cr sidecar before the 15th of the following month. A repeated delivery of the same payment MUST NOT change the period total. The system MUST NOT mark a declaration submitted, and MUST NOT notify the owner, when it cannot present a TRIBU-CR payload because that schema is unknown. A payment for a contract that is not signed MUST NOT enter the declaration.

#### Scenario: Monthly rental income declaration

- **WHEN** two rent payments for the same signed contract and the same calendar month are recorded for one owner
- **THEN** the system holds a single declaration for that owner and month whose gross is the sum of both payments

#### Scenario: Declaration before deadline

- **WHEN** the 15th of the month arrives and the previous month has rental income for a signed contract
- **THEN** that month's declaration has been handed to the submission boundary
- **AND** it is submitted to TRIBU-CR only when a TRIBU-CR payload schema exists
- **AND** otherwise it remains pending submission

#### Scenario: Repeated payment does not change the period total

- **WHEN** the same rent payment is recorded again for an owner and month that already include it
- **THEN** the declaration gross for that owner and month stays unchanged

#### Scenario: Owner is notified only after submission

- **WHEN** the submission boundary accepts the declaration as submitted to TRIBU-CR
- **THEN** the owner is notified of that submitted declaration
- **AND** a declaration that is still pending submission does not notify the owner

#### Scenario: Unsigned contract payment is excluded

- **WHEN** a rent payment is recorded for a contract that has not been signed
- **THEN** that payment is absent from every monthly declaration

### Requirement: Tax Rate Calculation

The system SHALL calculate capital-inmobiliario income tax as 15% of 85% of gross rental income, in integer colones, rounding half up at each step. The system SHALL also calculate IVA at 13% of that same gross, rounded half up, when the owner's aggregated gross for the month is strictly greater than ₡693,300, and SHALL calculate IVA as ₡0 otherwise. IVA is added alongside the income tax, not as a percentage of the income tax.

#### Scenario: Standard rental income tax

- **WHEN** the declaration is generated for a monthly gross of ₡500,000
- **THEN** the taxable base is ₡425,000
- **AND** the income tax is ₡63,750
- **AND** IVA is ₡0

#### Scenario: IVA applicable

- **WHEN** the declaration is generated for a monthly gross of ₡800,000
- **THEN** the taxable base is ₡680,000
- **AND** the income tax is ₡102,000
- **AND** IVA is ₡104,000

#### Scenario: IVA at the threshold

- **WHEN** the declaration is generated for a monthly gross of ₡693,300
- **THEN** IVA is ₡0
- **AND** the taxable base is ₡589,305
- **AND** the income tax is ₡88,396
