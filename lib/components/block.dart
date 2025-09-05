import 'dart:ui';
import 'package:flame/components.dart';
import 'package:stapelmeister/config.dart';
import 'package:stapelmeister/stapelmeister.dart';

typedef LandedCallback = void Function();

enum BlockState { sliding, dropping, landed }

class Block extends RectangleComponent with HasGameReference<Stapelmeister> {
  Block({
    required Vector2 position,
    required Vector2 size,
    required this.horizontalSpeed,
    required this.leftBound,
    required this.rightBound,
    required this.targetY,
    this.direction = 1.0,
    this.onLanded,
    Paint? paint,
  }) : super(
         position: position,
         size: size,
         paint: paint ?? (Paint()..color = const Color(0xFF2a9d8f)),
       );

  double horizontalSpeed;
  final double leftBound;
  final double rightBound;
  final double targetY;
  double direction; // +1 => right, -1 => left
  LandedCallback? onLanded;

  BlockState state = BlockState.sliding;

  void startDrop() {
    if (state == BlockState.sliding) {
      state = BlockState.dropping;
    }
  }

  double get left => position.x;
  double get right => position.x + size.x;

  @override
  void update(double dt) {
    super.update(dt);

    switch (state) {
      case BlockState.sliding:
        // Ping-pong horizontally between bounds
        position.x += direction * horizontalSpeed * dt;
        if (position.x <= leftBound) {
          position.x = leftBound;
          direction = 1.0;
        }
        if (position.x + size.x >= rightBound) {
          position.x = rightBound - size.x;
          direction = -1.0;
        }
        break;

      case BlockState.dropping:
        position.y += dropSpeed * dt;
        if (position.y >= targetY) {
          position.y = targetY;
          state = BlockState.landed;
          onLanded?.call();
        }
        break;

      case BlockState.landed:
        // no-op
        break;
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final outlinePaint = Paint()
      ..color = const Color(0xFF000000)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawRect(size.toRect(), outlinePaint);
  }
}
