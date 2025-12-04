import 'package:flutter/material.dart';

class NDSText extends StatelessWidget {
  const NDSText({super.key, required this.text, this.color = Colors.white});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(fontSize: 32, color: color),
      textAlign: TextAlign.center,
      textHeightBehavior: TextHeightBehavior(applyHeightToFirstAscent: false),
    );
  }
}
