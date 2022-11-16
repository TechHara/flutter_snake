import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'constants.dart';
import 'game_state.dart';

class GameBoard extends StatelessWidget {
  List<Widget> _getChildren(GameState state) {
    List<Widget> children = [];
    for (int i = 0; i < NUM_COLS * NUM_ROWS; ++i) {
      Widget cell;
      final val = state.cellValue[i];
      if (val == 0)
        cell = EmptyCell();
      else if (val == 1)
        cell = TailCell();
      else if (val == state.length)
        cell = HeadCell();
      else if (val < 0)
        cell = FruitCell();
      else
        cell = BodyCell();
      children.add(cell);
    }
    return children;
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<GameState>(context);

    return Stack(
      children: [
        Align(
          child: AspectRatio(
            aspectRatio: NUM_COLS / NUM_ROWS,
            child: Container(
              color: Colors.white,
              child: GridView.count(
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: NUM_COLS,
                children: _getChildren(state),
              ),
            ),
          ),
        ),
        state.isGameOver ? GameOver() : Container(),
      ],
    );
  }
}

class EmptyCell extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class FruitCell extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const FittedBox(
      child: Icon(
        Icons.adb,
        color: Colors.red,
      ),
    );
  }
}

class TailCell extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5),
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.green,
      ),
    );
  }
}

class BodyCell extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.green,
      ),
    );
  }
}

class HeadCell extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final state = Provider.of<GameState>(context);

    return FittedBox(
      child: Transform.rotate(
        angle: getRotationAngle(state.currentDir),
        child: const Icon(
          Icons.android,
          color: Colors.green,
        ),
      ),
    );
  }
}

class GameOver extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final state = Provider.of<GameState>(context);

    return Center(
      child: GestureDetector(
        onTap: () => state.startGame(),
        child: const Text(
          "Game Over!",
          style: TextStyle(
            fontSize: 36,
            color: Colors.red,
            backgroundColor: Colors.grey,
          ),
        ),
      ),
    );
  }
}
