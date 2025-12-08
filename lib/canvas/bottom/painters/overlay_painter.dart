import 'package:flutter/material.dart';
import 'package:nds_gui_kit/canvas/nds_canvas.dart';

/// Mixin that provides overlay painting functionality
mixin OverlayPainter {
  /// Draw a full-screen semi-transparent overlay
  void drawOverlay(Canvas canvas) {
    final rect = Rect.fromLTWH(
      0,
      0,
      kNDSWidth.toDouble(),
      kNDSHeight.toDouble(),
    );
    canvas.drawRect(rect, Paint()..color = Colors.black);
  }
}

