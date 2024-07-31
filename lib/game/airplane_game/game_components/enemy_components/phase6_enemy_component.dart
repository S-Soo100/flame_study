import 'dart:math' as math;

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_practice/game/airplane_game/airplane_game.dart';
import 'package:flame_practice/game/airplane_game/game_components/enemy_components/enemy_components_mixin.dart';
import 'package:flutter/foundation.dart';

class Phase6EnemyComponent extends SpriteComponent
    with CollisionCallbacks, HasGameRef<AirplaneGame>, EmenyComponentMixin {
  Phase6EnemyComponent(Vector2 position, {required this.id}) : super() {
    this.position = position;
    id = id;
  }
  int id;
  late Timer? shootTimer;
  late Timer? chargeTimer;
  double startAngle = 0;
  double endAngle = math.pi / 2;
  late double radius;

  double speed = 0.5;
  int _pattern = 0;
  int get pattern => _pattern;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    size = setComponentSizeByGame(gameRef);
    angle = 0;
    radius = gameRef.size.y * 0.3;
    anchor = Anchor.center;
    sprite = await gameRef.loadSprite('airplane_game/enemies/ship_0004.png');
    shootTimer = Timer(3, onTick: () => {shoot(game, position)}, repeat: true);
    chargeTimer = Timer(15, onTick: () {
      _pattern = 3;
    }, repeat: false);
  }

  @override
  void update(double dt) {
    super.update(dt);
    shootTimer!.update(dt);
    chargeTimer!.update(dt);

    if (isDead()) {
      removeFromParent();
    }
    updateActionByPhase(dt);
  }

  void phaseChange() {
    _pattern++;
  }

  void updateActionByPhase(double dt) {
    switch (_pattern) {
      case 0:
        firstPattern(dt);
        return;
      case 1:
        secondPattern(dt);
        return;
      case 2:
        groupingPattern(game, dt, position: position, id: id, y: size.y);
        return;
      case 3:
        chargePattern(game, position, dt);
        return;
      default:
        return;
    }
  }

  void firstPattern(double dt) {
    if (position.x < gameRef.size.x * 0.1) {
      phaseChange();
      return;
    }
    position.x -= speed * 8;
  }

  void secondPattern(double dt) {
    if (position.x > gameRef.size.x * 0.75) {
      phaseChange();
      return;
    }
    position.lerp(Vector2(gameRef.size.x * 0.8, gameRef.size.y / 2), dt);
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
