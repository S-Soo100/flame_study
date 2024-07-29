import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flame_practice/game/airplane_game/airplane_game.dart';
import 'package:flame_practice/game/airplane_game/game_components/bullet.dart';
import 'package:flame_practice/game/airplane_game/game_components/enemy_plane.dart';
import 'package:flame_practice/game/airplane_game/game_components/item.dart';
import 'package:flutter/material.dart';

class PlayerPlane extends SpriteAnimationComponent
    with HasGameRef<AirplaneGame>, CollisionCallbacks {
  final double _animationSpeed = 0.5;
  late final SpriteAnimation _standingAnimation;
  late final double playerSize;
  final Function hitAction;
  late Timer? _fireTimer;

  PlayerPlane(
      {required position, required this.hitAction, required this.playerSize})
      : super(size: Vector2.all(playerSize), position: position);

  late ShapeHitbox hitbox;
  @override
  void onLoad() async {
    super.onLoad();
    position = position;
    _fireTimer = Timer(
      2,
      onTick: fire,
      repeat: true,
    );

    final Paint defaultPaint = Paint()
      ..color = Colors.transparent
      ..style = PaintingStyle.stroke;
    hitbox = CircleHitbox()
      ..paint = defaultPaint
      ..renderShape = true;
    add(hitbox);
    await _loadAnimations();
    animation = _standingAnimation;
    anchor = Anchor.center;
  }

  @override
  void update(double dt) {
    super.update(dt);
    _fireTimer?.update(dt);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is ScreenHitbox) {
      if (position.x < game.size.x) {
        if (position.x < size.x) {
          position = Vector2(playerSize / 2, position.y);
          return;
        } else {
          position = Vector2(game.size.x - playerSize / 2, position.y);
          return;
        }
      }
    } else if (other is EnemyPlain) {
      if (other.state == EnemyPlainState.flying) {
        other.destroy();
        hitAction();
      }
    } else if (other is Item) {
      if (other.state == ItemState.falling) {
        FlameAudio.play('airplane_game/hp_item_sound.wav');
        other.itemAction();
      }
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

  void fire() {
    gameRef.add(Bullet(position: Vector2(position.x, position.y - 36)));
  }

  @override
  void onRemove() {
    _fireTimer?.stop();
    super.onRemove();
  }
}
