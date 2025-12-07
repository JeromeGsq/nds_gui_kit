import 'package:flutter/material.dart';

class ImagePP extends StatelessWidget {
  const ImagePP(
    this.imagePath, {
    super.key,
    this.repeat = ImageRepeat.noRepeat,
    this.scale,
  });

  final String imagePath;
  final ImageRepeat repeat;
  final double? scale;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      imagePath,
      scale: scale ?? 1,
      isAntiAlias: false,
      filterQuality: FilterQuality.none,
      repeat: repeat,
    );
  }
}
