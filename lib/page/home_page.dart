import 'package:flame/game.dart';
import 'package:flame_practice/page/game_screen.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: GameScreen(),
      ),
    );
  }
}
