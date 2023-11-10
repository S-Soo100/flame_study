import 'dart:async' as Async;
import 'package:flame/collisions.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flame/palette.dart';
import 'package:flame/timer.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flame_practice/core/state/game_state.dart';
import 'package:flame_practice/game/airplane_game/airplane_game_controller.dart';
import 'package:flame_practice/game/airplane_game/game_components/airplane_game_bg.dart';
import 'package:flame_practice/game/airplane_game/game_components/bullet.dart';
import 'package:flame_practice/game/airplane_game/game_components/item.dart';
import 'package:flame_practice/game/airplane_game/game_components/player_plane.dart';
import 'package:flame_practice/game/airplane_game/game_components/side_enemy_plain.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AirplaneGame extends FlameGame with TapCallbacks, HasCollisionDetection {
  final AirplaneGameBg _gameBg = AirplaneGameBg(type: 0);
  final AirplaneGameBg _gameBgSecond = AirplaneGameBg(type: 1);
  late AirplaneGameController _controller;
  late Async.Timer? _timer;
  late Async.Timer? _timer2;
  late Async.Timer? _sidePlainTimer;
  late Async.Timer? _itemTimer;
  late PlayerPlane _player;
  int difficulty;
  late int firstTimerDuration;
  late int secondTimerDuration;
  late int sideTimerDuration;
  late int hpItemTimerDuration;
  late Timer _difficultyKeeper;
  bool canFire = true;

  AirplaneGame({required this.difficulty}) : super() {
    _difficultyKeeper = Timer(120, onTick: () {
      print("onTick");
      addNewEnemnyTimer();
    }, repeat: true);
  }

  @override
  Color backgroundColor() => const Color(0xffCB815E);

  // @override
  // void render(Canvas canvas) {
  //   super.render(canvas);
  //   TextPaint textPaint =
  //       TextPaint(style: TextStyle(color: BasicPalette.white.color));
  //   canvas.drawCircle(const Offset(50, 50), 50, Paint()..color = Colors.red);
  //   textPaint.render(
  //       canvas, _difficultyKeeper.current.toStringAsFixed(2), Vector2.all(36));
  //   // textPaint.render(canvas, "sizeX:${size.x}", Vector2.all(30));
  //   // textPaint.render(canvas, "sizeX/12:${size.x / 12}", Vector2.all(40));
  //   // textPaint.render(canvas, "sizeX/20:${size.x / 20}", Vector2.all(60));
  // }

  @override
  Future<void> onLoad() async {
    _controller = Get.find<AirplaneGameController>();

    add(ScreenHitbox());

    await add(_gameBg);
    _gameBgSecond.position = Vector2(0, -size.y);
    await add(_gameBgSecond);

    _player = PlayerPlane(
        playerSize: size.x / 9,
        position: Vector2(size.x / 2, size.y - 100),
        hitAction: hitAction,
        onTapAction: fireBullet);
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
    if (_controller.state is Playing) {
      _difficultyKeeper.update(dt);
    }
  }

  @override
  void onTapUp(TapUpEvent event) {
    // TODO: implement onTapUp
    super.onTapUp(event);
    _player.fire();
  }

  @override
  void onTapDown(TapDownEvent event) {
    // TODO: implement onTapDown
    super.onTapDown(event);
  }

  void _setTimerDurationByDifficulty(int difficulty) {
    int diff = 3 - difficulty;
    firstTimerDuration = (diff * 1000) + 1100;
    secondTimerDuration = (diff * 1000) + 1700;
    sideTimerDuration = (diff * 1000) + 2600;
    hpItemTimerDuration = (diff * 1000) + 10000;
  }

  void _startEnemyAddTimers() {
    _timer = Async.Timer.periodic(Duration(milliseconds: firstTimerDuration),
        (timer) {
      if (_controller.state is Playing) {
        addEnemy();
      }
    });
    _timer2 = Async.Timer.periodic(Duration(milliseconds: secondTimerDuration),
        (timer) {
      if (_controller.state is Playing) {
        addEnemy();
      }
    });
    _sidePlainTimer = Async.Timer.periodic(
        Duration(milliseconds: sideTimerDuration), (timer) {
      if (_controller.state is Playing) {
        addSideEmeny();
      }
    });
    _itemTimer = Async.Timer.periodic(
        Duration(milliseconds: hpItemTimerDuration), (timer) {
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
    _controller.hit();
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

  void fireBullet() async {
    // print("Fire Bullet");
    if (canFire) {
      canFire = false;
      await add(Bullet(
          position: Vector2(_player.position.x, _player.position.y - 36)));
      Future.delayed(const Duration(milliseconds: 333), () {
        canFire = true;
      });
    }
  }

  void addNewEnemnyTimer() async {
    // print("new timer up");
    // await add(_controller.addRandomEnemy(difficulty: difficulty, size.x));
    Async.Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_controller.state is Playing) {
        // print("new timer test");
        add(_controller.addRandomEnemy(difficulty: difficulty, size.x));
      } else {
        timer.cancel();
        print('timer canceled');
      }
    });
  }
}
