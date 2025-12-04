import 'package:external_display/external_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nds_gui_kit/main_page.dart';

const double scaleFactor = 5.625 / 2;

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
void externalDisplayMain() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BottomDisplayView(),
    ),
  );
}

class TopDisplayView extends StatelessWidget {
  const TopDisplayView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SizedBox(width: 1920, height: 1080, child: TopScreen()),
    );
  }
}

class BottomDisplayView extends StatelessWidget {
  const BottomDisplayView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue,
      body: Center(
        child: SizedBox(width: 1240, height: 1080, child: BottomScreen()),
      ),
    );
  }
}
