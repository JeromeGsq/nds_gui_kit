import 'package:flutter/material.dart';
import 'package:nds_gui_kit/canvas/bottom/bottom_screen_painter.dart';
import 'package:nds_gui_kit/canvas/bottom/managers/favorites_manager.dart';
import 'package:nds_gui_kit/canvas/kits/button.dart';
import 'package:nds_gui_kit/canvas/screen_assets.dart';

class FavoriteButtonsPainter {
  static List<AppButton> _buttons = [];

  static void draw(
    Canvas canvas,
    FavoritesManager favoritesManager,
    Function(int)? onButtonTap,
  ) {
    final assets = ScreenAssets.instance;

    // Get favorite configurations
    final favorite0 = favoritesManager.getFavorite(0);
    final favorite1 = favoritesManager.getFavorite(1);
    final favorite2 = favoritesManager.getFavorite(2);
    final favorite3 = favoritesManager.getFavorite(3);

    // Get app icons from cache
    final icon0 = favorite0.packageName != null
        ? favoritesManager.appIconCache[favorite0.packageName]
        : null;
    final icon1 = favorite1.packageName != null
        ? favoritesManager.appIconCache[favorite1.packageName]
        : null;
    final icon2 = favorite2.packageName != null
        ? favoritesManager.appIconCache[favorite2.packageName]
        : null;
    final icon3 = favorite3.packageName != null
        ? favoritesManager.appIconCache[favorite3.packageName]
        : null;

    _buttons = [
      // Top Button
      AppLargeButton(
        canvas: canvas,
        text: favorite0.appName ?? '',
        appIcon: icon0,
        position: const Offset(34, 26),
        image: assets.buttonMain,
        pressedImage: assets.buttonMainPressed,
        onPressed: () {},
      ),

      // Left Button
      AppMainButton(
        canvas: canvas,
        text: favorite1.appName ?? '',
        appIcon: icon1,
        position: const Offset(34, 74),
        image: assets.buttonLarge,
        pressedImage: assets.buttonLargePressed,
        onPressed: () {},
      ),

      // Right Button
      AppMainButton(
        canvas: canvas,
        text: favorite2.appName ?? '',
        appIcon: icon2,
        position: const Offset(130, 74),
        image: assets.buttonLarge,
        pressedImage: assets.buttonLargePressed,
        onPressed: () {},
      ),

      // Bottom Button
      AppLargeButton(
        canvas: canvas,
        text: favorite3.appName ?? '',
        appIcon: icon3,
        position: const Offset(34, 122),
        image: assets.buttonMain,
        pressedImage: assets.buttonMainPressed,
        onPressed: () {},
      ),
    ];

    for (int i = 0; i < _buttons.length; i++) {
      final button = _buttons[i];

      if (button.containsPoint(touchPosition)) {
        button.tap();
        onButtonTap?.call(i);
      }

      button.draw(canvas);
    }
  }
}
