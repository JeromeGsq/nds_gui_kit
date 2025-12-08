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
  });

  final String text;

  @override
  void draw() {
    super.draw();

    AppText(
      canvas: canvas,
      text: text,
      position: Offset(64, 16) + position,
      fontSize: 14,
      color: Colors.black,
    ).draw();
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
  });

  final String text;

  @override
  void draw() {
    super.draw();

    AppText(
      canvas: canvas,
      text: text,
      position: Offset(16, 16) + position,
      fontSize: 14,
      color: Colors.black,
    ).draw();
  }
}
