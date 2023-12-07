import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class SlimeBackground extends SpriteComponent with HasGameRef {
  @override
  Future<void> onLoad() async {
    super.onLoad();
    add(RectangleHitbox());
    Sprite backgroundSprite =
        await gameRef.loadSprite('slime_world/slime_bg02.jpg');
    sprite = backgroundSprite;

    // final _gSize = gameRef.size;
    size = Vector2(1920, 1080);
    // backgroundSprite.originalSize.x, backgroundSprite.originalSize.y);
  }
}
