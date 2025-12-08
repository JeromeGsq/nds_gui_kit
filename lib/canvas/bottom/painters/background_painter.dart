import 'package:flutter/material.dart';
import 'package:nds_gui_kit/canvas/screen_assets.dart';
import 'package:nds_gui_kit/canvas/kits/canvas.dart';

class BackgroundPainter {
  static void draw(Canvas canvas) {
    final bgTile = ScreenAssets.instance.bgTile;
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
