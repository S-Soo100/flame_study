import 'package:flame/game.dart';
import 'package:flame_practice/game/my_game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: GameWidget(
            game: MyGame(),
            overlayBuilderMap: {
              'PauseMenu': (context, game) {
                return Container(
                  color: const Color(0xFF000000),
                  child: Text('A pause menu'),
                );
              },
            },
          ),
        ),
      ),
    );
  }
}
