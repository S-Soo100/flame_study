import 'package:flame_practice/page/airplane_game_page/airplane_game_page.dart';
import 'package:flame_practice/page/slime_game_page/slime_game_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final Map<String, Widget> _list = {
    "slime_world": SlimeGamePage(),
    "airplane_game": AirplaneGamePage()
  };

  @override
  Widget build(BuildContext context) {
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
      padding: const EdgeInsets.all(12),
      child: InkWell(
        onTap: () {
          Get.to(_list.values.toList()[index]);
        },
        child: Container(
          width: 120,
          height: 30,
          color: Colors.amber,
          child: Text("${_list.keys.toList()[index]}"),
        ),
      ),
    );
  }
}
