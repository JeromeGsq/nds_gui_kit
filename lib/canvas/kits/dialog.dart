import 'package:flutter/material.dart';
import 'package:nds_gui_kit/canvas/kits/paintable.dart';
import 'package:nds_gui_kit/canvas/screen_assets.dart';

class AppDialog extends Paintable {
  AppDialog({required this.canvas, required this.position, required this.size});

  final Canvas canvas;
  final Offset position;
  final Size size;

  @override
  void draw(Canvas canvas, {Offset? parentPosition = Offset.zero}) {
    canvas.drawImageNine(
      ScreenAssets.instance.dialog,
      Rect.fromLTWH(
        8,
        8,
        ScreenAssets.instance.dialog.width.toDouble() - 16,
        ScreenAssets.instance.dialog.height.toDouble() - 16,
      ),
      Rect.fromLTWH(
        position.dx,
        position.dy,
        size.width.toDouble(),
        size.height.toDouble(),
      ),
      Paint()..filterQuality = FilterQuality.none,
    );
  }

  void child(Paintable child) {
    child.draw(canvas, parentPosition: position);
  }
}
