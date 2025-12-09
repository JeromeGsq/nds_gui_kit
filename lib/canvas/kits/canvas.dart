import 'dart:ui' as ui;
import 'package:flutter/material.dart';

/// NDS Screen dimensions
const int kNDSWidth = 256;
const int kNDSHeight = 192;

class MainCanvas extends StatelessWidget {
  const MainCanvas({
    super.key,
    required this.painter,
    this.onTap,
    this.onTapDown,
    this.onTapUp,
    this.onLongPress,
  });

  final NDSCanvasPainter painter;
  final void Function(Offset pixelPosition)? onTap;
  final void Function(Offset pixelPosition)? onTapDown;
  final void Function(Offset pixelPosition)? onTapUp;
  final void Function(Offset pixelPosition)? onLongPress;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate scale to fit the screen while maintaining aspect ratio
        final scaleX = constraints.maxWidth / kNDSWidth;
        final scaleY = constraints.maxHeight / kNDSHeight;
        final scale = scaleX < scaleY ? scaleX : scaleY;

        final scaledWidth = kNDSWidth * scale;
        final scaledHeight = kNDSHeight * scale;

        // Convert screen coordinates to pixel coordinates
        Offset toPixelCoords(Offset screenPos) {
          final dx =
              (screenPos.dx - (constraints.maxWidth - scaledWidth) / 2) / scale;
          final dy =
              (screenPos.dy - (constraints.maxHeight - scaledHeight) / 2) /
              scale;
          return Offset(
            dx.clamp(0, kNDSWidth - 1).toDouble(),
            dy.clamp(0, kNDSHeight - 1).toDouble(),
          );
        }

        return Center(
          child: GestureDetector(
            onTapDown: onTapDown != null || onTap != null
                ? (details) {
                    final pixelPos = toPixelCoords(details.localPosition);
                    onTapDown?.call(pixelPos);
                  }
                : null,
            onTapUp: onTapUp != null || onTap != null
                ? (details) {
                    final pixelPos = toPixelCoords(details.localPosition);
                    onTapUp?.call(pixelPos);
                    onTap?.call(pixelPos);
                  }
                : null,
            onTapCancel: onTapUp != null
                ? () {
                    onTapUp?.call(Offset.zero);
                  }
                : null,
            onLongPressStart: onLongPress != null
                ? (details) {
                    final pixelPos = toPixelCoords(details.localPosition);
                    onLongPress?.call(pixelPos);
                  }
                : null,
            child: SizedBox(
              width: scaledWidth,
              height: scaledHeight,
              child: CustomPaint(
                size: Size(scaledWidth, scaledHeight),
                isComplex: true,
                willChange: painter.shouldRepaint,
                painter: _NDSCanvasPainterWrapper(painter, scale),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Wrapper that handles scaling for the custom painter
class _NDSCanvasPainterWrapper extends CustomPainter {
  _NDSCanvasPainterWrapper(this.painter, this.scale) : super(repaint: painter);

  final NDSCanvasPainter painter;
  final double scale;

  @override
  void paint(Canvas canvas, Size size) {
    // Save the canvas state
    canvas.save();

    // Scale the canvas
    canvas.scale(scale, scale);

    // Clip to NDS bounds
    canvas.clipRect(
      Rect.fromLTWH(0, 0, kNDSWidth.toDouble(), kNDSHeight.toDouble()),
    );

    // Let the painter draw
    painter.paint(canvas, Size(kNDSWidth.toDouble(), kNDSHeight.toDouble()));

    // Restore canvas state
    canvas.restore();
  }

  @override
  bool shouldRepaint(_NDSCanvasPainterWrapper oldDelegate) {
    return painter.shouldRepaint || oldDelegate.painter != painter;
  }
}

/// Abstract base class for NDS canvas painters.
/// Subclasses implement the paint method to draw on a 256x192 canvas.
abstract class NDSCanvasPainter extends ChangeNotifier {
  bool get shouldRepaint => true;

  /// Paint on a 256x192 canvas
  void paint(Canvas canvas, Size size);

  /// Check if a point is within a rectangle (for hit testing)
  bool hitTest(Offset point, Rect rect) {
    return rect.contains(point);
  }

  /// Draw an image at pixel-perfect coordinates
  void drawImage(Canvas canvas, ui.Image image, Offset position) {
    canvas.drawImage(
      image,
      position,
      Paint()..filterQuality = FilterQuality.none,
    );
  }

  /// Draw an image scaled to a destination rect
  void drawImageRect(Canvas canvas, ui.Image image, Rect src, Rect dst) {
    canvas.drawImageRect(
      image,
      src,
      dst,
      Paint()..filterQuality = FilterQuality.none,
    );
  }

  /// Draw a tiled image to fill a rect
  void drawImageTiled(Canvas canvas, ui.Image image, Rect rect) {
    final imgWidth = image.width.toDouble();
    final imgHeight = image.height.toDouble();

    for (double y = rect.top; y < rect.bottom; y += imgHeight) {
      for (double x = rect.left; x < rect.right; x += imgWidth) {
        final srcRect = Rect.fromLTWH(
          0,
          0,
          (rect.right - x).clamp(0, imgWidth),
          (rect.bottom - y).clamp(0, imgHeight),
        );

        final dstRect = Rect.fromLTWH(x, y, srcRect.width, srcRect.height);

        canvas.drawImageRect(
          image,
          srcRect,
          dstRect,
          Paint()
            ..filterQuality = FilterQuality.none
            ..isAntiAlias = false,
        );
      }
    }
  }

  /// Draw text at pixel coordinates
  void drawText(
    Canvas canvas,
    String text,
    Offset position, {
    Color color = Colors.white,
    double fontSize = 12,
    String fontFamily = 'Nintendo-DS-BIOS',
    TextAlign textAlign = TextAlign.left,
    double? maxWidth,
  }) {
    final textSpan = TextSpan(
      text: text,
      style: TextStyle(
        color: color,
        fontSize: fontSize,
        fontFamily: fontFamily,
        fontWeight: FontWeight.w500,
      ),
    );

    final textPainter = TextPainter(
      text: textSpan,
      textAlign: textAlign,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(maxWidth: maxWidth ?? double.infinity);

    // Adjust position based on text alignment
    double dx = position.dx;
    if (textAlign == TextAlign.center) {
      dx -= textPainter.width / 2;
    } else if (textAlign == TextAlign.right) {
      dx -= textPainter.width;
    }

    textPainter.paint(canvas, Offset(dx, position.dy));
  }

  /// Draw a filled rectangle
  void drawRect(Canvas canvas, Rect rect, Color color) {
    canvas.drawRect(rect, Paint()..color = color);
  }

  /// Draw a rectangle border
  void drawRectBorder(
    Canvas canvas,
    Rect rect,
    Color color, {
    double strokeWidth = 1,
  }) {
    canvas.drawRect(
      rect,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth,
    );
  }

  /// Draw a line
  void drawLine(
    Canvas canvas,
    Offset p1,
    Offset p2,
    Color color, {
    double strokeWidth = 1,
  }) {
    canvas.drawLine(
      p1,
      p2,
      Paint()
        ..color = color
        ..strokeWidth = strokeWidth,
    );
  }
}
