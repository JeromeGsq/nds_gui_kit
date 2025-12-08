import 'package:flutter/material.dart';
import 'package:nds_gui_kit/canvas/bottom/bottom_screen_painter.dart';
import 'package:nds_gui_kit/canvas/kits/button.dart';
import 'package:nds_gui_kit/canvas/screen_assets.dart';

class FavoriteButtonsPainter {
  static List<AppButton> _buttons = [];

  static void draw(Canvas canvas) {
    final assets = ScreenAssets.instance;

    _buttons = [
      // Top Button
      AppLargeButton(
        canvas: canvas,
        text: '',
        position: const Offset(34, 26),
        image: assets.buttonMain,
        pressedImage: assets.buttonMainPressed,
        onPressed: () {},
      ),

      // Left Button
      AppMainButton(
        canvas: canvas,
        text: '',
        position: const Offset(34, 74),
        image: assets.buttonLarge,
        pressedImage: assets.buttonLargePressed,
        onPressed: () {},
      ),

      // Right Button
      AppMainButton(
        canvas: canvas,
        text: '',
        position: const Offset(130, 74),
        image: assets.buttonLarge,
        pressedImage: assets.buttonLargePressed,
        onPressed: () {},
      ),

      // Bottom Button
      AppLargeButton(
        canvas: canvas,
        text: '',
        position: const Offset(34, 122),
        image: assets.buttonMain,
        pressedImage: assets.buttonMainPressed,
        onPressed: () {},
      ),
    ];

    for (final button in _buttons) {
      if (button.containsPoint(touchPosition)) {
        button.tap();
      }

      button.draw();
    }
  }
}
