import 'package:flame/game.dart';
import 'package:flame_practice/components/airplane_center_overlay_widget.dart';
import 'package:flame_practice/game/airplane_game/airplane_game.dart';
import 'package:flame_practice/game/slime_world/slime_game.dart';
import 'package:flutter/material.dart';

class AirplaneGamePage extends StatefulWidget {
  const AirplaneGamePage({super.key});

  @override
  State<AirplaneGamePage> createState() => _AirplaneGamePageState();
}

class _AirplaneGamePageState extends State<AirplaneGamePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Airplane Game"),
      ),
      body: Center(
        child: Stack(
          children: [
            GameWidget(game: AirplaneGame()),
            const Align(
                alignment: Alignment.center,
                child: AirplaneCenterOverlayWidget())
          ],
        ),
      ),
    );
  }
}
