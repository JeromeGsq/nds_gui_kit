import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:nds_gui_kit/canvas/bottom/bottom_screen_painter.dart';

class Button {
  Button({required this.image, required this.position, this.onPressed});

  final ui.Image image;
  final Offset position;
  final VoidCallback? onPressed;

  bool isPressed = false;

  Rect get rect => Rect.fromLTWH(
    position.dx,
    position.dy,
    image.width.toDouble(),
    image.height.toDouble(),
  );

  void draw(Canvas canvas) {
    canvas.drawImage(image, position, Paint());

    if (isPressed) {
      canvas.drawRect(
        rect,
        Paint()..color = Colors.black.withValues(alpha: 0.3),
      );
    }
  }

  void tap() {
    isPressed = true;
    onPressed?.call();
    touchPosition = null;
  }

  bool containsPoint(Offset? position) {
    return rect.contains(position ?? Offset.zero);
  }
}
