import 'package:flame/game.dart';
import 'package:flame_practice/game/airplane_game/airplane_game.dart';
import 'package:flame_practice/game/airplane_game/game_components/enemy_bullet.dart';

class EmenyComponentMixin {
  void shoot(AirplaneGame? game, Vector2 position) {
    Vector2 targetPosition = Vector2(game!.size.x / 2, game.size.y);
    Vector2 direction = (targetPosition - position).normalized();
    // Vector2 bulletPosition = position + direction * game.size.y / 2;
    game.add(EnemnyBullet(position, direction));
  }

  void finalPattern(AirplaneGame? game, Vector2 position, double dt) {
    if (position.x > game!.size.x / 2) {
      position.lerp(Vector2(game.size.x / 2, game.size.y), dt);
      position.y += 3;
      return;
    } else if (position.x < game.size.x / 2) {
      position.lerp(Vector2(game.size.x / 2, game.size.y), dt);
      position.y += 3;
      return;
    } else {
      position.y += 10 * dt;
    }
  }
}
