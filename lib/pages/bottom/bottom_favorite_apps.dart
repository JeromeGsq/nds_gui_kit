import 'package:flutter/material.dart';
import 'package:installed_apps/app_info.dart';
import 'package:installed_apps/installed_apps.dart';
import 'package:nds_gui_kit/models/favorite_app_config.dart';
import 'package:nds_gui_kit/services/favorites_storage_service.dart';
import 'package:nds_gui_kit/widgets/app_selector_overlay.dart';
import 'package:nds_gui_kit/widgets/image_button.dart';
import 'package:nds_gui_kit/widgets/text.dart';

class NDSFavoriteAppsView extends StatefulWidget {
  const NDSFavoriteAppsView({super.key});

  @override
  State<NDSFavoriteAppsView> createState() => _NDSFavoriteAppsViewState();
}

class _NDSFavoriteAppsViewState extends State<NDSFavoriteAppsView> {
  final _storageService = FavoritesStorageService();
  final List<FavoriteAppConfig> _favorites = List.generate(
    4,
    (_) => FavoriteAppConfig.empty(),
  );
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final favorites = await _storageService.loadAllFavorites();
    setState(() {
      for (int i = 0; i < favorites.length; i++) {
        _favorites[i] = favorites[i];
      }
      _isLoading = false;
    });
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
        onClose: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }

  Future<void> _configureButton(int index, AppInfo app) async {
    final config = FavoriteAppConfig(
      packageName: app.packageName,
      appName: app.name,
      appIcon: app.icon,
    );

    await _storageService.saveFavorite(index, config);
    setState(() {
      _favorites[index] = config;
    });
  }

  void _launchApp(int index) {
    final config = _favorites[index];
    if (config.isConfigured && config.packageName != null) {
      InstalledApps.startApp(config.packageName!);
    }
  }

  void _handleButtonTap(int index) {
    final config = _favorites[index];
    if (config.isConfigured) {
      _launchApp(index);
    } else {
      _showAppSelector(index);
    }
  }

  void _handleButtonLongPress(int index) {
    _showAppSelector(index);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      spacing: 10,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _FavoriteButton(
              config: _favorites[0],
              onTap: () => _handleButtonTap(0),
              onLongPress: () => _handleButtonLongPress(0),
            ),
            // _FavoriteButton(
            //   config: _favorites[1],
            //   onTap: () => _handleButtonTap(1),
            //   onLongPress: () => _handleButtonLongPress(1),
            // ),
          ],
        ),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //   children: [
        //     _FavoriteButton(
        //       config: _favorites[2],
        //       onTap: () => _handleButtonTap(2),
        //       onLongPress: () => _handleButtonLongPress(2),
        //     ),
        //     _FavoriteButton(
        //       config: _favorites[3],
        //       onTap: () => _handleButtonTap(3),
        //       onLongPress: () => _handleButtonLongPress(3),
        //     ),
        //   ],
        // ),
      ],
    );
  }
}

class _FavoriteButton extends StatelessWidget {
  const _FavoriteButton({
    required this.config,
    required this.onTap,
    required this.onLongPress,
  });

  final FavoriteAppConfig config;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: onLongPress,
      child: NDSImageButton(
        imagePath: 'assets/images/button_main.png',
        pressedImagePath: 'assets/images/button_main_pressed.png',
        onTap: onTap,
        child: config.isConfigured
            ? _ConfiguredButton(config: config)
            : _UnconfiguredButton(),
      ),
    );
  }
}

class _ConfiguredButton extends StatelessWidget {
  const _ConfiguredButton({required this.config});

  final FavoriteAppConfig config;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (config.appIcon != null)
          Padding(
            padding: const EdgeInsets.all(12),
            child: Image.memory(
              config.appIcon!,
              fit: BoxFit.contain,
              filterQuality: FilterQuality.none,
              isAntiAlias: false,
            ),
          ),
        SizedBox(width: 12),
        Expanded(
          child: Center(
            child: NDSText(
              text: config.appName ?? 'App',
              color: Colors.black,
              maxLines: 2,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}

class _UnconfiguredButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.add_circle_outline,
            size: 48,
            color: Colors.black.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 8),
          NDSText(
            text: 'Ajouter',
            color: Colors.black.withValues(alpha: 0.5),
            extraBold: true,
            fontSize: 14,
          ),
        ],
      ),
    );
  }
}
