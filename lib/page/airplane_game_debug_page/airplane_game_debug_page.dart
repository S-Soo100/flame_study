import 'dart:async';

import 'package:flame/game.dart';
import 'package:flame_practice/core/state/game_state.dart';
import 'package:flame_practice/game/airplane_game/airplane_game.dart';
import 'package:flame_practice/game/airplane_game/airplane_game_controller.dart';
import 'package:flame_practice/game/airplane_game/game_components/center_overlay_widget.dart';
import 'package:flame_practice/game/airplane_game/game_components/top_score_overlay_widget.dart';
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
    // TODO: implement initState
    super.initState();
    _controller = Get.find<AirplaneGameController>();
    _controller.debugGameStart();
    // _controller.disposeAll();
  }

  @override
  void dispose() {
    // TODO: implement dispose
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
          child: GameWidget(game: _controller.game),
        ));
  }
}
