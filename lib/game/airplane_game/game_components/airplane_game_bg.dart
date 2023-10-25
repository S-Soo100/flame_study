import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class AirplaneGameBg extends SpriteComponent with HasGameRef {
  @override
  Future<void> onLoad() async {
    super.onLoad();
    add(RectangleHitbox());
    sprite = await gameRef.loadSprite('airplane_game/bg.png');
    final _gSize = gameRef.size;
    size = Vector2(_gSize.x, _gSize.y);
  }
}