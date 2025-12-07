import 'package:external_display/external_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nds_gui_kit/pages/bottom/bottom.dart';
import 'package:nds_gui_kit/pages/top/top.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  final screens = await externalDisplay.getScreen();
  if (screens.length > 1) {
    await externalDisplay.connect(
      routeName: 'externalDisplayMain',
      targetScreen: 1,
    );
  }

  runApp(const TopDisplayView());
}

@pragma('vm:entry-point')
void externalDisplayMain() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  await Future.delayed(const Duration(milliseconds: 500));
  runApp(BottomDisplayView());
}

class TopDisplayView extends StatelessWidget {
  const TopDisplayView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Transform.scale(
        scale: 2,
        child: Center(
          child: SizedBox(width: 256, height: 192, child: TopScreen()),
        ),
      ),
    );
  }
}

class BottomDisplayView extends StatelessWidget {
  const BottomDisplayView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Center(
        child: SizedBox(width: 256, height: 192, child: BottomScreen()),
      ),
    );
  }
}
