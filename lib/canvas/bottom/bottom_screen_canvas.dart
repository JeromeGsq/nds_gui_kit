import 'package:flutter/material.dart';
import 'package:nds_gui_kit/canvas/bottom/bottom_screen_painter.dart';
import 'package:nds_gui_kit/canvas/nds_canvas.dart';

/// Bottom screen canvas implementation
/// Displays favorite apps and bottom bar buttons
class BottomScreenCanvas extends StatefulWidget {
  const BottomScreenCanvas({super.key});

  @override
  State<BottomScreenCanvas> createState() => _BottomScreenCanvasState();
}

class _BottomScreenCanvasState extends State<BottomScreenCanvas> {
  late BottomScreenPainter _painter;
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    _painter = BottomScreenPainter();
    _loadResources();
  }

  Future<void> _loadResources() async {
    await _painter.initialize();
    if (mounted) {
      setState(() => _isLoaded = true);
    }
  }

  @override
  void dispose() {
    _painter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _loadResources();
    if (!_isLoaded) {
      return const SizedBox.shrink();
    }

    return NDSCanvas(
      painter: _painter,
      onTapDown: (pos) => _painter.handleTapDown(pos),
      onTapUp: (pos) => _painter.handleTapUp(context, pos),
      onLongPress: (pos) => _painter.handleLongPress(context, pos),
    );
  }
}

