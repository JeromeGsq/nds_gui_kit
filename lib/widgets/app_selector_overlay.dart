import 'package:flutter/material.dart';
import 'package:installed_apps/app_info.dart';
import 'package:installed_apps/installed_apps.dart';
import 'package:nds_gui_kit/widgets/background_bottom.dart';
import 'package:nds_gui_kit/widgets/text.dart';

class NDSColors {
  static const Color background = Color(0xFF9E9E9E);
  static const Color backgroundDark = Color(0xFF787878);
  static const Color border = Color(0xFF404040);
  static const Color accent = Color(0xFF5888F8);
  static const Color accentLight = Color(0xFFB0C8F8);
  static const Color white = Color(0xFFF8F8F8);
  static const Color gridLine = Color(0xFF888888);
}

class AppSelectorOverlay extends StatefulWidget {
  const AppSelectorOverlay({
    super.key,
    required this.onAppSelected,
    required this.onClose,
  });

  final Function(AppInfo) onAppSelected;
  final VoidCallback onClose;

  @override
  State<AppSelectorOverlay> createState() => _AppSelectorOverlayState();
}

class _AppSelectorOverlayState extends State<AppSelectorOverlay> {
  List<AppInfo>? _apps;

  @override
  void initState() {
    super.initState();
    _loadApps();
  }

  Future<void> _loadApps() async {
    final apps = await InstalledApps.getInstalledApps(
      true, // exclude system apps
      true, // with icon
      '', // package name prefix filter
    );

    apps.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

    if (mounted) {
      setState(() {
        _apps = apps;
      });
    }
  }

  void _handleAppTap(AppInfo app) {
    widget.onAppSelected(app);
  }

  void _handleClose() {
    widget.onClose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleClose,
      child: Container(
        color: Colors.black.withValues(alpha: 0.7),
        child: Center(
          child: GestureDetector(
            onTap: () {}, // Prevent closing when tapping inside
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.8,
              decoration: BoxDecoration(
                color: NDSColors.background,
                border: Border.all(color: NDSColors.border, width: 4),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  // Header
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: NDSColors.backgroundDark,
                      border: Border(
                        bottom: BorderSide(color: NDSColors.border, width: 2),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        NDSText(
                          text: 'Sélectionner une application',
                          color: Colors.white,
                          extraBold: true,
                          fontSize: 14,
                        ),
                        GestureDetector(
                          onTap: _handleClose,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            child: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Apps list
                  Expanded(
                    child: _apps == null
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: NDSColors.accent,
                            ),
                          )
                        : Stack(
                            fit: StackFit.expand,
                            children: [
                              NDSBackgroundBottom(),
                              ListView.builder(
                                padding: const EdgeInsets.all(16),
                                physics: const ClampingScrollPhysics(),
                                itemCount: _apps!.length,
                                itemBuilder: (context, index) {
                                  final app = _apps![index];
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: _AppTile(
                                      app: app,
                                      onTap: () => _handleAppTap(app),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AppTile extends StatefulWidget {
  const _AppTile({required this.app, required this.onTap});

  final AppInfo app;
  final VoidCallback onTap;

  @override
  State<_AppTile> createState() => _AppTileState();
}

class _AppTileState extends State<_AppTile> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final icon = widget.app.icon;

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      child: Container(
        height: 70,
        decoration: BoxDecoration(
          color: _isPressed
              ? NDSColors.backgroundDark
              : NDSColors.white.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: NDSColors.border, width: 2),
          boxShadow: _isPressed
              ? []
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 3,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Row(
          children: [
            // Icon on the left
            Container(
              width: 70,
              height: 70,
              padding: const EdgeInsets.all(10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: icon != null
                    ? Image.memory(
                        icon,
                        fit: BoxFit.cover,
                        filterQuality: FilterQuality.none,
                        isAntiAlias: false,
                      )
                    : Container(
                        color: NDSColors.backgroundDark,
                        child: const Icon(
                          Icons.apps,
                          size: 28,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
            // App name on the right
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: NDSText(
                  text: widget.app.name,
                  color: Colors.black,
                  fontSize: 12,
                  maxLines: 2,
                  textAlign: TextAlign.left,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
