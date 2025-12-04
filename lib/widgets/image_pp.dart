import 'package:flutter/material.dart';
import 'package:nds_gui_kit/main.dart';

class ImagePP extends StatelessWidget {
  const ImagePP(
    this.imagePath, {
    super.key,
    this.repeat = ImageRepeat.noRepeat,
  });

  final String imagePath;
  final ImageRepeat repeat;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      imagePath,
      scale: 1 / (scaleFactor),
      isAntiAlias: false,
      filterQuality: FilterQuality.none,
      repeat: repeat,
    );
  }
}
