import 'dart:typed_data';

import 'package:android_intent_plus/android_intent.dart';
import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:nds_gui_kit/widgets/image_pp.dart';
import 'package:nds_gui_kit/widgets/text.dart';

class NDSSettingsButton extends StatefulWidget {
  const NDSSettingsButton({super.key});

  @override
  State<NDSSettingsButton> createState() => _NDSSettingsButtonState();
}

class _NDSSettingsButtonState extends State<NDSSettingsButton> {
  bool _isPressed = false;

  void _openSettings() {
    const intent = AndroidIntent(action: 'android.settings.SETTINGS');
    intent.launch();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: () => _openSettings(),
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
  const NDSMoreButton({super.key});

  @override
  State<NDSMoreButton> createState() => _NDSMoreButtonState();
}

class _NDSMoreButtonState extends State<NDSMoreButton> {
  bool _isPressed = false;

  void _showAppsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const NDSAppsBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: () => _showAppsBottomSheet(context),
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

// NDS Theme Colors
class NDSColors {
  static const Color background = Color(0xFF9E9E9E);
  static const Color backgroundDark = Color(0xFF787878);
  static const Color border = Color(0xFF404040);
  static const Color accent = Color(0xFF5888F8);
  static const Color accentLight = Color(0xFFB0C8F8);
  static const Color white = Color(0xFFF8F8F8);
  static const Color gridLine = Color(0xFF888888);
}

class NDSAppsBottomSheet extends StatefulWidget {
  const NDSAppsBottomSheet({super.key});

  @override
  State<NDSAppsBottomSheet> createState() => _NDSAppsBottomSheetState();
}

class _NDSAppsBottomSheetState extends State<NDSAppsBottomSheet> {
  List<Application>? _apps;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadApps();
  }

  Future<void> _loadApps() async {
    final apps = await DeviceApps.getInstalledApplications(
      includeAppIcons: true,
      includeSystemApps: false,
      onlyAppsWithLaunchIntent: true,
    );
    apps.sort(
      (a, b) => a.appName.toLowerCase().compareTo(b.appName.toLowerCase()),
    );
    setState(() {
      _apps = apps;
      _loading = false;
    });
  }

  void _launchApp(Application app) {
    DeviceApps.openApp(app.packageName);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: BoxDecoration(
        color: NDSColors.background,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(0)),
        border: Border.all(color: NDSColors.border, width: 4),
      ),
      child: Column(
        children: [
          // Header with NDS style
          _buildHeader(),
          // Grid pattern background with apps list
          Expanded(
            child: Stack(
              children: [
                // Grid pattern
                CustomPaint(painter: NDSGridPainter(), size: Size.infinite),
                // Apps list
                _loading
                    ? const Center(
                        child: NDSText(
                          text: 'Loading...',
                          color: Colors.black,
                          fontSize: 32,
                        ),
                      )
                    : _buildAppsList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: BoxDecoration(
        color: NDSColors.accent,
        border: Border(bottom: BorderSide(color: NDSColors.border, width: 4)),
      ),
      child: Row(
        children: [
          // Blue corner decoration
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: NDSColors.accentLight,
              border: Border.all(color: NDSColors.border, width: 2),
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: NDSText(
              text: 'Applications',
              color: Colors.white,
              fontSize: 36,
              extraBold: true,
            ),
          ),
          // Close button
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: NDSColors.white,
                border: Border.all(color: NDSColors.border, width: 3),
              ),
              child: const Center(
                child: NDSText(text: 'X', color: Colors.black, fontSize: 24),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _apps?.length ?? 0,
      itemBuilder: (context, index) {
        final app = _apps![index];
        return _NDSAppTile(app: app, onTap: () => _launchApp(app));
      },
    );
  }
}

class _NDSAppTile extends StatefulWidget {
  const _NDSAppTile({required this.app, required this.onTap});

  final Application app;
  final VoidCallback onTap;

  @override
  State<_NDSAppTile> createState() => _NDSAppTileState();
}

class _NDSAppTileState extends State<_NDSAppTile> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final hasIcon = widget.app is ApplicationWithIcon;
    final Uint8List? icon = hasIcon
        ? (widget.app as ApplicationWithIcon).icon
        : null;

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: _isPressed ? NDSColors.backgroundDark : NDSColors.white,
          border: Border.all(color: NDSColors.border, width: 3),
          boxShadow: _isPressed
              ? []
              : [
                  BoxShadow(
                    color: NDSColors.border.withValues(alpha: 0.5),
                    offset: const Offset(4, 4),
                    blurRadius: 0,
                  ),
                ],
        ),
        child: Row(
          children: [
            // App icon with NDS frame
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: NDSColors.background,
                border: Border.all(color: NDSColors.border, width: 2),
              ),
              child: icon != null
                  ? Image.memory(icon, fit: BoxFit.cover)
                  : const Icon(Icons.apps, size: 40),
            ),
            const SizedBox(width: 16),
            // App name
            Expanded(
              child: NDSText(
                text: widget.app.appName,
                color: Colors.black,
                fontSize: 28,
              ),
            ),
            // Arrow indicator
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: NDSColors.accent,
                border: Border.all(color: NDSColors.border, width: 2),
              ),
              child: const Center(
                child: NDSText(text: '>', color: Colors.white, fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NDSGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = NDSColors.gridLine.withValues(alpha: 0.3)
      ..strokeWidth = 1;

    const gridSize = 32.0;

    // Vertical lines
    for (double x = 0; x < size.width; x += gridSize) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    // Horizontal lines
    for (double y = 0; y < size.height; y += gridSize) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
