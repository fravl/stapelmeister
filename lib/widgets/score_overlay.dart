import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stapelmeister/services/score_service.dart';
import 'package:stapelmeister/theme/retro_text.dart';

class ScoreOverlay extends StatelessWidget {
  const ScoreOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    final scoreService = Get.find<ScoreService>();

    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Obx(
          () => Text(
            '${scoreService.score.value}',
            style: retroText(96)
          ),
        ),
      ),
    );
  }
}
