import 'package:flutter/material.dart';

ButtonStyle retroButtonStyle({Color color = const Color(0xFFE63946)}) {
  return ElevatedButton.styleFrom(
    backgroundColor: color, 
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
    shape: RoundedRectangleBorder(
      side: const BorderSide(color: Colors.black, width: 2),
      borderRadius: BorderRadius.zero,
    ),
  );
}
