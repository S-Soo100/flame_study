import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_practice/game/airplane_game/game_components/enemy_plane.dart';
import 'package:flutter/material.dart';

class PlayerPlane extends SpriteComponent with HasGameRef, CollisionCallbacks {
  static const double playerSize = 60.0;
  final Function hitAction;
  PlayerPlane({required position, required this.hitAction})
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
      if (position.x < size.x) {
        position = Vector2(position.x + 3, position.y);
      } else {
        position = Vector2(position.x - 3, position.y);
      }
    } else if (other is EnemyPlain) {
      if (other.state == EnemyPlainState.flying) {
        other.stopPlane();
        hitAction();
      }
    }
  }
}
