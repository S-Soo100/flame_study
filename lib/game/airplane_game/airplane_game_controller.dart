import 'dart:async';
import 'dart:math';

import 'package:flame/game.dart';
import 'package:flame_practice/core/state/game_state.dart';
import 'package:flame_practice/game/airplane_game/game_components/enemy_plane.dart';
import 'package:get/get.dart';

class AirplaneGameController extends GetxController {
  // late Timer? _timer;
  // late Timer? _timer2;
  Rx<GameState> _state = Rx(Init());
  GameState get state => _state.value;
  Rx<int> _score = Rx(0);
  int get score => _score.value;
  Rx<int> _hitPoint = Rx(5);
  int get hitPoint => _hitPoint.value;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void upScore(int score) {
    _score.value = _score.value + score;
  }

  void gameStart() {
    _state.value = Ready();
    Future.delayed(Duration(seconds: 3), () {
      _state.value = Playing();
      _hitPoint.value = 5;
    });
  }

  void endGame() {
    _state.value = Init();
    _score.value = 0;
    _hitPoint.value = 5;
  }

  void hit() {
    _hitPoint.value--;
    if (hitPoint == 0) {
      gameOver();
    }
  }

  void gameOver() {
    _state.value = GameOver();
  }

  EnemyPlain addRandomEnemy() {
    int randomDx = Random().nextInt(13) + 1;
    int randomSpeed = Random().nextInt(7) + 2;
    return EnemyPlain(position: Vector2(randomDx * 30, 30), speed: randomSpeed);
  }

  void tryAgain() {
    gameStart();
  }
}
