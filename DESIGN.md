---
name: Nexus Sovereign
colors:
  surface: '#0d1322'
  surface-dim: '#0d1322'
  surface-bright: '#33394a'
  surface-container-lowest: '#080e1d'
  surface-container-low: '#151b2b'
  surface-container: '#191f2f'
  surface-container-high: '#242a3a'
  surface-container-highest: '#2e3445'
  on-surface: '#dde2f8'
  on-surface-variant: '#bacac5'
  inverse-surface: '#dde2f8'
  inverse-on-surface: '#2a3041'
  outline: '#859490'
  outline-variant: '#3c4a46'
  surface-tint: '#3cddc7'
  primary: '#57f1db'
  on-primary: '#003731'
  primary-container: '#2dd4bf'
  on-primary-container: '#00574d'
  inverse-primary: '#006b5f'
  secondary: '#80d5cb'
  on-secondary: '#003733'
  secondary-container: '#007068'
  on-secondary-container: '#9af0e5'
  tertiary: '#cedafb'
  on-tertiary: '#24304a'
  tertiary-container: '#b2bede'
  on-tertiary-container: '#414d68'
  error: '#ffb4ab'
  on-error: '#690005'
  error-container: '#93000a'
  on-error-container: '#ffdad6'
  primary-fixed: '#62fae3'
  primary-fixed-dim: '#3cddc7'
  on-primary-fixed: '#00201c'
  on-primary-fixed-variant: '#005047'
  secondary-fixed: '#9cf2e8'
  secondary-fixed-dim: '#80d5cb'
  on-secondary-fixed: '#00201d'
  on-secondary-fixed-variant: '#00504a'
  tertiary-fixed: '#d8e2ff'
  tertiary-fixed-dim: '#bac6e7'
  on-tertiary-fixed: '#0f1b34'
  on-tertiary-fixed-variant: '#3b4661'
  background: '#0d1322'
  on-background: '#dde2f8'
  surface-variant: '#2e3445'
typography:
  headline-xl:
    fontFamily: Inter
    fontSize: 32px
    fontWeight: '700'
    lineHeight: 40px
    letterSpacing: -0.02em
  headline-xl-mobile:
    fontFamily: Inter
    fontSize: 26px
    fontWeight: '700'
    lineHeight: 32px
    letterSpacing: -0.015em
  headline-lg:
    fontFamily: Inter
    fontSize: 22px
    fontWeight: '700'
    lineHeight: 28px
    letterSpacing: -0.01em
  headline-md:
    fontFamily: Inter
    fontSize: 18px
    fontWeight: '600'
    lineHeight: 24px
    letterSpacing: -0.005em
  headline-sm:
    fontFamily: Inter
    fontSize: 16px
    fontWeight: '600'
    lineHeight: 22px
  body-lg:
    fontFamily: Inter
    fontSize: 15px
    fontWeight: '400'
    lineHeight: 22px
  body-md:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '400'
    lineHeight: 20px
  body-sm:
    fontFamily: Inter
    fontSize: 12px
    fontWeight: '400'
    lineHeight: 16px
  financial-display:
    fontFamily: Inter
    fontSize: 28px
    fontWeight: '700'
    lineHeight: 34px
    letterSpacing: -0.02em
  financial-md:
    fontFamily: Inter
    fontSize: 18px
    fontWeight: '700'
    lineHeight: 24px
    letterSpacing: -0.01em
  label-md:
    fontFamily: Inter
    fontSize: 12px
    fontWeight: '600'
    lineHeight: 16px
    letterSpacing: 0.04em
  label-sm:
    fontFamily: Inter
    fontSize: 11px
    fontWeight: '500'
    lineHeight: 14px
    letterSpacing: 0.02em
  legal-code:
    fontFamily: Inter
    fontSize: 11px
    fontWeight: '500'
    lineHeight: 16px
    letterSpacing: 0.05em
rounded:
  sm: 0.125rem
  DEFAULT: 0.25rem
  md: 0.375rem
  lg: 0.5rem
  xl: 0.75rem
  full: 9999px
spacing:
  gutter: 1rem
  gutter-tablet: 1.5rem
  margin: 1rem
  margin-tablet: 2rem
  space-xs: 0.25rem
  space-sm: 0.5rem
  space-md: 1rem
  space-lg: 1.5rem
  space-xl: 2rem
---

## Brand & Style

This design system establishes a high-assurance, precision-engineered mobile operating environment for the intersection of PropTech, FinTech, and LegalTech within Costa Rica’s high-value residential market. The design narrative rejects casual consumer tropes in favor of an institutional-grade, cryptographically verified instrument. It speaks directly to property owners, institutional landlords, high-net-worth tenants, and legal fiduciaries who require absolute clarity, legal finality, and financial sovereignty.

The design movement combines **Corporate Modern** with **Technical Precision Glassmorphism** and architectural dark surfaces. Visual hierarchy is achieved through micro-borders, deep abyssal layering, luminous turquoise accents, and monospaced cryptographic elements. Every interaction must project zero-ambiguity authority: buttons feel locked and purposeful, escrow steps resemble strict ledger states, and legal clauses are surfaced with undeniable structural integrity.

## Colors

The palette operates under strict dark mode constraints designed for OLED efficiency and low-glare document legibility.

### Core Canvas & Surfaces
- **Primary Background (`#070D1C`):** Base canvas depth; used for foundational root views and system status bar backdrop.
- **Surface Level 1 / Card Surface (`#121B30`):** Default card background, bottom sheets, and inactive negotiation modules.
- **Surface Level 2 / Elevated Surface (`#18243D`):** Modals, interactive counter-offers, active state containers, and floating panels.
- **Surface Secondary (`#111C36`):** Embedded sub-containers, input fields, and recessed legal text containers.
- **Structural Border (`#26344F`):** Crisp 1px division lines separating terms, escrow stages, and field groups without cast shadows.

### Accent & Interaction
- **Primary Turquoise (`#2DD4BF`):** Primary action trigger, signature actions, approved escrow phases, and critical monetary highlights.
- **Dark Accent (`#0F766E`):** Active state backdrops, progress track fill bases, and focused selection borders.

### Typography & Content
- **Primary Text (`#F8FAFC`):** Display headlines, contractual terms, and dominant monetary figures.
- **Secondary / Muted Text (`#A8B3C7`):** Field labels, legal timestamp metadata, and secondary lease obligations.

### Regulatory & Semantic Feedback
- **Success (`#22C55E`):** Funds cleared, contract signed, verified cadastral entry, active insurance.
- **Warning (`#F59E0B`):** Pending escrow deposit, counter-offer expiring, walk-through inspection discrepancy.
- **Error (`#EF4444`):** Signature failure, escrow rejection, lease violation, KYC verification failure.

## Typography

The typography uses Inter across all view states to preserve strict metric precision and legibility across high-density legal clauses and financial calculations.

- **Financial Numerals:** Always presented with tabular figures (`tnum`) enabled to ensure vertical alignment of financial amounts across counter-offers and ledger lines. The official Costa Rican Colón symbol (`₡`) precedes figures with a non-breaking space (e.g., `₡ 850,000`), matched at full display weight (700).
- **Legal Clauses:** Body copy uses `body-md` with strict `lineHeight: 20px` to maintain steady cadence across scrolling contracts. Sub-clauses utilize `body-sm` in secondary text `#A8B3C7`.
- **Digital Signatures & Hashes:** Timestamps, cryptographic hashes, and public escrow addresses render in `legal-code` with uppercase styling and tracked-out spacing for inspection legibility.

## Layout & Spacing

The mobile layout operates on a standard Android 8dp grid system mapped to rem tokens (base `1rem` = `16px`). 

- **Outer Margins:** Fixed at `1rem` (16dp) on standard handheld screens (`< 600dp`) to maximize horizontal line length for dual-column negotiation comparisons, expanding to `2rem` on foldable or tablet devices.
- **Vertical Flow:** Stack sequences use strict 8dp intervals (`space-xs` = 4dp, `space-sm` = 8dp, `space-md` = 16dp, `space-lg` = 24dp, `space-xl` = 32dp).
- **Form Factor Reflow:** On standard mobile screens, comparison matrices (Tenant Offer vs. Landlord Counter-Offer) display side-by-side using equal 50% split viewports with an absolute minimum gutter of `space-xs` (4dp) and a 1px vertical `#26344F` divider.
- **Android System Insets:** The layout explicitly reserves edge-to-edge padding incorporating `WindowInsetsCompat.getInsets(Type.systemBars())`, positioning interactive action bars safely above the Android predictive gesture navigation bar.

## Elevation & Depth

This system avoids blurred drop shadows in favor of **structural tonal layering** and **subtle perimeter luminance**. Because the primary background is `#070D1C`, ambient shadows are physically indistinguishable; depth is instead communicated through luminance shifts and micro-borders:

- **Level 0 (Canvas Base - `#070D1C`):** Base scroll container. Flat, zero elevation.
- **Level 1 (Card & Content Blocks - `#121B30`):** Framed by a continuous 1px solid border in `#26344F`. No drop shadow.
- **Level 2 (Elevated Sheets & Floating Panels - `#18243D`):** Applied to active drawer layers, bottom sheets, and sticky CTA panels. Outlined with 1px `#26344F` and an ambient glow of `0px 8px 24px rgba(0, 0, 0, 0.45)`.
- **Level 3 (Cryptographic & Verified Focus):** When an element transitions to an active, verified, or signature-ready state, the 1px border transitions from `#26344F` to `#2DD4BF` at 40% opacity, paired with an inner top border highlight of `inset 0px 1px 0px rgba(45, 212, 191, 0.15)`.

## Shapes

To project institutional trust, legal permanence, and structural discipline, the system implements a **Soft (Level 1)** geometric standard:

- **Base Elements (4px / 0.25rem):** Checkboxes, status indicator chips, digital hash copy blocks, and micro-tags.
- **Input Fields & Action Controls (8px / 0.5rem):** Primary action buttons, text input fields, bottom bar action anchors.
- **Cards & Sheet Modules (12px / 0.75rem):** Property summaries, negotiation cards, and escrow timeline wrappers.
- **Bottom Sheets (Top Left & Right Only):** 16px corner radius to smoothly transition from native screen borders.

## Components

### 1. Android Top App Bar & Verification Badges
- **Container:** Height 64dp, background `#070D1C` with a 1px bottom border `#26344F`.
- **Title Block:** `headline-md` paired with a verified status badge.
- **Badge Anatomy:** Compact horizontal chip (height 22dp, radius 4dp, background `rgba(45, 212, 191, 0.10)`, border 1px `rgba(45, 212, 191, 0.30)`). Encapsulates a 12dp turquoise check shield icon and `label-sm` text reading `FE DE FECHAS ACTIVA` or `REGISTRO NACIONAL OK`.

### 2. Android Bottom Navigation Bar
- **Container:** Height 68dp + gesture inset padding. Background `#0B132B`, 1px top border `#26344F`.
- **Items:** 4 primary destinations (Explorar, Negociaciones, Depósito Escrow, Propiedad Activa).
- **State Styling:** Inactive icons and labels use `#A8B3C7`. Active states transition to `#2DD4BF` with an active micro-pill indicator (height 3dp, width 16dp, border-radius 2dp, color `#2DD4BF`) positioned at the bottom of the icon.

### 3. Structured Negotiation Comparison Cards
- **Architecture:** Split layout module wrapping current offer vs. proposed terms.
- **Surface:** Level 1 `#121B30`, border 1px `#26344F`.
- **Data Pairs:** Each parameter (Canon Mensual, Depósito en Garantía, Plazo Contractual, Cuota de Mantenimiento) is laid out in strict alternating row tints (`#111C36` vs `#121B30`).
- **Diff Highlighting:** Disputed or modified fields display an alert tint (`rgba(245, 158, 11, 0.15)`) with an amber tag showing difference delta (e.g., `+₡ 50,000`).

### 4. Escrow Status Tracker (5-Stage Linear Pipeline)
- **Stages:** `1. Depositado` → `2. Retenido` → `3. Contrato Activo` → `4. Inspección` → `5. Liberación`.
- **Visual Mechanics:** Horizontal segmented rail. Completed stages render with a solid line `#2DD4BF` and filled circular check node (`#2DD4BF` glyph on `#0F766E` background).
- **Active Node:** Pulsing outer ring `rgba(45, 212, 191, 0.3)` around an elevated node containing the active step index.
- **Pending Stages:** Inactive nodes set to `#18243D` with a `#26344F` connecting rail.
- **Context Card:** Directly underneath the track, display the custodian bank account summary and notary identification hash in `legal-code`.

### 5. Contract Viewer & Digital Timestamping Block
- **Document Viewport:** Padded document view `#0B132B` inside Level 1 card `#121B30`.
- **Hash Footer Block:** Pinned or inline verification block. Contains:
  - Timestamp: `ISO-8601 / UTC-6 (Costa Rica Standard Time)` in `label-sm`.
  - Hash string: Truncated SHA-256 string (e.g., `0x7f2c...8a4b`) in `legal-code` on `#111C36` chip.
  - Signer identities: Digital signature indicators with green micro-badges (`FIRMADO CON FIRMA DIGITAL BCCR`).

### 6. Property Identity Cards
- **Image Module:** Aspect ratio 16:9, rounded top corners (12px), overlaid with gradient vignette (`rgba(7, 13, 28, 0.8)` at base).
- **Overlay Chips:** Upper-left displays verification tier (`REGISTRALMENTE VERIFICADO`), upper-right displays active lease status.
- **Data Deck:** Monthly rent displayed in bold `financial-md` (`₡ 650,000 / mes`), property location (Cantón, Distrito), and quick metadata (habitaciones, parqueos, pet-friendly status).

### 7. Action Buttons & Input Fields
- **Primary Button:** Height 48dp, background `#2DD4BF`, text color `#070D1C` (bold weight 600). Pressed state `#0F766E` with text `#F8FAFC`.
- **Secondary Button:** Height 48dp, background `#18243D`, border 1px `#26344F`, text `#F8FAFC`.
- **Destructive Button:** Height 48dp, background `rgba(239, 68, 68, 0.12)`, border 1px `#EF4444`, text `#EF4444`.
- **Input Fields:** Height 52dp, background `#111C36`, border 1px `#26344F`, text `#F8FAFC`. Active focus switches border to `#2DD4BF`. Prefix displays currency symbol `₡` pinned in `#A8B3C7`.