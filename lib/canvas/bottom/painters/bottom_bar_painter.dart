import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:nds_gui_kit/canvas/bottom/models/bottom_screen_assets.dart';

class BottomBar {
  static List<BottomBarButton> _buttons = [];

  static void tap(Offset position) {
    for (final button in _buttons) {
      if (button.containsPoint(position)) {
        button.onTap?.call();
      }
    }
  }

  static void draw(Canvas canvas) {
    final assets = BottomScreenAssets.instance;

    // Light button
    _buttons = [
      BottomBarButton(
        image: assets.buttonLight,
        position: const Offset(6.0, 171),
        onTap: () {},
      ),

      // Settings button
      BottomBarButton(
        image: assets.buttonSettings,
        position: const Offset(118, 171),
        onTap: () {},
      ),

      // More button
      BottomBarButton(
        image: assets.buttonMore,
        position: const Offset(230, 171),
        onTap: () {},
      ),
    ];

    for (final button in _buttons) {
      button.draw(canvas);
    }
  }
}

class BottomBarButton {
  BottomBarButton({required this.image, required this.position, this.onTap});

  final ui.Image image;
  final Offset position;
  final VoidCallback? onTap;

  late Rect rect;

  void draw(Canvas canvas) {
    final paint = Paint()..filterQuality = FilterQuality.none;
    canvas.drawImage(image, position, paint);

    rect = Rect.fromLTWH(
      position.dx,
      position.dy,
      image.width.toDouble(),
      image.height.toDouble(),
    );
  }

  bool containsPoint(Offset position) {
    return rect.contains(position);
  }
}
