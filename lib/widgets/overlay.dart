import 'package:flutter/material.dart';
import 'package:motor/motor.dart';
import 'package:nds_gui_kit/services/overlay_service.dart';
import 'package:signals/signals_flutter.dart';

class NDSOverlay extends StatelessWidget {
  const NDSOverlay({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Watch((context) {
      final isVisible = overlaySignal.value;

      return Stack(
        fit: StackFit.expand,
        children: [
          child,
          IgnorePointer(
            ignoring: !isVisible,
            child: SingleMotionBuilder(
              motion: CupertinoMotion.snappy(),
              value: isVisible ? 1.0 : 0.0,
              builder: (context, opacity, child) {
                if (opacity == 0.0) return const SizedBox.shrink();

                return GestureDetector(
                  onTap: hideOverlay,
                  child: Container(
                    color: Colors.black.withValues(alpha: opacity),
                  ),
                );
              },
            ),
          ),
        ],
      );
    });
  }
}
