# Municipal Dashboard Specification

## Purpose

Web dashboard for Costa Rican municipalities displaying real-time rental data overlaid on cadastral and Plan Regulador GIS layers. Enables local governments to enforce rental licenses, plan public services, and update the Plan Regulador with live data.

**Services affected**: GIS Service, Analytics Service, Contract Service
**Reference**: AltruPets B2G (apps/web/b2g/)
**Priority**: Medium (post-traction, ~500+ contracts)

---

## Requirements

### Requirement: Rental Heat Map

The system SHALL display a heat map of rental contract density per district, overlaid on cadastral/Plan Regulador layers.

#### Scenario: District-level heat map
- GIVEN authenticated municipal user
- WHEN the user selects a district view
- THEN contract density is rendered as a heat map
- AND the base layer shows cadastral boundaries

#### Scenario: GIS layer integration (ArcGIS)
- GIVEN a municipality with ArcGIS REST endpoints (San José, Alajuela, etc.)
- WHEN the dashboard loads
- THEN cadastral features are fetched via FeatureServer REST API
- AND projected to CRTM05 (EPSG:5367)

#### Scenario: GIS layer integration (OGC)
- GIVEN a municipality with OGC endpoints (San Carlos, Santa Ana, etc.)
- WHEN the dashboard loads
- THEN cadastral features are fetched via WMS/WFS as GeoJSON

### Requirement: Patent Compliance Monitoring

The system SHALL identify properties with active contracts but no rental license (patente de alquileres).

#### Scenario: Non-compliant properties
- GIVEN active contracts in the system
- WHEN cross-referenced with municipal license records
- THEN properties without a valid license are flagged
- AND the count of non-compliant properties is displayed per district

### Requirement: Rental Price Index

The system SHALL calculate and display a monthly rental price index per district using actual transactional data.

#### Scenario: Monthly price update
- GIVEN rental payment data for the previous month
- WHEN the price index calculation runs
- THEN average, median, and range prices per district are computed
- AND the index is published to the dashboard

### Requirement: Rental Trends Analytics

The system SHALL show occupancy rates, turnover, and average lease duration by zone.

#### Scenario: Zone-level trends
- GIVEN historical contract data
- WHEN a municipal user selects a zone
- THEN occupancy rate, average turnover, and average duration are displayed
- AND trends are shown over a configurable time period

### Requirement: Housing Alerts

The system SHALL surface housing alerts including deficit/surplus, mass evictions, and critical zones.

#### Scenario: Deficit alert
- GIVEN occupancy data falling below a threshold
- WHEN the analytics engine detects a deficit
- THEN an alert is raised on the dashboard
- AND the affected district is highlighted

#### Scenario: Mass eviction detection
- GIVEN multiple contract terminations in a short period
- WHEN the threshold is exceeded
- THEN a mass eviction alert is raised
- AND affected properties are listed

### Requirement: Potential Tax Collection

The system SHALL show uncollected vs. collected rental licenses and project revenue.

#### Scenario: Revenue projection
- GIVEN license and contract data
- WHEN the projection model runs
- THEN potential vs. actual revenue per district is displayed
- AND a 12-month projection is generated

### Requirement: Dashboard Settings

The system SHALL allow municipal administrators to configure approval rules, alert thresholds, and jurisdiction scope.

#### Scenario: Alert threshold configuration
- GIVEN an authenticated municipal admin
- WHEN the admin updates alert thresholds
- THEN new thresholds take effect immediately
- AND existing alerts are re-evaluated

### Requirement: Minimum Data Threshold

The system SHALL require a minimum of ~500 active contracts before enabling analytics features.

#### Scenario: Below threshold
- GIVEN fewer than 500 active contracts
- WHEN a municipal user accesses the dashboard
- THEN a message indicates insufficient data for statistical analysis
- AND basic listing data is still available

### Requirement: AltruPets Layer Integration

The system SHALL optionally overlay AltruPets data (animal reports, eviction-abandonment correlations) on the municipal dashboard.

#### Scenario: Animal report overlay
- GIVEN AltruPets data available for the municipality
- WHEN the admin enables the AltruPets layer
- THEN animal reports are shown on the map
- AND correlations with evictions are highlighted
