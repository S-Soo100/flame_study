import 'package:flame/game.dart';
import 'package:flame_practice/game/airplane_game/game_components/center_overlay_widget.dart';
import 'package:flame_practice/game/airplane_game/airplane_game.dart';
import 'package:flame_practice/game/airplane_game/game_components/top_score_overlay_widget.dart';
import 'package:flame_practice/game/slime_world/slime_game.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
        backgroundColor: Colors.black12,
        appBar: AppBar(
          title: const Text("Airplane Game"),
        ),
        body: Center(
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              if (constraints.maxWidth > 500) {
                return Center(
                  child: SizedBox(
                    width: 450,
                    height: Get.height,
                    child: _gameScreen(),
                  ),
                );
              }
              return _gameScreen();
            },
          ),
        ));
  }

  Widget _gameScreen() {
    return Stack(
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
