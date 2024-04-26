import 'package:flutter/material.dart';
import 'package:hanging_spider/app_state.dart';
import 'package:hanging_spider/game_screen.dart';
import 'package:hanging_spider/start_screen.dart';
import 'package:hanging_spider/utils/screens.dart';
import 'package:provider/provider.dart';

class ScreenManager extends StatefulWidget {
  const ScreenManager({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ScreenManagerState();
  }
}

class _ScreenManagerState extends State<ScreenManager> {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();
    var activeScreen = appState.getCurrentActiveScreen();

    return activeScreen == Screens.startscreen
        ? const StartScreen()
        : const GameScreen();
  }
}
