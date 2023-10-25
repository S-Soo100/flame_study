import 'package:flame/game.dart';
import 'package:flame_practice/game/airplane_game/game_components/airplane_center_overlay_widget.dart';
import 'package:flame_practice/game/airplane_game/airplane_game.dart';
import 'package:flame_practice/game/slime_world/slime_game.dart';
import 'package:flutter/material.dart';

class AirplaneGamePage extends StatefulWidget {
  const AirplaneGamePage({super.key});

  @override
  State<AirplaneGamePage> createState() => _AirplaneGamePageState();
}

class _AirplaneGamePageState extends State<AirplaneGamePage> {
  late AirplaneGame _game;

  @override
  void initState() {
    super.initState();
    _game = AirplaneGame(moveLeft: _, moveRight: _);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Airplane Game"),
      ),
      body: Center(
        child: Stack(
          children: [
            GameWidget(game: _game),
            Align(
                alignment: Alignment.center,
                child: AirplaneCenterOverlayWidget(
                  leftTap: _game.flyLeft,
                  rightTap: _game.flyRight,
                ))
          ],
        ),
      ),
    );
  }

  void _() {
    print("tap tap tap ");
  }
}
