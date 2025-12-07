import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:installed_apps/app_info.dart';
import 'package:installed_apps/installed_apps.dart';
import 'package:nds_gui_kit/canvas/image_cache.dart';
import 'package:nds_gui_kit/canvas/nds_canvas.dart';
import 'package:nds_gui_kit/models/favorite_app_config.dart';
import 'package:nds_gui_kit/services/favorites_storage_service.dart';
import 'package:nds_gui_kit/services/overlay_service.dart';
import 'package:nds_gui_kit/widgets/app_selector_overlay.dart';

/// Bottom screen canvas implementation
class BottomScreenCanvas extends StatefulWidget {
  const BottomScreenCanvas({super.key});

  @override
  State<BottomScreenCanvas> createState() => _BottomScreenCanvasState();
}

class _BottomScreenCanvasState extends State<BottomScreenCanvas> {
  late BottomScreenPainter _painter;
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    _painter = BottomScreenPainter();
    _loadResources();
  }

  Future<void> _loadResources() async {
    await _painter.initialize();
    if (mounted) {
      setState(() => _isLoaded = true);
    }
  }

  @override
  void dispose() {
    _painter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoaded) {
      return const SizedBox.shrink();
    }

    return NDSCanvas(
      painter: _painter,
      onTapDown: (pos) => _painter.handleTapDown(pos),
      onTapUp: (pos) => _painter.handleTapUp(context, pos),
      onLongPress: (pos) => _painter.handleLongPress(context, pos),
    );
  }
}

/// Button definition for hit testing
class _ButtonDef {
  final Rect rect;
  final String id;
  final String imagePath;
  final String? pressedImagePath;

  const _ButtonDef({
    required this.rect,
    required this.id,
    required this.imagePath,
    this.pressedImagePath,
  });
}

/// Painter for the bottom screen
class BottomScreenPainter extends NDSCanvasPainter {
  // Cached images
  ui.Image? _bgTile;
  ui.Image? _buttonMain;
  ui.Image? _buttonMainPressed;
  ui.Image? _buttonLight;
  ui.Image? _buttonSettings;
  ui.Image? _buttonMore;

  // App icon cache
  final Map<String, ui.Image> _appIconCache = {};

  // State
  final _storageService = FavoritesStorageService();
  final List<FavoriteAppConfig> _favorites = List.generate(
    4,
    (_) => FavoriteAppConfig.empty(),
  );
  String? _pressedButtonId;
  bool _overlayVisible = false;

  // Button definitions (will be populated after images load)
  final List<_ButtonDef> _buttons = [];

  // Layout constants
  static const double bottomBarY = 168;
  static const double buttonSpacing = 32;

  Future<void> initialize() async {
    final cache = NDSImageCache.instance;

    // Load all images
    _bgTile = await cache.loadImage('assets/images/bg_tile_bottom.png');
    _buttonMain = await cache.loadImage('assets/images/button_main.png');
    _buttonMainPressed = await cache.loadImage(
      'assets/images/button_main_pressed.png',
    );
    _buttonLight = await cache.loadImage('assets/images/button_light.png');
    _buttonSettings = await cache.loadImage(
      'assets/images/button_settings.png',
    );
    _buttonMore = await cache.loadImage('assets/images/button_more_apps.png');

    // Setup button definitions
    _setupButtons();

    // Load favorites
    await _loadFavorites();

    // Listen to overlay changes
    overlaySignal.subscribe((visible) {
      _overlayVisible = visible;
      notifyListeners();
    });

    notifyListeners();
  }

  void _setupButtons() {
    // Main favorite button (center of screen)
    if (_buttonMain != null) {
      final mainBtnWidth = _buttonMain!.width.toDouble();
      final mainBtnHeight = _buttonMain!.height.toDouble();

      _buttons.add(
        _ButtonDef(
          rect: Rect.fromLTWH(
            (kNDSWidth - mainBtnWidth) / 2 + .5,
            (kNDSHeight - mainBtnHeight) / 2 + .5,
            mainBtnWidth,
            mainBtnHeight,
          ),
          id: 'favorite_0',
          imagePath: 'assets/images/button_main.png',
          pressedImagePath: 'assets/images/button_main_pressed.png',
        ),
      );
    }

    // Bottom bar buttons (hardcoded positions - must match _drawBottomBarButtons)
    const lightButtonX = 6.0;
    const settingsButtonX = 118.0;
    const moreButtonX = 230.0;
    const buttonY = 171.0;

    if (_buttonLight != null) {
      _buttons.add(
        _ButtonDef(
          rect: Rect.fromLTWH(
            lightButtonX,
            buttonY,
            _buttonLight!.width.toDouble(),
            _buttonLight!.height.toDouble(),
          ),
          id: 'light',
          imagePath: 'assets/images/button_light.png',
        ),
      );
    }

    if (_buttonSettings != null) {
      _buttons.add(
        _ButtonDef(
          rect: Rect.fromLTWH(
            settingsButtonX,
            buttonY,
            _buttonSettings!.width.toDouble(),
            _buttonSettings!.height.toDouble(),
          ),
          id: 'settings',
          imagePath: 'assets/images/button_settings.png',
        ),
      );
    }

    if (_buttonMore != null) {
      _buttons.add(
        _ButtonDef(
          rect: Rect.fromLTWH(
            moreButtonX,
            buttonY,
            _buttonMore!.width.toDouble(),
            _buttonMore!.height.toDouble(),
          ),
          id: 'more',
          imagePath: 'assets/images/button_more_apps.png',
        ),
      );
    }
  }

  Future<void> _loadFavorites() async {
    final favorites = await _storageService.loadAllFavorites();
    for (int i = 0; i < favorites.length && i < _favorites.length; i++) {
      _favorites[i] = favorites[i];

      // Load app icon if configured
      if (_favorites[i].isConfigured && _favorites[i].appIcon != null) {
        await _loadAppIcon(_favorites[i].packageName!, _favorites[i].appIcon!);
      }
    }
    notifyListeners();
  }

  Future<void> _loadAppIcon(String packageName, Uint8List iconData) async {
    if (_appIconCache.containsKey(packageName)) return;

    try {
      final codec = await ui.instantiateImageCodec(iconData);
      final frame = await codec.getNextFrame();
      _appIconCache[packageName] = frame.image;
    } catch (e) {
      // Ignore icon load errors
    }
  }

  void handleTapDown(Offset position) {
    // Find which button was pressed
    for (final button in _buttons) {
      if (button.rect.contains(position)) {
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
      if (button.id == pressedId && button.rect.contains(position)) {
        _handleButtonTap(context, pressedId);
        return;
      }
    }
  }

  void handleLongPress(BuildContext context, Offset position) {
    // Check for long press on favorite button
    for (final button in _buttons) {
      if (button.id.startsWith('favorite_') && button.rect.contains(position)) {
        final index = int.parse(button.id.split('_')[1]);
        _showAppSelector(context, index);
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
    final config = _favorites[index];
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
    final config = FavoriteAppConfig(
      packageName: app.packageName,
      appName: app.name,
      appIcon: app.icon,
    );

    await _storageService.saveFavorite(index, config);
    _favorites[index] = config;

    // Load the app icon
    if (app.icon != null) {
      await _loadAppIcon(app.packageName, app.icon!);
    }

    notifyListeners();
  }

  @override
  void paint(Canvas canvas, Size size) {
    // Draw background
    _drawBackground(canvas);

    // Draw main favorite button
    _drawFavoriteButton(canvas, 0);

    // Draw bottom bar buttons
    _drawBottomBarButtons(canvas);

    // Draw overlay if visible
    if (_overlayVisible) {
      _drawOverlay(canvas);
    }
  }

  void _drawBackground(Canvas canvas) {
    if (_bgTile == null) return;

    // Tile the background with scale (original uses 1.4 scale)
    final tileWidth = _bgTile!.width.toDouble();
    final tileHeight = _bgTile!.height.toDouble();

    for (
      double y = -tileWidth / 2;
      y < kNDSHeight + tileWidth / 2;
      y += tileHeight
    ) {
      for (
        double x = -tileWidth / 3;
        x < kNDSWidth + tileWidth / 2;
        x += tileWidth
      ) {
        canvas.drawImageRect(
          _bgTile!,
          Rect.fromLTWH(
            0,
            0,
            _bgTile!.width.toDouble(),
            _bgTile!.height.toDouble(),
          ),
          Rect.fromLTWH(x, y, tileWidth, tileHeight),
          Paint()..filterQuality = FilterQuality.none,
        );
      }
    }
  }

  void _drawFavoriteButton(Canvas canvas, int index) {
    final button = _buttons.firstWhere(
      (b) => b.id == 'favorite_$index',
      orElse: () => throw Exception('Button not found'),
    );

    final isPressed = _pressedButtonId == button.id;
    final image = isPressed ? _buttonMainPressed : _buttonMain;

    if (image == null) return;

    drawImage(canvas, image, button.rect.topLeft);

    // Draw app content
    final config = _favorites[index];
    if (config.isConfigured) {
      _drawConfiguredFavorite(canvas, button.rect, config);
    } else {
      _drawUnconfiguredFavorite(canvas, button.rect);
    }
  }

  void _drawConfiguredFavorite(
    Canvas canvas,
    Rect buttonRect,
    FavoriteAppConfig config,
  ) {
    // Draw app icon if available
    final iconImage = config.packageName != null
        ? _appIconCache[config.packageName]
        : null;

    if (iconImage != null) {
      final iconSize = 48.0;
      final iconX = buttonRect.left + 12;
      final iconY = buttonRect.top + (buttonRect.height - iconSize) / 2;

      canvas.drawImageRect(
        iconImage,
        Rect.fromLTWH(
          0,
          0,
          iconImage.width.toDouble(),
          iconImage.height.toDouble(),
        ),
        Rect.fromLTWH(iconX, iconY, iconSize, iconSize),
        Paint()..filterQuality = FilterQuality.none,
      );
    }

    // Draw app name
    final textX = buttonRect.left + (iconImage != null ? 72 : 12);
    final textY = buttonRect.top + buttonRect.height / 2 - 6;

    drawText(
      canvas,
      config.appName ?? 'App',
      Offset(textX, textY),
      color: Colors.black,
      maxWidth: buttonRect.width - (iconImage != null ? 84 : 24),
    );
  }

  void _drawUnconfiguredFavorite(Canvas canvas, Rect buttonRect) {
    // Draw "+" icon
    final centerX = buttonRect.center.dx;
    final centerY = buttonRect.center.dy - 10;

    // Draw circle outline
    canvas.drawCircle(
      Offset(centerX, centerY),
      20,
      Paint()
        ..color = Colors.black.withValues(alpha: 0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );

    // Draw plus
    drawLine(
      canvas,
      Offset(centerX - 10, centerY),
      Offset(centerX + 10, centerY),
      Colors.black.withValues(alpha: 0.3),
      strokeWidth: 2,
    );
    drawLine(
      canvas,
      Offset(centerX, centerY - 10),
      Offset(centerX, centerY + 10),
      Colors.black.withValues(alpha: 0.3),
      strokeWidth: 2,
    );

    // Draw "Ajouter" text
    drawText(
      canvas,
      'Ajouter',
      Offset(centerX, centerY + 28),
      color: Colors.black.withValues(alpha: 0.5),
      textAlign: TextAlign.center,
      fontSize: 14,
    );
  }

  void _drawBottomBarButtons(Canvas canvas) {
    // Hardcoded button positions for pixel-perfect placement
    const lightButtonX = 6.0;
    const settingsButtonX = 118.0;
    const moreButtonX = 230.0;
    const buttonY = 171.0;

    // Draw light button
    if (_buttonLight != null) {
      drawImage(canvas, _buttonLight!, const Offset(lightButtonX, buttonY));
      if (_pressedButtonId == 'light') {
        drawRect(
          canvas,
          Rect.fromLTWH(
            lightButtonX,
            buttonY,
            _buttonLight!.width.toDouble(),
            _buttonLight!.height.toDouble(),
          ),
          Colors.black.withValues(alpha: 0.3),
        );
      }
    }

    // Draw settings button
    if (_buttonSettings != null) {
      drawImage(
        canvas,
        _buttonSettings!,
        const Offset(settingsButtonX, buttonY),
      );
      if (_pressedButtonId == 'settings') {
        drawRect(
          canvas,
          Rect.fromLTWH(
            settingsButtonX,
            buttonY,
            _buttonSettings!.width.toDouble(),
            _buttonSettings!.height.toDouble(),
          ),
          Colors.black.withValues(alpha: 0.3),
        );
      }
    }

    // Draw more button
    if (_buttonMore != null) {
      drawImage(canvas, _buttonMore!, const Offset(moreButtonX, buttonY));
      if (_pressedButtonId == 'more') {
        drawRect(
          canvas,
          Rect.fromLTWH(
            moreButtonX,
            buttonY,
            _buttonMore!.width.toDouble(),
            _buttonMore!.height.toDouble(),
          ),
          Colors.black.withValues(alpha: 0.3),
        );
      }
    }
  }

  void _drawOverlay(Canvas canvas) {
    // Draw semi-transparent overlay
    drawRect(
      canvas,
      Rect.fromLTWH(0, 0, kNDSWidth.toDouble(), kNDSHeight.toDouble()),
      Colors.black.withValues(alpha: 1),
    );
  }
}
