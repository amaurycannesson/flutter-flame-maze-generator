import 'package:flutter/material.dart';
import 'package:flame/game.dart';

import 'maze_game.dart';

void main() {
  final mazeGame = MazeGame();

  runApp(
    GameWidget(
      game: mazeGame,
      overlayBuilderMap: {
        'Settings': settingsBuilder,
      },
      initialActiveOverlays: ['Settings'],
    ),
  );
}
