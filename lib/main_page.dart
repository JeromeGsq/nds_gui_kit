import 'package:flutter/material.dart';
import 'package:nds_gui_kit/widgets/background_bottom.dart';
import 'package:nds_gui_kit/widgets/background_top.dart';
import 'package:nds_gui_kit/widgets/battery.dart';
import 'package:nds_gui_kit/widgets/clock.dart';
import 'package:nds_gui_kit/widgets/text.dart';
import 'package:nds_gui_kit/widgets/top_bar.dart';

const pseudo = 'Hello';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue,
      body: Center(
        child: SizedBox(width: 1920, height: 1080, child: TopScreen()),
      ),
    );
  }
}

class TopScreen extends StatelessWidget {
  const TopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        const NDSBackgroundTop(),
        Positioned(
          left: 0,
          top: 0,
          right: 0,
          child: NDSTopBar(
            children: [
              NDSText(
                text: TimeOfDay.fromDateTime(DateTime.now()).format(context),
              ),
              NDSText(
                text:
                    "${DateTime.now().day.toString().padLeft(2, '0')}/${DateTime.now().month.toString().padLeft(2, '0')}",
              ),
              NDSBattery(),
            ],
          ),
        ),

        // Content
        Positioned(left: 121, top: 74, child: const NDSClock()),
      ],
    );
  }
}

class BottomScreen extends StatelessWidget {
  const BottomScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const NDSBackgroundBottom();
  }
}
