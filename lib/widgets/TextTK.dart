import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextTK extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color color;
  final FontWeight fontWeight;
  final TextOverflow textOverflow;
  final int maxLine;

  const TextTK(
      {required this.text,
      this.fontSize = 18,
      this.color = Colors.black,
      this.fontWeight = FontWeight.normal,
      this.textOverflow = TextOverflow.visible,
      this.maxLine = 1});

  @override
  Widget build(BuildContext context) {
    return Text(text,
        maxLines: maxLine,
        overflow: textOverflow,
        style: GoogleFonts.getFont('Inter',
            fontSize: fontSize, color: color, fontWeight: fontWeight));
  }
}

extension CapExtension on String {
  String get inCaps =>
      this.length > 0 ? '${this[0].toUpperCase()}${this.substring(1)}' : '';
  String get allInCaps => this.toUpperCase();
  String get capitalizeFirstofEach => this
      .replaceAll(RegExp(' +'), ' ')
      .split(" ")
      .map((str) => str.inCaps)
      .join(" ");
}
