import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:installed_apps/app_info.dart';
import 'package:installed_apps/installed_apps.dart';
import 'package:nds_gui_kit/canvas/bottom/managers/favorites_manager.dart';
import 'package:nds_gui_kit/canvas/bottom/models/bottom_screen_assets.dart';
import 'package:nds_gui_kit/canvas/bottom/models/button_definition.dart';
import 'package:nds_gui_kit/canvas/bottom/painters/background_painter.dart';
import 'package:nds_gui_kit/canvas/bottom/painters/bottom_bar_painter.dart';
import 'package:nds_gui_kit/canvas/bottom/painters/favorite_buttons_painter.dart';
import 'package:nds_gui_kit/canvas/bottom/painters/overlay_painter.dart';
import 'package:nds_gui_kit/canvas/nds_canvas.dart';
import 'package:nds_gui_kit/models/favorite_app_config.dart';
import 'package:nds_gui_kit/services/overlay_service.dart';
import 'package:nds_gui_kit/widgets/app_selector_overlay.dart';

/// Painter for the bottom screen
/// Uses mixins for modular painting functionality
class BottomScreenPainter extends NDSCanvasPainter
    with
        BackgroundPainter,
        FavoriteButtonsPainter,
        BottomBarPainter,
        OverlayPainter {
  // Managers
  final _favoritesManager = FavoritesManager();

  // State
  final List<ButtonDefinition> _buttons = [];
  String? _pressedButtonId;
  bool _overlayVisible = false;

  // Mixin requirements (instance-specific state)
  @override
  String? get pressedButtonId => _pressedButtonId;

  @override
  List<ButtonDefinition> get buttons => _buttons;

  @override
  List<FavoriteAppConfig> get favorites => _favoritesManager.favorites;

  @override
  Map<String, ui.Image> get appIconCache => _favoritesManager.appIconCache;

  /// Initialize all resources
  Future<void> initialize() async {
    await BottomScreenAssets.ensureLoaded();
    _setupButtons();
    await _favoritesManager.loadFavorites();

    // Listen to favorites changes
    _favoritesManager.addListener(notifyListeners);

    // Listen to overlay changes
    overlaySignal.subscribe((visible) {
      _overlayVisible = visible;
      notifyListeners();
    });

    notifyListeners();
  }

  void _setupButtons() {
    _buttons.clear();
    _setupFavoriteButtons();
  }

  void _setupFavoriteButtons() {
    final assets = BottomScreenAssets.instance;
    final mainW = assets.mainButtonWidth;
    final mainH = assets.mainButtonHeight;
    final largeW = assets.largeButtonWidth;
    final largeH = assets.largeButtonHeight;

    // Top favorite button
    _buttons.add(
      ButtonDefinition(
        isLarge: false,
        rect: Rect.fromLTWH(
          (kNDSWidth - mainW) / 2 + .5,
          (kNDSHeight - mainH) / 2 + .5 - 48,
          mainW,
          mainH,
        ),
        id: 'favorite_0',
        image: assets.buttonMain,
        pressedImage: assets.buttonMainPressed,
      ),
    );

    // Bottom favorite button
    _buttons.add(
      ButtonDefinition(
        isLarge: false,
        rect: Rect.fromLTWH(
          (kNDSWidth - mainW) / 2 + .5,
          (kNDSHeight - mainH) / 2 + .5 + 48,
          mainW,
          mainH,
        ),
        id: 'favorite_1',
        image: assets.buttonMain,
        pressedImage: assets.buttonMainPressed,
      ),
    );

    // Left favorite button
    _buttons.add(
      ButtonDefinition(
        isLarge: true,
        rect: Rect.fromLTWH(
          (kNDSWidth - largeW) / 2 + .5 - 48,
          (kNDSHeight - largeH) / 2 + .5,
          largeW,
          largeH,
        ),
        id: 'favorite_2',
        image: assets.buttonLarge,
        pressedImage: assets.buttonLargePressed,
      ),
    );

    // Right favorite button
    _buttons.add(
      ButtonDefinition(
        isLarge: true,
        rect: Rect.fromLTWH(
          (kNDSWidth - largeW) / 2 + .5 + 48,
          (kNDSHeight - largeH) / 2 + .5,
          largeW,
          largeH,
        ),
        id: 'favorite_3',
        image: assets.buttonLarge,
        pressedImage: assets.buttonLargePressed,
      ),
    );
  }

  // --- Input Handling ---
  void handleTapDown(Offset position) {
    for (final button in _buttons) {
      if (button.containsPoint(position)) {
        _pressedButtonId = button.id;
        notifyListeners();
        return;
      }
    }
    _pressedButtonId = null;
    notifyListeners();
  }

  void handleTapUp(BuildContext context, Offset position) {
    final pressedId = _pressedButtonId;
    _pressedButtonId = null;
    notifyListeners();

    // If overlay is visible, hide it on any tap
    if (_overlayVisible) {
      hideOverlay();
      return;
    }

    if (pressedId == null) return;

    // Check if tap ended on the same button
    for (final button in _buttons) {
      if (button.id == pressedId && button.containsPoint(position)) {
        _handleButtonTap(context, pressedId);
        return;
      }
    }
  }

  void handleLongPress(BuildContext context, Offset position) {
    for (final button in _buttons) {
      if (button.isFavoriteButton && button.containsPoint(position)) {
        final index = button.favoriteIndex;
        if (index != null) {
          _showAppSelector(context, index);
        }
        return;
      }
    }
  }

  void _handleButtonTap(BuildContext context, String buttonId) {
    switch (buttonId) {
      case 'light':
        showOverlay();
        break;
      case 'settings':
        // TODO: Settings action
        break;
      case 'more':
        // TODO: More apps action
        break;
      default:
        if (buttonId.startsWith('favorite_')) {
          final index = int.parse(buttonId.split('_')[1]);
          _handleFavoriteTap(context, index);
        }
    }
  }

  void _handleFavoriteTap(BuildContext context, int index) {
    final config = _favoritesManager.getFavorite(index);
    if (config.isConfigured && config.packageName != null) {
      InstalledApps.startApp(config.packageName!);
    } else {
      _showAppSelector(context, index);
    }
  }

  void _showAppSelector(BuildContext context, int index) {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.transparent,
      builder: (context) => AppSelectorOverlay(
        onAppSelected: (app) {
          Navigator.of(context).pop();
          _configureButton(index, app);
        },
        onClose: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }

  Future<void> _configureButton(int index, AppInfo app) async {
    await _favoritesManager.configureButton(index, app, _buttons);
  }

  // --- Painting ---
  @override
  void paint(Canvas canvas, Size size) {
    drawBackground(canvas);
    drawFavoriteButtons(canvas);
    drawBottomBarButtons(canvas);

    if (_overlayVisible) {
      drawOverlay(canvas);
    }
  }

  @override
  void dispose() {
    _favoritesManager.removeListener(notifyListeners);
    _favoritesManager.dispose();
    super.dispose();
  }
}
