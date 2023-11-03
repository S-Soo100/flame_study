import 'dart:math';
import 'dart:async' as ASYNC;
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_practice/game/airplane_game/airplane_game_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum EnemyPlainState { flying, hit }

class EnemyPlain extends SpriteComponent with HasGameRef, CollisionCallbacks {
  static const double enemySize = 76.0;
  late AirplaneGameController _controller;
  final int speed;
  EnemyPlain({required position, required this.speed})
      : super(size: Vector2.all(enemySize), position: position);

  late ShapeHitbox hitbox;
  EnemyPlainState _state = EnemyPlainState.flying;
  EnemyPlainState get state => _state;
  late String planeType;
  late int planeScore;
  late Sprite? _spirte;

  String initRandomType() {
    int type = Random().nextInt(3);
    switch (type) {
      case 0:
        planeScore = 100;
        return 'airplane_game/enemies/ship_0000.png';
      case 1:
        planeScore = 120;
        return 'airplane_game/enemies/ship_0002.png';
      case 2:
        planeScore = 130;
        return 'airplane_game/enemies/ship_0003.png';
      // case 3:
      //   planeScore = 30;
      //   return 'airplane_game/enemies/ship_0004.png';
      // case 4:
      //   planeScore = 20;
      //   return 'airplane_game/enemies/ship_0006.png';
      // case 5:
      //   planeScore = 50;
      //   return 'airplane_game/enemies/ship_0007.png';
      // case 6:
      //   planeScore = 60;
      //   return 'airplane_game/enemies/ship_0008.png';
      // case 7:
      //   planeScore = 20;
      //   return 'airplane_game/enemies/ship_0010.png';
      // case 8:
      //   planeScore = 20;
      //   return 'airplane_game/enemies/ship_0011.png';
      default:
        return 'airplane_game/enemies/ship_0010.png';
    }
  }

  @override
  void onLoad() async {
    super.onLoad();
    _controller = Get.find<AirplaneGameController>();
    planeType = initRandomType();
    _spirte = await gameRef.loadSprite(planeType);
    sprite = _spirte;
    position = position;
    angle = angle + pi;
    // anchor = Anchor.center;

    final Paint defaultPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke;
    hitbox = CircleHitbox()
      ..paint = defaultPaint
      ..renderShape = true;
    add(hitbox);
  }

  @override
  void update(double dt) {
    if (_state == EnemyPlainState.flying) {
      position = Vector2(position.x, position.y + speed + 0.3);
    }
    if (position.y + 1 > game.size.y) {
      removeFromParent();
      _controller.upScore(planeScore);
    }
    super.update(dt);
  }

  @override
  void onCollision(Set<Vector2> points, PositionComponent other) {
    super.onCollision(points, other);
    if (other is ScreenHitbox) {
      if (position.x < game.size.x) {
        if (position.x < size.x) {
          position = Vector2(0, position.y);
          return;
        } else if (position.x + size.x - 1 > game.size.x) {
          position = Vector2(game.size.x - size.x, position.y);
          return;
        }
      }
    } else {
      //...
    }
  }

  ASYNC.Timer? destroyTimer;

  void destroy() async {
    setStateToHit();
    _spirte = await gameRef.loadSprite(planeType);
    bool blink = false;
    sprite = null;
    destroyTimer =
        ASYNC.Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (blink == true) {
        sprite = null;
        blink = false;
      } else {
        sprite = _spirte;
        blink = true;
      }
    });
    Future.delayed(const Duration(seconds: 1), (() {
      removeFromParent();
      destroyTimer?.cancel();
    }));
  }

  void stopPlane() {
    destroy();
    // Future.delayed(const Duration(seconds: 1), (() {
    //   removeFromParent();
    //   destroyTimer?.cancel();
    // }));
  }

  void setStateToHit() {
    _state = EnemyPlainState.hit;
  }

  void upScore() {
    _controller.upScore(planeScore);
  }
}
