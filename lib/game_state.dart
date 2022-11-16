import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';

import 'constants.dart';

enum Direction {
  RIGHT,
  UP,
  LEFT,
  DOWN,
}

double getRotationAngle(Direction dir) {
  switch (dir) {
    case Direction.RIGHT:
      return pi / 2;
    case Direction.UP:
      return 0;
    case Direction.LEFT:
      return -pi / 2;
    case Direction.DOWN:
      return pi;
  }
}

class GameState with ChangeNotifier {
  GameState() {
    startGame();
  }

  late bool isGameOver;

  final rg = Random();

  void _generateFruit() {
    int fruitPos;
    do {
      fruitPos = rg.nextInt(cellValue.length);
    } while (cellValue[fruitPos] != 0);

    cellValue[fruitPos] = -1;
  }

  void startGame() {
    isGameOver = false;
    cellValue = List.filled(NUM_ROWS * NUM_COLS, 0);
    headPos = rg.nextInt(cellValue.length);
    final dirIdx = rg.nextInt(Direction.values.length);
    currentDir = nextDir = Direction.values[dirIdx];
    final tailPos = _neighbor(headPos, oppositeDir(currentDir));

    length = 2;
    cellValue[headPos] = length;
    cellValue[tailPos] = 1;

    _generateFruit();

    gameLoop =
        Timer.periodic(const Duration(milliseconds: DELTA_T_MS), (timer) {
      _update();
    });

    bestScore = max(bestScore, currentScore);
    currentScore = 0;
    notifyListeners();
  }

  void _update() {
    currentDir = nextDir;

    headPos = _neighbor(headPos, currentDir);
    if (cellValue[headPos] == -1) {
      // consume fruit
      ++currentScore;
      ++length;
      _generateFruit();
      cellValue[headPos] = length;
    } else if (cellValue[headPos] > 1) {
      // collision
      isGameOver = true;
      gameLoop.cancel();
      notifyListeners();
    } else {
      for (int i = 0; i < cellValue.length; ++i) {
        if (cellValue[i] <= 0) continue;
        --cellValue[i];
      }
      cellValue[headPos] = length;
    }

    notifyListeners();
  }

  static Direction oppositeDir(Direction dir) {
    switch (dir) {
      case Direction.RIGHT:
        return Direction.LEFT;
      case Direction.UP:
        return Direction.DOWN;
      case Direction.LEFT:
        return Direction.RIGHT;
      case Direction.DOWN:
        return Direction.UP;
    }
  }

  int _neighbor(int pos, Direction dir) {
    switch (dir) {
      case Direction.RIGHT:
        if (pos % NUM_COLS == NUM_COLS - 1) {
          pos -= NUM_COLS;
        }
        ++pos;
        break;
      case Direction.UP:
        if (pos ~/ NUM_COLS == 0) {
          pos += NUM_ROWS * NUM_COLS;
        }
        pos -= NUM_COLS;
        break;
      case Direction.LEFT:
        if (pos % NUM_COLS == 0) {
          pos += NUM_COLS;
        }
        --pos;
        break;
      case Direction.DOWN:
        if (pos ~/ NUM_COLS == NUM_ROWS - 1) {
          pos -= NUM_ROWS * NUM_COLS;
        }
        pos += NUM_COLS;
        break;
    }

    return pos;
  }

  int currentScore = 0;
  int bestScore = 0;

  late Direction currentDir;
  late Direction nextDir;

  late List<int> cellValue;

  late int headPos;
  late int length;

  late Timer gameLoop;
}
