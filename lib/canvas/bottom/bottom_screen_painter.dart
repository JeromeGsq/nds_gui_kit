import 'package:flutter/material.dart';
import 'package:nds_gui_kit/canvas/bottom/managers/favorites_manager.dart';
import 'package:nds_gui_kit/canvas/bottom/painters/favorite_buttons_painter.dart';
import 'package:nds_gui_kit/canvas/bottom/painters/background_painter.dart';
import 'package:nds_gui_kit/canvas/bottom/painters/bottom_bar_painter.dart';
import 'package:nds_gui_kit/canvas/bottom/painters/overlay_painter.dart';
import 'package:nds_gui_kit/canvas/kits/canvas.dart';

Offset? touchPosition;
bool overlayVisible = false;

class BottomScreenPainter extends NDSCanvasPainter {
  final _favoritesManager = FavoritesManager();

  @override
  void paint(Canvas canvas, Size size) {
    if (overlayVisible) {
      OverlayPainter.draw(canvas);
      return;
    }

    BackgroundPainter.draw(canvas);
    BottomBarPainter.draw(canvas);
    FavoriteButtonsPainter.draw(canvas);
  }

  @override
  void dispose() {
    _favoritesManager.removeListener(notifyListeners);
    _favoritesManager.dispose();
    super.dispose();
  }
}
