import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:nds_gui_kit/main.dart';
import 'package:nds_gui_kit/widgets/image_pp.dart';

class NDSClock extends StatefulWidget {
  const NDSClock({super.key});

  @override
  NDSClockState createState() => NDSClockState();
}

class NDSClockState extends State<NDSClock> {
  late Timer _timer;
  double _secondsAngle = 0;
  double _minutesAngle = 0;
  double _hoursAngle = 0;

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _updateAngles();
    });

    _updateAngles();
  }

  void _updateAngles() {
    // According to the current time, calculate the angle of the clock hands
    final now = DateTime.now();

    final seconds = now.second.toDouble();
    final minutes = now.minute.toDouble();
    final hours = now.hour.toDouble();

    // Offset by -π/2 to start at 12 o'clock (top) instead of 3 o'clock (right)
    final secondsAngle = (seconds / 60) * 2 * pi - pi / 2;
    final minutesAngle = ((minutes + seconds / 60) / 60) * 2 * pi - pi / 2;
    final hoursAngle = (((hours % 12) + minutes / 60) / 12) * 2 * pi - pi / 2;

    setState(() {
      _secondsAngle = secondsAngle;
      _minutesAngle = minutesAngle;
      _hoursAngle = hoursAngle;
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        ImagePP('assets/images/clock.png'),
        // Hours
        _ClockHand(angle: _hoursAngle, length: 28, color: Colors.grey[600]!),
        // Minutes
        _ClockHand(angle: _minutesAngle, length: 35, color: Colors.grey[700]!),
        // Seconds
        _ClockHand(angle: _secondsAngle, length: 40, color: Colors.red),

        Container(
          width: 5 * scaleFactor,
          height: 5 * scaleFactor,
          color: Colors.grey[700]!,
        ),
      ],
    );
  }
}

class _ClockHand extends StatelessWidget {
  const _ClockHand({
    required this.angle,
    required this.length,
    required this.color,
  });

  final double angle;
  final double length;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: angle,
      child: Transform.scale(
        scale: scaleFactor,
        child: Transform.translate(
          offset: Offset(length / 2, 0),
          child: Container(width: length, height: 2, color: color),
        ),
      ),
    );
  }
}
