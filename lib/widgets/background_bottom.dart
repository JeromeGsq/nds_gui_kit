import 'package:flutter/material.dart';
import 'package:nds_gui_kit/widgets/image_pp.dart';

class NDSBackgroundBottom extends StatelessWidget {
  const NDSBackgroundBottom({super.key});

  @override
  Widget build(BuildContext context) {
    return ImagePP(
      'assets/images/bg_tile_bottom.png',
      scale: 1.4,
      repeat: ImageRepeat.repeat,
    );
  }
}
