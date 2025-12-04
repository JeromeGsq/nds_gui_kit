import 'package:flutter/material.dart';

class NDSText extends StatelessWidget {
  const NDSText({super.key, required this.text, this.color = Colors.white});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 30,
        color: color,
        fontFamily: 'Nintendo-DS-BIOS',
        decoration: TextDecoration.none,
        fontWeight: FontWeight.w500,
      ),
      textAlign: TextAlign.center,
      textHeightBehavior: const TextHeightBehavior(
        applyHeightToFirstAscent: false,
      ),
    );
  }
}
