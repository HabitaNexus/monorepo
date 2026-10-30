import 'package:flutter/material.dart';
import 'package:shared_ui_core/shared_ui_core.dart';

/// Typed access to the HabitaNexus brand tokens (style-dictionary source).
/// Primary ramp generated from seed #1A5276 with material_color_utilities
/// (same engine as ColorScheme.fromSeed used by AppTheme).
/// Secondary/accent/success/warning/error/neutral ramps: plantilla M3
/// pendiente de definición de marca (ver HAB design system).
class HabitanexusTokens {
  HabitanexusTokens._();

  static DesignTokenModel? _tokens;

  /// Load from the brand asset paths (app-local first, package fallback).
  static Future<void> initialize() async {
    _tokens ??= await TokensReader.load([
      'assets/style_dictionary/tokens.json',
      'packages/habitanexus_ui/assets/style_dictionary/tokens.json',
    ]);
  }

  /// Override for tests / previews.
  @visibleForTesting
  static void debugSetTokens(DesignTokenModel tokens) => _tokens = tokens;

  static DesignTokenModel get tokens {
    final t = _tokens;
    if (t == null) {
      throw StateError('HabitanexusTokens.initialize() must be awaited first');
    }
    return t;
  }

  static bool get isLoaded => _tokens != null;
}
