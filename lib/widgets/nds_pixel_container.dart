import 'package:flutter/material.dart';

/// A container that maintains the Nintendo DS 256x192 pixel resolution
/// while scaling to fit the available screen space.
///
/// This widget replaces the Canvas-based MainCanvas by using Transform.scale
/// on a fixed-size SizedBox, allowing all child widgets to work in the
/// native 256x192 coordinate system.
class NDSPixelContainer extends StatelessWidget {
  const NDSPixelContainer({
    super.key,
    this.size = const Size(256, 192),
    required this.child,
  });

  final Size size;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate scale to fit the screen while maintaining aspect ratio
        final scaleX = constraints.maxWidth / size.width;
        final scaleY = constraints.maxHeight / size.height;
        final scale = scaleX < scaleY ? scaleX : scaleY;

        return Center(
          child: Transform.scale(
            scale: scale,
            child: SizedBox(
              width: size.width,
              height: size.height,
              child: child,
            ),
          ),
        );
      },
    );
  }
}
