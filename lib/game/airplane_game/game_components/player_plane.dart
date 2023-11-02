import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flame_practice/game/airplane_game/game_components/enemy_plane.dart';
import 'package:flame_practice/game/airplane_game/game_components/item.dart';
import 'package:flame_practice/game/slime_world/game_components/slime.dart';
import 'package:flutter/material.dart';

class PlayerPlane extends SpriteAnimationComponent
    with HasGameRef, CollisionCallbacks {
  final double _animationSpeed = 0.5;
  final double _playerSpeed = 300;
  late final SpriteAnimation _standingAnimation;
  static const double playerSize = 84.0;
  final Function hitAction;
  PlayerPlane({required position, required this.hitAction})
      : super(size: Vector2.all(playerSize), position: position);

  late ShapeHitbox hitbox;
  @override
  void onLoad() async {
    super.onLoad();
    // sprite = await gameRef.loadSprite('airplane_game/player_red_plane.png');
    position = position;

    final Paint defaultPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke;
    hitbox = CircleHitbox()
      ..paint = defaultPaint
      ..renderShape = true;
    add(hitbox);
    await _loadAnimations();
    animation = _standingAnimation;
    // anchor = Anchor.center;
  }

  @override
  void update(double dt) {
    super.update(dt);
  }

  @override
  void onCollision(Set<Vector2> points, PositionComponent other) {
    super.onCollision(points, other);
    if (other is ScreenHitbox) {
      if (position.x < game.size.x) {
        if (position.x < size.x) {
          position = Vector2(0, position.y);
          return;
        } else {
          position = Vector2(game.size.x - size.x, position.y);
          return;
        }
      }
    } else if (other is EnemyPlain) {
      if (other.state == EnemyPlainState.flying) {
        other.stopPlane();
        hitAction();
      }
    } else if (other is Item) {
      other.itemAction();
    }
  }

  Future<void> _loadAnimations() async {
    final spriteSheet = SpriteSheet(
        image: await gameRef.images
            .load('airplane_game/player_red_plane_sprite2.png'),
        srcSize: Vector2(128.0, 128.0));

    _standingAnimation = spriteSheet.createAnimation(
      row: 0,
      stepTime: _animationSpeed,
      from: 0,
      to: 5,
    );
  }
}
