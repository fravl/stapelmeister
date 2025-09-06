import 'package:flutter/material.dart';

TextStyle retroText(double size, {Color color = Colors.white}) {
  return TextStyle(
    fontFamily:
        'PressStart2P',
    fontSize: size,
    color: color,
    letterSpacing: 1.5,
    shadows: [
      Shadow(
        blurRadius: 4,
        color: Colors.black,
        offset: Offset(2, 2),
      ),
    ],
  );
}
