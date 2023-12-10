import 'package:flame_practice/game/line_painter/line_painter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';

class LinePaintingPage extends StatefulWidget {
  const LinePaintingPage({super.key});

  @override
  State<LinePaintingPage> createState() => _LinePaintingPageState();
}

class _LinePaintingPageState extends State<LinePaintingPage> {
  late TextEditingController _xEditingController;
  late TextEditingController _yEditingController;

  double x = Get.width / 2;
  double y = Get.height / 2;

  late LinePainter _rotaterPainter;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _xEditingController = TextEditingController();
    _yEditingController = TextEditingController();
    _rotaterPainter = LinePainter(x: x, y: y);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("LinePainting Page"),
      ),
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
                      if (kDebugMode) {
                        print("apply");
                      }
                      _rotaterPainter.drawLine(
                          double.parse(_xEditingController.text),
                          double.parse(_yEditingController.text));
                      setState(() {});
                    },
                    child: const Text("Apply"))
              ],
            ),
          ),
          //
          const SizedBox(),
          Container(
              width: Get.width,
              height: Get.height * 0.8,
              color: Colors.grey[400],
              child: CustomPaint(
                size: Size(Get.width, Get.height * 0.8),
                painter: _rotaterPainter,
              )),
          //
          const SizedBox()
        ],
      )),
    );
  }
}
