import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stapelmeister/services/score_service.dart';

class ResultsOverlay extends StatelessWidget {
  final VoidCallback onRetry;

  const ResultsOverlay({
    super.key,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final score = Get.find<ScoreService>().score;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Game Over", style: Theme.of(context).textTheme.headlineLarge),
          const SizedBox(height: 12),
          Text("Score: $score", style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 24),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: onRetry,
                child: const Text("Retry"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
