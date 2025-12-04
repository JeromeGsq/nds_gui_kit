import 'package:flutter/material.dart';
import 'package:nds_gui_kit/widgets/background_bottom.dart';
import 'package:nds_gui_kit/widgets/background_top.dart';
import 'package:nds_gui_kit/widgets/clock.dart';

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
