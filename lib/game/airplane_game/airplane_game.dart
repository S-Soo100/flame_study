import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flame/palette.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flame_practice/game/airplane_game/airplane_game_controller.dart';
import 'package:flame_practice/game/airplane_game/game_components/airplane_game_bg.dart';
import 'package:flame_practice/game/airplane_game/game_components/enemy_components/phase1_enemy_component.dart';
import 'package:flame_practice/game/airplane_game/game_components/enemy_components/phase2_enemy_component.dart';
import 'package:flame_practice/game/airplane_game/game_components/enemy_components/phase3_enemy_component.dart';
import 'package:flame_practice/game/airplane_game/game_components/player_plane.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AirplaneGame extends FlameGame with TapCallbacks, HasCollisionDetection {
  final AirplaneGameBg _gameBg = AirplaneGameBg(type: 0);
  final AirplaneGameBg _gameBgSecond = AirplaneGameBg(type: 1);
  bool canFire = true;

  final double phaseTime = 20;
  final int phaseEnemyAmount = 10;
  final double phaseEndTime = 25;
  late AirplaneGameController _controller;
  late PlayerPlane _player;
  late Timer? _phase1Timer;
  late Timer? _phase2Timer;
  late Timer? _phase3Timer;
  late List<Phase1EnemyComponent> phase1Enemies;
  late List<Phase2EnemyComponent> phase2Enemies;
  late List<Phase3EnemyComponent> phase3Enemies;

  AirplaneGame() : super();

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
      playerSize: 50,
      position: Vector2(size.x / 2, size.y - 100),
      hitAction: hitAction,
    );
    await add(_player);
    setEnemyArray();
    setTimers();
    // overlays.add('score');
    // overlays.add('score2');
    // overlays.add('score3');
  }

  @override
  void update(double dt) async {
    super.update(dt);
    updateActionByPhase(dt);
  }

  void updateActionByPhase(double dt) {
    switch (_controller.phase) {
      case AirplaneGamePhase.phaseFirst:
        firstPhase(dt);
        return;
      case AirplaneGamePhase.phaseSecond:
        secondPhase(dt);
        return;
      case AirplaneGamePhase.phaseThird:
        thirdPhase(dt);
        return;
      case AirplaneGamePhase.phaseFourth:
        fourthPhase(dt);
        return;
      default:
        return;
    }
  }

  void setEnemyArray() {
    phase1Enemies = List.generate(
        10, (index) => Phase1EnemyComponent(Vector2(0, 500), id: index));
    phase2Enemies = List.generate(
        10, (index) => Phase2EnemyComponent(Vector2(size.x, 500), id: index));
    phase3Enemies = List.generate(
        10, (index) => Phase3EnemyComponent(Vector2(0, 500), id: index));
  }

  void setTimers() {
    _phase1Timer = Timer(1, onTick: createPhase1Enemy, repeat: true);
    _phase2Timer = Timer(1, onTick: createPhase2Enemy, repeat: true);
    _phase3Timer = Timer(1, onTick: createPhase3Enemy, repeat: true);
  }

  double phase1EnemyCount = 0;
  void createPhase1Enemy() {
    if (phase1EnemyCount < phaseEnemyAmount) {
      add(phase1Enemies[phase1EnemyCount.toInt()]);
      phase1EnemyCount++;
      // return;
    } else {
      phase1EnemyCount++;
    }
    if (phase1EnemyCount > phaseEndTime) {
      _phase1Timer?.stop();
      phase1EnemyCount = 0;
      _controller.setAirplaneGamePhase(AirplaneGamePhase.phaseSecond);
    }
  }

  double phase2EnemyCount = 0;
  void createPhase2Enemy() {
    if (phase2EnemyCount < phaseEnemyAmount) {
      add(phase2Enemies[phase2EnemyCount.toInt()]);
      phase2EnemyCount++;
      // return;
    } else {
      phase2EnemyCount++;
    }
    if (phase2EnemyCount > phaseEndTime) {
      _controller.setAirplaneGamePhase(AirplaneGamePhase.phaseThird);
    }
  }

  double phase3EnemyCount = 0;
  void createPhase3Enemy() {
    if (phase3EnemyCount < phaseEnemyAmount) {
      add(phase3Enemies[phase3EnemyCount.toInt()]);
      phase3EnemyCount++;
      // return;
    } else {
      phase3EnemyCount++;
    }
    if (phase3EnemyCount > phaseEndTime) {
      _controller.setAirplaneGamePhase(AirplaneGamePhase.phaseFourth);
    }
  }

  void firstPhase(double dt) {
    _phase1Timer?.update(dt);
  }

  void secondPhase(double dt) {
    _phase2Timer?.update(dt);
  }

  void thirdPhase(double dt) {
    _phase3Timer?.update(dt);
  }

  void fourthPhase(double dt) {}

  @override
  void onRemove() {
    _phase1Timer?.stop();
    super.onRemove();
  }

  void flyLeft() {
    double dx = size.x / 16;
    _player.position = Vector2(_player.position.x - dx, _player.position.y);
    if (_player.position.x - (_player.size.x / 2) - dx < 0) {
      _player.position = Vector2(_player.size.x / 2, _player.position.y);
      kDebugMode ? print("fly exception Left") : null;
    }
  }

  void flyRight() {
    double dx = size.x / 16;
    _player.position = Vector2(_player.position.x + dx, _player.position.y);
    if (_player.position.x + (_player.size.x / 2) + dx > size.x) {
      _player.position =
          Vector2(size.x - _player.size.x / 2, _player.position.y);
      kDebugMode ? print("fly exception Right") : null;
    }
  }

  void hitAction() {
    // _controller.hit();
  }

  void stopMusic() {
    FlameAudio.bgm.stop();
  }

  void playBgm() {
    FlameAudio.bgm.play('airplane_game/bg_music.mp3');
  }

  Vector2 getPlayerPosition() {
    return _player.position;
  }
}
