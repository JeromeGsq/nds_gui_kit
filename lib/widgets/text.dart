import 'package:flutter/material.dart';

class NDSText extends StatelessWidget {
  const NDSText({
    super.key,
    required this.text,
    this.color = Colors.white,
    this.fontSize = 12,
    this.extraBold = false,
    this.maxLines,
    this.textAlign = TextAlign.center,
  });

  final String text;
  final Color color;
  final double fontSize;
  final bool extraBold;
  final int? maxLines;
  final TextAlign textAlign;

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
              textAlign: textAlign,
              maxLines: maxLines,
              overflow: maxLines != null ? TextOverflow.ellipsis : null,
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
          textAlign: textAlign,
          maxLines: maxLines,
          overflow: maxLines != null ? TextOverflow.ellipsis : null,
          textHeightBehavior: const TextHeightBehavior(
            applyHeightToFirstAscent: false,
          ),
        ),
      ],
    );
  }
}
