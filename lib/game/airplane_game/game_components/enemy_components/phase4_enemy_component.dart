import 'dart:math' as math;

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_practice/game/airplane_game/airplane_game.dart';
import 'package:flame_practice/game/airplane_game/game_components/enemy_components/enemy_components_mixin.dart';
import 'package:flutter/foundation.dart';

class Phase4EnemyComponent extends SpriteComponent
    with CollisionCallbacks, HasGameRef<AirplaneGame>, EmenyComponentMixin {
  Phase4EnemyComponent({required this.id}) : super() {
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
  final int finalPatternNumber = 4;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    position = Vector2(gameRef.size.x, gameRef.size.y * 0.8 - 50);
    angle = 0;
    size = setComponentSizeByGame(gameRef);
    radius = gameRef.size.y * 0.3;
    anchor = Anchor.center;
    sprite = await gameRef.loadSprite('airplane_game/enemies/ship_0002.png');
    shootTimer = Timer(3, onTick: () => {shoot(game, position)}, repeat: true);
    chargeTimer = Timer(15, onTick: () {
      _pattern = finalPatternNumber;
    }, repeat: false);
    angle = -math.pi / 2.3;
  }

  double frequency = 1.0;
  double time = 1;
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
        angle = math.pi * 0.25;
        secondPattern(dt);
        return;
      case 2:
        thirdPattern(dt);
        return;
      case 3:
        groupingPattern(game, dt, position: position, id: id, y: size.y);
        if (position.y < gameRef.size.y * 0.3) {
          angle = -math.pi;
        }
        return;
      case 4:
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
    position.y--;
  }

  void secondPattern(double dt) {
    if (position.y < gameRef.size.y * 0.3) {
      phaseChange();
      return;
    }
    time += dt;
    position.x += math.sin((time - 1) * frequency);
    position.y -= time;
  }

  void thirdPattern(double dt) {
    if (position.y > gameRef.size.y * 0.8) {
      phaseChange();
      return;
    }
    position.lerp(Vector2(game.size.x, game.size.y * 0.9), dt);
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
