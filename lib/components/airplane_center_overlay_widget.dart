import 'package:flutter/material.dart';

class AirplaneCenterOverlayWidget extends StatefulWidget {
  const AirplaneCenterOverlayWidget({super.key});

  @override
  State<AirplaneCenterOverlayWidget> createState() =>
      _AirplaneCenterOverlayWidgetState();
}

class _AirplaneCenterOverlayWidgetState
    extends State<AirplaneCenterOverlayWidget> {
  Color _left = Colors.white;
  Color _right = Colors.white;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _left = Colors.amberAccent;
              Future.delayed(Duration(milliseconds: 200), () {
                _left = Colors.white;
                setState(() {});
              });
            });
          },
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: AnimatedContainer(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: _left,
                ),
                padding: const EdgeInsets.all(30),
                duration: Duration(milliseconds: 200),
                child: Text("<-")),
          ),
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              _right = Colors.amberAccent;
              Future.delayed(Duration(milliseconds: 200), () {
                _right = Colors.white;
                setState(() {});
              });
            });
          },
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: AnimatedContainer(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: _right,
                ),
                padding: const EdgeInsets.all(30),
                duration: Duration(milliseconds: 300),
                child: Text("->")),
          ),
        ),
      ],
    );
  }
}
