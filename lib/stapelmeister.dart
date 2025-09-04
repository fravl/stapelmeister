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

  double get width => size.x;
  double get height => size.y;

  late final TowerController tower;

  @override
  FutureOr<void> onLoad() async {
    super.onLoad();

    camera.viewfinder.anchor = Anchor.topLeft;

    await world.add(PlayArea());

    tower = TowerController();
    await world.add(tower);

    overlays.add('ScoreOverlay');
  }
}
