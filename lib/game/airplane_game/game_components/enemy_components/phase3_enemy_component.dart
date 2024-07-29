import 'dart:math' as math;

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_practice/game/airplane_game/airplane_game.dart';
import 'package:flame_practice/game/airplane_game/game_components/enemy_components/enemy_components_mixin.dart';
import 'package:flutter/foundation.dart';

class Phase3EnemyComponent extends SpriteComponent
    with CollisionCallbacks, HasGameRef<AirplaneGame>, EmenyComponentMixin {
  Phase3EnemyComponent(Vector2 position, {required this.id})
      : super(size: Vector2(50, 50)) {
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
    angle = 0;
    radius = gameRef.size.y * 0.3;
    anchor = Anchor.center;
    sprite = await gameRef.loadSprite('airplane_game/enemies/ship_0006.png');
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
        thirdPattern(dt);
        return;
      case 3:
        finalPattern(game, position, dt);
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

  void thirdPattern(double dt) {
    // position.lerp(Vector2(gameRef.size.x / 2, gameRef.size.y + 80), dt);

    double _y = 100;
    double _x = (gameRef.size.x / 2 - 120) + (60 * id);
    if (id > 4) {
      _y += 60;
      _x -= 300;
    }
    position.lerp(Vector2(_x, _y), dt);
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
