import 'package:flutter/material.dart';
import 'package:nds_gui_kit/canvas/bottom/bottom_screen_painter.dart';
import 'package:nds_gui_kit/canvas/kits/button.dart';
import 'package:nds_gui_kit/canvas/screen_assets.dart';

class FavoriteButtonsPainter {
  static List<Button> _buttons = [];

  static void draw(Canvas canvas) {
    final assets = ScreenAssets.instance;

    _buttons = [
      // Top Button
      Button(
        image: assets.buttonMain,
        pressedImage: assets.buttonMainPressed,
        position: const Offset(34, 26),
      ),

      // Left Button
      Button(
        image: assets.buttonLarge,
        pressedImage: assets.buttonLargePressed,
        position: const Offset(34, 74),
      ),

      // Right Button
      Button(
        image: assets.buttonLarge,
        pressedImage: assets.buttonLargePressed,
        position: const Offset(130, 74),
      ),

      // Bottom Button
      Button(
        image: assets.buttonMain,
        pressedImage: assets.buttonMainPressed,
        position: const Offset(34, 122),
      ),
    ];

    for (final button in _buttons) {
      if (button.containsPoint(touchPosition)) {
        button.tap();
      }

      button.draw(canvas);
    }
  }
}
