import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stapelmeister/services/score_service.dart';
import 'package:stapelmeister/theme/retro_button.dart';
import 'package:stapelmeister/theme/retro_text.dart';

class ResultsOverlay extends StatelessWidget {
  final VoidCallback onRetry;

  const ResultsOverlay({
    super.key,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final score = Get.find<ScoreService>().score;

    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.only(top: 128),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("GAME OVER", style: retroText(64)),
            const SizedBox(height: 16),
            Text("SCORE: $score", style: retroText(32)),
            const SizedBox(height: 32),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  style: retroButtonStyle(),
                  onPressed: onRetry,
                  child: Text("RETRY", style: retroText(64)),
                ),            
              ],
            ),
          ],
        ),
      ),
    );
  }
}
