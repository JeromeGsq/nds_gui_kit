import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:installed_apps/app_info.dart';
import 'package:nds_gui_kit/canvas/bottom/models/button_definition.dart';
import 'package:nds_gui_kit/models/favorite_app_config.dart';
import 'package:nds_gui_kit/services/favorites_storage_service.dart';

/// Manages favorite apps configuration and icon caching
class FavoritesManager extends ChangeNotifier {
  final FavoritesStorageService _storageService = FavoritesStorageService();

  /// List of configured favorites
  final List<FavoriteAppConfig> _favorites = List.generate(
    4,
    (_) => FavoriteAppConfig.empty(),
  );

  /// Cache for app icons
  final Map<String, ui.Image> _appIconCache = {};

  /// Get the list of favorites
  List<FavoriteAppConfig> get favorites => List.unmodifiable(_favorites);

  /// Get the app icon cache
  Map<String, ui.Image> get appIconCache => _appIconCache;

  /// Load all favorites from storage
  Future<void> loadFavorites() async {
    final storedFavorites = await _storageService.loadAllFavorites();

    for (int i = 0; i < storedFavorites.length && i < _favorites.length; i++) {
      _favorites[i] = storedFavorites[i];

      // Load app icon if configured
      if (_favorites[i].isConfigured && _favorites[i].appIcon != null) {
        await loadAppIcon(_favorites[i].packageName!, _favorites[i].appIcon!);
      }
    }

    notifyListeners();
  }

  /// Load and cache an app icon
  Future<void> loadAppIcon(String packageName, Uint8List iconData) async {
    if (_appIconCache.containsKey(packageName)) return;

    try {
      final codec = await ui.instantiateImageCodec(iconData);
      final frame = await codec.getNextFrame();
      _appIconCache[packageName] = frame.image;
    } catch (e) {
      // Ignore icon load errors
      debugPrint('Failed to load icon for $packageName: $e');
    }
  }

  /// Configure a favorite button with an app
  Future<void> configureButton(
    int index,
    AppInfo app,
    List<ButtonDefinition> buttons,
  ) async {
    // Find the button definition to get its isLarge property
    final button = buttons.firstWhere(
      (b) => b.id == 'favorite_$index',
      orElse: () => throw ArgumentError('Button not found: favorite_$index'),
    );

    final config = FavoriteAppConfig(
      packageName: app.packageName,
      appName: app.name,
      appIcon: app.icon,
      isLarge: button.isLarge,
    );

    await _storageService.saveFavorite(index, config);
    _favorites[index] = config;

    // Load the app icon
    if (app.icon != null) {
      await loadAppIcon(app.packageName, app.icon!);
    }

    notifyListeners();
  }

  /// Get favorite at index
  FavoriteAppConfig getFavorite(int index) {
    if (index < 0 || index >= _favorites.length) {
      return FavoriteAppConfig.empty();
    }
    return _favorites[index];
  }

  /// Check if a favorite is configured at index
  bool isConfigured(int index) {
    return index >= 0 &&
        index < _favorites.length &&
        _favorites[index].isConfigured;
  }
}

