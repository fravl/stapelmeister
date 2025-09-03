// lib/components/play_area.dart
import 'dart:async';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:stapelmeister/components/tower_controller.dart';
import 'package:stapelmeister/config.dart';
import 'package:stapelmeister/stapelmeister.dart';

class PlayArea extends RectangleComponent
    with HasGameReference<Stapelmeister>, TapCallbacks {
  PlayArea()
      : super(
          paint: Paint()..color = const Color(0xfff2e8cf),
          children: [RectangleHitbox()],
        );

  late final TowerController tower;

  @override
  FutureOr<void> onLoad() async {
    size = Vector2(game.width, game.height);

    // You can choose difficulty here:
    tower = TowerController(level: Level.easy);
    add(tower);
  }

  @override
  void onTapDown(TapDownEvent event) {
    tower.drop();
    super.onTapDown(event);
  }
}
