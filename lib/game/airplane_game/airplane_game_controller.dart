import 'dart:async';
import 'dart:math';

import 'package:flame/game.dart';
import 'package:flame_practice/core/state/game_state.dart';
import 'package:flame_practice/game/airplane_game/airplane_game.dart';
import 'package:flame_practice/game/airplane_game/game_components/enemy_plane.dart';
import 'package:flame_practice/game/airplane_game/game_components/side_enemy_plain.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class AirplaneGameController extends GetxController {
  // late Timer? _timer;
  // late Timer? _timer2;
  final Rx<GameState> _state = Rx(Init());
  GameState get state => _state.value;
  final Rx<int> _score = Rx(0);
  int get score => _score.value;
  final Rx<int> _hitPoint = Rx(5);
  int get hitPoint => _hitPoint.value;

  late AirplaneGame _game;
  AirplaneGame get game => _game;

  AirplaneGame newGameInstance() {
    return AirplaneGame();
  }

  void setNewGame() {
    _game = newGameInstance();
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void upScore(int score) {
    if (state is Playing) {
      _score.value = _score.value + score;
    }
  }

  void gameStart() {
    _state.value = Ready();
    Future.delayed(const Duration(seconds: 3), () {
      _state.value = Playing();
      _score.value = 0;
      _hitPoint.value = 5;
    });
  }

  void endGame() {
    _state.value = Init();
    _score.value = 0;
    _hitPoint.value = 5;
  }

  void hit() {
    if (state is Playing) {
      _hitPoint.value--;
      if (hitPoint == 0) {
        gameOver();
      }
    }
  }

  void gameOver() {
    if (state is Playing) {
      _state.value = GameOver();
    }
  }

  EnemyPlain addRandomEnemy(double sizex) {
    int randomDx = Random().nextInt(sizex ~/ 30) + 1;
    int randomSpeed = Random().nextInt(7) + 3;
    return EnemyPlain(
        position: Vector2(randomDx * 30, -60), speed: randomSpeed);
  }

  SideEnemyPlain addRandomSideEmenyPlain(double sizex, double sizey) {
    double randomInt = Random().nextDouble() * 0.1;
    print(randomInt);
    double randomDy = randomInt * sizey; // 화면 위에서 15% 이내
    int randomSpeed = Random().nextInt(4) + 3;
    bool randomSide = Random().nextBool();
    sideEnemyPlainType type =
        randomSide ? sideEnemyPlainType.left : sideEnemyPlainType.right;
    SideEnemyPlain sidePlain = SideEnemyPlain(
        position: Vector2(randomSide ? -60 : sizex + 60, randomDy),
        speed: randomSpeed,
        type: type);
    sidePlain.angle = randomSide ? -0.25 * pi : 0.25 * pi;
    return sidePlain;
  }

  void tryAgain() {
    setNewGame();
    gameStart();
  }

  void debugGameStart() {
    setNewGame();
    _state.value = Playing();
    _score.value = -1;
    _hitPoint.value = -1;
  }

  void disposeAll() {
    kDebugMode ? print("dispose all timers") : null;
    _game.timerOut();
  }
}
