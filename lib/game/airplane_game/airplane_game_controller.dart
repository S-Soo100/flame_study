import 'dart:async';
import 'dart:math';

import 'package:flame/game.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flame_practice/core/state/game_state.dart';
import 'package:flame_practice/game/airplane_game/airplane_game.dart';
import 'package:flame_practice/game/airplane_game/game_components/airplane_game_over_widget.dart';
import 'package:flame_practice/game/airplane_game/game_components/enemy_plane.dart';
import 'package:flame_practice/game/airplane_game/game_components/item.dart';
import 'package:flame_practice/game/airplane_game/game_components/side_enemy_plain.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class AirplaneGameController extends GetxController {
  late Timer? scoreTimer;
  final Rx<GameState> _state = Rx(Init());
  GameState get state => _state.value;
  final Rx<int> _score = Rx(0);
  int get score => _score.value;
  final Rx<int> _killCount = Rx(0);
  int get killCount => _killCount.value;
  final Rx<int> _hitPoint = Rx(5);
  int get hitPoint => _hitPoint.value;
  Rx<int> _difficulty = Rx(0);
  int get difficulty => _difficulty.value;
  void setDifficulty(int diff) {
    if (diff > 1) {
      _difficulty.value = 2;
      return;
    }
    _difficulty.value = diff;
  }

  late AirplaneGame _game;
  AirplaneGame get game => _game;

  AirplaneGame newGameInstance() {
    return AirplaneGame(difficulty: _difficulty.value);
  }

  void setNewGame() {
    setScoreTimer();
    _game = newGameInstance();
  }

  @override
  void onInit() {
    super.onInit();
  }

  void setScoreTimer() {
    scoreTimer = Timer.periodic(const Duration(milliseconds: 1000), (timer) {
      if (state is Playing) {
        _score.value = _score.value + 10;
      }
    });
  }

  void cancelScoreTimer() {
    scoreTimer?.cancel();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void upScore(int score) {
    if (state is Playing) {
      // _score.value = _score.value + score;
    }
  }

  void gameStart() {
    _state.value = Ready();
    _game.playBgm();
    Future.delayed(const Duration(seconds: 3), () {
      _state.value = Playing();
      _score.value = 0;
      _killCount.value = 0;
      _hitPoint.value = 5;
      setNewGame();
    });
  }

  void endGame() {
    _state.value = Init();
    _score.value = 0;
    _hitPoint.value = 5;
    stopMusic();
    _game.disposeTimer();
    try {
      cancelScoreTimer();
    } catch (e) {}
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
      _game.cancelAllTimers();
      _game.stopMusic();
      cancelScoreTimer();
      _showGameOverDialog();
    }
  }

  EnemyPlain addRandomEnemy(double sizex, {required int difficulty}) {
    int randomDx = Random().nextInt(sizex ~/ 30) + 1;
    int randomSpeed = Random().nextInt(difficulty * 2 + 3) + 2;
    return EnemyPlain(
        enemySize: _game.size.x / 10,
        position: Vector2(randomDx * 30, -60),
        speed: randomSpeed);
  }

  SideEnemyPlane addRandomSideEmenyPlain(double sizex, double sizey,
      {required int difficulty}) {
    double randomInt = Random().nextDouble() * 0.1;
    double randomDy = randomInt * sizey; // 화면 위에서 15% 이내
    int randomSpeed = Random().nextInt(difficulty * 2 + 3) + 2;
    bool randomSide = Random().nextBool();
    sideEnemyPlainType type =
        randomSide ? sideEnemyPlainType.left : sideEnemyPlainType.right;
    SideEnemyPlane sidePlain = SideEnemyPlane(
        enemySize: _game.size.x / 12,
        position: Vector2(randomSide ? -60 : sizex + 60, randomDy),
        speed: randomSpeed,
        type: type);
    sidePlain.angle = randomSide ? -0.25 * pi : 0.25 * pi;
    sidePlain.size = Vector2.all(60);
    return sidePlain;
  }

  void tryAgain() {
    print("try again");
    setNewGame();
    gameStart();
  }

  void debugGameStart() {
    setNewGame();
    _state.value = Playing();
    _score.value = -1;
    _hitPoint.value = -1;
    _killCount.value = 0;
  }

  void debugGameEnd() {
    _score.value = 0;
    _killCount.value = 0;
    _hitPoint.value = 5;
    _state.value = Init();
    disposeAll();
    setNewGame();
  }

  void disposeAll() {
    kDebugMode ? print("dispose all timers") : null;
    // stopMusic();
    _game.cancelAllTimers();
  }

  void stopMusic() {
    _game.stopMusic();
  }

  void addHpUpItems(double sizex) {
    int randomDx = Random().nextInt(sizex ~/ 8) + 1;
    Item hpUpItem = Item(
        itemSize: sizex / 11,
        image: 'airplane_game/items/item_hp.png',
        action: () {
          _killCount.value = 0;
          _hitPoint.value > 0 ? _hitPoint.value++ : null;
        },
        position: Vector2(randomDx * 30, 0));
    _game.addHpUpItems(hpUpItem);
  }

  void upKillCount() {
    _killCount.value++;
  }

  void _showGameOverDialog() async {
    bool isRetry = await Get.dialog(
        AirplaneGameOverWidget(
          distanceMeter: score,
          killScore: killCount,
        ),
        barrierDismissible: false);
    // Get.to(AirplaneGameOverWidget(
    //   distanceMeter: score,
    //   killScore: killCount,
    // ));
    if (isRetry) {
      setNewGame();
      tryAgain();
    }
  }
}
