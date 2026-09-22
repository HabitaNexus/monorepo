/// Shared HabitaNexus UI package — Atomic Design widgets y tema M3.
///
/// Presentación pura: nunca debe depender de DTOs de API ni de providers
/// de Riverpod. Los widgets se organizan en `src/{atoms,molecules,organisms}`
/// y cada uno nace con su story en `apps/widgetbook`.
library;

// ---------------------------------------------------------------------------
// Theme — tokens M3 del design system (HAB-20)
// ---------------------------------------------------------------------------
export 'src/theme/app_theme.dart';

// ---------------------------------------------------------------------------
// Models — view-models puros de presentación (sin equatable ni DTOs)
// ---------------------------------------------------------------------------
export 'src/models/nearby_space.dart';

// ---------------------------------------------------------------------------
// Atoms — piezas mínimas sin estado ([atoms])
// ---------------------------------------------------------------------------
export 'src/atoms/space_type_icon.dart';

// ---------------------------------------------------------------------------
// Molecules — composición de átomos ([molecules])
// ---------------------------------------------------------------------------
export 'src/molecules/space_card.dart';

// ---------------------------------------------------------------------------
// Organisms — bloques de pantalla ([organisms])
// ---------------------------------------------------------------------------
export 'src/organisms/nearby_coworkings.dart';
