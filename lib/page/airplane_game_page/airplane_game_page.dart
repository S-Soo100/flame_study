import 'dart:async';

import 'package:flame/game.dart';
import 'package:flame_practice/core/state/game_state.dart';
import 'package:flame_practice/game/airplane_game/airplane_game_controller.dart';
import 'package:flame_practice/game/airplane_game/game_components/center_overlay_widget.dart';
import 'package:flame_practice/game/airplane_game/airplane_game.dart';
import 'package:flame_practice/game/airplane_game/game_components/top_score_overlay_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AirplaneGamePage extends StatefulWidget {
  const AirplaneGamePage({super.key});

  @override
  State<AirplaneGamePage> createState() => _AirplaneGamePageState();
}

class _AirplaneGamePageState extends State<AirplaneGamePage> {
  late AirplaneGame _game;
  late AirplaneGameController _controller = Get.find<AirplaneGameController>();

  Timer? readyTimer;
  int readyCount = 3;

  @override
  void initState() {
    super.initState();
    _controller = Get.find<AirplaneGameController>();
    _game = AirplaneGame(moveLeft: fasd, moveRight: fasd);
  }

  AirplaneGame instance() {
    return AirplaneGame(moveLeft: fasd, moveRight: fasd);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.endGame();
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

  void fasd() {
    print("tap tap tap ");
  }

  Widget _gameScreen() {
    return Obx(() {
      GameState state = _controller.state;
      if (state is Init) {
        return Center(
          child: GestureDetector(
            onTap: () {
              getReady();
              _controller.gameStart();
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  color: Colors.amber,
                  padding: const EdgeInsets.all(20),
                  child: const Text("Ready")),
            ),
          ),
        );
      }
      return Stack(
        children: [
          GameWidget(game: _game),
          if (state is Playing)
            Align(
                alignment: Alignment.center,
                child: CenterOverlayWidget(
                  leftTap: _game.flyLeft,
                  rightTap: _game.flyRight,
                )),
          Align(
            alignment: Alignment.topCenter,
            child: TopScoreOverlayWidget(
              hitPoint: _controller.hitPoint,
              score: _controller.score,
            ),
          ),
          if (state is GameOver) _gameOverWidget(),
          if (state is Ready) _readyWidget()
        ],
      );
    });
  }

  Widget _gameOverWidget() {
    return Container(
      color: Colors.black.withOpacity(0.7),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: Text(
                "Game Over!!!!",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 25),
              ),
            ),
            Text(
              "Score: ${_controller.score}",
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 20.0),
              child: Text(
                "wanna try again?",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: GestureDetector(
                    onTap: () {
                      _controller.tryAgain();
                      _game = AirplaneGame(moveLeft: fasd, moveRight: fasd);
                    },
                    child: Container(
                      width: 120,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white,
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        "Try Again",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: Container(
                      width: 120,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white,
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        "Later",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic),
                      ),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  void getReady() {
    readyTimer = Timer.periodic(Duration(milliseconds: 1000), (timer) {
      setState(() {
        readyCount--;
      });
      print("readyCount is ${readyCount}");
      if (readyCount < 0) {
        readyTimer?.cancel();
        readyCount = 3;
      }
    });
  }

  Widget _readyWidget() {
    return Center(
      child: Container(
        color: Colors.black.withOpacity(0.2),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(),
            AnimatedContainer(
              duration: const Duration(milliseconds: 100),
              width: 200,
              height: 200,
              alignment: Alignment.center,
              child: Text(
                "${readyCount.toString()}",
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 80),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
