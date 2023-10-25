import 'dart:math';
import 'dart:async' as ASYNC;
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

enum EnemyPlainState { flying, hit }

class EnemyPlain extends SpriteComponent with HasGameRef, CollisionCallbacks {
  static const double enemySize = 60.0;
  final int speed;
  final Function upScore;
  EnemyPlain({required position, required this.speed, required this.upScore})
      : super(size: Vector2.all(enemySize), position: position);

  late ShapeHitbox hitbox;
  EnemyPlainState _state = EnemyPlainState.flying;
  EnemyPlainState get state => _state;
  late String planeType;
  late int planeScore;
  late Sprite? _spirte;

  String initRandomType() {
    int type = Random().nextInt(4);
    switch (type) {
      case 0:
        planeScore = 20;
        return 'airplane_game/enemies/enemy1-1.png';
      case 1:
        planeScore = 100;
        return 'airplane_game/enemies/enemy2-1.png';
      case 2:
        planeScore = 50;
        return 'airplane_game/enemies/enemy3-1.png';
      case 3:
        planeScore = 30;
        return 'airplane_game/choppers/chopper2-2.png';
      default:
        return 'airplane_game/enemies/enemy3-1.png';
    }
  }

  @override
  void onLoad() async {
    super.onLoad();
    planeType = initRandomType();
    _spirte = await gameRef.loadSprite(planeType);
    sprite = _spirte;
    position = position;

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
      position = Vector2(position.x, position.y + speed);
    }
    super.update(dt);
  }

  @override
  void onCollision(Set<Vector2> points, PositionComponent other) {
    super.onCollision(points, other);
    if (other is ScreenHitbox) {
      if (position.x > game.size.x) {
        position = Vector2(game.size.x - 60, position.y);
      }
      if (position.y < game.size.y) {
        removeFromParent();
        upScore();
      } else {}
      //...
    } else {
      //...
    }
  }

  ASYNC.Timer? destroyTimer;

  void destroy() async {
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
  }

  void stopPlane() {
    _state = EnemyPlainState.hit;
    destroy();
    Future.delayed(const Duration(seconds: 1), (() => removeFromParent()));
  }
}
