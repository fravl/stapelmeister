import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:stapelmeister/components/play_area.dart';
import 'package:stapelmeister/components/tower_controller.dart';
import 'package:stapelmeister/config.dart';

class Stapelmeister extends FlameGame {
  Stapelmeister()
    : super(
        camera: CameraComponent.withFixedResolution(
          width: gameWidth,
          height: gameHeight,
        ),
      );
  var currentLevel = Level.easy;

  double get width => size.x;
  double get height => size.y;

  late final TowerController tower;

  void gameOver() {
    overlays.remove('ScoreOverlay');
    overlays.add('Results');
  }

  void start(Level level) {
    currentLevel = level;
    overlays.remove('Results');
    tower.newGame();
    overlays.add('ScoreOverlay');
  }

  @override
  FutureOr<void> onLoad() async {
    super.onLoad();

    camera.viewfinder.anchor = Anchor.topLeft;

    await world.add(PlayArea());

    tower = TowerController();
    await world.add(tower);

    overlays.add('Start');
    await tower.buildBase();
  }
}
