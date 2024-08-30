import 'dart:math' as math;

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_practice/game/airplane_game/airplane_game.dart';
import 'package:flame_practice/game/airplane_game/game_components/enemy_components/enemy_components_mixin.dart';
import 'package:flutter/foundation.dart';

class Phase1EnemyComponent extends SpriteComponent
    with CollisionCallbacks, HasGameRef<AirplaneGame>, EmenyComponentMixin {
  Phase1EnemyComponent({required this.id}) : super() {
    id = id;
  }
  int id;
  late Timer? shootTimer;
  late Timer? chargeTimer;
  double startAngle = 0;
  double endAngle = math.pi / 2;
  late double radius;
  final int finalPatternNumber = 2;

  double speed = 0.5;
  int _pattern = 0;
  int get Pattern => _pattern;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    size = setComponentSizeByGame(gameRef);
    position = Vector2(0, gameRef.size.y * 0.8 - 50);
    radius = gameRef.size.y * 0.3;
    anchor = Anchor.center;
    sprite = await gameRef.loadSprite('airplane_game/enemies/ship_0004.png');
    shootTimer = Timer(4, onTick: () => {shoot(game, position)}, repeat: true);
    chargeTimer = Timer(15, onTick: () {
      _pattern = finalPatternNumber;
    }, repeat: false);
    angle = 0.5 * math.pi;
  }

  @override
  void update(double dt) {
    super.update(dt);
    shootTimer!.update(dt);
    chargeTimer!.update(dt);

    if (isDead()) {
      removeFromParent();
    }
    updateActionByPattern(dt);
  }

  void patternChange() {
    _pattern++;
  }

  void updateActionByPattern(double dt) {
    switch (_pattern) {
      case 0:
        firstPattern(dt);
        return;
      case 1:
        angle = -0.25 * math.pi;
        groupingPattern(game, dt, position: position, id: id, y: size.y);

        if (position.y < gameRef.size.y * 0.3) {
          angle = -math.pi;
        }
        return;
      case 2:
        chargePattern(game, position, dt);
        return;
      default:
        return;
    }
  }

  void firstPattern(double dt) {
    if (position.x > gameRef.size.x * 0.9) {
      patternChange();
      return;
    }
    position.x += speed * 8;
  }

  bool isDead() {
    if (position.y > gameRef.size.y) {
      if (kDebugMode) {
        print("die");
      }
      return true;
    }
    return false;
  }
}
