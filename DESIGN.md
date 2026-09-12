---
version: "alpha"
name: HabitaNexus
description: "Design system for HabitaNexus — a long-term rental housing marketplace for Costa Rica"
colors:
  seed: "#1A5276"
  light-primary: "#2A638A"
  light-on-primary: "#FFFFFF"
  light-primary-container: "#CBE6FF"
  light-on-primary-container: "#024B71"
  light-secondary: "#50606F"
  light-on-secondary: "#FFFFFF"
  light-secondary-container: "#D4E4F6"
  light-on-secondary-container: "#394856"
  light-tertiary: "#66587B"
  light-on-tertiary: "#FFFFFF"
  light-tertiary-container: "#ECDCFF"
  light-on-tertiary-container: "#4D4162"
  light-error: "#BA1A1A"
  light-on-error: "#FFFFFF"
  light-error-container: "#FFDAD6"
  light-on-error-container: "#93000A"
  light-surface: "#F7F9FF"
  light-on-surface: "#181C20"
  light-surface-variant: "#DEE3EA"
  light-on-surface-variant: "#41474D"
  light-outline: "#72787E"
  light-outline-variant: "#C1C7CE"
  light-shadow: "#000000"
  light-surface-tint: "#2A638A"
  primary: "#2A638A"
  dark-primary: "#97CCF9"
  dark-on-primary: "#003450"
  dark-primary-container: "#024B71"
  dark-on-primary-container: "#CBE6FF"
  dark-secondary: "#B8C8D9"
  dark-on-secondary: "#22323F"
  dark-secondary-container: "#394856"
  dark-on-secondary-container: "#D4E4F6"
  dark-tertiary: "#D0BFE7"
  dark-on-tertiary: "#362B4A"
  dark-tertiary-container: "#4D4162"
  dark-on-tertiary-container: "#ECDCFF"
  dark-error: "#FFB4AB"
  dark-on-error: "#690005"
  dark-error-container: "#93000A"
  dark-on-error-container: "#FFDAD6"
  dark-surface: "#101417"
  dark-on-surface: "#E0E3E8"
  dark-surface-variant: "#41474D"
  dark-on-surface-variant: "#C1C7CE"
  dark-outline: "#8B9198"
  dark-outline-variant: "#41474D"
  dark-shadow: "#000000"
  dark-surface-tint: "#97CCF9"
typography:
  display-large:
    fontFamily: Roboto
    fontSize: 57px
    fontWeight: "400"
    lineHeight: 1.12
    letterSpacing: -0.25px
  display-medium:
    fontFamily: Roboto
    fontSize: 45px
    fontWeight: "400"
    lineHeight: 1.16
    letterSpacing: 0px
  display-small:
    fontFamily: Roboto
    fontSize: 36px
    fontWeight: "400"
    lineHeight: 1.22
    letterSpacing: 0px
  headline-large:
    fontFamily: Roboto
    fontSize: 32px
    fontWeight: "400"
    lineHeight: 1.25
    letterSpacing: 0px
  headline-medium:
    fontFamily: Roboto
    fontSize: 28px
    fontWeight: "400"
    lineHeight: 1.29
    letterSpacing: 0px
  headline-small:
    fontFamily: Roboto
    fontSize: 24px
    fontWeight: "400"
    lineHeight: 1.33
    letterSpacing: 0px
  title-large:
    fontFamily: Roboto
    fontSize: 22px
    fontWeight: "400"
    lineHeight: 1.27
    letterSpacing: 0px
  title-medium:
    fontFamily: Roboto
    fontSize: 16px
    fontWeight: "500"
    lineHeight: 1.5
    letterSpacing: 0.15px
  title-small:
    fontFamily: Roboto
    fontSize: 14px
    fontWeight: "500"
    lineHeight: 1.43
    letterSpacing: 0.1px
  body-large:
    fontFamily: Roboto
    fontSize: 16px
    fontWeight: "400"
    lineHeight: 1.5
    letterSpacing: 0.5px
  body-medium:
    fontFamily: Roboto
    fontSize: 14px
    fontWeight: "400"
    lineHeight: 1.43
    letterSpacing: 0.25px
  body-small:
    fontFamily: Roboto
    fontSize: 12px
    fontWeight: "400"
    lineHeight: 1.33
    letterSpacing: 0.4px
  label-large:
    fontFamily: Roboto
    fontSize: 14px
    fontWeight: "500"
    lineHeight: 1.43
    letterSpacing: 0.1px
  label-medium:
    fontFamily: Roboto
    fontSize: 12px
    fontWeight: "500"
    lineHeight: 1.33
    letterSpacing: 0.5px
  label-small:
    fontFamily: Roboto
    fontSize: 11px
    fontWeight: "500"
    lineHeight: 1.45
    letterSpacing: 0.5px
rounded:
  sm: 8px
  md: 12px
  lg: 16px
  xl: 24px
  full: 9999px
spacing:
  xs: 4px
  sm: 8px
  md: 12px
  lg: 16px
  xl: 24px
  xxl: 32px
components:
  card-default:
    backgroundColor: "{colors.light-surface}"
    rounded: "{rounded.md}"
  card-nearby:
    backgroundColor: "{colors.light-surface}"
    rounded: "{rounded.md}"
    width: 180px
  tag:
    backgroundColor: "{colors.light-secondary-container}"
    textColor: "{colors.light-on-secondary-container}"
    rounded: "{rounded.md}"
    padding: 8px 2px
    typography: "{typography.label-medium}"
  partnership-badge-active:
    backgroundColor: "#C8E6C9"
    textColor: "#2E7D32"
    rounded: "{rounded.md}"
    padding: 8px 4px
    typography: "{typography.label-medium}"
  partnership-badge-pending:
    backgroundColor: "#FFE0B2"
    textColor: "#E65100"
    rounded: "{rounded.md}"
    padding: 8px 4px
    typography: "{typography.label-medium}"
  info-row-label:
    textColor: "{colors.light-on-surface-variant}"
    typography: "{typography.body-medium}"
  info-row-value:
    typography: "{typography.body-medium}"
  filter-sheet:
    padding: "{spacing.xl}"
  app-bar-title:
    typography: "{typography.title-large}"
---

## Overview

**Professional Trust meets Tropical Functionality.** HabitaNexus adopts Material Design 3 with a deep navy-blue seed color (#1A5276) evoking the stability and reliability expected of a rental marketplace. The interface is clean, utilitarian, and content-forward — prioritizing listing density and scannable information architecture over decorative embellishment.

The app speaks Spanish-first and serves the Costa Rican market. The design personality is **competent and approachable**: it does not try to impress with visual flair but earns trust through clarity, consistency, and predictable interaction patterns. Every screen is organized around helping users find, evaluate, and secure long-term housing with minimal friction.

## Colors

The color system is generated dynamically from a single seed color using the Material 3 tonal palette algorithm. All tokens above are the exact computed values for both light and dark modes.

### Seed Color

The deep blue-green seed (#1A5276) was chosen to evoke the Pacific and Caribbean waters surrounding Costa Rica. It is not a vibrant or trendy blue — it is a serious, institutional blue that communicates trustworthiness in financial and contractual contexts.

### Light Theme

- **Primary (#2A638A):** Used for interactive elements, active states, and key navigation. A slightly lighter, more saturated blue than the seed — visible and intentional without being aggressive.
- **Primary Container (#CBE6FF):** Light blue used as a surface tint for image placeholders, card accents, and illustrative backgrounds.
- **Secondary (#50606F):** A muted slate-gray for secondary actions, toggle backgrounds, and meta information. Recedes behind primary without disappearing.
- **Secondary Container (#D4E4F6):** The background for tags, chips, and small metadata badges. Creates tonal hierarchy within card layouts.
- **Surface (#F7F9FF):** An icy off-white foundation that keeps the UI feeling airy and clean. Not pure white — the subtle blue tint harmonizes with the primary palette.
- **Error (#BA1A1A):** Standard M3 red reserved for destructive actions and validation messages. Used sparingly.
- **Outline (#72787E):** Borders, dividers, and low-emphasis strokes where a full surface elevation change is too heavy.

### Dark Theme

Dark mode inverts the tonal relationship. Primary becomes a luminous sky blue (#97CCF9) on deep navy backgrounds. Containers darken to near-charcoal (#101417) and text resolves to a cool off-white (#E0E3E8). The dark scheme follows M3's standard luminance inversion: light containers invert to dark, light text inverts to light-on-dark.

### Semantic Use

- **Green (#C8E6C9 / #2E7D32):** Active partnership indicators and positive status badges.
- **Orange (#FFE0B2 / #E65100):** Pending states, transitional statuses, and cautionary badges.
- **Amber (#FFC107):** Star ratings and review scores.
- **Grey (#9E9E9E):** Disabled states, empty placeholders, inactive amenity chips, and secondary metadata.

## Typography

The app uses **Roboto** (the Material Design default) across all platforms via the standard M3 type scale. The full 15-step type ramp is defined in the tokens above.

### Usage in Practice

| Token | Usage | Weight Override |
|-------|-------|-----------------|
| headline-small | Space name on detail page | Bold (w700) |
| title-large | Section headers, filter sheet titles | None |
| title-medium | Card titles, section headings | Bold (w700) |
| title-small | Sub-headings in cards | None |
| label-large | Nearby card space names | Bold (w700) |
| body-large | Description text (detail page) | None |
| body-medium | Address text, body content | None |
| body-small | Addresses (card view), metadata | None |
| label-medium | — | Used at 12px for tags and metadata |

### Overrides

Inline weight overrides are common: `FontWeight.bold` (w700) is applied to any text acting as a title or heading, overriding the token's default weight. This pattern is used in cards, detail pages, and section headers to create stronger visual hierarchy on small screens.

A `google_fonts` dependency exists in `pubspec.yaml` but is not yet activated. Future adoption of a custom font (e.g., Inter or Plus Jakarta Sans) can be done via `GoogleFonts` without changing the type scale structure.

## Layout & Spacing

### Grid

The layout uses a single-column mobile-first grid on a flexible viewport. No fixed column grid is enforced — content flows vertically with consistent horizontal margins.

### Spacing Scale

All dimensions follow a loose 4px / 8px base rhythm:

| Token | Value | Typical Use |
|-------|-------|-------------|
| xs | 4px | Icon-to-text gaps, tag inner padding vertical, star rating gaps |
| sm | 8px | Between subtitle and tags, info row spacing, amenity chip gaps, divider to content |
| md | 12px | Between filters, inner card padding (nearby), tag gap, list vertical padding |
| lg | 16px | Card content padding, page margin, between sections, card bottom margin |
| xl | 24px | Filter sheet padding, large section gaps, outer page gutters |
| xxl | 32px | Before/after dividers, major section separators |

### Content Density

- **Cards:** Content is packed tightly — 12–16px padding — to maximize listing density.
- **Page margins:** 16px horizontal padding on all scrollable content.
- **Sheets:** 24px horizontal and top padding, 24px + keyboard inset at bottom.
- **Dividers:** 32px vertical spacing above and below to create clear section boundaries.
- **Empty states:** Centered layout with 16px gap between icon and text. Minimalist — no illustration, just icon + copy.

## Elevation & Depth

The app relies entirely on **Material 3 Card default elevation (1dp)** for surface separation. There are no custom shadow definitions, no modal dialogs with heightened elevation, and no floating action buttons with extended elevation.

- **Cards:** Subtle 1dp shadow provides enough separation from the surface to indicate interactivity without creating visual noise.
- **Bottom Sheets:** Default M3 bottom sheet elevation — sits above the content layer.
- **AppBar:** Standard M3 app bar with no elevation (surface-colored on iOS-style, elevated on Material-style).
- **Interactive states:** Ink ripple on `InkWell` provides tactile feedback on tap. No lift-on-hover effects are implemented.
- **Surface hierarchy:** Content is organized flat — there is no multi-layered elevation strategy. The only separation is card vs. surface.

## Shapes

The shape language uses **consistently moderate rounding**:

| Token | Value | Usage |
|-------|-------|-------|
| sm | 8px | Card image placeholders, small decorative containers |
| md | 12px | Card bodies, tags, badges, nearby cards, partnership indicators, amenity chips |
| full | 9999px | Not currently used (reserved for future avatars, status dots) |

The MD (12px) radius is the dominant shape token, appearing across cards, tags, badges, and chips. This creates visual consistency without the playfulness of pill shapes or the formality of sharp corners. The 8px radius is used sparingly for secondary containers within cards.

## Components

### Cards

The primary content container in the app. Two variants exist:

- **Standard Card (`card-default`):** Full-width list card with an 80×80 image placeholder on the left and content on the right. Used in the main listing view. Padding: 16px.
- **Nearby Card (`card-nearby`):** Horizontal 180px-wide card in a horizontal scroll row. Compact padding (12px) with icon + name layout. Used in the "nearby" section.

Both use M3 Card default elevation (1dp) and 12px border radius on the InkWell hit area.

### Tags

Small metadata indicators with secondary-container background, 12px border radius, 8px horizontal / 2px vertical padding, and 12px font size. Used for space type labels (Café, Coworking, CECI), WiFi speed, and day-pass price.

### Partnership Badges

Contextual status badges that appear on the detail page. Not shown when status is `none`. Three states:

- **Active:** Green background (#C8E6C9) with dark green text (#2E7D32) — label: "Partner".
- **Pending:** Orange background (#FFE0B2) with dark orange text (#E65100) — label: "En gestión".
- **Inactive/Expired:** Orange background (#FFE0B2) with dark orange text (#E65100) — label: "Ex-partner".

### Amenity Chips

M3 `Chip` widgets with leading icon and label. Inactive chips use a light grey background (#F5F5F5). Active chips use the M3 default chip style. Spacing: 8px gap between chips.

### Info Rows

Label-value pairs with a leading icon. Labels use the `on-surface-variant` color (grey, #41474D) at `body-medium` size. Values use medium weight (w500) at `body-medium` size. Icons are 20px at grey (#9E9E9E). Vertical padding: 8px. Label column width: 120px.

### Filter Sheet

A modal bottom sheet containing dropdowns, switches, and an action button. Uses 24px padding. Title uses `title-large`. Dropdowns use standard M3 `DropdownButtonFormField`. The action button is a standard M3 `FilledButton` labeled "Aplicar filtros".

### App Bar

Standard M3 `AppBar` with title text. Lists the feature name (e.g., "Coworkings & Cafés"). Contains filter icon button as an action on the finder page. No elevation tint — uses surface color.

### Empty State

Centered column with a 64px `search_off` icon in grey (#9E9E9E), followed by a two-line message in Spanish ("No se encontraron espacios" / "Prueba con otros filtros"). 16px gap between icon and text.

## Do's and Don'ts

- **Do** use `primary-container` (#CBE6FF light / #024B71 dark) for image placeholders and illustrative surfaces — never use pure grey for placeholders.
- **Do** use `secondary-container` (#D4E4F6 light / #394856 dark) for all tag and chip backgrounds to maintain tonal consistency.
- **Do** apply `FontWeight.bold` (w700) to any text serving as a title or heading, even when the typography token specifies a lower weight.
- **Do not** introduce new color tokens not derived from the Material 3 tonal palette. If a new semantic color is needed, derive it from the seed via `ColorScheme.fromSeed()`.
- **Do not** use inline hex colors for primary UI elements — always reference theme color tokens.
- **Do not** use hardcoded spacing values outside the defined spacing scale (xs–xxl).
- **Do not** create new elevation levels. Cards = 1dp, everything else = 0dp.
- **Do** use grey (#9E9E9E) for disabled, inactive, and placeholder elements — but prefer theme color tokens for all active UI.
- **Do** keep the UI content-dense and functional. Avoid decorative illustrations or ornamental flourishes — HabitaNexus is a tool, not a gallery.
