import 'package:flutter/material.dart';

class XColor {
  XColor({
    @required this.r,
    @required this.g,
    @required this.b,
  });

  final int r;
  final int g;
  final int b;

  Color getColor() {
    return Color.fromARGB(255, r, g, b);
  }

  Color gradient(XColor color, int div, int max) {
    XColor newColor;
    newColor = new XColor(
      r: r + (((color.r - r) / max) * div).floor(),
      g: g + (((color.g - g) / max) * div).floor(),
      b: b + (((color.b - b) / max) * div).floor(),
    );
    return newColor.getColor();
  }
}