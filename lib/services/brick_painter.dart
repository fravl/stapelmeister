import 'dart:math';
import 'package:flutter/material.dart';
import 'package:stapelmeister/components/block.dart';

class BrickPainter {
  static int _count = 0;

  static void reset() {
    _count = 0;
  }

  static Paint nextPaint() {
    final color = _progressiveColor(_count);
    _count++;
    return Paint()..color = color;
  }

  static Paint paintFromBlock(Block block) {
    return Paint()..color = block.paint.color;
  }

  static Color _progressiveColor(int index) {
    const double hueStart = 200; // blue
    const double hueEnd = 360 + hueStart;
    const double hueRange = hueEnd - hueStart;

    // Cycle through 200 distinct hues
    final tHue = (index % 200) / 200.0;
    final hue = (hueStart + hueRange * tHue) % 360;

    const double saturation = 0.5;

    // Ramp up brightness from 0.4 to 0.9
    final value = min(0.9, 0.4 + index * 0.008);

    return HSVColor.fromAHSV(1.0, hue, saturation, value).toColor();
  }
}
