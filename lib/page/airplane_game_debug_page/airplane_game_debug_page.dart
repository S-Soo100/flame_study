import 'dart:async';

import 'package:flame/game.dart';
import 'package:flame_practice/game/airplane_game/airplane_game_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AirplaneGameDebugPage extends StatefulWidget {
  const AirplaneGameDebugPage({super.key});

  @override
  State<AirplaneGameDebugPage> createState() => _AirplaneGameDebugPageState();
}

class _AirplaneGameDebugPageState extends State<AirplaneGameDebugPage> {
  // late AirplaneGame _game;
  late AirplaneGameController _controller = Get.find<AirplaneGameController>();

  Timer? readyTimer;
  int readyCount = 3;

  @override
  void initState() {
    super.initState();
    _controller = Get.find<AirplaneGameController>();
    _controller.debugGameStart();
    // _controller.disposeAll();
  }

  @override
  void dispose() {
    _controller.debugGameEnd();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black12,
        appBar: AppBar(
          title: const Text("Debug Page"),
        ),
        body: Center(
          child: GameWidget(
            game: _controller.game,
            overlayBuilderMap: {
              'score': (context, game) {
                return Container(
                  width: 100,
                  height: 100,
                  color: Colors.red,
                );
              },
              'score2': (context, game) {
                return Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: 100,
                    height: 100,
                    color: Colors.blue,
                  ),
                );
              },
              'score3': (context, game) {
                return Container(
                  width: 100,
                  height: 100,
                  color: Colors.blue,
                );
              },
            },
          ),
        ));
  }
}
