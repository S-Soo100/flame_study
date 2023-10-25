import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';

class PlayerPlane extends SpriteComponent with HasGameRef, CollisionCallbacks {
  static const double playerSize = 50.0;
  PlayerPlane({required position})
      : super(size: Vector2.all(playerSize), position: position);

  late ShapeHitbox hitbox;

  @override
  void onLoad() async {
    super.onLoad();
    sprite = await gameRef.loadSprite('airplane_game/player1.png');
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
    super.update(dt);
  }

  @override
  void onCollision(Set<Vector2> points, PositionComponent other) {
    super.onCollision(points, other);
    if (other is ScreenHitbox) {
      print("Wall");
      if (position.x < size.x) {
        print("Wall left");
        // print("other position ${other.position.x}");
        // print("slime position ${position.x}");
        position = Vector2(position.x + 3, position.y);
      } else {
        print("Wall Right");
        // print("other position ${other.position.x}");
        // print("slime position ${position.x}");
        position = Vector2(position.x - 3, position.y);
      }
      //...
    } else {
      //...
    }
  }
}
