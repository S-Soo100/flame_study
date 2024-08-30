// ignore_for_file: unnecessary_brace_in_string_interps

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class TopScoreOverlayWidget extends StatelessWidget {
  TopScoreOverlayWidget(
      {super.key,
      required this.hitPoint,
      required this.score,
      required this.killCount});
  int hitPoint;
  int score;
  int killCount;
  String _score() {
    String scoreText = score.toString();
    switch (scoreText.length) {
      case 0:
        return "0000";
      case 1:
        return "000$scoreText";
      case 2:
        return "00$scoreText";
      case 3:
        return "0$scoreText";
      case 4:
        return scoreText;
      default:
        return scoreText;
    }
  }

  String getDistanceStringUtil(int i) {
    int share = i ~/ 1000;
    int reminder = i % 1000;
    String reminderFix = (reminder / 10).toStringAsFixed(0);
    String reminderFixHundred = (reminder / 100).toStringAsFixed(0);
    if (i < 1000) {
      return "$i";
    }
    if (i < 10000) {
      return "${share}.${reminderFix}";
    }
    return "${share}.${reminderFixHundred}";
  }

  String getDistanceUnitUtil(int i) {
    if (i < 1000) {
      return "m";
    }
    return "km";
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white, width: 1),
              color: Colors.white.withOpacity(0.1),
            ),
            alignment: Alignment.center,
            child: Text(
              "❤️ ${hitPoint}",
              style: const TextStyle(
                  color: Colors.red, fontWeight: FontWeight.bold, fontSize: 22),
            ),
          ),
          Container(
            width: 280,
            height: 72,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey, width: 3),
              color: Colors.grey.withOpacity(0.8),
            ),
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(width: 16),
                ClipRect(
                  child: Container(
                    width: 48,
                    height: 48,
                    margin: const EdgeInsets.only(left: 0, right: 4),
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            alignment: Alignment(0, 0),
                            fit: BoxFit.contain,
                            image: AssetImage(
                                "assets/images/airplane_game/enemies/ship_gray.png"))),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  width: 64,
                  height: 48,
                  child: Row(
                    children: [
                      const Text(
                        "x",
                        style: TextStyle(
                            overflow: TextOverflow.fade,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                      Text(
                        "${killCount}",
                        style: const TextStyle(
                            overflow: TextOverflow.fade,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 24),
                      ),
                    ],
                  ),
                ),
                ClipRect(
                  child: Container(
                    width: 48,
                    height: 48,
                    margin: const EdgeInsets.only(right: 6),
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            alignment: Alignment(0, 0),
                            fit: BoxFit.contain,
                            image: AssetImage(
                                "assets/images/airplane_game/distance_icon.png"))),
                  ),
                ),
                Text(
                  getDistanceStringUtil(score),
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
                Text(
                  getDistanceUnitUtil(score),
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
