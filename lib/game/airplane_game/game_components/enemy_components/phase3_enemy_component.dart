import 'dart:math' as math;

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_practice/game/airplane_game/airplane_game.dart';
import 'package:flame_practice/game/airplane_game/game_components/enemy_components/enemy_components_mixin.dart';
import 'package:flutter/foundation.dart';

class Phase3EnemyComponent extends SpriteComponent
    with CollisionCallbacks, HasGameRef<AirplaneGame>, EmenyComponentMixin {
  Phase3EnemyComponent({required this.id}) : super() {
    id = id;
  }
  int id;
  late Timer? shootTimer;
  late Timer? chargeTimer;

  double speed = 0.5;
  int _pattern = 0;
  int get pattern => _pattern;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    size = setComponentSizeByGame(gameRef);
    position = Vector2(0, gameRef.size.y * 0.8 - 50);
    anchor = Anchor.center;
    sprite = await gameRef.loadSprite('airplane_game/enemies/ship_0006.png');
    shootTimer = Timer(3, onTick: () => {shoot(game, position)}, repeat: true);
    chargeTimer = Timer(15, onTick: () {
      _pattern = 3;
    }, repeat: false);
    angle = 0.5 * math.pi;
  }

  double amplitude = 100.0;
  double frequency = 1.0;
  double time = 0.0;
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
        angle = 0;
        secondPattern(dt);
        return;
      case 2:
        groupingPattern(game, dt, position: position, id: id, y: size.y);
        if (position.y < gameRef.size.y * 0.3) {
          angle = -math.pi;
        }
        return;
      case 3:
        chargePattern(game, position, dt);
        return;
      default:
        return;
    }
  }

  void firstPattern(double dt) {
    if (position.x > gameRef.size.x * 0.51) {
      phaseChange();
      return;
    }
    position.x += speed * 8;
  }

  void secondPattern(double dt) {
    if (position.y < gameRef.size.y * 0.3) {
      phaseChange();
      return;
    }

    time += dt;
    // 좌우 움직임
    position.x = game.size.x / 2 + math.sin(time * frequency) * amplitude;
    position.y -= time / 2;
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
