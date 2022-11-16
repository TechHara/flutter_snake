import 'package:flutter/material.dart';
import 'package:flutter_snake/scores.dart';
import 'package:provider/provider.dart';

import 'controls.dart';
import 'game_board.dart';
import 'game_state.dart';

class SnakeGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final state = Provider.of<GameState>(context);

    return Column(
      children: [
        Expanded(
          flex: 3,
          child: GameBoard(),
        ),
        Expanded(
          flex: 2,
          child: Controls(),
        ),
        Expanded(
          flex: 1,
          child: Scores(state.currentScore, state.bestScore),
        ),
      ],
    );
  }
}
