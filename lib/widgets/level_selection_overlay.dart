import 'package:flutter/material.dart';
import 'package:stapelmeister/config.dart';
import 'package:stapelmeister/theme/retro_button.dart';
import 'package:stapelmeister/theme/retro_text.dart';

const easyButtonColor = Color(0xFF3AB09E);
const mediumButtonColor = Color(0xFFFE5A1D);
const hardButtonColor = Color(0xFF1F305E);

class LevelSelectionOverlay extends StatelessWidget {
  final void Function(Level) onSelect;

  const LevelSelectionOverlay({super.key, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isWide = width > 600;

    final buttons = [
      ElevatedButton(
        style: retroButtonStyle(color: easyButtonColor),
        onPressed: () => onSelect(Level.easy),
        child: Text("EASY", style: retroText(28)),
      ),
      ElevatedButton(
        style: retroButtonStyle(color: mediumButtonColor),
        onPressed: () => onSelect(Level.medium),
        child: Text("MEDIUM", style: retroText(28)),
      ),
      ElevatedButton(
        style: retroButtonStyle(color: hardButtonColor),
        onPressed: () => onSelect(Level.hard),
        child: Text("HARD", style: retroText(28)),
      ),
    ];

    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.only(top: 128),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("SELECT LEVEL", style: retroText(48)),
              const SizedBox(height: 48),
              isWide
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      spacing: 10,
                      children: buttons,
                    )
                  : Column(mainAxisSize: MainAxisSize.min, spacing: 28, children: buttons),
            ],
          ),
        ),
      ),
    );
  }
}
