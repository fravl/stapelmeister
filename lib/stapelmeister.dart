import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:stapelmeister/components/play_area.dart';
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

  @override
  FutureOr<void> onLoad() async {
    super.onLoad();

    camera.viewfinder.anchor = Anchor.topLeft;

    world.add(PlayArea());
  }
}
