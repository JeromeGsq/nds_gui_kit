import 'package:external_display/external_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nds_gui_kit/canvas/bottom/bottom_screen_canvas.dart';
import 'package:nds_gui_kit/canvas/image_cache.dart';
import 'package:nds_gui_kit/canvas/kits/canvas.dart';
import 'package:nds_gui_kit/canvas/screen_assets.dart';
import 'package:nds_gui_kit/canvas/top/top_screen_canvas.dart';

Future<void> _init() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  await MainImageCache.instance.preloadAllImages();
  await ScreenAssets.ensureLoaded();
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

  runApp(const BottomDisplayView());
}

@pragma('vm:entry-point')
void externalDisplayMain() async {
  await _init();
  await Future.delayed(const Duration(milliseconds: 100));

  runApp(BottomDisplayView());
}

class TopDisplayView extends StatelessWidget {
  const TopDisplayView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LayoutBuilder(
        builder: (context, constraints) {
          // Calculate scale to fit the screen
          final scaleX = constraints.maxWidth / kNDSWidth;
          final scaleY = constraints.maxHeight / kNDSHeight;
          var scale = scaleX < scaleY ? scaleX : scaleY;

          return Center(
            child: SizedBox(
              width: kNDSWidth * scale,
              height: kNDSHeight * scale,
              child: const TopScreenCanvas(),
            ),
          );
        },
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
      home: LayoutBuilder(
        builder: (context, constraints) {
          // Calculate scale to fit the screen
          final scaleX = constraints.maxWidth / kNDSWidth;
          final scaleY = constraints.maxHeight / kNDSHeight;
          var scale = scaleX < scaleY ? scaleX : scaleY;

          return Center(
            child: SizedBox(
              width: kNDSWidth * scale,
              height: kNDSHeight * scale,
              child: const BottomScreenCanvas(),
            ),
          );
        },
      ),
    );
  }
}
