import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stapelmeister/widgets/game_app.dart';

import 'services/score_service.dart';

void main() {
  Get.put(ScoreService());
  runApp(const GameApp());
}

