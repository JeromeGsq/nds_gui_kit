import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:nds_gui_kit/main_page.dart';
import 'package:nds_gui_kit/widgets/image_pp.dart';
import 'package:nds_gui_kit/widgets/text.dart';

class NDSTopBar extends StatelessWidget {
  const NDSTopBar({super.key, this.children = const []});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 32,
      child: Stack(
        fit: StackFit.expand,
        children: [
          ImagePP('assets/images/top_bar_bg_1.png', repeat: ImageRepeat.repeat),
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: .only(top: 3),
                  child: NDSText(text: pseudo),
                ),
                Spacer(),
                // for each child, add a spacer
                ...children.map(
                  (child) => Row(
                    children: [
                      _Divider(),
                      Gap(8),
                      Padding(padding: .only(top: 3), child: child),
                      Gap(8),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return ImagePP('assets/images/top_bar_divider.png');
  }
}
