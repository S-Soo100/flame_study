import 'package:flame_practice/game/triangle_game/triangle_game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class TriangleGameController with ChangeNotifier, DiagnosticableTreeMixin {
  final TriangleGame _game = TriangleGame();
  double _leftSpeed = 3;
  double _rightSpeed = 3;

  TriangleGame get game => _game;
  double get leftSpeed => _leftSpeed;
  double get rightSpeed => _rightSpeed;

  void move({required double left, required double right}) {
    _game.moveByWheel(left, right);
    notifyListeners();
  }

  void setLeftSpeed(double speed) {
    _leftSpeed = speed;
    notifyListeners();
  }

  void setRightSpeed(double speed) {
    _rightSpeed = speed;
    notifyListeners();
  }

  void upLeftSpeed() {
    _leftSpeed++;
    setSpeedToGame();
    notifyListeners();
  }

  void downLeftSpeed() {
    _leftSpeed--;
    setSpeedToGame();
    notifyListeners();
  }

  void upRightSpeed() {
    _rightSpeed++;
    setSpeedToGame();
    notifyListeners();
  }

  void downRightSpeed() {
    _rightSpeed--;
    setSpeedToGame();
    notifyListeners();
  }

  void setSpeedToGame() {
    move(left: _leftSpeed, right: _rightSpeed);
  }
}
