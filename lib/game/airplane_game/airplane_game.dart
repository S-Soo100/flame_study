import 'dart:async';
import 'dart:math';
import 'package:flame/collisions.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flame_practice/core/state/game_state.dart';
import 'package:flame_practice/game/airplane_game/airplane_game_controller.dart';
import 'package:flame_practice/game/airplane_game/game_components/airplane_game_bg.dart';
import 'package:flame_practice/game/airplane_game/game_components/player_plane.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AirplaneGame extends FlameGame with TapCallbacks, HasCollisionDetection {
  final AirplaneGameBg _gameBg = AirplaneGameBg();
  final AirplaneGameBg _gameBgSecond = AirplaneGameBg();
  late AirplaneGameController _controller;
  late Timer? _timer;
  late Timer? _timer2;
  late PlayerPlane _player;

  AirplaneGame();

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
    _timer = Timer.periodic(const Duration(milliseconds: 2200), (timer) {
      if (_controller.state is Playing) {
        addEnemy();
      }
    });
    _timer2 = Timer.periodic(const Duration(milliseconds: 2800), (timer) {
      if (_controller.state is Playing) {
        addEnemy();
      }
    });
  }

  @override
  void onRemove() {
    _timer?.cancel();
    _timer2?.cancel();
    super.onRemove();
  }

  @override
  void update(double dt) async {
    super.update(dt);
  }

  void addEnemy() async {
    add(_controller.addRandomEnemy(size.x));
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
}
