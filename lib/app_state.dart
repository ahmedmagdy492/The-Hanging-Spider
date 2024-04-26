import 'package:flutter/material.dart';
import 'package:hanging_spider/utils/screens.dart';

class AppState extends ChangeNotifier {
  var _activeScreen = 0;

  void changeScreen(Screens screen) {
    switch (screen) {
      case Screens.gamescreen:
        _activeScreen = 1;
        notifyListeners();
        break;
      case Screens.startscreen:
        _activeScreen = 0;
        notifyListeners();
        break;
    }
  }

  Screens getCurrentActiveScreen() {
    return _activeScreen == 0 ? Screens.startscreen : Screens.gamescreen;
  }
}
