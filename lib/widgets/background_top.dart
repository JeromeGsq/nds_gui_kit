import 'package:flutter/material.dart';
import 'package:nds_gui_kit/widgets/image_pp.dart';

class NDSBackgroundTop extends StatelessWidget {
  const NDSBackgroundTop({super.key});

  @override
  Widget build(BuildContext context) {
    return ImagePP('assets/images/bg_tile_top.png', repeat: ImageRepeat.repeat);
  }
}
