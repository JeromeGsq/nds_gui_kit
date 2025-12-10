import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nds_gui_kit/widgets/background_top.dart';
import 'package:nds_gui_kit/widgets/battery.dart';
import 'package:nds_gui_kit/widgets/calendar.dart';
import 'package:nds_gui_kit/widgets/clock.dart';
import 'package:nds_gui_kit/widgets/nds_pixel_container.dart';
import 'package:nds_gui_kit/widgets/text.dart';
import 'package:nds_gui_kit/widgets/top_bar.dart';

/// Top screen widget using pure Flutter widgets instead of Canvas
class TopScreen extends StatefulWidget {
  const TopScreen({super.key});

  @override
  State<TopScreen> createState() => _TopScreenState();
}

class _TopScreenState extends State<TopScreen> {
  late Timer _timer;
  String _timeString = '';
  String _dateString = '';

  @override
  void initState() {
    super.initState();
    _updateTime();
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      _updateTime();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _updateTime() {
    final now = DateTime.now();
    setState(() {
      // Format time as HH:mm
      _timeString =
          '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
      // Format date as dd/MM
      _dateString =
          '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.black,
        body: NDSPixelContainer(
          size: const Size(342, 192),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Background
              const NDSBackgroundTop(),

              // Top bar with pseudo, time, date, and battery
              Positioned(
                left: 0,
                top: 0,
                width: 342,
                height: 16,
                child: NDSTopBar(
                  children: [
                    NDSText(text: _timeString, fontSize: 12),
                    NDSText(text: _dateString, fontSize: 12),
                    const NDSBattery(),
                  ],
                ),
              ),

              // Clock
              const Positioned(left: 50, top: 55, child: NDSClock()),

              // Calendar
              const Positioned(right: 49, top: 40, child: NDSCalendar()),
            ],
          ),
        ),
      ),
    );
  }
}
