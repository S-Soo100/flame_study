import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flutter/material.dart';

class TouchArrowC extends SpriteComponent with TapCallbacks, HasGameRef {
  double speed = 10; // 이동 속도

  TouchArrowC();

  @override
  void onLoad() async {
    super.onLoad();
    anchor = Anchor.center;
    angle = angle - (0.5 * pi);
    sprite = await gameRef.loadSprite('triangle_game/arrow.png');
    size = Vector2.all(50);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
  }

  void move(double dt) {
    x += speed * cos(angle) * dt;
    y += speed * sin(angle) * dt;
  }

  void rotate(double radians) {
    angle += radians;
  }
}
