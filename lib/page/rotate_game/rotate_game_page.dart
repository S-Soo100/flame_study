import 'package:flame_practice/game/rotate_game/rotater_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';

class RotateGamePage extends StatefulWidget {
  const RotateGamePage({super.key});

  @override
  State<RotateGamePage> createState() => _RotateGamePageState();
}

class _RotateGamePageState extends State<RotateGamePage> {
  late TextEditingController _xEditingController;
  late TextEditingController _yEditingController;

  double x = Get.width / 2;
  double y = Get.height / 2;

  late RotaterPainter _rotaterPainter;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _xEditingController = TextEditingController();
    _yEditingController = TextEditingController();
    _rotaterPainter = RotaterPainter(x: x, y: y);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
          child: Column(
        children: [
          //
          SizedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  children: [
                    const Text("X: "),
                    Container(
                      decoration: BoxDecoration(
                          // borderRadius: BorderRadius.circular(20),
                          color: Colors.grey[300]),
                      width: 72,
                      height: 36,
                      child: TextFormField(
                        controller: _xEditingController,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text("Y: "),
                    Container(
                      decoration: BoxDecoration(color: Colors.grey[300]),
                      width: 72,
                      height: 36,
                      child: TextFormField(
                        controller: _yEditingController,
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                    onPressed: () {
                      print("apply");
                      _rotaterPainter.drawLine(
                          double.parse(_xEditingController.text),
                          double.parse(_yEditingController.text));
                      setState(() {});
                    },
                    child: Text("Apply"))
              ],
            ),
          ),
          //
          SizedBox(),
          Container(
              width: Get.width,
              height: Get.height * 0.8,
              color: Colors.grey[400],
              child: CustomPaint(
                size: Size(Get.width, Get.height * 0.8),
                painter: _rotaterPainter,
              )),
          //
          SizedBox()
        ],
      )),
    );
  }
}
