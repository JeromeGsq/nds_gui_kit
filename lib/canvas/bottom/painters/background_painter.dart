import 'package:flutter/material.dart';
import 'package:nds_gui_kit/canvas/bottom/models/bottom_screen_assets.dart';
import 'package:nds_gui_kit/canvas/nds_canvas.dart';

/// Mixin that provides background painting functionality
mixin BackgroundPainter {
  /// Draw the tiled background
  void drawBackground(Canvas canvas) {
    if (!BottomScreenAssets.isLoaded) return;

    final bgTile = BottomScreenAssets.instance.bgTile;
    final tileWidth = bgTile.width.toDouble();
    final tileHeight = bgTile.height.toDouble();

    final paint = Paint()..filterQuality = FilterQuality.none;

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
          bgTile,
          Rect.fromLTWH(0, 0, tileWidth, tileHeight),
          Rect.fromLTWH(x, y, tileWidth, tileHeight),
          paint,
        );
      }
    }
  }
}
