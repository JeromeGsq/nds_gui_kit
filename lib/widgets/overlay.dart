import 'package:flutter/material.dart';
import 'package:nds_gui_kit/services/overlay_service.dart';
import 'package:signals/signals_flutter.dart';

class NDSOverlay extends StatelessWidget {
  const NDSOverlay({super.key, this.child});

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Watch((context) {
      final isVisible = overlaySignal.value;

      return Stack(
        children: [
          if (child != null) Positioned.fill(child: child!),
          if (isVisible)
            GestureDetector(
              onTap: hideOverlay,
              child: Container(color: Colors.black.withValues(alpha: 1)),
            ),
        ],
      );
    });
  }
}
