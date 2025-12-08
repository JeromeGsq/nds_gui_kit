import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:nds_gui_kit/canvas/bottom/models/button_definition.dart';
import 'package:nds_gui_kit/models/favorite_app_config.dart';

/// Mixin that provides favorite buttons painting functionality
mixin FavoriteButtonsPainter {
  // Required state from the painter
  List<ButtonDefinition> get buttons;
  List<FavoriteAppConfig> get favorites;
  Map<String, ui.Image> get appIconCache;
  String? get pressedButtonId;

  /// Draw all favorite buttons
  void drawFavoriteButtons(Canvas canvas) {
    final favoriteButtons = buttons.where((b) => b.isFavoriteButton);

    for (final button in favoriteButtons) {
      final index = button.favoriteIndex;
      if (index == null) continue;

      final isPressed = pressedButtonId == button.id;
      final image = isPressed ? button.pressedImage : button.image;

      if (image == null) continue;

      _drawButtonImage(canvas, image, button.rect.topLeft);

      // Draw app content
      final config = index < favorites.length ? favorites[index] : null;
      if (config != null && config.isConfigured) {
        _drawConfiguredFavorite(canvas, button.rect, config);
      } else {
        _drawUnconfiguredFavorite(canvas, button.rect);
      }
    }
  }

  void _drawButtonImage(Canvas canvas, ui.Image image, Offset position) {
    canvas.drawImage(
      image,
      position,
      Paint()..filterQuality = FilterQuality.none,
    );
  }

  void _drawConfiguredFavorite(
    Canvas canvas,
    Rect buttonRect,
    FavoriteAppConfig config,
  ) {
    // Draw app icon if available
    final iconImage = config.packageName != null
        ? appIconCache[config.packageName]
        : null;

    if (iconImage != null) {
      _drawAppIcon(canvas, iconImage, buttonRect, config.isLarge);
    }

    // Draw app name
    _drawAppName(canvas, config, buttonRect, iconImage != null);
  }

  void _drawAppIcon(
    Canvas canvas,
    ui.Image iconImage,
    Rect buttonRect,
    bool isLarge,
  ) {
    final iconSize = isLarge ? 40.0 : 32.0;
    final iconX = buttonRect.left + (isLarge ? 8 : 7);
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

  void _drawAppName(
    Canvas canvas,
    FavoriteAppConfig config,
    Rect buttonRect,
    bool hasIcon,
  ) {
    final textX = buttonRect.left + (hasIcon ? (config.isLarge ? 56 : 64) : 12);
    final textY = buttonRect.top + buttonRect.height / 2 - 6.5;
    final maxWidth = buttonRect.width - (hasIcon ? (config.isLarge ? 68 : 84) : 24);

    final textSpan = TextSpan(
      text: config.appName ?? 'App',
      style: const TextStyle(
        color: Colors.black,
        fontSize: 18,
        fontFamily: 'Nintendo-DS-BIOS',
        fontWeight: FontWeight.w500,
      ),
    );

    final textPainter = TextPainter(
      text: textSpan,
      textAlign: TextAlign.left,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(maxWidth: maxWidth);
    textPainter.paint(canvas, Offset(textX, textY));
  }

  void _drawUnconfiguredFavorite(Canvas canvas, Rect buttonRect) {
    final centerX = buttonRect.center.dx;
    final centerY = buttonRect.center.dy - 7;

    final textSpan = const TextSpan(
      text: '-',
      style: TextStyle(
        color: Colors.black,
        fontSize: 18,
        fontFamily: 'Nintendo-DS-BIOS',
        fontWeight: FontWeight.w500,
      ),
    );

    final textPainter = TextPainter(
      text: textSpan,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(centerX - textPainter.width / 2, centerY),
    );
  }
}

