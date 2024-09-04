import 'package:flame/game.dart';
import 'package:flame_practice/game/triangle_game/triangle_game.dart';
import 'package:flame_practice/game/triangle_game/triangle_game_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class TriangleGamePage extends StatefulWidget {
  const TriangleGamePage({super.key});

  @override
  State<TriangleGamePage> createState() => _TriangleGamePageState();
}

class _TriangleGamePageState extends State<TriangleGamePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TriangleGameController>(
      create: (BuildContext context) => TriangleGameController(),
      child: Scaffold(
          appBar: AppBar(
            title: const Text("삼각함수 렛츠고"),
          ),
          body: Consumer<TriangleGameController>(
              builder: (context, provider, child) {
            TriangleGame game = provider.game;
            return SizedBox(
              width: Get.width,
              height: Get.height,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: GameWidget(
                      game: game,
                    ),
                  ),
                  Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        margin: const EdgeInsets.all(4),
                        width: Get.width,
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: Colors.blueGrey.withOpacity(0.6),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    provider.upLeftSpeed();
                                  },
                                  icon: const Icon(
                                    Icons.arrow_upward,
                                    size: 32,
                                    color: Colors.white,
                                  ),
                                  style: IconButton.styleFrom(
                                      foregroundColor: Colors.white),
                                ),
                                Text(
                                  context
                                      .watch<TriangleGameController>()
                                      .leftSpeed
                                      .toStringAsFixed(0),
                                  style: const TextStyle(
                                      fontSize: 32, color: Colors.white),
                                ),
                                IconButton(
                                  onPressed: () {
                                    provider.downLeftSpeed();
                                  },
                                  icon: const Icon(
                                    Icons.arrow_downward,
                                    size: 32,
                                    color: Colors.white,
                                  ),
                                  style: IconButton.styleFrom(
                                    foregroundColor: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    provider.upRightSpeed();
                                  },
                                  icon: const Icon(
                                    Icons.arrow_upward,
                                    size: 32,
                                    color: Colors.white,
                                  ),
                                  style: IconButton.styleFrom(
                                      foregroundColor: Colors.white),
                                ),
                                Text(
                                  context
                                      .watch<TriangleGameController>()
                                      .rightSpeed
                                      .toStringAsFixed(0),
                                  style: const TextStyle(
                                      fontSize: 32, color: Colors.white),
                                ),
                                IconButton(
                                  onPressed: () {
                                    provider.downRightSpeed();
                                  },
                                  icon: const Icon(
                                    Icons.arrow_downward,
                                    size: 32,
                                    color: Colors.white,
                                  ),
                                  style: IconButton.styleFrom(
                                    foregroundColor: Colors.white,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ))
                ],
              ),
            );
          })),
    );
  }
}
