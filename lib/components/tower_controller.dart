// lib/components/tower_controller.dart
import 'dart:async';
import 'dart:ui';
import 'package:flame/components.dart' hide Block;
import 'package:stapelmeister/components/block.dart';
import 'package:stapelmeister/config.dart';
import 'package:stapelmeister/stapelmeister.dart';

class TowerController extends Component with HasGameReference<Stapelmeister> {
  TowerController({this.level = Level.easy});

  final Level level;

  final List<Block> _stack = [];
  Block? _current; // moving/dropping block

  double get _movementSpeed => levelSpeeds[level]!;
  double get _landingBaseY => game.height - baseBottomMargin; // y of the base row

  double get _leftBound => horizontalMargin;
  double get _rightBound => game.width - horizontalMargin;

  // Convenience: top block landing y for the next block
  double get _nextLandingY => _landingBaseY - (_stack.length) * blockHeight;

  Future<void> newGame() async {
    // Clear previous
    await _clearAll();
    // Add base block
    final baseX = (game.width - baseWidth) / 2;
    final baseY = _landingBaseY - blockHeight; // top-left anchor; y is top of the base block

    final baseBlock = Block(
      position: Vector2(baseX, baseY),
      size: Vector2(baseWidth, blockHeight),
      horizontalSpeed: 0,
      leftBound: _leftBound,
      rightBound: _rightBound,
      targetY: baseY,
      direction: 0,
      paint: Paint()..color = const Color(0xFF264653),
    )..state = BlockState.landed;

    _stack.add(baseBlock);
    add(baseBlock);

    // Spawn first moving block
    _spawnNext();
  }

  void _spawnNext() {
    final last = _stack.last;
    final targetY = _nextLandingY - blockHeight; // next layer sits above the last

    final width = last.size.x; // start same width as the top block
    final startX = _leftBound; // start from left side
    final startY = targetY - spawnDropGap; // spawn above, to see the drop

    final block = Block(
      position: Vector2(startX, startY),
      size: Vector2(width, blockHeight),
      horizontalSpeed: _movementSpeed,
      leftBound: _leftBound,
      rightBound: _rightBound,
      targetY: targetY,
      direction: 1.0,
      onLanded: _onCurrentLanded,
      paint: Paint()..color = const Color(0xFFE76F51),
    );

    _current = block;
    add(block);
  }

  void drop() {
    _current?.startDrop();
  }

  void _onCurrentLanded() {
    final current = _current!;
    final last = _stack.last;

    // Compute overlap rectangle between current and last along X
    final overlapLeft = current.left >= last.left ? current.left : last.left;
    final overlapRight = current.right <= last.right ? current.right : last.right;
    final overlapWidth = overlapRight - overlapLeft;

    if (overlapWidth <= 0) {
      // Missed completely -> game over (simple reset for now)
      _gameOver();
      return;
    }

    // Optional: treat very small misalignments as perfect
    final isPerfect = (overlapWidth - last.size.x).abs() <= perfectTolerance;

    // Trim current to overlap
    current.position.x = isPerfect ? last.position.x : overlapLeft;
    current.size.x = isPerfect ? last.size.x : overlapWidth;

    // Check minimum width
    if (current.size.x < minWidthToContinue) {
      _gameOver();
      return;
    }

    // Lock it in as part of the stack
    _stack.add(current);
    _current = null;

    // Spawn next layer
    _spawnNext();
  }

  Future<void> _gameOver() async {
    // Simple: reset after a short delay. Replace with nicer UI later.
    await Future<void>.delayed(const Duration(milliseconds: 400));
    await newGame();
  }

  Future<void> _clearAll() async {
    // Remove all components managed by this controller
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
