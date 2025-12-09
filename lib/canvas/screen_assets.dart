import 'dart:ui' as ui;

import 'package:nds_gui_kit/canvas/image_cache.dart';

/// Singleton that encapsulates all image assets for the bottom screen
/// Loaded once via [ensureLoaded], then accessible via [instance]
class ScreenAssets {
  // Singleton
  static ScreenAssets? _instance;
  static Future<void>? _loadingFuture;

  /// Get the singleton instance (throws if not loaded)
  static ScreenAssets get instance {
    if (_instance == null) {
      throw StateError(
        'BottomScreenAssets not loaded. Call ensureLoaded() first.',
      );
    }
    return _instance!;
  }

  /// Check if assets are loaded
  static bool get isLoaded => _instance != null;

  /// Ensure assets are loaded (safe to call multiple times)
  static Future<void> ensureLoaded() async {
    if (_instance != null) return;

    // Prevent multiple concurrent loads
    _loadingFuture ??= _load();
    await _loadingFuture;
  }

  static Future<void> _load() async {
    final cache = MainImageCache.instance;

    final results = await Future.wait([
      cache.loadImage('assets/images/bg_tile_bottom.png'),
      cache.loadImage('assets/images/button_main.png'),
      cache.loadImage('assets/images/button_main_pressed.png'),
      cache.loadImage('assets/images/button_large.png'),
      cache.loadImage('assets/images/button_large_pressed.png'),
      cache.loadImage('assets/images/button_light.png'),
      cache.loadImage('assets/images/button_settings.png'),
      cache.loadImage('assets/images/button_more_apps.png'),
      cache.loadImage('assets/images/dialog.png'),
    ]);

    _instance = ScreenAssets._(
      bgTile: results[0],
      buttonMain: results[1],
      buttonMainPressed: results[2],
      buttonLarge: results[3],
      buttonLargePressed: results[4],
      buttonLight: results[5],
      buttonSettings: results[6],
      buttonMore: results[7],
      dialog: results[8],
    );
  }

  // Instance fields
  final ui.Image bgTile;
  final ui.Image buttonMain;
  final ui.Image buttonMainPressed;
  final ui.Image buttonLarge;
  final ui.Image buttonLargePressed;
  final ui.Image buttonLight;
  final ui.Image buttonSettings;
  final ui.Image buttonMore;
  final ui.Image dialog;

  const ScreenAssets._({
    required this.bgTile,
    required this.buttonMain,
    required this.buttonMainPressed,
    required this.buttonLarge,
    required this.buttonLargePressed,
    required this.buttonLight,
    required this.buttonSettings,
    required this.buttonMore,
    required this.dialog,
  });

  /// Get main button dimensions
  double get mainButtonWidth => buttonMain.width.toDouble();
  double get mainButtonHeight => buttonMain.height.toDouble();

  /// Get large button dimensions
  double get largeButtonWidth => buttonLarge.width.toDouble();
  double get largeButtonHeight => buttonLarge.height.toDouble();
}
