import 'package:get/get.dart';

class ScoreService extends GetxController {
  var score = 0.obs;

  void reset() => score.value = 0;
  void increment([int amount = 1]) => score.value += amount;
}
