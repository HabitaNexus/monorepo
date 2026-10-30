/// HabitaNexus brand package: tokens + typed accessors over shared_ui_core.
///
/// Parsing logic lives in core once; this brand only ships tokens.json +
/// [HabitanexusTokens] plus the M3 [AppTheme] built from the same seed.
library habitanexus_ui;

// Brand tokens (interface de flutter_shared_ui)
export 'src/habitanexus_tokens.dart';
export 'package:shared_ui_core/shared_ui_core.dart';

// Theme M3 (seed #1A5276)
export 'src/theme/app_theme.dart';

// Atoms — (vacío: ver README.md)
// Molecules — (vacío)
// Organisms — (vacío)
