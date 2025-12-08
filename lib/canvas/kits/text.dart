import 'package:flutter/material.dart';
import 'package:nds_gui_kit/canvas/bottom/bottom_screen_painter.dart';
import 'package:nds_gui_kit/canvas/kits/paintable.dart';

class AppText extends Paintable {
  AppText({
    required this.canvas,
    required this.text,
    required this.position,
    required this.fontSize,
    required this.color,
    this.onPressed,
  });

  final Canvas canvas;
  final String text;
  final Offset position;
  final double fontSize;
  final Color color;
  final VoidCallback? onPressed;

  bool isPressed = false;

  Rect get rect =>
      Rect.fromLTWH(position.dx, position.dy, text.length * 12, 12);

  @override
  void draw() {
    final textSpan = TextSpan(
      text: text,
      style: TextStyle(
        color: color,
        fontSize: fontSize,
        fontFamily: 'Nintendo-DS-BIOS',
        fontWeight: FontWeight.w500,
      ),
    );

    final textPainter = TextPainter(
      text: textSpan,
      textAlign: TextAlign.left,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    textPainter.paint(canvas, position);
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
