import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:stapelmeister/config.dart';

class ScoreService extends GetxController {
  var score = 0.obs;

  final Box<int> _box = Hive.box<int>('scores');

  final highScores = <Level, RxInt>{};

  init() {
    for (final level in Level.values) {
      final stored = _box.get(level.name, defaultValue: 0) ?? 0;
      highScores[level] = stored.obs;
    }
  }

  void reset() => score.value = 0;

  void increment([int amount = 1]) => score.value += amount;

  void saveHighScore(Level level) {
    final current = score.value;
    if (current > (highScores[level]?.value ?? 0)) {
      highScores[level]?.value = current;
      _box.put(level.name, current);
    }
  }

  int getHighScore(Level level) => highScores[level]?.value ?? 0;
}
