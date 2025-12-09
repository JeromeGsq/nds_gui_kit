import 'package:flutter/material.dart';
import 'package:installed_apps/app_info.dart';
import 'package:nds_gui_kit/canvas/bottom/bottom_screen_painter.dart';
import 'package:nds_gui_kit/canvas/kits/canvas.dart';
import 'package:nds_gui_kit/widgets/app_selector_overlay.dart';

class BottomScreenCanvas extends StatefulWidget {
  const BottomScreenCanvas({super.key});

  @override
  State<BottomScreenCanvas> createState() => _BottomScreenCanvasState();
}

class _BottomScreenCanvasState extends State<BottomScreenCanvas> {
  late final BottomScreenPainter _painter;

  @override
  void initState() {
    super.initState();
    _painter = BottomScreenPainter(
      onFavoriteButtonTap: _handleFavoriteButtonTap,
    );
    _painter.favoritesManager.addListener(_onFavoritesChanged);
    _painter.favoritesManager.loadFavorites();
  }

  @override
  void dispose() {
    _painter.favoritesManager.removeListener(_onFavoritesChanged);
    _painter.dispose();
    super.dispose();
  }

  void _onFavoritesChanged() {
    setState(() {}); // Repaint when favorites change
  }

  void _handleFavoriteButtonTap(int index) {
    if (index < 0 || index >= 4) return;

    final favorite = _painter.favoritesManager.getFavorite(index);

    if (favorite.isConfigured) {
      // Launch app (defer to avoid calling during paint)
      Future.microtask(() => _painter.favoritesManager.launchApp(index));
    } else {
      // Show app selector (defer to avoid calling during paint)
      Future.microtask(() {
        if (!mounted) return;
        showDialog(
          context: context,
          barrierDismissible: true,
          barrierColor: Colors.transparent,
          builder: (context) => AppSelectorOverlay(
            onAppSelected: (app) {
              Navigator.of(context).pop();
              _configureButton(index, app);
            },
            onClose: () => Navigator.of(context).pop(),
          ),
        );
      });
    }
  }

  Future<void> _configureButton(int index, AppInfo app) async {
    await _painter.favoritesManager.configureButton(index, app);
    setState(() {}); // Trigger repaint
  }

  @override
  Widget build(BuildContext context) {
    return MainCanvas(
      painter: _painter,
      onTapDown: (pos) => setState(() => touchPosition = pos),
      onTapUp: (_) => setState(() => touchPosition = null),
    );
  }
}
