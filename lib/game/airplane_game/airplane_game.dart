import 'dart:async';
import 'package:flame/collisions.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flame_practice/core/state/game_state.dart';
import 'package:flame_practice/game/airplane_game/airplane_game_controller.dart';
import 'package:flame_practice/game/airplane_game/game_components/airplane_game_bg.dart';
import 'package:flame_practice/game/airplane_game/game_components/player_plane.dart';
import 'package:flame_practice/game/airplane_game/game_components/side_enemy_plain.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AirplaneGame extends FlameGame with TapCallbacks, HasCollisionDetection {
  final AirplaneGameBg _gameBg = AirplaneGameBg();
  final AirplaneGameBg _gameBgSecond = AirplaneGameBg();
  late AirplaneGameController _controller;
  late Timer? _timer;
  late Timer? _timer2;
  late Timer? sidePlainTimer;
  late PlayerPlane _player;
  int difficulty;
  int firstTimerDuration = 2200;
  int secondTimerDuration = 2800;
  int sideTimerDuration = 4600;

  AirplaneGame({required this.difficulty}) : super();

  @override
  Color backgroundColor() => const Color(0xffE8C274);

  @override
  Future<void> onLoad() async {
    _controller = Get.find<AirplaneGameController>();
    add(ScreenHitbox());
    await add(_gameBg);
    _gameBgSecond.position = Vector2(0, -size.y);
    await add(_gameBgSecond);
    _player = PlayerPlane(
        position: Vector2(size.x / 2 - 30, size.y - 100), hitAction: hitAction);
    await add(_player);
    setTimerDurationByDifficulty();
    startEnemyAddTimers();
  }

  void setTimerDurationByDifficulty() {
    int diff = 2 - difficulty;
    print("diff: " + diff.toString());
    firstTimerDuration = (diff * 1000) + 1100;
    secondTimerDuration = (diff * 1000) + 1700;
    sideTimerDuration = (diff * 1000) + 2600;
    print(
        "diff = $diff, $firstTimerDuration, $secondTimerDuration, $sideTimerDuration");
  }

  void startEnemyAddTimers() {
    _timer =
        Timer.periodic(Duration(milliseconds: firstTimerDuration), (timer) {
      if (_controller.state is Playing) {
        addEnemy();
      }
    });
    _timer2 =
        Timer.periodic(Duration(milliseconds: secondTimerDuration), (timer) {
      if (_controller.state is Playing) {
        addEnemy();
      }
    });
    sidePlainTimer =
        Timer.periodic(Duration(milliseconds: sideTimerDuration), (timer) {
      if (_controller.state is Playing) {
        addSideEmeny();
      }
    });
  }

  @override
  void onRemove() {
    _timer?.cancel();
    _timer2?.cancel();
    sidePlainTimer?.cancel();
    super.onRemove();
  }

  @override
  void update(double dt) async {
    super.update(dt);
  }

  void addEnemy() async {
    await add(_controller.addRandomEnemy(difficulty: difficulty, size.x));
  }

  void addSideEmeny() async {
    SideEnemyPlain plane = _controller.addRandomSideEmenyPlain(
        difficulty: difficulty, size.x, size.y);
    await add(plane);
  }

  void flyLeft() {
    _player.position = Vector2(_player.position.x - 17, _player.position.y);
  }

  void flyRight() {
    _player.position = Vector2(_player.position.x + 17, _player.position.y);
  }

  void hitAction() {
    _controller.hit();
  }

  void timerOut() {
    _timer?.cancel();
    _timer2?.cancel();
    sidePlainTimer?.cancel();
  }
}
