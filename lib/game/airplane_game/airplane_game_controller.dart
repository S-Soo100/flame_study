import 'dart:async';
import 'dart:math';

import 'package:flame/game.dart';
import 'package:flame_practice/core/state/game_state.dart';
import 'package:flame_practice/game/airplane_game/airplane_game.dart';
import 'package:flame_practice/game/airplane_game/game_components/enemy_plane.dart';
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

  void tryAgain() {
    setNewGame();
    gameStart();
  }
}
