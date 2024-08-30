import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_practice/core/state/game_state.dart';
import 'package:flame_practice/game/airplane_game/airplane_game.dart';
import 'package:flame_practice/game/airplane_game/game_components/airplane_game_over_widget.dart';
import 'package:get/get.dart';

enum AirplaneGamePhase {
  init,
  phase1,
  phase2,
  phase3,
  phase4,
  phase5,
  phase6,
  phase7
}

class AirplaneGameController extends GetxController {
  AirplaneGamePhase _phase = AirplaneGamePhase.init;
  void setAirplaneGamePhase(AirplaneGamePhase newPhase) {
    _phase = newPhase;
  }

  AirplaneGamePhase get phase => _phase;

  late Timer? timeCount;
  Rx<double> timeCountValue = Rx(0);
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
    return AirplaneGame();
  }

  void setNewGame() {
    _game = newGameInstance();
    //todo debuggggggggggggggggggg
    _phase = AirplaneGamePhase.phase5; //! debuging
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
      _game.stopMusic();
      _showGameOverDialog();
    }
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
    setNewGame();
  }

  void stopMusic() {
    _game.stopMusic();
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
    if (isRetry) {
      setNewGame();
      tryAgain();
    }
  }
}
