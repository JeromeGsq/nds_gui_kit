import 'package:flutter/material.dart';
import 'package:nds_gui_kit/canvas/bottom/bottom_screen_painter.dart';
import 'package:nds_gui_kit/canvas/kits/canvas.dart';

class BottomScreenCanvas extends StatefulWidget {
  const BottomScreenCanvas({super.key});

  @override
  State<BottomScreenCanvas> createState() => _BottomScreenCanvasState();
}

class _BottomScreenCanvasState extends State<BottomScreenCanvas> {
  @override
  Widget build(BuildContext context) {
    return MainCanvas(
      painter: BottomScreenPainter(),
      onTapDown: (pos) => setState(() => touchPosition = pos),
      onTapUp: (_) => setState(() => touchPosition = null),
    );
  }
}
