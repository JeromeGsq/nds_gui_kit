import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:nds_gui_kit/canvas/bottom/bottom_screen_painter.dart';
import 'package:nds_gui_kit/canvas/kits/paintable.dart';
import 'package:nds_gui_kit/canvas/kits/text.dart';

class AppButton extends Paintable {
  AppButton({
    required this.canvas,
    required this.image,
    required this.position,
    this.onPressed,
    this.pressedImage,
  });

  final Canvas canvas;
  final ui.Image image;
  final Offset position;
  final VoidCallback? onPressed;
  final ui.Image? pressedImage;

  bool isPressed = false;

  Rect get rect => Rect.fromLTWH(
    position.dx,
    position.dy,
    image.width.toDouble(),
    image.height.toDouble(),
  );

  @override
  void draw() {
    canvas.drawImage(image, position, Paint());

    if (isPressed && pressedImage != null) {
      canvas.drawImage(pressedImage!, position, Paint());
    } else if (isPressed && pressedImage == null) {
      canvas.drawRect(
        rect,
        Paint()..color = Colors.black.withValues(alpha: 0.3),
      );
    }
  }

  void child(Paintable child) {
    child.draw();
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

class AppLargeButton extends AppButton {
  AppLargeButton({
    required super.canvas,
    required super.image,
    required super.position,
    required super.onPressed,
    required super.pressedImage,
    required this.text,
    this.appIcon,
  });

  final String text;
  final ui.Image? appIcon;

  @override
  void draw() {
    super.draw();

    // Draw app icon if available
    if (appIcon != null) {
      final iconSize = 32.0;
      final iconX = position.dx + 7;
      final iconY = position.dy + (image.height - iconSize) / 2;

      canvas.drawImageRect(
        appIcon!,
        Rect.fromLTWH(
          0,
          0,
          appIcon!.width.toDouble(),
          appIcon!.height.toDouble(),
        ),
        Rect.fromLTWH(iconX, iconY, iconSize, iconSize),
        Paint()..filterQuality = FilterQuality.medium,
      );
    }

    // Draw text
    if (text.isNotEmpty) {
      AppText(
        canvas: canvas,
        text: text,
        position: Offset(appIcon != null ? 56 : 64, 16) + position,
        fontSize: 14,
        color: Colors.black,
      ).draw();
    }
  }
}

class AppMainButton extends AppButton {
  AppMainButton({
    required super.canvas,
    required super.image,
    required super.position,
    required super.onPressed,
    required super.pressedImage,
    required this.text,
    this.appIcon,
  });

  final String text;
  final ui.Image? appIcon;

  @override
  void draw() {
    super.draw();

    // Draw app icon if available
    if (appIcon != null) {
      final iconSize = 32.0;
      final iconX = position.dx + 32;
      final iconY = position.dy + (image.height - iconSize) / 2;

      canvas.drawImageRect(
        appIcon!,
        Rect.fromLTWH(
          0,
          0,
          appIcon!.width.toDouble(),
          appIcon!.height.toDouble(),
        ),
        Rect.fromLTWH(iconX, iconY, iconSize, iconSize),
        Paint()..filterQuality = FilterQuality.medium,
      );
    }
  }
}
