import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flame_practice/game/touch_angle_game/components/touch_arrow.dart';
import 'package:flutter/material.dart';

class TouchAngleGame extends FlameGame with HasGameRef, TapCallbacks {
  late TouchArrowC _touchArrowC;

  TouchAngleGame() {
    _touchArrowC = TouchArrowC();
  }

  double leftSpeed = 0;
  double rightSpeed = 0;

  @override
  void render(canvas) {
    super.render(canvas);
    TextPaint textPaint = TextPaint(
      style: const TextStyle(color: Colors.white),
    );

    textPaint.render(
        canvas, "X: ${_touchArrowC.x.toStringAsFixed(2)}", Vector2(30, 60));
    textPaint.render(
        canvas, "Y: ${_touchArrowC.y.toStringAsFixed(2)}", Vector2(30, 90));
    textPaint.render(canvas,
        "angle: ${(_touchArrowC.angle).toStringAsFixed(2)}", Vector2(30, 110));
  }

  TimerComponent _timerComp = TimerComponent(
    period: 1,
    repeat: true,
    autoStart: true,
    onTick: () {
      print("TimerComponent");
    },
  );

  late Timer aremover;
  void removeTimer() {
    _timerComp.removeFromParent();
  }

  @override
  void onLoad() {
    super.onLoad();
    add(_touchArrowC);
    _touchArrowC.x = size.x / 2;
    _touchArrowC.y = size.y / 2;
    add(_timerComp);
    aremover = Timer(6, repeat: true, onTick: () {
      removeTimer();
      print("removed a");
    });
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (_timerComp.isMounted) {
      _touchArrowC.move(dt);
      aremover.update(dt);
    }
    // 캐릭터의 이동 및 갱신 로직
  }

  @override
  void onTapDown(TapDownEvent event) {
    // 터치 이벤트 처리
    double dx = event.localPosition.x - _touchArrowC.x;
    double dy = event.localPosition.y - _touchArrowC.y;
    // 터치 위치와 캐릭터 위치 간의 각도 계산
    double angle = atan2(dy, dx);
    // double angle = atan2(dy, dx) + (0.5 * pi);

    // 캐릭터 방향을 갱신
    // TouchArrow.rotate(angle);
    print("Angle Change : angle${_touchArrowC.angle} => radians$angle");
    _touchArrowC.angle = angle;
    // print("Angle is now ${TouchArrow.angle}");

    //! if (!_timerComp.isMounted) {
    //!   add(_timerComp);
    //! }
  }

  void move(double dx, double dy) {
    double x = dx - _touchArrowC.x;
    double y = dy - _touchArrowC.y;
    double angle = atan2(y, x);
    _touchArrowC.angle = angle;
    add(_timerComp);
  }

  void setSpeed(double l, double r) {
    leftSpeed = l;
    rightSpeed = r;
  }
}
