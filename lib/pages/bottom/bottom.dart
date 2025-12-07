import 'package:flutter/material.dart';
import 'package:nds_gui_kit/pages/bottom/bottom_all_apps.dart';
import 'package:nds_gui_kit/pages/bottom/bottom_favorite_apps.dart';
import 'package:nds_gui_kit/services/overlay_service.dart';
import 'package:nds_gui_kit/widgets/background_bottom.dart';
import 'package:nds_gui_kit/widgets/buttons.dart';
import 'package:nds_gui_kit/widgets/overlay.dart';

class BottomScreen extends StatelessWidget {
  const BottomScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return NDSOverlay(
      child: Scaffold(
        extendBody: true,
        body: Stack(
          fit: StackFit.expand,
          children: [
            Positioned(
              top: 0,
              left: 0,
              child: SizedBox(
                height: 192,
                width: 256,
                child: const NDSBackgroundBottom(),
              ),
            ),
            _Body(),
          ],
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 11.75),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              NDSLightButton(onTap: showOverlay),
              NDSSettingsButton(),
              NDSMoreButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class _Body extends StatefulWidget {
  const _Body();

  @override
  State<_Body> createState() => __BodyState();
}

class __BodyState extends State<_Body> {
  int _currentView = 1;

  @override
  Widget build(BuildContext context) {
    if (_currentView == 0) {
      return NDSAllAppsView(onBack: () => setState(() => _currentView = 1));
    } else if (_currentView == 1) {
      return NDSFavoriteAppsView();
    } else {
      return SizedBox();
    }
  }
}
