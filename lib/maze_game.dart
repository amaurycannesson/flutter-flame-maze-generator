import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/gestures.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:flutter/rendering.dart';

import 'maze.dart';

const int smallSize = 21;
const int mediumSize = 41;
const int largeSize = 81;

class MazeGame extends BaseGame with ScrollDetector, PanDetector {
  late final tileset;
  late Maze _maze;
  late IsometricTileMapComponent _map;
  double _frameTime = 0;
  double _speed = 0.25;

  @override
  Future<void> onLoad() async {
    tileset = SpriteSheet(
      image: await images.load('isometric-sandbox-32x32/isometric-sandbox-sheet.png'),
      srcSize: Vector2.all(32.0),
    );

    generate();

    camera.setRelativeOffset(Anchor.topCenter);
    camera.translateBy(Vector2(0, -32));
  }

  generate({int size = smallSize}) {
    _maze = Maze.generate(size: size);
    _map = IsometricTileMapComponent(tileset, _maze.map);
  }

  increaseSpeed() => _speed *= 2;

  decreaseSpeed() => _speed /= 2;

  @override
  void update(double dt) {
    super.update(dt);

    _frameTime += dt;
    if (_frameTime * _speed >= 0.017) {
      _maze.update();
      _frameTime = 0;
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    camera.apply(canvas);
    _map.render(canvas);
  }

  @override
  void onScroll(PointerScrollInfo event) {
    final zooms = [0.25, 0.5, 0.75, 1.0, 1.5, 2.0, 2.5];
    final idx = zooms.indexOf(camera.zoom) - event.scrollDelta.game.y.sign.toInt();
    camera.zoom = zooms[idx % zooms.length];
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    camera.translateBy(info.delta.global * -1);
    camera.snap();
  }
}

Widget settingsBuilder(BuildContext buildContext, MazeGame game) {
  return Material(
    color: Colors.transparent,
    child: Theme(
      data: ThemeData.from(colorScheme: ColorScheme.light()).copyWith(
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            primary: Colors.black,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FittedBox(
          child: ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  color: Color.fromRGBO(255, 255, 255, 0.7),
                ),
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Speed'),
                    ButtonBar(
                      children: [
                        OutlinedButton(
                          onPressed: () => game.decreaseSpeed(),
                          child: Icon(Icons.fast_rewind),
                        ),
                        OutlinedButton(
                          onPressed: () => game.increaseSpeed(),
                          child: Icon(Icons.fast_forward),
                        ),
                      ],
                    ),
                    Text('Size'),
                    ButtonBar(
                      children: [
                        OutlinedButton(
                          onPressed: () => game.generate(size: smallSize),
                          child: Text('$smallSize'),
                        ),
                        OutlinedButton(
                          onPressed: () => game.generate(size: mediumSize),
                          child: Text('$mediumSize'),
                        ),
                        OutlinedButton(
                          onPressed: () => game.generate(size: largeSize),
                          child: Text('$largeSize'),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
