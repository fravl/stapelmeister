import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:stapelmeister/stapelmeister.dart';

class Debris extends RectangleComponent with HasGameReference<Stapelmeister> {
  Vector2 velocity;
  final double gravity;
  final double angularVel;

  Debris({
    required Vector2 position,
    required Vector2 size,
    required Paint paint,
    required this.velocity,
    this.gravity = 700,
    this.angularVel = 6.0,
  }) : super(
          position: position,
          size: size,
          paint: paint,
          anchor: Anchor.center,
        );

  @override
  void update(double dt) {
    super.update(dt);

    // apply gravity
    velocity.y += gravity * dt;
    position += velocity * dt;

    // spin
    angle += angularVel * dt;

    // remove when below screen
    if (position.y > game.height + 200) {
      removeFromParent();
    }
  }
}
