import 'package:flutter/material.dart';
import 'package:nds_gui_kit/models/favorite_app_config.dart';
import 'package:nds_gui_kit/widgets/image_pp.dart';
import 'package:nds_gui_kit/widgets/text.dart';

/// A favorite app button that displays an app icon and name
class NDSFavoriteButton extends StatefulWidget {
  const NDSFavoriteButton({
    super.key,
    required this.index,
    required this.config,
    required this.appIcon,
    this.onTap,
    this.onLongPress,
  });

  final int index;
  final FavoriteAppConfig config;
  final MemoryImage? appIcon;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  @override
  State<NDSFavoriteButton> createState() => _NDSFavoriteButtonState();
}

class _NDSFavoriteButtonState extends State<NDSFavoriteButton> {
  bool _isPressed = false;

  bool get _isLarge => widget.index == 0 || widget.index == 3;

  String get _buttonImage => _isLarge
      ? 'assets/images/button_main.png'
      : 'assets/images/button_large.png';

  String get _pressedButtonImage => _isLarge
      ? 'assets/images/button_main_pressed.png'
      : 'assets/images/button_large_pressed.png';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      onLongPress: widget.onLongPress,
      child: Stack(
        children: [
          // Button background
          ImagePP(_isPressed ? _pressedButtonImage : _buttonImage),

          // App icon overlay (32x32) - centered for large buttons, positioned for small
          if (widget.appIcon != null)
            Positioned.fill(
              child: Center(
                child: _isLarge
                    ? Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Image(
                          image: widget.appIcon!,
                          width: 32,
                          height: 32,
                          filterQuality: FilterQuality.none,
                          isAntiAlias: false,
                        ),
                      )
                    : Image(
                        image: widget.appIcon!,
                        width: 32,
                        height: 32,
                        filterQuality: FilterQuality.none,
                        isAntiAlias: false,
                      ),
              ),
            ),

          // App name for large buttons
          if (_isLarge && widget.config.appName != null)
            Positioned(
              left: 0,
              right: 0,
              bottom: 4,
              child: NDSText(
                text: widget.config.appName!,
                fontSize: 10,
                maxLines: 1,
                textAlign: TextAlign.center,
              ),
            ),
        ],
      ),
    );
  }
}
