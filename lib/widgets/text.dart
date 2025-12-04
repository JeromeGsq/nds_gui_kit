import 'package:flutter/material.dart';

class NDSText extends StatelessWidget {
  const NDSText({
    super.key,
    required this.text,
    this.color = Colors.white,
    this.fontSize = 30,
    this.extraBold = false,
  });

  final String text;
  final Color color;
  final double fontSize;
  final bool extraBold;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (extraBold)
          Transform.translate(
            offset: Offset(2, 0),
            child: Text(
              text,
              style: TextStyle(
                fontSize: fontSize,
                color: Colors.white,
                fontFamily: 'Nintendo-DS-BIOS',
                decoration: TextDecoration.none,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              textHeightBehavior: const TextHeightBehavior(
                applyHeightToFirstAscent: false,
              ),
            ),
          ),

        Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            color: color,
            fontFamily: 'Nintendo-DS-BIOS',
            decoration: TextDecoration.none,
            fontWeight: FontWeight.w500,
          ),

          textAlign: TextAlign.center,
          textHeightBehavior: const TextHeightBehavior(
            applyHeightToFirstAscent: false,
          ),
        ),
      ],
    );
  }
}
