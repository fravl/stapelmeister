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
  TowerController({this.level = Level.easy});

  final Level level;

  final List<Block> _stack = [];
  Block? _current;

  double get _movementSpeed => levelSpeeds[level]!;

  double get _leftBound => horizontalMargin;
  double get _rightBound => game.width - horizontalMargin;

  double get _nextLandingY => game.height - (_stack.length) * blockHeight;

  var _nextSpawnXPosition = horizontalMargin;

  Future<void> newGame() async {
    Get.find<ScoreService>().reset();
    BrickPainter.reset();
    await _clearAll();
    // Add base block
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
      currentHeight -= blockHeight;
    }

    // Spawn first moving block
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
      _gameOver();
      return;
    }

    final isPerfect = (overlapWidth - last.size.x).abs() <= perfectTolerance;

    current.position.x = isPerfect ? last.position.x : overlapLeft;
    current.size.x = isPerfect ? last.size.x : overlapWidth;

    if (current.size.x < minWidthToContinue) {
      _gameOver();
      return;
    }

    if (!isPerfect) {
      // Create debris for the cut-off part
      final cutWidth = last.size.x - overlapWidth;

      final cutX = current.right < last.right
          ? last.left
          : overlapRight;

      final debris = Debris(
        position: Vector2(cutX, current.position.y),
        size: Vector2(cutWidth, current.size.y),
        paint: BrickPainter.paintFromBlock(current),
        velocity: Vector2(
          current.right < last.right ? -200 : 200,
          -75,
        ),
      );

      game.world.add(debris);
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

  @override
  FutureOr<void> onLoad() async {
    await newGame();
  }
}
