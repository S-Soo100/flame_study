import 'package:flame_practice/game/airplane_game/airplane_game_controller.dart';
import 'package:get/get.dart';

class InitialBindings extends Bindings {
  @override
  void dependencies() {
    Get.put<AirplaneGameController>(AirplaneGameController(), permanent: true);
  }
}
