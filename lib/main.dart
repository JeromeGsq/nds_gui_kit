import 'package:external_display/external_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nds_gui_kit/screens/bottom_screen.dart';
import 'package:nds_gui_kit/screens/top_screen.dart';

Future<void> _init() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
}

void main() async {
  await _init();

  final screens = await externalDisplay.getScreen();
  if (screens.length > 1) {
    await externalDisplay.connect(
      routeName: 'externalDisplayMain',
      targetScreen: 1,
    );
  }

  runApp(const TopScreen());
}

@pragma('vm:entry-point')
void externalDisplayMain() async {
  await _init();
  await Future.delayed(const Duration(milliseconds: 100));

  runApp(const BottomScreen());
}
