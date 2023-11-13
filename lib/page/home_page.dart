import 'package:flame_audio/flame_audio.dart';
import 'package:flame_practice/page/airplane_game_debug_page/airplane_game_debug_page.dart';
import 'package:flame_practice/page/airplane_game_page/airplane_game_page.dart';
import 'package:flame_practice/page/slime_game_page/slime_game_page.dart';
import 'package:flame_practice/page/sound_game/sound_game_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final Map<String, Widget> _list = {
    "slime_world": SlimeGamePage(),
    "airplane_game": AirplaneGamePage(),
    "airplane_game_debug": AirplaneGameDebugPage(),
    "sound_game_debug": SoundGamePage(),
  };

  @override
  Widget build(BuildContext context) {
    FlameAudio.bgm.initialize();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return Scaffold(
      appBar: AppBar(),
      body: Center(
          child: ListView.separated(
              itemBuilder: (context, index) => _listTile(index),
              separatorBuilder: (context, index) => const Divider(),
              itemCount: _list.length)),
    );
  }

  Widget _listTile(int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
      child: InkWell(
        onTap: () {
          Get.to(() => _list.values.toList()[index]);
        },
        child: Container(
          width: 120,
          height: 60,
          color: Colors.amber,
          alignment: Alignment.center,
          child: Text("${_list.keys.toList()[index]}"),
        ),
      ),
    );
  }
}
