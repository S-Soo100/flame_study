import 'package:flame/components.dart';

class AirplaneGameBg extends SpriteComponent with HasGameRef {
  int type;
  AirplaneGameBg({required this.type});

  String getBgImage() {
    switch (type) {
      case 0:
        return 'airplane_game/bg_pixel_001.png';
      case 1:
        return 'airplane_game/bg_pixel_002.png';
      default:
        return 'airplane_game/bg_pixel_002.png';
    }
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    // add(RectangleHitbox());
    sprite = await gameRef.loadSprite(getBgImage());

    final _gSize = gameRef.size;
    size = Vector2(_gSize.x, _gSize.y);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (y > gameRef.size.y) {
      position = Vector2(x, -y);
    } else {
      position = Vector2(x, y + 1.7);
    }
  }
}
