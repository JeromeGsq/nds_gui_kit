import 'package:flutter/material.dart';
import 'package:nds_gui_kit/widgets/image_pp.dart';

class NDSImageButton extends StatefulWidget {
  const NDSImageButton({
    super.key,
    this.imagePath = 'assets/images/button_large.png',
    this.pressedImagePath = 'assets/images/button_large_pressed.png',
    this.child,
    this.onTap,
  });

  final String imagePath;
  final String pressedImagePath;
  final Widget? child;
  final VoidCallback? onTap;

  @override
  State<NDSImageButton> createState() => _NDSImageButtonState();
}

class _NDSImageButtonState extends State<NDSImageButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      child: Stack(
        children: [
          ImagePP(_isPressed ? widget.pressedImagePath : widget.imagePath),
          if (widget.child != null) Positioned.fill(child: widget.child!),
        ],
      ),
    );
  }
}
