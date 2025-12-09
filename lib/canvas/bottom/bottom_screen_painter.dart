import 'package:flutter/material.dart';
import 'package:nds_gui_kit/canvas/bottom/managers/favorites_manager.dart';
import 'package:nds_gui_kit/canvas/bottom/painters/favorite_buttons_painter.dart';
import 'package:nds_gui_kit/canvas/bottom/painters/background_painter.dart';
import 'package:nds_gui_kit/canvas/bottom/painters/bottom_bar_painter.dart';
import 'package:nds_gui_kit/canvas/bottom/painters/overlay_painter.dart';
import 'package:nds_gui_kit/canvas/kits/canvas.dart';
import 'package:nds_gui_kit/canvas/kits/dialog.dart';
import 'package:nds_gui_kit/canvas/kits/text.dart';

Offset? touchPosition;
bool overlayVisible = false;

class BottomScreenPainter extends NDSCanvasPainter {
  final Function(int)? onFavoriteButtonTap;

  BottomScreenPainter({this.onFavoriteButtonTap});

  final favoritesManager = FavoritesManager();

  @override
  void paint(Canvas canvas, Size size) {
    if (overlayVisible) {
      OverlayPainter.draw(canvas);
      return;
    }

    BackgroundPainter.draw(canvas);
    BottomBarPainter.draw(canvas);
    FavoriteButtonsPainter.draw(canvas, favoritesManager, onFavoriteButtonTap);

    // AppDialog(
    //     canvas: canvas,
    //     position: const Offset((256 - 206) / 2, (192 - 67) / 2),
    //     size: const Size(206, 67),
    //   )
    //   ..draw(canvas)
    //   ..child(
    //     AppText(
    //       text: 'Dialog',
    //       position: const Offset(10, 10),
    //       fontSize: 14,
    //       color: Colors.white,
    //     ),
    //   );
  }

  @override
  void dispose() {
    favoritesManager.removeListener(notifyListeners);
    favoritesManager.dispose();
    super.dispose();
  }
}
