import 'package:flutter/material.dart';
import 'package:nds_gui_kit/widgets/image_pp.dart';

class NDSSettingsButton extends StatefulWidget {
  const NDSSettingsButton({super.key, this.onTap});

  final VoidCallback? onTap;

  @override
  State<NDSSettingsButton> createState() => _NDSSettingsButtonState();
}

class _NDSSettingsButtonState extends State<NDSSettingsButton> {
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
          ImagePP('assets/images/button_settings.png'),
          if (_isPressed)
            Positioned.fill(
              child: ColorFiltered(
                colorFilter: ColorFilter.mode(
                  Colors.black.withValues(alpha: 0.3),
                  BlendMode.srcATop,
                ),
                child: ImagePP('assets/images/button_settings.png'),
              ),
            ),
        ],
      ),
    );
  }
}

class NDSMoreButton extends StatefulWidget {
  const NDSMoreButton({super.key, this.onTap});

  final VoidCallback? onTap;

  @override
  State<NDSMoreButton> createState() => _NDSMoreButtonState();
}

class _NDSMoreButtonState extends State<NDSMoreButton> {
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
          ImagePP('assets/images/button_more_apps.png'),
          if (_isPressed)
            Positioned.fill(
              child: ColorFiltered(
                colorFilter: ColorFilter.mode(
                  Colors.black.withValues(alpha: 0.3),
                  BlendMode.srcATop,
                ),
                child: ImagePP('assets/images/button_more_apps.png'),
              ),
            ),
        ],
      ),
    );
  }
}

class NDSLightButton extends StatefulWidget {
  const NDSLightButton({super.key, this.onTap});

  final VoidCallback? onTap;

  @override
  State<NDSLightButton> createState() => _NDSLightButtonState();
}

class _NDSLightButtonState extends State<NDSLightButton> {
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
          ImagePP('assets/images/button_light.png'),
          if (_isPressed)
            Positioned.fill(
              child: ColorFiltered(
                colorFilter: ColorFilter.mode(
                  Colors.black.withValues(alpha: 0.3),
                  BlendMode.srcATop,
                ),
                child: ImagePP('assets/images/button_light.png'),
              ),
            ),
        ],
      ),
    );
  }
}
