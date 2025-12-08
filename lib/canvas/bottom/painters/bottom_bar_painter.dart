import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:nds_gui_kit/canvas/bottom/models/bottom_screen_assets.dart';

class BottomBarButton {
  const BottomBarButton({
    required this.image,
    required this.position,
    this.onTap,
  });

  final ui.Image image;
  final Offset position;
  final VoidCallback? onTap;

  void draw(Canvas canvas) {
    final paint = Paint()..filterQuality = FilterQuality.none;
    canvas.drawImage(image, position, paint);
  }
}

mixin BottomBarPainter {
  void drawBottomBarButtons(Canvas canvas) {
    final assets = BottomScreenAssets.instance;

    // Light button
    BottomBarButton(
      image: assets.buttonLight,
      position: const Offset(6.0, 171),
      onTap: () {},
    ).draw(canvas);

    // Settings button
    BottomBarButton(
      image: assets.buttonSettings,
      position: const Offset(118, 171),
      onTap: () {},
    ).draw(canvas);

    // More button
    BottomBarButton(
      image: assets.buttonMore,
      position: const Offset(230, 171),
      onTap: () {},
    ).draw(canvas);
  }
}
