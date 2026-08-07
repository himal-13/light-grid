import 'dart:math';
import '../models/level_model.dart';

final List<LevelData> pathFillLevels = [
  // Level 1: Simple L-shape
  LevelData(
    id: 0,
    tiles: [
      const Point(0, 0),
      const Point(0, 1),
      const Point(0, 2),
      const Point(1, 2),
      const Point(2, 2),
    ],
    startingOnTiles: [],
  ),
  // Level 2: Plus shape
  LevelData(
    id: 1,
    tiles: [
      const Point(1, 0),
      const Point(1, 1),
      const Point(1, 2),
      const Point(0, 1),
      const Point(2, 1),
    ],
    startingOnTiles: [],
  ),
  // Level 3: Hollow Square (Unusual shape)
  LevelData(
    id: 2,
    tiles: [
      const Point(0, 0), const Point(1, 0), const Point(2, 0),
      const Point(0, 1),                    const Point(2, 1),
      const Point(0, 2), const Point(1, 2), const Point(2, 2),
    ],
    startingOnTiles: [],
  ),
  // Level 4: Zig-zag
  LevelData(
    id: 3,
    tiles: [
      const Point(0, 0), const Point(1, 0),
      const Point(1, 1), const Point(2, 1),
      const Point(2, 2), const Point(3, 2),
    ],
    startingOnTiles: [],
  ),
  // Level 5: T-shape
  LevelData(
    id: 4,
    tiles: [
      const Point(0, 0), const Point(1, 0), const Point(2, 0),
      const Point(1, 1),
      const Point(1, 2),
    ],
    startingOnTiles: [],
  ),
];
