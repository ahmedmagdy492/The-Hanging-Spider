import 'package:flutter/material.dart';

class WaitingScreen extends StatelessWidget {
  const WaitingScreen(this.textToDisplay, {super.key});

  final String textToDisplay;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        textToDisplay,
        style: const TextStyle(
          fontSize: 20,
        ),
      ),
    );
  }
}
