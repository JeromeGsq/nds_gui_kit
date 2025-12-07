import 'dart:ui' as ui;
import 'package:flutter/services.dart';

/// Singleton cache for loading and storing UI images for canvas drawing.
class NDSImageCache {
  NDSImageCache._();
  static final NDSImageCache instance = NDSImageCache._();

  final Map<String, ui.Image> _cache = {};
  final Map<String, Future<ui.Image>> _pending = {};

  /// Check if an image is already loaded
  bool isLoaded(String assetPath) => _cache.containsKey(assetPath);

  /// Get a loaded image (returns null if not loaded)
  ui.Image? getImage(String assetPath) => _cache[assetPath];

  /// Load an image from assets
  Future<ui.Image> loadImage(String assetPath) async {
    // Return cached image if available
    if (_cache.containsKey(assetPath)) {
      return _cache[assetPath]!;
    }

    // Return pending future if already loading
    if (_pending.containsKey(assetPath)) {
      return _pending[assetPath]!;
    }

    // Start loading
    final future = _loadImageFromAsset(assetPath);
    _pending[assetPath] = future;

    try {
      final image = await future;
      _cache[assetPath] = image;
      _pending.remove(assetPath);
      return image;
    } catch (e) {
      _pending.remove(assetPath);
      rethrow;
    }
  }

  /// Load multiple images at once
  Future<Map<String, ui.Image>> loadImages(List<String> assetPaths) async {
    final futures = assetPaths.map((path) => loadImage(path));
    final images = await Future.wait(futures);
    
    final result = <String, ui.Image>{};
    for (int i = 0; i < assetPaths.length; i++) {
      result[assetPaths[i]] = images[i];
    }
    return result;
  }

  /// Preload all common NDS images
  Future<void> preloadAllImages() async {
    await loadImages([
      'assets/images/bg_tile_top.png',
      'assets/images/bg_tile_bottom.png',
      'assets/images/top_bar_bg_1.png',
      'assets/images/top_bar_divider.png',
      'assets/images/clock.png',
      'assets/images/calendar.png',
      'assets/images/battery.png',
      'assets/images/button_main.png',
      'assets/images/button_main_pressed.png',
      'assets/images/button_light.png',
      'assets/images/button_settings.png',
      'assets/images/button_more_apps.png',
    ]);
  }

  Future<ui.Image> _loadImageFromAsset(String assetPath) async {
    final data = await rootBundle.load(assetPath);
    final codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
    final frame = await codec.getNextFrame();
    return frame.image;
  }

  /// Clear the cache
  void clear() {
    for (final image in _cache.values) {
      image.dispose();
    }
    _cache.clear();
  }

  /// Dispose a specific image
  void disposeImage(String assetPath) {
    final image = _cache.remove(assetPath);
    image?.dispose();
  }
}

