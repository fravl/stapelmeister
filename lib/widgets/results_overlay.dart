import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stapelmeister/config.dart';
import 'package:stapelmeister/services/score_service.dart';
import 'package:stapelmeister/theme/retro_button.dart';
import 'package:stapelmeister/theme/retro_text.dart';

class ResultsOverlay extends StatelessWidget {
  final VoidCallback onRetry;
  final Level level;

  const ResultsOverlay({
    super.key,
    required this.onRetry,
    required this.level,
  });

  @override
  Widget build(BuildContext context) {
    final scoreService = Get.find<ScoreService>();

    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.only(top: 128),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("GAME OVER", style: retroText(64)),
            const SizedBox(height: 16),
            Obx(() => Text(
                  "SCORE: ${scoreService.score.value}",
                  style: retroText(32),
                )),
            const SizedBox(height: 16),
            Obx(() => Text(
                  "HIGH SCORE: "
                  "${scoreService.getHighScore(level)}",
                  style: retroText(24),
                )),
            const SizedBox(height: 32),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  style: retroButtonStyle(),
                  onPressed: onRetry,
                  child: Text("RETRY", style: retroText(32, color: Colors.white)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
