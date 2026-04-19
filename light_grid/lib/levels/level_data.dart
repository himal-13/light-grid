import 'dart:math';
import '../models/level_model.dart';

final List<LevelData> allLevels = [
  // // 3x3 Regular Squares (Levels 0-4)
  // _generateSquareLevel(0, 3, 2),
  // _generateSquareLevel(1, 3, 3),
  // _generateSquareLevel(2, 3, 4),
  // _generateSquareLevel(3, 3, 5),
  // _generateSquareLevel(4, 3, 6),

  // // 4x4 Regular Squares (Levels 5-9)
  // _generateSquareLevel(5, 4, 3),
  // _generateSquareLevel(6, 4, 4),
  // _generateSquareLevel(7, 4, 5),
  // _generateSquareLevel(8, 4, 6),
  // _generateSquareLevel(9, 4, 8),

  // Irregular: Cross (Levels 10-12)
  LevelData(
    id: 1,
    tiles: [
    const Point(0, 0), const Point(1, 0), 
  ],
    startingOnTiles: [],
  ),
   LevelData(
    id: 2,
    tiles: [
       const Point(1, 0), const Point(2, 0),
      const Point(0, 1), const Point(3, 1),
      const Point(0, 2), const Point(3, 2),
       const Point(1, 3), const Point(2, 3), 
    ],
    startingOnTiles: [const Point(1, 0), const Point(2, 0)],
  ),
 
  LevelData(
    id: 3,
    tiles: _getCrossPoints(5),
    startingOnTiles: [const Point(0, 2), const Point(4, 2), const Point(2, 0), const Point(2, 4)],
  ),
//  LevelData(
//     id: 3,
//     tiles: [
//       const Point(0, 1), const Point(1, 0), const Point(1, 1), const Point(1, 2), const Point(2, 1),
//       const Point(3, 1),
//     ],
//     startingOnTiles: [const Point(3, 1)],
//   ),
  // Irregular: Diamond (Levels 13-16)
  LevelData(
    id: 4,
    tiles: _getDiamondPoints(3),
    startingOnTiles: [const Point(1, 1)],
  ),
  LevelData(
    id: 5,
    tiles: _getDiamondPoints(3),
    startingOnTiles: [const Point(0, 1), const Point(2, 1), const Point(1, 0), const Point(1, 2)],
  ),
  LevelData(
    id: 6,
    tiles: _getDiamondPoints(5),
    startingOnTiles: [const Point(0,2),const Point(2, 2), const Point(1, 2), const Point(3, 2), const Point(4, 2)],
  ),
  _generateDiamondLevel(16, 5, 5),
 LevelData(
    id: 8,
    tiles: [
      const Point(0, 1), const Point(1, 0), const Point(1, 1), const Point(1, 2), const Point(2, 1),
      const Point(3, 1),
    ],
    startingOnTiles: [const Point(3, 1), const Point(0, 1),  ],
  ),
  // Irregular: Triangle (Levels 17-20)
  LevelData(
    id: 9,
    tiles: _getTrianglePoints(3),
    startingOnTiles: [const Point(0, 0), const Point(1, 1)],
  ),
  LevelData(
    id: 10,
    tiles: _getTrianglePoints(4),
    startingOnTiles: [const Point(1, 1), const Point(2, 2)],
  ),
  //10-11
  _generateTriangleLevel(19, 4, 4),
  _generateTriangleLevel(20, 5, 5),

 LevelData(
    id: 13,
    tiles: [
      const Point(0, 1), const Point(1, 0), const Point(1, 1), const Point(1, 2), const Point(2, 1), const Point(3, 1),
      const Point(3, 2),
    ],
    startingOnTiles: [const Point(3, 1), const Point(0, 1),  ],
  ),
  // 5x5 Regular Squares (Levels 21-25)
  _generateSquareLevel(21, 5, 6),
   LevelData(
    id: 13,
    tiles: [
      const Point(0, 1), const Point(1, 0), const Point(1, 1), const Point(1, 2), const Point(1, 3),
       const Point(2, 0),  const Point(2, 1),  const Point(3, 1),  const Point(4, 1),
      
    ],
    startingOnTiles: [const Point(3, 1), const Point(0, 1),  ],
  ),

];

// Helper to generate a square level with random solvable start
LevelData _generateSquareLevel(int id, int size, int complexity) {
  List<Point<int>> tiles = [];
  for (int x = 0; x < size; x++) {
    for (int y = 0; y < size; y++) {
      tiles.add(Point(x, y));
    }
  }

  // To ensure solvability, start with all ON (the goal) and toggle random points.
  // Then the final state is our "starting state".
  Set<Point<int>> states = tiles.toSet(); // Start with all ON
  Random rand = Random(id); // Stable levels based on ID
  
  for (int i = 0; i < complexity; i++) {
    Point<int> p = tiles[rand.nextInt(tiles.length)];
    // Toggle point and neighbors
    _toggleSimulated(states, p, tiles);
  }

  return LevelData(
    id: id,
    tiles: tiles,
    startingOnTiles: states.toList(),
  );
}

void _toggleSimulated(Set<Point<int>> states, Point<int> p, List<Point<int>> validTiles) {
  List<Point<int>> affected = [
    p,
    Point(p.x - 1, p.y), Point(p.x + 1, p.y),
    Point(p.x, p.y - 1), Point(p.x, p.y + 1),
    Point(p.x - 1, p.y - 1), Point(p.x + 1, p.y - 1),
    Point(p.x - 1, p.y + 1), Point(p.x + 1, p.y + 1),
  ];

  for (var a in affected) {
    if (validTiles.contains(a)) {
      if (states.contains(a)) {
        states.remove(a);
      } else {
        states.add(a);
      }
    }
  }
}

List<Point<int>> _getCrossPoints(int size) {
  List<Point<int>> tiles = [];
  int mid = size ~/ 2;
  for (int i = 0; i < size; i++) {
    tiles.add(Point(mid, i));
    if (i != mid) tiles.add(Point(i, mid));
  }
  return tiles;
}

List<Point<int>> _getDiamondPoints(int size) {
  List<Point<int>> tiles = [];
  int mid = size ~/ 2;
  for (int x = 0; x < size; x++) {
    for (int y = 0; y < size; y++) {
      if ((x - mid).abs() + (y - mid).abs() <= mid) {
        tiles.add(Point(x, y));
      }
    }
  }
  return tiles;
}

List<Point<int>> _getTrianglePoints(int size) {
  List<Point<int>> tiles = [];
  for (int y = 0; y < size; y++) {
    for (int x = 0; x <= y; x++) {
      tiles.add(Point(x, y));
    }
  }
  return tiles;
}

LevelData _generateDiamondLevel(int id, int size, int complexity) {
  List<Point<int>> tiles = _getDiamondPoints(size);
  Set<Point<int>> states = tiles.toSet();
  Random rand = Random(id);
  for (int i = 0; i < complexity; i++) {
    _toggleSimulated(states, tiles[rand.nextInt(tiles.length)], tiles);
  }
  return LevelData(id: id, tiles: tiles, startingOnTiles: states.toList());
}

LevelData _generateTriangleLevel(int id, int size, int complexity) {
  List<Point<int>> tiles = _getTrianglePoints(size);
  Set<Point<int>> states = tiles.toSet();
  Random rand = Random(id);
  for (int i = 0; i < complexity; i++) {
    _toggleSimulated(states, tiles[rand.nextInt(tiles.length)], tiles);
  }
  return LevelData(id: id, tiles: tiles, startingOnTiles: states.toList());
}
