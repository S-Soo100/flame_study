import 'dart:async';
import 'package:flame/collisions.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flame_practice/core/state/game_state.dart';
import 'package:flame_practice/game/airplane_game/airplane_game_controller.dart';
import 'package:flame_practice/game/airplane_game/game_components/airplane_game_bg.dart';
import 'package:flame_practice/game/airplane_game/game_components/item.dart';
import 'package:flame_practice/game/airplane_game/game_components/player_plane.dart';
import 'package:flame_practice/game/airplane_game/game_components/side_enemy_plain.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AirplaneGame extends FlameGame with TapCallbacks, HasCollisionDetection {
  final AirplaneGameBg _gameBg = AirplaneGameBg(type: 0);
  final AirplaneGameBg _gameBgSecond = AirplaneGameBg(type: 1);
  late AirplaneGameController _controller;
  late Timer? _timer;
  late Timer? _timer2;
  late Timer? _sidePlainTimer;
  late Timer? _itemTimer;
  late PlayerPlane _player;
  int difficulty;
  late int firstTimerDuration;
  late int secondTimerDuration;
  late int sideTimerDuration;

  AirplaneGame({required this.difficulty}) : super();

  @override
  Color backgroundColor() => const Color(0xffCB815E);

  @override
  Future<void> onLoad() async {
    _controller = Get.find<AirplaneGameController>();

    add(ScreenHitbox());

    await add(_gameBg);
    _gameBgSecond.position = Vector2(0, -size.y);
    await add(_gameBgSecond);

    _player = PlayerPlane(
        position: Vector2(size.x / 2 - 42, size.y - 100), hitAction: hitAction);
    await add(_player);

    _setTimerDurationByDifficulty(difficulty);
    _startEnemyAddTimers();
  }

  @override
  void onRemove() {
    _timer?.cancel();
    _timer2?.cancel();
    _sidePlainTimer?.cancel();
    // stopMusic();
    super.onRemove();
  }

  @override
  void update(double dt) async {
    super.update(dt);
  }

  void _setTimerDurationByDifficulty(int difficulty) {
    int diff = 2 - difficulty;
    firstTimerDuration = (diff * 1000) + 1100;
    secondTimerDuration = (diff * 1000) + 1700;
    sideTimerDuration = (diff * 1000) + 2600;
  }

  void _startEnemyAddTimers() {
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
    _sidePlainTimer =
        Timer.periodic(Duration(milliseconds: sideTimerDuration), (timer) {
      if (_controller.state is Playing) {
        addSideEmeny();
      }
    });
    _itemTimer = Timer.periodic(const Duration(seconds: 16), (timer) {
      if (_controller.state is Playing) {
        _controller.addHpUpItems(size.x);
      }
    });
  }

  void addEnemy() async {
    await add(_controller.addRandomEnemy(difficulty: difficulty, size.x));
  }

  void addSideEmeny() async {
    SideEnemyPlane plane = _controller.addRandomSideEmenyPlain(
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
    // pool.start();
    _controller.hit();

    FlameAudio.play('airplane_game/hit_sound.wav');
  }

  void cancelAllTimers() {
    _timer?.cancel();
    _timer2?.cancel();
    _sidePlainTimer?.cancel();
    _itemTimer?.cancel();
  }

  void stopMusic() {
    FlameAudio.bgm.stop();
    // FlameAudio.bgm.dispose();
  }

  void playBgm() {
    // FlameAudio.bgm.initialize();
    FlameAudio.bgm.play('airplane_game/bg_music.mp3');
  }

  void addHpUpItems(Item item) async {
    await add(item);
  }
}
