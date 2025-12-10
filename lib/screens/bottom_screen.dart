import 'package:flutter/material.dart';
import 'package:installed_apps/app_info.dart';
import 'package:nds_gui_kit/managers/favorites_manager.dart';
import 'package:nds_gui_kit/widgets/app_selector_overlay.dart';
import 'package:nds_gui_kit/widgets/background_bottom.dart';
import 'package:nds_gui_kit/widgets/buttons.dart';
import 'package:nds_gui_kit/widgets/nds_favorite_button.dart';
import 'package:nds_gui_kit/widgets/nds_pixel_container.dart';

/// Bottom screen widget using pure Flutter widgets instead of Canvas
class BottomScreen extends StatefulWidget {
  const BottomScreen({super.key});

  @override
  State<BottomScreen> createState() => _BottomScreenState();
}

class _BottomScreenState extends State<BottomScreen> {
  late FavoritesManager _favoritesManager;
  bool _overlayVisible = false;

  @override
  void initState() {
    super.initState();
    _favoritesManager = FavoritesManager();
    _favoritesManager.addListener(_onFavoritesChanged);
    _favoritesManager.loadFavorites();
  }

  @override
  void dispose() {
    _favoritesManager.removeListener(_onFavoritesChanged);
    _favoritesManager.dispose();
    super.dispose();
  }

  void _onFavoritesChanged() {
    setState(() {}); // Rebuild when favorites change
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.black,
        body: NDSPixelContainer(
          size: const Size(256, 223),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Background
              const NDSBackgroundBottom(),

              // Favorite buttons at exact pixel positions
              Positioned(left: 34, top: 41.5, child: _buildFavoriteButton(0)),
              Positioned(left: 34, top: 89.5, child: _buildFavoriteButton(1)),
              Positioned(left: 130, top: 89.5, child: _buildFavoriteButton(2)),
              Positioned(left: 34, top: 137.5, child: _buildFavoriteButton(3)),

              // Control buttons
              Positioned(
                left: 22,
                bottom: 1 + 8,
                child: NDSLightButton(
                  onTap: () => setState(() => _overlayVisible = true),
                ),
              ),
              Positioned(
                left: 118,
                bottom: 8,
                child: const NDSSettingsButton(),
              ),
              Positioned(right: 21, bottom: 8, child: const NDSMoreButton()),

              // Black overlay
              if (_overlayVisible)
                Positioned.fill(
                  child: GestureDetector(
                    onTap: () => setState(() => _overlayVisible = false),
                    child: Container(color: Colors.black),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFavoriteButton(int index) {
    final config = _favoritesManager.getFavorite(index);
    final appIcon = config.packageName != null
        ? _favoritesManager.appIconCache[config.packageName]
        : null;

    return NDSFavoriteButton(
      index: index,
      config: config,
      appIcon: appIcon,
      onTap: () => _handleFavoriteTap(index),
      onLongPress: () => _handleFavoriteLongPress(index),
    );
  }

  void _handleFavoriteTap(int index) {
    final config = _favoritesManager.getFavorite(index);

    if (config.isConfigured) {
      // Launch the configured app
      _favoritesManager.launchApp(index);
    } else {
      // Show app selector to configure
      _showAppSelector(index);
    }
  }

  void _handleFavoriteLongPress(int index) {
    // Show app selector for reconfiguration
    _showAppSelector(index);
  }

  void _showAppSelector(int index) {
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
  }

  Future<void> _configureButton(int index, AppInfo app) async {
    await _favoritesManager.configureButton(index, app);
  }
}
