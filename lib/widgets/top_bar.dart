import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:nds_gui_kit/widgets/editable_pseudo.dart';
import 'package:nds_gui_kit/widgets/image_pp.dart';

class NDSTopBar extends StatelessWidget {
  const NDSTopBar({super.key, this.children = const []});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: ImagePP(
            'assets/images/top_bar_bg_1.png',
            repeat: ImageRepeat.repeat,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 4, top: 3),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              NDSEditablePseudo(),
              Spacer(),
              // for each child, add a spacer
              ...children.map(
                (child) => Row(children: [_Divider(), Gap(4), child, Gap(4)]),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(0, -1),
      child: ImagePP('assets/images/top_bar_divider.png'),
    );
  }
}
