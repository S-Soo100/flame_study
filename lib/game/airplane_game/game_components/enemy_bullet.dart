import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_practice/game/airplane_game/airplane_game.dart';
import 'dart:math' as math;

class EnemnyBullet extends SpriteComponent
    with CollisionCallbacks, HasGameRef<AirplaneGame> {
  final Vector2 direction;
  final double speed = 100.0;

  EnemnyBullet(Vector2 position, this.direction)
      : super(size: Vector2(12, 20)) {
    this.position = position;
    angle = math.atan2(direction.y, direction.x);
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    sprite = await Sprite.load('airplane_game/items/enemy_bullet_16_8.png');
    angle += math.pi / 2;
  }

  @override
  void update(double dt) {
    super.update(dt);
    position += direction * speed * dt;

    if (position.y > game.size.y ||
        position.y < 0 ||
        position.x > game.size.x ||
        position.x < 0) {
      removeFromParent();
    }
  }
}
