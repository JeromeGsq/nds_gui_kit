import 'package:flutter/material.dart';
import 'package:nds_gui_kit/canvas/kits/button.dart';
import 'package:nds_gui_kit/canvas/bottom/bottom_screen_painter.dart';
import 'package:nds_gui_kit/canvas/screen_assets.dart';

class BottomBarPainter {
  static List<AppButton> _buttons = [];

  static void draw(Canvas canvas) {
    final assets = ScreenAssets.instance;

    // Light button
    _buttons = [
      AppButton(
        canvas: canvas,
        image: assets.buttonLight,
        position: const Offset(6, 171),
        onPressed: () {
          overlayVisible = true;
        },
      ),

      // Settings button
      AppButton(
        canvas: canvas,
        image: assets.buttonSettings,
        position: const Offset(118, 171),
        onPressed: () {},
      ),

      // More button
      AppButton(
        canvas: canvas,
        image: assets.buttonMore,
        position: const Offset(230, 171),
        onPressed: () {},
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
