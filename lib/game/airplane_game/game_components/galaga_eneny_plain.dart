import 'package:flame/components.dart';
import 'package:flame_practice/game/airplane_game/airplane_game.dart';
import 'dart:math';
import 'package:flame_practice/game/airplane_game/game_components/enemy_components/enemy_components_mixin.dart';

class BlueEnemyPlain extends SpriteComponent
    with HasGameRef<AirplaneGame>, EmenyComponentMixin {
  static const double speed = 30.0;
  final Vector2 velocity = Vector2.zero();
  double amplitude = 60.0;
  double frequency = 1.0;
  double time = 0.0;
  double shootTimer = 0.0;
  final double shootInterval = 2.0; // 2초마다 발사

  BlueEnemyPlain() : super(size: Vector2(50, 50));

  @override
  Future<void> onLoad() async {
    super.onLoad();
    anchor = Anchor.bottomCenter;
    sprite = await Sprite.load('airplane_game/enemies/ship_0000.png');
    position = Vector2(
      game.size.x / 2,
      -size.y,
    );
  }

  @override
  void update(double dt) {
    super.update(dt);
    time += dt;
    shootTimer += dt;

    // 좌우 움직임
    position.x = game.size.x / 2 + sin(time * frequency) * amplitude;

    // 아래로 이동
    position.y += speed * dt;

    // 화면 밖으로 나가면 제거
    if (position.y > game.size.y) {
      removeFromParent();
    }
    // 2초마다 총알 발사
    if (shootTimer >= shootInterval) {
      shoot(game, position);
      shootTimer = 0.0;
    }
  }
}
