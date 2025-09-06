import 'dart:async';
import 'package:flame/components.dart' hide Block;
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stapelmeister/components/block.dart';
import 'package:stapelmeister/components/debris.dart';
import 'package:stapelmeister/config.dart';
import 'package:stapelmeister/services/brick_painter.dart';
import 'package:stapelmeister/services/score_service.dart';
import 'package:stapelmeister/stapelmeister.dart';

class TowerController extends Component with HasGameReference<Stapelmeister> {
  TowerController();

  final List<Block> _stack = [];
  Block? _current;

  double get _movementSpeed => levelSpeeds[game.currentLevel]!;

  double get _leftBound => horizontalMargin;
  double get _rightBound => game.width - horizontalMargin;

  double get _nextLandingY => game.height - (_stack.length) * blockHeight;

  var _nextSpawnXPosition = horizontalMargin;

  Future<void> buildBase() async {
    BrickPainter.reset();
    await _clearAll();

    final baseX = (game.width - baseWidth) / 2;
    var currentHeight = game.height;

    while (currentHeight > game.height / 2) {
      final baseBlock = Block(
        position: Vector2(baseX, currentHeight),
        size: Vector2(baseWidth, blockHeight),
        horizontalSpeed: 0,
        leftBound: _leftBound,
        rightBound: _rightBound,
        targetY: currentHeight,
        paint: BrickPainter.nextPaint(),
      )..state = BlockState.landed;

      _stack.add(baseBlock);
      await add(baseBlock);

      // Temporarily use center coordinates for animation
      final originalAnchor = baseBlock.anchor;
      final originalPosition = baseBlock.position.clone();

      baseBlock.anchor = Anchor.center;
      baseBlock.position = Vector2(
        baseX + baseWidth / 2,
        currentHeight + blockHeight / 2,
      );
      baseBlock.scale = Vector2.all(0);

      baseBlock.add(
        ScaleEffect.to(
          Vector2.all(1.1),
          EffectController(duration: 0.15, curve: Curves.easeOut),
          onComplete: () {
            baseBlock.add(
              ScaleEffect.to(
                Vector2.all(1.0),
                EffectController(duration: 0.1, curve: Curves.easeIn),
                onComplete: () {
                  // Restore original coordinates
                  baseBlock.anchor = originalAnchor;
                  baseBlock.position = originalPosition;
                },
              ),
            );
          },
        ),
      );

      await Future.delayed(const Duration(milliseconds: 30));
      currentHeight -= blockHeight;
    }
  }

  Future<void> newGame() async {
    _spawnNext();
  }

  Future<void> _spawnNext() async {
    final last = _stack.last;
    final targetY = _nextLandingY;

    final width = last.size.x;
    final startY = targetY - spawnDropGap;

    final block = Block(
      position: Vector2(_nextSpawnXPosition, startY),
      size: Vector2(width, blockHeight),
      horizontalSpeed: _movementSpeed,
      leftBound: _leftBound,
      rightBound: _rightBound,
      targetY: targetY,
      onLanded: _onCurrentLanded,
      paint: BrickPainter.nextPaint(),
    );

    _current = block;
    await add(block);
  }

  void drop() {
    _current?.startDrop();
  }

  void _createDebris({
    required Vector2 position,
    required Vector2 size,
    required Paint paint,
    required Vector2 velocity,
  }) {
    final debris = Debris(
      position: position.clone(),
      size: size.clone(),
      paint: paint,
      velocity: velocity,
    );
    game.world.add(debris);
  }

  void _onCurrentLanded() {
    final current = _current!;
    final last = _stack.last;

    // Compute overlap rectangle between current and last along X
    final overlapLeft = current.left >= last.left ? current.left : last.left;
    final overlapRight = current.right <= last.right
        ? current.right
        : last.right;
    final overlapWidth = overlapRight - overlapLeft;

    if (overlapWidth <= 0) {
      remove(current);
      _createDebris(
        position: current.position,
        size: current.size,
        paint: current.paint,
        velocity: Vector2(0, -200),
      );
      _gameOver();
      return;
    }

    final isPerfect = (overlapWidth - last.size.x).abs() <= perfectTolerance;

    current.position.x = isPerfect ? last.position.x : overlapLeft;
    current.size.x = isPerfect ? last.size.x : overlapWidth;

    if (current.size.x < minWidthToContinue) {
      remove(current);
      _createDebris(
        position: current.position,
        size: current.size,
        paint: current.paint,
        velocity: Vector2(0, -200),
      );
      _gameOver();
      return;
    }

    if (!isPerfect) {
      // Create debris for the cut-off part
      final cutWidth = last.size.x - overlapWidth;
      final cutX = current.right < last.right ? last.left : overlapRight;
      _createDebris(
        position: Vector2(cutX, current.position.y),
        size: Vector2(cutWidth, current.size.y),
        paint: BrickPainter.paintFromBlock(current),
        velocity: Vector2(current.right < last.right ? -200 : 200, -75),
      );
    }

    _stack.add(current);
    final removed = _stack.removeAt(0);
    removed.removeFromParent();

    for (final block in _stack) {
      block.add(
        MoveByEffect(
          Vector2(0, blockHeight),
          EffectController(duration: 0.25, curve: Curves.easeOut),
        ),
      );
    }
    _current = null;

    Get.find<ScoreService>().increment();

    _nextSpawnXPosition = _nextSpawnXPosition == _leftBound
        ? _rightBound - current.size.x
        : _leftBound;

    _spawnNext();
  }

  Future<void> _gameOver() async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    game.gameOver();
  }

  Future<void> _clearAll() async {
    for (final c in List<Component>.from(children)) {
      c.removeFromParent();
    }
    _stack.clear();
    _current = null;
  }
}
