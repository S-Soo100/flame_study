import 'dart:async';
import 'dart:math';
import 'package:flame/collisions.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flame_practice/game/airplane_game/game_components/airplane_game_bg.dart';
import 'package:flame_practice/game/airplane_game/game_components/enemy_plane.dart';
import 'package:flame_practice/game/airplane_game/game_components/player_plane.dart';
import 'package:flutter/material.dart';

class AirplaneGame extends FlameGame with TapCallbacks, HasCollisionDetection {
  final AirplaneGameBg _gameBg = AirplaneGameBg();
  late Timer? _timer;
  late Timer? _timer2;
  late PlayerPlane _player;
  Function moveLeft;
  Function moveRight;
  int _emenyCount = 0;

  AirplaneGame({required this.moveLeft, required this.moveRight});

  @override
  Color backgroundColor() => const Color(0xff434343);

  @override
  Future<void> onLoad() async {
    add(ScreenHitbox());
    await add(_gameBg);
    _player = PlayerPlane(position: Vector2(size.x / 2 - 25, size.y - 80));
    await add(_player);

    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      addEnemy();
    });
    _timer2 = Timer.periodic(const Duration(seconds: 3), (timer) {
      addEnemy();
    });
  }

  @override
  void onRemove() {
    _timer?.cancel();
    super.onRemove();
  }

  @override
  void update(double dt) async {
    super.update(dt);
  }

  void addEnemy() async {
    print("ADD ENEMNY");
    print("${_emenyCount}");
    int randomDx = Random().nextInt(15) + 1;
    int randomSpeed = Random().nextInt(6) + 1;
    EnemyPlain enemy =
        EnemyPlain(position: Vector2(randomDx * 25, 25), speed: randomSpeed);
    add(enemy);
  }

  void flyLeft() {
    moveLeft();
    _player.position = Vector2(_player.position.x - 14, _player.position.y);
  }

  void flyRight() {
    moveRight();
    _player.position = Vector2(_player.position.x + 14, _player.position.y);
  }
}
