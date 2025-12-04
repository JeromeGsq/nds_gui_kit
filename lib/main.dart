import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nds_gui_kit/main_page.dart';

const double scaleFactor = 5.625 / 2;
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SizedBox(width: 1920, height: 1080, child: TopScreen()),
    ),
  );
}

@pragma('vm:entry-point')
void externalDisplayMain() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SizedBox(width: 1240, height: 1080, child: BottomScreen()),
    ),
  );
}
