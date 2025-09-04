import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:stapelmeister/components/play_area.dart';
import 'package:stapelmeister/components/tower_controller.dart';
import 'package:stapelmeister/config.dart';
import 'package:stapelmeister/services/score_service.dart';

class Stapelmeister extends FlameGame {
  Stapelmeister()
      : super(
          camera: CameraComponent.withFixedResolution(
            width: gameWidth,
            height: gameHeight,
          ),
        );

  double get width => size.x;
  double get height => size.y;

  late final TowerController tower;
  late final ScoreService scoreService;

  @override
  FutureOr<void> onLoad() async {
    super.onLoad();

    camera.viewfinder.anchor = Anchor.topLeft;
    scoreService = ScoreService();

    await world.add(PlayArea());

    tower = TowerController();
    await world.add(tower);
  }
}
