import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:stapelmeister/stapelmeister.dart';
import 'package:stapelmeister/widgets/level_selection_overlay.dart';
import 'package:stapelmeister/widgets/results_overlay.dart';
import 'package:stapelmeister/widgets/score_overlay.dart';
import 'package:stapelmeister/widgets/start_screen.dart';

import '../config.dart';

class GameApp extends StatefulWidget {
  const GameApp({super.key});

  @override
  State<GameApp> createState() => _GameAppState();
}

class _GameAppState extends State<GameApp> {
  late final Stapelmeister game;

  @override
  void initState() {
    super.initState();
    game = Stapelmeister();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xffa9d6e5), Color(0xfff2e8cf)],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: Column(
                  children: [
                    Expanded(
                      child: FittedBox(
                        child: SizedBox(
                          width: gameWidth,
                          height: gameHeight,
                          child: GameWidget(
                            game: game,
                            overlayBuilderMap: {
                              'Start': (_, __) => StartOverlay(
                                onStart: () {
                                  game.overlays.remove('Start');
                                  game.overlays.add('LevelSelection');
                                },
                              ),
                              'ScoreOverlay': (_, __) => const ScoreOverlay(),
                              'Results': (_, __) => ResultsOverlay(
                                onRetry: () {
                                  game.overlays.remove('Results');
                                  game.overlays.add('LevelSelection');
                                  game.reset();
                                },
                              ),
                              'LevelSelection': (_, __) =>
                                  LevelSelectionOverlay(
                                    onSelect: (level) {
                                      game.overlays.remove('LevelSelection');
                                      game.start(level);
                                    },
                                  ),
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
