import 'package:flutter/material.dart';
import 'package:hanging_spider/app_state.dart';
import 'package:hanging_spider/utils/screens.dart';
import 'package:provider/provider.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Image.asset(
            "assets/images/logo.png",
            alignment: Alignment.center,
          ),
          const SizedBox(
            height: 30,
          ),
          TextButton(
            onPressed: () {
              appState.changeScreen(Screens.gamescreen);
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.black,
              padding: const EdgeInsets.all(20),
            ),
            child: const Text(
              "Join a Game",
              style: TextStyle(fontSize: 20),
            ),
          )
        ],
      ),
    );
  }
}
