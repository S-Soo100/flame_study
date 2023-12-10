import 'package:flame/game.dart';
import 'package:flame_practice/game/touch_angle_game/touch_angle_game.dart';
import 'package:flame_practice/game/triangle_game/triangle_game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class TouchArrowGamePage extends StatefulWidget {
  const TouchArrowGamePage({super.key});

  @override
  State<TouchArrowGamePage> createState() => _TouchArrowGamePageState();
}

class _TouchArrowGamePageState extends State<TouchArrowGamePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.greenAccent,
        ),
        body: Container(
            decoration: const BoxDecoration(color: Colors.white),
            child: Center(
                child: GameWidget(
              game: TouchAngleGame(),
            ))));
  }
}
