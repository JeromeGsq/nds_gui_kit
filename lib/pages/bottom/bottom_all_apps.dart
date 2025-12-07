import 'package:flutter/material.dart';
import 'package:installed_apps/app_info.dart';
import 'package:installed_apps/installed_apps.dart';
import 'package:nds_gui_kit/widgets/background_bottom.dart';

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

class NDSAllAppsView extends StatefulWidget {
  const NDSAllAppsView({super.key, required this.onBack});

  final VoidCallback onBack;

  @override
  State<NDSAllAppsView> createState() => _NDSAllAppsViewState();
}

class _NDSAllAppsViewState extends State<NDSAllAppsView> {
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

    setState(() {
      _apps = apps;
    });
  }

  void _launchApp(AppInfo app) {
    InstalledApps.startApp(app.packageName);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: NDSColors.background,
        border: Border.all(color: NDSColors.border, width: 4),
      ),
      child: Column(
        children: [
          // Grid pattern background with apps list
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Grid pattern
                NDSBackgroundBottom(),
                GridView.builder(
                  padding: const EdgeInsets.all(16),
                  physics: const ClampingScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 32,
                    mainAxisSpacing: 32,
                    childAspectRatio: 1,
                  ),
                  itemCount: _apps?.length ?? 0,
                  itemBuilder: (context, index) {
                    final app = _apps![index];
                    return _NDSAppTile(app: app, onTap: () => _launchApp(app));
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NDSAppTile extends StatefulWidget {
  const _NDSAppTile({required this.app, required this.onTap});

  final AppInfo app;
  final VoidCallback onTap;

  @override
  State<_NDSAppTile> createState() => _NDSAppTileState();
}

class _NDSAppTileState extends State<_NDSAppTile> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final icon = widget.app.icon;

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      child: icon != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(26),
              child: Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    child: Image.memory(
                      icon,
                      fit: BoxFit.cover,
                      filterQuality: FilterQuality.none,
                      isAntiAlias: false,
                    ),
                  ),
                ],
              ),
            )
          : const Icon(Icons.apps, size: 32),
    );
  }
}
