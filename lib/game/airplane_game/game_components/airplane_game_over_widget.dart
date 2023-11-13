import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../page/home_page.dart';

class AirplaneGameOverWidget extends StatefulWidget {
  final int distanceMeter;
  final int killScore;
  const AirplaneGameOverWidget(
      {super.key, required this.distanceMeter, required this.killScore});

  @override
  State<AirplaneGameOverWidget> createState() => _AirplaneGameOverWidgetState();
}

class _AirplaneGameOverWidgetState extends State<AirplaneGameOverWidget>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  late double firstLineValue;
  late double secondLineValue;
  double thirdLineValue = 0;

  @override
  void initState() {
    super.initState();
    firstLineValue = widget.distanceMeter.toDouble();
    secondLineValue = widget.killScore.toDouble();
    thirdLineValue = 0;
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
    Future.delayed(const Duration(seconds: 1), () {
      _controller.forward();
    });

    double i1 = widget.distanceMeter.toDouble();
    double i2 = widget.killScore.toDouble();
    double i3 = (i1 * 1 / 10) + (i2 * 50);
    print(i3);
    _controller.addListener(() {
      setState(() {
        firstLineValue = (i1 * (1 - _animation.value));
        secondLineValue = (i2 * (1 - _animation.value));
        thirdLineValue = i3 * _animation.value;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Center(
        child: Container(
          width: 300,
          height: 300,
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.all(10),
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "최종 점수",
                  style: TextStyle(color: Colors.blueAccent, fontSize: 20),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "거리 점수:",
                    style: TextStyle(fontSize: 24),
                  ),
                  Text(
                    firstLineValue.toStringAsFixed(1),
                    style: const TextStyle(fontSize: 24),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "격추 점수:",
                    style: TextStyle(fontSize: 24),
                  ),
                  Text(
                    secondLineValue.toStringAsFixed(1),
                    style: const TextStyle(fontSize: 24),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Divider(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "총점:",
                    style: TextStyle(fontSize: 24),
                  ),
                  Text(
                    thirdLineValue.toStringAsFixed(1),
                    style: const TextStyle(fontSize: 24),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                        onPressed: () {
                          Get.back(result: false);
                          Get.back();
                        },
                        child: const Text("나가기")),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                        onPressed: () {
                          Get.back(result: true);
                        },
                        child: const Text("한번 더 하기")),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
