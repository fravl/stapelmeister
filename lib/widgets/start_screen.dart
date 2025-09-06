import 'package:flutter/material.dart';
import 'package:stapelmeister/theme/retro_text.dart';

class StartOverlay extends StatefulWidget {
  final VoidCallback onStart;

  const StartOverlay({super.key, required this.onStart});

  @override
  State<StartOverlay> createState() => _StartOverlayState();
}

class _StartOverlayState extends State<StartOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onStart,
      behavior: HitTestBehavior.opaque,
      child: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.only(top: 240),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                children: [
                  Text(
                    "Stapelmeister",
                    style: retroText(48, color: Colors.black).copyWith(
                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 4
                        ..color = Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    "Stapelmeister",
                    style: retroText(48, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),

              const SizedBox(height: 240),
              FadeTransition(
                opacity: _controller.drive(Tween(begin: 0.4, end: 1.0)),
                child: Text("Tap to Begin", style: retroText(16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
