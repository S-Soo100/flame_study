import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame_practice/game/slime_world/game_components/slime_button.dart';
import 'package:flame_practice/game/slime_world/game_components/slime_background.dart';
import 'package:flame_practice/game/slime_world/game_components/slime.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class SlimeGame extends FlameGame with TapCallbacks, HasCollisionDetection {
  late Slime _slime;
  late Slime _slime2;
  late Slime _slime3;
  late SlimeButton _button1;
  late SlimeButton _button2;
  bool goLeft = false;

  @override
  Color backgroundColor() => const Color(0xffe6e6e6);

  final SlimeBackground _backGround = SlimeBackground();

  @override
  Future<void> onLoad() async {
    // 화면 고정
    add(ScreenHitbox());
    await add(_backGround);
    _slime = Slime(type: 1, position: Vector2(size.x / 2, size.y - 200));
    _slime2 = Slime(type: 2, position: Vector2(size.x - 200, size.y - 200));
    _slime3 = Slime(type: 3, position: Vector2(200, size.y - 200));
    _button1 = SlimeButton(
        func: () {
          _moveLeft(_slime);
        },
        position: Vector2(100, size.y - 20));
    _button2 = SlimeButton(
        func: () {
          _moveRight(_slime);
        },
        position: Vector2(250, size.y - 20));
    add(_slime);
    add(_slime2);
    add(_slime3);
    add(_button1);
    add(_button2);
    _slime2.flipHorizontally();
    super.onLoad();
  }

  @override
  void onTapUp(TapUpEvent event) {
    super.onTapUp(event);
    _moveObjectByTap(_slime);
  }

  void _moveObjectByTap(Slime comp) {
    if (goLeft) {
      _moveLeft(comp);
      comp.position.x - 25 < 40 ? _flipSlime(comp) : null;
    } else {
      _moveRight(comp);
      comp.position.x + 25 > size.x - 40 ? _flipSlime(comp) : null;
    }
  }

  void _flipSlime(Slime comp) {
    Vector2 prev = comp.position;
    comp.flipHorizontallyAroundCenter();
    goLeft = !goLeft;
  }

  void _moveLeft(Slime comp) {
    if (!goLeft) {
      comp.flipHorizontallyAroundCenter();
      goLeft = true;
    }
    Vector2 prev = comp.position;
    if (comp.position.x - 25 < 40) return;
    comp.position = Vector2(prev.x - 25, prev.y);
  }

  void _moveRight(Slime comp) {
    if (goLeft) {
      comp.flipHorizontallyAroundCenter();
      goLeft = false;
    }
    Vector2 prev = comp.position;
    if (comp.position.x + 25 > size.x - 40) return;
    comp.position = Vector2(prev.x + 25, prev.y);
  }
}
