import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';

class Slime extends SpriteAnimationComponent
    with HasGameRef, CollisionCallbacks {
  static const playerSize = 50.0;
  Slime({required this.type, required position})
      : super(size: Vector2.all(playerSize), position: position);

  int type;
  final double _animationSpeed = 0.15;
  final double _playerSpeed = 300;
  late final SpriteAnimation _standingAnimation;
  late ShapeHitbox hitbox;
  final _defaultColor = Colors.red;

  @override
  void onLoad() async {
    super.onLoad();

    final Paint defaultPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke;
    hitbox = CircleHitbox()
      ..paint = defaultPaint
      ..renderShape = true;
    add(hitbox);

    await _loadAnimations();
    animation = _standingAnimation;
  }

  int get _slimeType => (type * 3) - 3;

  Future<void> _loadAnimations() async {
    final spriteSheet = SpriteSheet(
        image: await gameRef.images.load('slime_sprite_sheet.png'),
        srcSize: Vector2(16.0, 16.0));

    _standingAnimation = spriteSheet.createAnimation(
      row: 0,
      stepTime: _animationSpeed,
      from: _slimeType,
      to: _slimeType + 3,
    );
  }

  @override
  void update(double dt) {
    // TODO: implement update
    super.update(dt);
    if (!hitbox.isColliding && position.y < 500) {
      position.y = position.y + 1;
    }
  }

  @override
  void onCollision(Set<Vector2> points, PositionComponent other) {
    super.onCollision(points, other);
    if (other is ScreenHitbox) {
      print("Wall");
      if (position.x < size.x) {
        print("Wall left");
        // print("other position ${other.position.x}");
        // print("slime position ${position.x}");
        position = Vector2(position.x + 1, position.y);
      } else {
        print("Wall Right");
        // print("other position ${other.position.x}");
        // print("slime position ${position.x}");
        position = Vector2(position.x - 1, position.y);
      }
      //...
    } else if (other is Slime) {
      //...
      // print("Slime Collision");
      if (other.position.x > position.x) {
        other.position = Vector2(other.position.x + 1, other.position.y - 1);
      } else {
        other.position = Vector2(other.position.x - 1, other.position.y - 1);
      }
    } else {
      //...
    }
  }

  // @override
  // void onCollisionEnd(PositionComponent other) {
  //   super.onCollisionEnd(other);
  //   if (other is ScreenHitbox) {
  //     //...
  //   } else if (other is Slime) {
  //     //...
  //     // print("Slime Collision");
  //   } else {
  //     //...
  //   }
  // }
}
