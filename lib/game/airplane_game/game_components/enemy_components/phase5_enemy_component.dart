import 'dart:math' as math;

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_practice/game/airplane_game/airplane_game.dart';
import 'package:flame_practice/game/airplane_game/game_components/enemy_components/enemy_components_mixin.dart';
import 'package:flutter/foundation.dart';

class Phase5EnemyComponent extends SpriteComponent
    with CollisionCallbacks, HasGameRef<AirplaneGame>, EmenyComponentMixin {
  Phase5EnemyComponent({required this.id}) : super() {
    id = id;
  }
  int id;
  late Timer? shootTimer;
  late Timer? chargeTimer;
  double startAngle = 0;
  double endAngle = math.pi / 2;
  late double radius;
  final int finalPatternNumber = 3;

  double speed = 0.5;
  int _pattern = 0;
  int get pattern => _pattern;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    position = Vector2(0, gameRef.size.y * 0.6 - 50);
    size = setComponentSizeByGame(gameRef);
    radius = gameRef.size.x * 0.5;
    anchor = Anchor.center;
    sprite = await gameRef.loadSprite('airplane_game/enemies/ship_0003.png');
    shootTimer = Timer(3, onTick: () => {shoot(game, position)}, repeat: true);
    chargeTimer = Timer(15, onTick: () {
      _pattern = finalPatternNumber;
    }, repeat: false);
    angle = -0.5 * math.pi;
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
        // secondPattern(dt);
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
    if (position.x > gameRef.size.x * 1.1) {
      phaseChange();
      angle = 0;
      return;
    }
    position.x += speed * 8;
  }

  void secondPattern(double dt) {
    if (position.y < gameRef.size.y * 0.2) {
      angle = 0;
      phaseChange();
      return;
    }
    // 각도 업데이트
    angle += speed * dt;
    Vector2 myCenter = Vector2(gameRef.size.x, gameRef.size.y * 0.4);

    // 반원 운동 제한 (0 ~ π)
    if (angle > math.pi + math.pi / 2) {
      angle = math.pi;
    }

    // 새로운 위치 계산
    position.x = myCenter.x + radius * math.cos(angle);
    position.y = myCenter.y + radius * math.sin(angle);
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
