import 'package:flutter/material.dart';
import 'package:hanging_spider/app_state.dart';
import 'package:provider/provider.dart';

import 'screen_manager.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AppState(),
      child: const MaterialApp(
        home: SafeArea(
          child: Scaffold(
            body: ScreenManager(),
          ),
        ),
      ),
    ),
  );
}
