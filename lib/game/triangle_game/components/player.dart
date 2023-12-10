import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class Player extends SpriteComponent with TapCallbacks, HasGameRef {
  double _moveSpeed = 0; // 이동 속도
  double _leftSpeed = 0;
  double _rightSpeed = 0;

  Player();

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
    x += _moveSpeed * cos(angle) * dt;
    y += _moveSpeed * sin(angle) * dt;
    setAngle(l: _leftSpeed, r: _rightSpeed);
    x += _moveSpeed * cos(angle) * dt;
    y += _moveSpeed * sin(angle) * dt;
  }

  void setAngle({required double l, required double r}) async {
    angle = angle + ((l - r) * pi / 3600);
    await Future.delayed(const Duration(milliseconds: 100));
  }

  void setSpeed({required double l, required double r}) {
    _leftSpeed = l;
    _rightSpeed = r;
    _moveSpeed = (l + r);
  }

  void rotate(double radians) {
    print("Angle Change : angle$angle + radians$radians");
    angle += radians;
  }
}
