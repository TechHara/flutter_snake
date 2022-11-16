import 'package:flutter/material.dart';
import 'package:flutter_snake/snake_game.dart';
import 'package:provider/provider.dart';

import 'game_state.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.grey,
        body: SafeArea(
          child: ChangeNotifierProvider(
            create: (BuildContext context) => GameState(),
            child: SnakeGame(),
          ),
        ),
      ),
    ),
  );
}
