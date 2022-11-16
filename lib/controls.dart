import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_snake/game_state.dart';
import 'package:provider/provider.dart';

class Controls extends StatelessWidget {
  Widget _emptyCell() {
    return Container();
  }

  Widget _buttonCell(Direction dir, GameState state) {
    return GestureDetector(
      onTap: () {
        if (dir != GameState.oppositeDir(state.currentDir)) {
          state.nextDir = dir;
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black54,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Transform.rotate(
          angle: getRotationAngle(dir) - pi/2,
          child: const Icon(
            Icons.play_arrow_rounded,
            color: Colors.white,
            size: 36,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<GameState>(context);
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Align(
        child: AspectRatio(
          aspectRatio: 1,
          child: GridView.count(
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            children: [
              _emptyCell(),
              _buttonCell(Direction.UP, state),
              _emptyCell(),
              _buttonCell(Direction.LEFT, state),
              _emptyCell(),
              _buttonCell(Direction.RIGHT, state),
              _emptyCell(),
              _buttonCell(Direction.DOWN, state),
              _emptyCell(),
            ],
          ),
        ),
      ),
    );
  }
}
