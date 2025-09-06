import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:stapelmeister/widgets/game_app.dart';

import 'services/score_service.dart';

Future<void> main() async {
  await Hive.initFlutter();
  await Hive.openBox<int>('scores');

  final scoreService = ScoreService();
  await scoreService.init();
  Get.put(scoreService);
  runApp(const GameApp());
}
