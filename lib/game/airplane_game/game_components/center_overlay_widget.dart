import 'dart:async';
import 'package:flutter/material.dart';

class CenterOverlayWidget extends StatefulWidget {
  Function leftTap;
  Function rightTap;

  CenterOverlayWidget(
      {super.key, required this.leftTap, required this.rightTap});

  @override
  State<CenterOverlayWidget> createState() => _CenterOverlayWidgetState();
}

class _CenterOverlayWidgetState extends State<CenterOverlayWidget> {
  Color _left = Colors.white.withOpacity(0.5);
  Color _right = Colors.white.withOpacity(0.5);
  late Timer? _timer;

  void changeLeftColor() {
    setState(() {
      _left = Colors.redAccent.withOpacity(0.5);
      Future.delayed(const Duration(milliseconds: 200), () {
        _left = Colors.white.withOpacity(0.5);
        setState(() {});
      });
    });
  }

  void changeRightColor() {
    setState(() {
      _right = Colors.redAccent.withOpacity(0.5);
      Future.delayed(const Duration(milliseconds: 200), () {
        _right = Colors.white.withOpacity(0.5);
        setState(() {});
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () {
            widget.leftTap();
            changeLeftColor();
          },
          onLongPress: () {
            _timer = Timer.periodic(Duration(milliseconds: 150), (timer) {
              widget.leftTap();
            });
          },
          onLongPressEnd: (details) {
            _timer?.cancel();
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: AnimatedContainer(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: _left,
                ),
                padding: const EdgeInsets.all(30),
                duration: const Duration(milliseconds: 200),
                child: const Text("<-")),
          ),
        ),
        GestureDetector(
          onTap: () {
            widget.rightTap();
            changeRightColor();
          },
          onLongPress: () {
            _timer = Timer.periodic(Duration(milliseconds: 150), (timer) {
              widget.rightTap();
            });
          },
          onLongPressEnd: (details) {
            _timer?.cancel();
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: AnimatedContainer(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: _right,
                ),
                padding: const EdgeInsets.all(30),
                duration: const Duration(milliseconds: 300),
                child: const Text("->")),
          ),
        ),
      ],
    );
  }
}
