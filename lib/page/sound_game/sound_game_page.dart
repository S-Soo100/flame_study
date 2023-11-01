import 'package:flame/game.dart';
import 'package:flame_practice/game/slime_world/slime_game.dart';
import 'package:flame_practice/game/sound_game/sound_game.dart';
import 'package:flutter/material.dart';

class SoundGamePage extends StatefulWidget {
  const SoundGamePage({super.key});

  @override
  State<SoundGamePage> createState() => _SoundGamePageState();
}

class _SoundGamePageState extends State<SoundGamePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sound Game"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: GameWidget(
            game: SoundGame(),
          ),
        ),
      ),
    );
  }
}
