import 'package:flutter/material.dart';
import 'package:nds_gui_kit/canvas/bottom/bottom_screen_painter.dart';
import 'package:nds_gui_kit/canvas/kits/canvas.dart';

class OverlayPainter {
  static void draw(Canvas canvas) {
    final rect = Rect.fromLTWH(
      0,
      0,
      kNDSWidth.toDouble(),
      kNDSHeight.toDouble(),
    );

    if (touchPosition != null && rect.contains(touchPosition!)) {
      overlayVisible = false;
    }

    // Overlay
    canvas.drawRect(rect, Paint()..color = Colors.black);
  }
}
