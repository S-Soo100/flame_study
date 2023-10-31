import 'package:flame/extensions.dart';
import 'package:flame_practice/game/airplane_game/airplane_game_controller.dart';
import 'package:flame_practice/game/airplane_game/game_components/enemy_plane.dart';
import 'dart:math';
import 'dart:async' as ASYNC;
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_practice/game/airplane_game/airplane_game_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum sideEnemyPlainType { left, right }

class SideEnemyPlain extends EnemyPlain {
  final sideEnemyPlainType type;
  EnemyPlainState _state = EnemyPlainState.flying;
  EnemyPlainState get state => _state;
  late Sprite? _spirte;
  SideEnemyPlain(
      {required super.position, required super.speed, required this.type});
  late AirplaneGameController _controller;

  @override
  void onLoad() async {
    super.onLoad();
    planeType = initRandomType();
    _spirte = await gameRef.loadSprite(planeType);
    sprite = _spirte;
    _controller = Get.find<AirplaneGameController>();
  }

  @override
  void update(double dt) {
    // super.update(dt);
    if (_state == EnemyPlainState.flying) {
      if (type == sideEnemyPlainType.left) {
        position = Vector2(position.x + (speed / 1.2), position.y + speed);
      } else {
        position = Vector2(position.x - (speed / 1.2), position.y + speed);
      }
    }

    if (type == sideEnemyPlainType.left && position.x > gameRef.size.x) {
      print('side left');
      removeFromParent();
      _controller.upScore(planeScore);
      return;
    } else if (type == sideEnemyPlainType.right && position.x < 0) {
      print('side right');
      removeFromParent();
      _controller.upScore(planeScore);
      return;
    }
  }

  @override
  void onCollision(Set<Vector2> points, PositionComponent other) {
    // super.onCollision(points, other);
    if (other is ScreenHitbox) {
      // ...
    } else {
      // ...
    }
  }

  @override
  void stopPlane() {
    _state = EnemyPlainState.hit;
    destroy();
    Future.delayed(const Duration(seconds: 1), (() => removeFromParent()));
  }
}
