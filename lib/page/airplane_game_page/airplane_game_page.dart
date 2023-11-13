import 'dart:async';

import 'package:flame/game.dart';
import 'package:flame_practice/core/state/game_state.dart';
import 'package:flame_practice/game/airplane_game/airplane_game_controller.dart';
import 'package:flame_practice/game/airplane_game/game_components/airplane_game_over_widget.dart';
import 'package:flame_practice/game/airplane_game/game_components/center_overlay_widget.dart';
import 'package:flame_practice/game/airplane_game/game_components/top_score_overlay_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AirplaneGamePage extends StatefulWidget {
  const AirplaneGamePage({super.key});

  @override
  State<AirplaneGamePage> createState() => _AirplaneGamePageState();
}

class _AirplaneGamePageState extends State<AirplaneGamePage> {
  // late AirplaneGame _game;
  late AirplaneGameController _controller = Get.find<AirplaneGameController>();

  Timer? readyTimer;
  int readyCount = 3;

  @override
  void initState() {
    super.initState();
    _controller = Get.find<AirplaneGameController>();
    _controller.setNewGame();
  }

  @override
  void dispose() {
    _controller.endGame();
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
          child: _gameScreen(),
        ));
  }

  void fasd() {
    // print("tap tap tap ");
  }

  Widget _gameScreen() {
    return Obx(() {
      GameState state = _controller.state;
      int diff = _controller.difficulty;
      if (state is Init) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "$diff",
                style: const TextStyle(color: Colors.white),
              ),
              Container(
                alignment: Alignment.center,
                width: Get.width,
                height: 60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          _controller.setDifficulty(0);
                        },
                        child: const Text("쉬움")),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: ElevatedButton(
                          onPressed: () {
                            _controller.setDifficulty(1);
                          },
                          child: const Text("보통")),
                    ),
                    ElevatedButton(
                        onPressed: () {
                          _controller.setDifficulty(2);
                        },
                        child: const Text("어려움")),
                  ],
                ),
              ),
              const Text(
                "Airplane Game",
                style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              ClipRect(
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          alignment: Alignment(0, 0),
                          fit: BoxFit.contain,
                          image: AssetImage(
                              "assets/images/airplane_game/player1.png"))),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(32.0),
                child: ElevatedButton(
                  onPressed: () {
                    getReady();
                    _controller.gameStart();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    textStyle: const TextStyle(fontSize: 24),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 10),
                  ),
                  child: const Text(
                    "Start Game",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        );
      }
      return Stack(
        children: [
          Center(
            child: GameWidget(
              game: _controller.game,
            ),
          ),
          if (state is Playing)
            Align(
                alignment: Alignment.center,
                child: CenterOverlayWidget(
                  leftTap: _controller.game.flyLeft,
                  rightTap: _controller.game.flyRight,
                )),
          Align(
            alignment: Alignment.topCenter,
            child: TopScoreOverlayWidget(
              hitPoint: _controller.hitPoint,
              score: _controller.score,
              killCount: _controller.killCount,
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
                      // Get.to(AirplaneGameOverWidget(
                      //   distanceMeter: _controller.score,
                      //   killScore: _controller.killCount,
                      // ));

                      Get.dialog(
                          AirplaneGameOverWidget(
                            distanceMeter: _controller.score,
                            killScore: _controller.killCount,
                          ),
                          barrierDismissible: false);
                      // getReady();
                      // _controller.tryAgain();
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
    readyTimer = Timer.periodic(const Duration(milliseconds: 1000), (timer) {
      setState(() {
        readyCount--;
      });
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
                readyCount.toString(),
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
