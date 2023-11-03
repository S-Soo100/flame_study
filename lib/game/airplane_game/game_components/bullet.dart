import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_practice/game/airplane_game/game_components/enemy_plane.dart';
import 'package:flame_practice/game/airplane_game/game_components/item.dart';
import 'package:flutter/material.dart';

class Bullet extends SpriteComponent with CollisionCallbacks, HasGameRef {
  Bullet({required position})
      : super(size: Vector2(12, 40), position: position);
  late ShapeHitbox hitbox;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    sprite = await gameRef.loadSprite('airplane_game/items/bullet_001.png');
    final Paint defaultPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke;
    hitbox = RectangleHitbox()
      ..paint = defaultPaint
      ..renderShape = true;
    add(hitbox);
  }

  @override
  void update(double dt) {
    super.update(dt);
    position = Vector2(x, y - 3);
    //화면 맨 위로 나가면 사라지는 로직
    if (y < 0) {
      removeFromParent();
    }
  }

  @override
  void onCollision(Set<Vector2> points, PositionComponent other) {
    super.onCollision(points, other);
    if (other is ScreenHitbox) {
    } else if (other is EnemyPlain) {
      // 박살내고
      // 스코어 올리고
      // 총알 없애고
      if (other.state == EnemyPlainState.flying) {
        other.destroy();
      }
      removeFromParent();
    } else if (other is Item) {
      // 박살내고
      // 슬프다
      if (other.state == ItemState.falling) {
        other.itemAction();
      }
      removeFromParent();
    }
  }
}
