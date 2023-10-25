import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class TopScoreOverlayWidget extends StatelessWidget {
  TopScoreOverlayWidget({super.key, required this.score});
  int score;
  String _score() {
    String scoreText = score.toString();
    if (kDebugMode) {
      print("Score length = ${scoreText.length}");
    }
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(),
          Container(
            width: 180,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey, width: 3),
              color: Colors.grey.withOpacity(0.8),
            ),
            alignment: Alignment.center,
            child: Text(
              "Score : ${_score()}",
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }
}
