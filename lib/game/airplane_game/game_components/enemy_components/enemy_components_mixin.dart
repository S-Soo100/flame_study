import 'package:flame/game.dart';
import 'package:flame_practice/game/airplane_game/airplane_game.dart';
import 'package:flame_practice/game/airplane_game/game_components/enemy_components/enemy_bullet.dart';
import 'dart:math' as math;

class EmenyComponentMixin {
  void shoot(AirplaneGame? game, Vector2 position) {
    Vector2 targetPosition = Vector2(game!.size.x / 2, game.size.y);
    Vector2 direction = (targetPosition - position).normalized();
    game.add(EnemnyBullet(position, direction));
  }

  Vector2 setComponentSizeByGame(AirplaneGame? game) {
    if (game == null) return Vector2(80, 80);
    double size = game.size.x / 11;
    return Vector2(size, size);
  }

  void chargePattern(AirplaneGame? game, Vector2 position, double dt) {
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

  void groupingPattern(AirplaneGame? gameRef, double dt,
      {required double y, required int id, required Vector2 position}) {
    double xStandard = gameRef!.size.x / 8;
    double _y = gameRef.size.y * 0.1;
    double _x = (xStandard * 2) + (xStandard * id);
    if (id > 4) {
      _y += y + 10;
      _x -= (xStandard * 5);
    }
    position.lerp(Vector2(_x, _y), dt);
  }
}
