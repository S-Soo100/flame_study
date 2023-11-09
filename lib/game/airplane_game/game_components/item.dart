import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'dart:async' as ASYNC;

enum ItemState { falling, hit }

class Item extends SpriteComponent with HasGameRef, CollisionCallbacks {
  ItemState _state = ItemState.falling;
  ItemState get state => _state;
  static const double itemSize = 64.0;
  late ShapeHitbox hitbox;
  String image;
  Function action;
  late Sprite? _spirte;

  Item({required position, required this.image, required this.action})
      : super(size: Vector2.all(itemSize), position: position);

  @override
  void onLoad() async {
    super.onLoad();
    anchor = Anchor.center;
    // sprite = await gameRef.loadSprite('airplane_game/items/item_hp.png');
    _spirte = await gameRef.loadSprite(image);
    sprite = _spirte;
    position = position;

    final Paint defaultPaint = Paint()
      ..color = Colors.transparent
      ..style = PaintingStyle.stroke;
    hitbox = CircleHitbox()
      ..paint = defaultPaint
      ..renderShape = true;
    add(hitbox);
  }

  @override
  void update(double dt) {
    super.update(dt);
    angle = angle + 0.02;
    // position = Vector2(position.x, position.y + 3);
    _state == ItemState.falling
        ? position = Vector2(position.x, position.y + 3)
        //     // : angle = angle + dt * 30;
        : null;

    if (position.y + size.y > game.size.y) {
      removeFromParent();
    }
  }

  ASYNC.Timer? destroyTimer;

  void itemAction() {
    destroy();
    action();
  }

  void destroy() async {
    if (_state == ItemState.falling) {
      _state = ItemState.hit;
      _spirte = await gameRef.loadSprite(image);
      bool blink = false;
      destroyTimer =
          ASYNC.Timer.periodic(const Duration(milliseconds: 33), (timer) {
        if (blink == true) {
          sprite = null;
          blink = false;
        } else {
          sprite = _spirte;
          blink = true;
        }
      });
      Future.delayed(const Duration(milliseconds: 500), (() {
        destroyTimer?.cancel();
        removeFromParent();
      }));
    }
  }
}
