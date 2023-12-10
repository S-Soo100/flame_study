import 'package:flame/game.dart';
import 'package:flame_practice/game/slime_world/slime_game.dart';
import 'package:flutter/material.dart';

class SlimeGamePage extends StatefulWidget {
  const SlimeGamePage({super.key});

  @override
  State<SlimeGamePage> createState() => _SlimeGamePageState();
}

class _SlimeGamePageState extends State<SlimeGamePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Slime Game"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: GameWidget(
            game: SlimeGame(),
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
