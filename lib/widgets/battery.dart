import 'package:flutter/material.dart';
import 'package:nds_gui_kit/widgets/image_pp.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:nds_gui_kit/widgets/text.dart';

class NDSBattery extends StatefulWidget {
  const NDSBattery({super.key});

  @override
  NDSBatteryState createState() => NDSBatteryState();
}

class NDSBatteryState extends State<NDSBattery> {
  final _battery = Battery();
  int _batteryLevel = 100;
  Color _colorLevel = Colors.green;

  @override
  void initState() {
    super.initState();

    updateBatteryLevel();

    _battery.onBatteryStateChanged.listen((state) {
      updateBatteryLevel();
    });
  }

  void updateBatteryLevel() async {
    final batteryLevel = await _battery.batteryLevel;

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
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 2,
      children: [
        NDSText(text: '$_batteryLevel%'),
        Transform.translate(
          offset: Offset(0, -0.5),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Battery background
              // Positioned(
              //   left: 0,
              //   child: Container(
              //     color: Colors.black.withValues(alpha: 0.5),
              //     height: 4,
              //     width: 11,
              //   ),
              // ),
              Positioned(
                left: 0,
                child: Container(
                  color: _colorLevel,
                  height: 2,
                  width: 12 * _batteryLevel / 100,
                ),
              ),
              Positioned(
                left: 0,
                child: Container(
                  color: _colorLevel,
                  height: 4,
                  width: 10 * _batteryLevel / 100,
                ),
              ),

              ImagePP('assets/images/battery.png'),
            ],
          ),
        ),
      ],
    );
  }
}
