import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:nds_gui_kit/widgets/image_pp.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:nds_gui_kit/widgets/text.dart';

class NDSBattery extends StatefulWidget {
  const NDSBattery({super.key});

  @override
  NDSBatteryState createState() => NDSBatteryState();
}

class NDSBatteryState extends State<NDSBattery> {
  int _batteryLevel = 100;
  Color _colorLevel = Colors.green;

  @override
  void initState() {
    super.initState();

    updateBatteryLevel();

    Battery().onBatteryStateChanged.listen((state) {
      updateBatteryLevel();
    });
  }

  void updateBatteryLevel() async {
    final batteryLevel = await Battery().batteryLevel;

    setState(() {
      _batteryLevel = batteryLevel.toInt();
      _colorLevel = _getBatteryColor(_batteryLevel);
    });
  }

  Color _getBatteryColor(int level) {
    // Normalize battery level to 0.0 - 1.0
    final normalizedLevel = level / 100.0;

    if (normalizedLevel <= 0.2) {
      // Lerp from red to yellow (0% to 20%)
      final t = normalizedLevel / 0.2; // Map 0.0-0.2 to 0.0-1.0
      return Color.lerp(Colors.red, Colors.yellow, t)!;
    } else {
      // Lerp from yellow to green (20% to 100%)
      final t = (normalizedLevel - 0.2) / 0.8; // Map 0.2-1.0 to 0.0-1.0
      return Color.lerp(Colors.yellow, Colors.green, t)!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 6,
      children: [
        NDSText(text: '$_batteryLevel%'),
        Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              left: 0,
              child: Container(
                color: _colorLevel,
                height: 8,
                width: 32 * _batteryLevel / 100,
              ),
            ),
            Positioned(
              left: 0,
              child: Container(
                color: _colorLevel,
                height: 16,
                width: 26 * _batteryLevel / 100,
              ),
            ),
            ImagePP('assets/images/battery.png'),
          ],
        ),
      ],
    );
  }
}
