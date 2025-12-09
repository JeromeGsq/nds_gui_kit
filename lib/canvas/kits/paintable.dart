import 'dart:ui';

abstract class Paintable {
  void draw(Canvas canvas, {Offset? parentPosition = Offset.zero});
}
