import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/palette.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flame_practice/game/slime_world/game_components/slime.dart';
import 'package:flutter/widgets.dart' hide Animation;

class SoundGame extends FlameGame with TapDetector {
  static final Paint black = BasicPalette.black.paint();
  static final Paint gray = const PaletteEntry(Color(0xFFCCCCCC)).paint();
  static final TextPaint text = TextPaint(
    style: TextStyle(color: BasicPalette.white.color),
  );

  SoundGame() {
    count = Timer(10, onTick: () {
      print("ON Tick");
    }, repeat: true);
  }

  late AudioPool pool;
  double dtt = 0;
  late Timer count;
  @override
  Future<void> onLoad() async {
    pool = await FlameAudio.createPool(
      'sounds/sound03.wav',
      minPlayers: 1,
      maxPlayers: 4,
    );
    startBgmMusic();
  }

  @override
  void update(double dt) {
    // TODO: implement update
    super.update(dt);
    if (count.current == 9.999) {
      print("HEY");
      add(Slime(type: 0, position: Vector2.all(100)));
    }
    count.update(dt);
  }

  @override
  void onRemove() {
    FlameAudio.bgm.stop();
    // FlameAudio.bgm.dispose();
    super.onRemove();
  }

  Rect get button => Rect.fromLTWH(20, size.y - 300, size.x - 40, 200);

  void startBgmMusic() {
    // FlameAudio.bgm.initialize();
    FlameAudio.bgm.play('music/bg_music.mp3');
  }

  void fireOne() {
    FlameAudio.play('sounds/sound01.wav');
  }

  void fireTwo() {
    pool.start();
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.drawRect(size.toRect(), black);

    text.render(
      canvas,
      '(click anywhere for 1)',
      Vector2(size.x / 2, 200),
      anchor: Anchor.topCenter,
    );

    canvas.drawRect(button, gray);

    text.render(
      canvas,
      'click here for 2',
      Vector2(size.x / 2, size.y - 200),
      anchor: Anchor.bottomCenter,
    );

    text.render(
        canvas, "count: ${count.current.toStringAsFixed(4)}", Vector2.all(20));
  }

  @override
  void onTapDown(TapDownInfo info) {
    if (button.containsPoint(info.eventPosition.widget)) {
      fireTwo();
    } else {
      fireOne();
    }
  }
}
