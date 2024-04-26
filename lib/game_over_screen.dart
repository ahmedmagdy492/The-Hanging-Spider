import 'package:flutter/material.dart';
import 'package:hanging_spider/app_state.dart';
import 'package:hanging_spider/game_over_status.dart';
import 'package:hanging_spider/utils/screens.dart';
import 'package:provider/provider.dart';

class GameOverScreen extends StatelessWidget {
  const GameOverScreen(this._msgToShow, {super.key});

  final GameOverStatus _msgToShow;

  String _getMsgOf(GameOverStatus gameOverStatus) {
    if (gameOverStatus == GameOverStatus.noWin) {
      return "No One Win";
    } else if (gameOverStatus == GameOverStatus.youWon) {
      return "Congrats You Won";
    }

    return "You Lost, The Other Player Won";
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            _getMsgOf(_msgToShow),
            style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w800),
          ),
          const SizedBox(
            height: 30,
          ),
          TextButton(
            onPressed: () {
              appState.changeScreen(Screens.startscreen);
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.black,
              padding: const EdgeInsets.all(20),
            ),
            child: const Text(
              "OK",
              style: TextStyle(fontSize: 20),
            ),
          )
        ],
      ),
    );
  }
}
