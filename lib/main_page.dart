import 'package:flutter/material.dart';
import 'package:nds_gui_kit/widgets/background_bottom.dart';
import 'package:nds_gui_kit/widgets/image_button.dart';
import 'package:nds_gui_kit/widgets/buttons.dart';
import 'package:nds_gui_kit/widgets/background_top.dart';
import 'package:nds_gui_kit/widgets/battery.dart';
import 'package:nds_gui_kit/widgets/calendar.dart';
import 'package:nds_gui_kit/widgets/clock.dart';
import 'package:nds_gui_kit/widgets/text.dart';
import 'package:nds_gui_kit/widgets/top_bar.dart';

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
        Positioned(left: 80, top: 113, child: const NDSClock()),
        Positioned(right: 76, top: 72, child: const NDSCalendar()),
      ],
    );
  }
}

class BottomScreen extends StatelessWidget {
  const BottomScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        const NDSBackgroundBottom(),
        Align(alignment: Alignment.bottomCenter, child: NDSSettingsButton()),
        Align(alignment: Alignment.bottomRight, child: NDSMoreButton()),
        Column(
          spacing: 10,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                NDSImageButton(
                  onTap: () {},
                  child: Center(
                    child: NDSText(
                      text: 'Nintendo DS',
                      color: Colors.black,
                      extraBold: true,
                      fontSize: 40,
                    ),
                  ),
                ),
                NDSImageButton(
                  onTap: () {},
                  child: Center(
                    child: NDSText(
                      text: 'GameBoy Advance',
                      color: Colors.black,
                      extraBold: true,
                      fontSize: 40,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                NDSImageButton(
                  onTap: () {},
                  child: Center(
                    child: NDSText(
                      text: 'Nintendo Switch',
                      color: Colors.black,
                      extraBold: true,
                      fontSize: 40,
                    ),
                  ),
                ),
                NDSImageButton(
                  onTap: () {},
                  child: Center(
                    child: NDSText(
                      text: 'GameBoy Color',
                      color: Colors.black,
                      extraBold: true,
                      fontSize: 40,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
