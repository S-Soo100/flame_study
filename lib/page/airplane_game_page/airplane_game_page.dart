import 'package:flame/game.dart';
import 'package:flame_practice/game/airplane_game/game_components/center_overlay_widget.dart';
import 'package:flame_practice/game/airplane_game/airplane_game.dart';
import 'package:flame_practice/game/airplane_game/game_components/top_score_overlay_widget.dart';
import 'package:flame_practice/game/slime_world/slime_game.dart';
import 'package:flutter/material.dart';

class AirplaneGamePage extends StatefulWidget {
  const AirplaneGamePage({super.key});

  @override
  State<AirplaneGamePage> createState() => _AirplaneGamePageState();
}

class _AirplaneGamePageState extends State<AirplaneGamePage> {
  late AirplaneGame _game;
  int score = 0;

  @override
  void initState() {
    super.initState();
    _game = AirplaneGame(moveLeft: fasd, moveRight: fasd, scoreUp: upScore);
  }

  @override
  void dispose() {
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
                child: CenterOverlayWidget(
                  leftTap: _game.flyLeft,
                  rightTap: _game.flyRight,
                )),
            Align(
              alignment: Alignment.topCenter,
              child: TopScoreOverlayWidget(
                score: score,
              ),
            )
          ],
        ),
      ),
    );
  }

  void upScore() {
    setState(() {
      score = score + 10;
    });
  }

  void fasd() {
    print("tap tap tap ");
  }
}
