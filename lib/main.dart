import 'package:external_display/external_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nds_gui_kit/canvas/bottom_screen_canvas.dart';
import 'package:nds_gui_kit/canvas/image_cache.dart';
import 'package:nds_gui_kit/canvas/nds_canvas.dart';
import 'package:nds_gui_kit/canvas/top_screen_canvas.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  // Preload all images
  await NDSImageCache.instance.preloadAllImages();

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

  // Preload all images for external display
  await NDSImageCache.instance.preloadAllImages();

  runApp(BottomDisplayView());
}

class TopDisplayView extends StatelessWidget {
  const TopDisplayView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: Colors.black),
      home: Scaffold(
        backgroundColor: Colors.black,
        body: LayoutBuilder(
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
      theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: Colors.black),
      home: Scaffold(
        backgroundColor: Colors.black,
        body: LayoutBuilder(
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
      ),
    );
  }
}
