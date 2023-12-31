import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flutter/material.dart';

class SlimeButton extends RectangleComponent with TapCallbacks {
  static const buttonSize = 120.0;
  final Function func;
  SlimeButton({
    required this.func,
    required position,
  }) : super(
            anchor: Anchor.center,
            size: Vector2.all(buttonSize),
            position: position);

  @override
  void onLoad() async {
    super.onLoad();
  }

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    func();
  }
}
