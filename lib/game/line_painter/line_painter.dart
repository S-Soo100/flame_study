import 'package:flutter/material.dart';

class LinePainter extends CustomPainter {
  LinePainter({required this.x, required this.y}) {
    points = [Offset(x, y)];
  }
  double x;
  double y;
  List<Offset> points = [Offset(0, 0)];
  Paint paint2 = Paint()
    ..color = Colors.redAccent
    ..strokeWidth = 4.0
    ..strokeCap = StrokeCap.round;
  @override
  void paint(Canvas canvas, Size size) {
    paint2;
    for (int i = 0; i < points.length; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i], points[i + 1], paint2);
        canvas.drawCircle(points[i + 1], 8, paint2);
      } else if (points[i] != null && points[i + 1] == null) {
        // Draw a point (if the user stopped drawing)
        canvas.drawLine(Offset(0, 0), points[i], paint2);
        canvas.drawCircle(points[i + 1], 10, paint2);
      }
    }
  }

  void drawLine(double dx, double dy) {
    points.add(Offset(dx, dy));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
