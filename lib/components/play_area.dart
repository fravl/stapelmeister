import 'dart:async';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:stapelmeister/config.dart';
import 'package:stapelmeister/stapelmeister.dart';

class PlayArea extends RectangleComponent
    with HasGameReference<Stapelmeister>, TapCallbacks {
  PlayArea()
      : super(
          paint: Paint()..color = const Color(0xfff2e8cf),
          children: [RectangleHitbox()],
        );

  @override
  FutureOr<void> onLoad() async {
    final rect = game.camera.visibleWorldRect;
    position = Vector2(rect.left, rect.top - blockHeight);
    size = Vector2(rect.width, rect.height + blockHeight);
  }

  @override
  void update(double dt) {
    super.update(dt);
    // Always fill the camera's viewport
    final rect = game.camera.visibleWorldRect;
    position = Vector2(rect.left, rect.top - blockHeight);
    size = Vector2(rect.width, rect.height + blockHeight);
  }

  @override
  void onTapDown(TapDownEvent event) {
    game.tower.drop();
    super.onTapDown(event);
  }
}
