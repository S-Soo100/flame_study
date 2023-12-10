import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flame_practice/game/triangle_game/components/player.dart';
import 'package:flutter/material.dart';

class TriangleGame extends FlameGame with HasGameRef, TapCallbacks {
  late Player player;
  late Timer moveStopper;

  TriangleGame() {
    player = Player();
  }
  bool isMoving = false;

  @override
  void render(canvas) {
    super.render(canvas);
    TextPaint textPaint = TextPaint(
      style: const TextStyle(color: Colors.white),
    );

    textPaint.render(
        canvas, "X: ${player.x.toStringAsFixed(2)}", Vector2(30, 60));
    textPaint.render(
        canvas, "Y: ${player.y.toStringAsFixed(2)}", Vector2(30, 90));
    textPaint.render(canvas, "angle: ${(player.angle).toStringAsFixed(2)}",
        Vector2(30, 110));
  }

  @override
  void onLoad() {
    super.onLoad();
    add(player);
    player.x = size.x / 2;
    player.y = size.y / 2;
    moveStopper = Timer(6, repeat: false, onTick: () {
      isMoving = false;
    });
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (isMoving) {
      player.move(dt);
      moveStopper.update(dt);
    }
  }

  @override
  void onTapDown(TapDownEvent event) {
    print(
        "X:${event.localPosition.x.toStringAsFixed(2)} Y:${event.localPosition.y.toStringAsFixed(2)}");
    // double dx = event.localPosition.x - player.x;
    // double dy = event.localPosition.y - player.y;
    // double angle = atan2(dy, dx);
    // player.angle = angle;

    // if (!_timerComp.isMounted) {
    //   add(_timerComp);
    // }
  }

  void moveByWheel(double left, double right) {
    // player.setAngle(l: left, r: right);
    player.setSpeed(l: left, r: right);
    startMove();
  }

  void startMove() {
    isMoving = true;
  }
}
