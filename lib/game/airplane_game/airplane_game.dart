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
import 'package:flame_practice/game/airplane_game/game_components/enemy_components/phase4_enemy_component.dart';
import 'package:flame_practice/game/airplane_game/game_components/enemy_components/phase5_enemy_component.dart';
import 'package:flame_practice/game/airplane_game/game_components/enemy_components/phase6_enemy_component.dart';
import 'package:flame_practice/game/airplane_game/game_components/enemy_components/phase7_enemy_component.dart';
import 'package:flame_practice/game/airplane_game/game_components/player_plane.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AirplaneGame extends FlameGame with TapCallbacks, HasCollisionDetection {
  final AirplaneGameBg _gameBg = AirplaneGameBg(type: 0);
  final AirplaneGameBg _gameBgSecond = AirplaneGameBg(type: 1);
  late Map<AirplaneGamePhase, List<SpriteComponent>> enemies;
  late Map<AirplaneGamePhase, Timer> timers;
  late Map<AirplaneGamePhase, SpriteComponent> phaseConfigs;
  bool canFire = true;

  final double phaseTime = 20;
  final int phaseEnemyAmount = 10;
  final double phaseEndTime = 25;
  late AirplaneGameController _controller;
  late PlayerPlane _player;
  late Timer? _phase1Timer;
  late Timer? _phase2Timer;
  late Timer? _phase3Timer;
  late Timer? _phase4Timer;
  late Timer? _phase5Timer;
  late Timer? _phase6Timer;
  late Timer? _phase7Timer;
  late List<Phase1EnemyComponent> phase1Enemies;
  late List<Phase2EnemyComponent> phase2Enemies;
  late List<Phase3EnemyComponent> phase3Enemies;
  late List<Phase4EnemyComponent> phase4Enemies;
  late List<Phase5EnemyComponent> phase5Enemies;
  late List<Phase6EnemyComponent> phase6Enemies;
  late List<Phase7EnemyComponent> phase7Enemies;

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
    setPhases();
    // overlays.add('score');
    // overlays.add('score2');
    // overlays.add('score3');
  }

  @override
  void update(double dt) async {
    super.update(dt);
    updateTimerByPhase(dt);
  }

  void updateTimerByPhase(double dt) {
    final actions = {
      AirplaneGamePhase.phase1: _phase1Timer?.update,
      AirplaneGamePhase.phase2: _phase2Timer?.update,
      AirplaneGamePhase.phase3: _phase3Timer?.update,
      AirplaneGamePhase.phase4: _phase4Timer?.update,
      AirplaneGamePhase.phase5: _phase5Timer?.update,
      AirplaneGamePhase.phase6: _phase6Timer?.update,
      AirplaneGamePhase.phase7: _phase7Timer?.update,
    };

    actions[_controller.phase]?.call(dt);
  }

  void setPhase1() {
    phase1Enemies = List.generate(
        phaseEnemyAmount, (index) => Phase1EnemyComponent(id: index));
    _phase1Timer = Timer(1, onTick: createPhase1Enemy, repeat: true);
  }

  void setPhase2() {
    phase2Enemies = List.generate(
        phaseEnemyAmount, (index) => Phase2EnemyComponent(id: index));
    _phase2Timer = Timer(1, onTick: createPhase2Enemy, repeat: true);
  }

  void setPhase3() {
    phase3Enemies = List.generate(
        phaseEnemyAmount, (index) => Phase3EnemyComponent(id: index));
    _phase3Timer = Timer(1, onTick: createPhase3Enemy, repeat: true);
  }

  void setPhase4() {
    phase4Enemies = List.generate(phaseEnemyAmount,
        (index) => Phase4EnemyComponent(Vector2(size.x, 500), id: index));
    _phase4Timer = Timer(1, onTick: createPhase4Enemy, repeat: true);
  }

  void setPhase5() {
    phase5Enemies = List.generate(phaseEnemyAmount,
        (index) => Phase5EnemyComponent(Vector2(0, 500), id: index));
    _phase5Timer = Timer(1, onTick: createPhase5Enemy, repeat: true);
  }

  void setPhase6() {
    phase6Enemies = List.generate(phaseEnemyAmount,
        (index) => Phase6EnemyComponent(Vector2(size.x, 500), id: index));
    _phase6Timer = Timer(1, onTick: createPhase6Enemy, repeat: true);
  }

  void setPhase7() {
    phase7Enemies = List.generate(phaseEnemyAmount,
        (index) => Phase7EnemyComponent(Vector2(0, 500), id: index));
    _phase7Timer = Timer(1, onTick: createPhase7Enemy, repeat: true);
  }

  void setPhases() {
    setPhase1();
    setPhase2();
    setPhase3();
    setPhase4();
    setPhase5();
    setPhase6();
    setPhase7();
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
      setPhase2();
      _controller.setAirplaneGamePhase(AirplaneGamePhase.phase2);
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
      _phase2Timer?.stop();
      phase2EnemyCount = 0;
      setPhase3();
      _controller.setAirplaneGamePhase(AirplaneGamePhase.phase3);
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
      _phase3Timer?.stop();
      phase3EnemyCount = 0;
      setPhase4();
      _controller.setAirplaneGamePhase(AirplaneGamePhase.phase4);
    }
  }

  double phase4EnemyCount = 0;
  void createPhase4Enemy() {
    if (phase4EnemyCount < phaseEnemyAmount) {
      add(phase4Enemies[phase4EnemyCount.toInt()]);
      phase4EnemyCount++;
      // return;
    } else {
      phase4EnemyCount++;
    }
    if (phase4EnemyCount > phaseEndTime) {
      _phase4Timer?.stop();
      phase4EnemyCount = 0;
      setPhase5();
      _controller.setAirplaneGamePhase(AirplaneGamePhase.phase5);
    }
  }

  double phase5EnemyCount = 0;
  void createPhase5Enemy() {
    if (phase5EnemyCount < phaseEnemyAmount) {
      add(phase5Enemies[phase5EnemyCount.toInt()]);
      phase5EnemyCount++;
      // return;
    } else {
      phase5EnemyCount++;
    }
    if (phase5EnemyCount > phaseEndTime) {
      _phase5Timer?.stop();
      phase5EnemyCount = 0;
      setPhase6();
      _controller.setAirplaneGamePhase(AirplaneGamePhase.phase6);
    }
  }

  double phase6EnemyCount = 0;
  void createPhase6Enemy() {
    if (phase6EnemyCount < phaseEnemyAmount) {
      add(phase6Enemies[phase6EnemyCount.toInt()]);
      phase6EnemyCount++;
      // return;
    } else {
      phase6EnemyCount++;
    }
    if (phase6EnemyCount > phaseEndTime) {
      _phase6Timer?.stop();
      phase6EnemyCount = 0;
      setPhase7();
      _controller.setAirplaneGamePhase(AirplaneGamePhase.phase7);
    }
  }

  double phase7EnemyCount = 0;
  void createPhase7Enemy() {
    if (phase7EnemyCount < phaseEnemyAmount) {
      add(phase7Enemies[phase7EnemyCount.toInt()]);
      phase7EnemyCount++;
      // return;
    } else {
      phase7EnemyCount++;
    }
    if (phase7EnemyCount > phaseEndTime) {
      _phase7Timer?.stop();
      phase7EnemyCount = 0;
      setPhase1();
      _controller.setAirplaneGamePhase(AirplaneGamePhase.phase1);
    }
  }

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
