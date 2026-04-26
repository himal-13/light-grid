import 'dart:math';
import '../models/level_model.dart';

final List<LevelData> allLevels = [
  // EXISTING LEVELS 1-13 (preserved)
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
    startingOnTiles: [const Point(0, 2), const Point(2, 2), const Point(1, 2), const Point(3, 2), const Point(4, 2)],
  ),
  _generateDiamondLevel(16, 5, 5),
  LevelData(
    id: 8,
    tiles: [
      const Point(0, 1), const Point(1, 0), const Point(1, 1), const Point(1, 2), const Point(2, 1),
      const Point(3, 1),
    ],
    startingOnTiles: [const Point(3, 1), const Point(0, 1)],
  ),
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
  _generateTriangleLevel(19, 4, 4),
  _generateTriangleLevel(20, 5, 5),
  LevelData(
    id: 13,
    tiles: [
      const Point(0, 1), const Point(1, 0), const Point(1, 1), const Point(1, 2), const Point(2, 1), const Point(3, 1),
      const Point(3, 2),
    ],
    startingOnTiles: [const Point(3, 1), const Point(0, 1)],
  ),
  _generateSquareLevel(21, 5, 6),
  LevelData(
    id: 13,
    tiles: [
      const Point(0, 1), const Point(1, 0), const Point(1, 1), const Point(1, 2), const Point(1, 3),
      const Point(2, 0), const Point(2, 1), const Point(3, 1), const Point(4, 1),
    ],
    startingOnTiles: [const Point(3, 1), const Point(0, 1)],
  ),

  // ========== NEW LEVELS 14-50 ==========

  // Level 14 - Heart Shape (Irregular)
  _createHeartLevel(14),

  // Level 15 - Small Rectangle
  LevelData(
    id: 15,
    tiles: _getRectanglePoints(3, 4),
    startingOnTiles: [const Point(0, 0), const Point(2, 3)],
  ),

  // Level 16 - Diamond Medium
  _generateDiamondLevel(16, 4, 6),

  // Level 17 - Small Cross
  LevelData(
    id: 17,
    tiles: _getCrossPoints(3),
    startingOnTiles: [const Point(1, 0), const Point(1, 2)],
  ),

  // Level 18 - Arrow Shape (Irregular)
  _createArrowLevel(18),

  // Level 19 - Triangle Medium
  _generateTriangleLevel(19, 5, 6),

  // Level 20 - Square 4x4
  _generateSquareLevel(20, 4, 5),

  // Level 21 - Rectangle 6x4
  _generateRectangleLevel(21, 6, 4, 7),

  // Level 22 - Plus Sign (Irregular)
  _createPlusLevel(22),

  // Level 23 - Diamond Large
  _generateDiamondLevel(23, 6, 8),

  // Level 24 - Triangle Large
  _generateTriangleLevel(24, 6, 8),

  // Level 25 - Square Ring (Irregular)
  _createSquareRingLevel(25),

  // Level 26 - Rectangle 5x5
  _generateSquareLevel(26, 5, 7),

  // Level 27 - Diamond Small
  _generateDiamondLevel(27, 3, 4),

  // Level 28 - L-Shape (Irregular)
  _createLShapeLevel(28),

  // Level 29 - Rectangle 7x3
  _generateRectangleLevel(29, 7, 3, 6),

  // Level 30 - Cross Large
  LevelData(
    id: 30,
    tiles: _getCrossPoints(7),
    startingOnTiles: [const Point(3, 0), const Point(3, 6), const Point(0, 3), const Point(6, 3)],
  ),

  // Level 31 - Zigzag Shape (Irregular)
  _createZigzagLevel(31),

  // Level 32 - Diamond Medium
  _generateDiamondLevel(32, 4, 5),

  // Level 33 - Triangle Medium
  _generateTriangleLevel(33, 5, 6),

  // Level 34 - Rectangle 8x3
  _generateRectangleLevel(34, 8, 3, 8),

  // Level 35 - Hourglass Shape (Irregular)
  _createHourglassLevel(35),

  // Level 36 - Square 5x5
  _generateSquareLevel(36, 5, 6),

  // Level 37 - Diamond Large
  _generateDiamondLevel(37, 7, 10),

  // Level 38 - Triangle Large
  _generateTriangleLevel(38, 7, 10),

  // Level 39 - Spiral Shape (Irregular)
  _createSpiralLevel(39),

  // Level 40 - Rectangle 6x5
  _generateRectangleLevel(40, 6, 5, 9),

  // Level 41 - Cross Medium
  LevelData(
    id: 41,
    tiles: _getCrossPoints(5),
    startingOnTiles: [const Point(2, 0), const Point(2, 4), const Point(0, 2), const Point(4, 2)],
  ),

  // Level 42 - Butterfly Shape (Irregular)
  _createButterflyLevel(42),

  // Level 43 - Diamond Extra Large
  _generateDiamondLevel(43, 8, 12),

  // Level 44 - Triangle Extra Large
  _generateTriangleLevel(44, 8, 12),

  // Level 45 - Crown Shape (Irregular)
  _createCrownLevel(45),

  // Level 46 - Rectangle 9x4
  _generateRectangleLevel(46, 9, 4, 10),

  // Level 47 - Square 6x6
  _generateSquareLevel(47, 6, 9),

  // Level 48 - Star Shape (Irregular)
  _createStarLevel(48),

  // Level 49 - Diamond Max
  _generateDiamondLevel(49, 9, 14),

  // Level 50 - Complex Spiral (Irregular)
  _createComplexSpiralLevel(50),
];

// ============ HELPER FUNCTIONS ============

List<Point<int>> _getRectanglePoints(int width, int height) {
  List<Point<int>> tiles = [];
  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {
      tiles.add(Point(x, y));
    }
  }
  return tiles;
}

LevelData _generateRectangleLevel(int id, int width, int height, int complexity) {
  List<Point<int>> tiles = _getRectanglePoints(width, height);
  Set<Point<int>> states = tiles.toSet();
  Random rand = Random(id);
  for (int i = 0; i < complexity; i++) {
    _toggleSimulated(states, tiles[rand.nextInt(tiles.length)], tiles);
  }
  return LevelData(id: id, tiles: tiles, startingOnTiles: states.toList());
}

// ============ IRREGULAR SHAPE CREATORS ============

// Heart Shape
LevelData _createHeartLevel(int id) {
  List<Point<int>> tiles = [
    const Point(0, 2), const Point(1, 1), const Point(1, 2), const Point(1, 3),
    const Point(2, 0), const Point(2, 1), const Point(2, 2), const Point(2, 3), const Point(2, 4),
    const Point(3, 0), const Point(3, 1), const Point(3, 2), const Point(3, 3), const Point(3, 4),
    const Point(4, 1), const Point(4, 2), const Point(4, 3),
    const Point(5, 2), const Point(5, 3),
    const Point(6, 2),
  ];
  
  Set<Point<int>> states = tiles.toSet();
  Random rand = Random(id);
  for (int i = 0; i < 4; i++) {
    _toggleSimulated(states, tiles[rand.nextInt(tiles.length)], tiles);
  }
  return LevelData(id: id, tiles: tiles, startingOnTiles: states.toList());
}

// Arrow Shape
LevelData _createArrowLevel(int id) {
  List<Point<int>> tiles = [
    const Point(0, 1), const Point(1, 0), const Point(1, 1), const Point(1, 2),
    const Point(2, 0), const Point(2, 1), const Point(2, 2), const Point(2, 3),
    const Point(3, 0), const Point(3, 1), const Point(3, 2), const Point(3, 3),
    const Point(4, 0), const Point(4, 1), const Point(4, 2),
    const Point(5, 1),
  ];
  
  Set<Point<int>> states = tiles.toSet();
  Random rand = Random(id);
  for (int i = 0; i < 5; i++) {
    _toggleSimulated(states, tiles[rand.nextInt(tiles.length)], tiles);
  }
  return LevelData(id: id, tiles: tiles, startingOnTiles: states.toList());
}

// Plus Sign
LevelData _createPlusLevel(int id) {
  List<Point<int>> tiles = [
    const Point(0, 2), const Point(1, 2), const Point(2, 0), const Point(2, 1),
    const Point(2, 2), const Point(2, 3), const Point(2, 4),
    const Point(3, 2), const Point(4, 2),
  ];
  
  Set<Point<int>> states = tiles.toSet();
  Random rand = Random(id);
  for (int i = 0; i < 4; i++) {
    _toggleSimulated(states, tiles[rand.nextInt(tiles.length)], tiles);
  }
  return LevelData(id: id, tiles: tiles, startingOnTiles: states.toList());
}

// Square Ring (hollow square)
LevelData _createSquareRingLevel(int id) {
  List<Point<int>> tiles = [];
  int size = 5;
  for (int x = 0; x < size; x++) {
    for (int y = 0; y < size; y++) {
      if (x == 0 || x == size - 1 || y == 0 || y == size - 1) {
        tiles.add(Point(x, y));
      }
    }
  }
  
  Set<Point<int>> states = tiles.toSet();
  Random rand = Random(id);
  for (int i = 0; i < 6; i++) {
    _toggleSimulated(states, tiles[rand.nextInt(tiles.length)], tiles);
  }
  return LevelData(id: id, tiles: tiles, startingOnTiles: states.toList());
}

// L-Shape
LevelData _createLShapeLevel(int id) {
  List<Point<int>> tiles = [
    const Point(0, 0), const Point(0, 1), const Point(0, 2), const Point(0, 3),
    const Point(1, 3), const Point(2, 3), const Point(3, 3),
  ];
  
  Set<Point<int>> states = tiles.toSet();
  Random rand = Random(id);
  for (int i = 0; i < 4; i++) {
    _toggleSimulated(states, tiles[rand.nextInt(tiles.length)], tiles);
  }
  return LevelData(id: id, tiles: tiles, startingOnTiles: states.toList());
}

// Zigzag Shape
LevelData _createZigzagLevel(int id) {
  List<Point<int>> tiles = [
    const Point(0, 1), const Point(1, 0), const Point(1, 1), const Point(1, 2),
    const Point(2, 1), const Point(2, 2), const Point(2, 3),
    const Point(3, 2), const Point(3, 3), const Point(3, 4),
    const Point(4, 3),
  ];
  
  Set<Point<int>> states = tiles.toSet();
  Random rand = Random(id);
  for (int i = 0; i < 5; i++) {
    _toggleSimulated(states, tiles[rand.nextInt(tiles.length)], tiles);
  }
  return LevelData(id: id, tiles: tiles, startingOnTiles: states.toList());
}

// Hourglass Shape
LevelData _createHourglassLevel(int id) {
  List<Point<int>> tiles = [
    const Point(0, 0), const Point(1, 0), const Point(2, 0), const Point(3, 0), const Point(4, 0),
    const Point(0, 1), const Point(1, 1), const Point(3, 1), const Point(4, 1),
    const Point(0, 2), const Point(2, 2), const Point(4, 2),
    const Point(0, 3), const Point(1, 3), const Point(3, 3), const Point(4, 3),
    const Point(0, 4), const Point(1, 4), const Point(2, 4), const Point(3, 4), const Point(4, 4),
  ];
  
  Set<Point<int>> states = tiles.toSet();
  Random rand = Random(id);
  for (int i = 0; i < 6; i++) {
    _toggleSimulated(states, tiles[rand.nextInt(tiles.length)], tiles);
  }
  return LevelData(id: id, tiles: tiles, startingOnTiles: states.toList());
}

// Spiral Shape
LevelData _createSpiralLevel(int id) {
  List<Point<int>> tiles = [
    const Point(0, 0), const Point(1, 0), const Point(2, 0), const Point(3, 0),
    const Point(0, 1), const Point(3, 1),
    const Point(0, 2), const Point(1, 2), const Point(2, 2), const Point(3, 2),
    const Point(1, 3), const Point(3, 3),
    const Point(1, 4), const Point(2, 4), const Point(3, 4),
  ];
  
  Set<Point<int>> states = tiles.toSet();
  Random rand = Random(id);
  for (int i = 0; i < 5; i++) {
    _toggleSimulated(states, tiles[rand.nextInt(tiles.length)], tiles);
  }
  return LevelData(id: id, tiles: tiles, startingOnTiles: states.toList());
}

// Butterfly Shape
LevelData _createButterflyLevel(int id) {
  List<Point<int>> tiles = [
    const Point(0, 1), const Point(1, 0), const Point(1, 2),
    const Point(2, 1),
    const Point(3, 0), const Point(3, 2),
    const Point(4, 1),
    const Point(1, 4), const Point(2, 3), const Point(2, 5),
    const Point(3, 4),
    const Point(1, 6), const Point(2, 6), const Point(3, 6),
  ];
  
  Set<Point<int>> states = tiles.toSet();
  Random rand = Random(id);
  for (int i = 0; i < 6; i++) {
    _toggleSimulated(states, tiles[rand.nextInt(tiles.length)], tiles);
  }
  return LevelData(id: id, tiles: tiles, startingOnTiles: states.toList());
}

// Crown Shape
LevelData _createCrownLevel(int id) {
  List<Point<int>> tiles = [
    const Point(0, 0), const Point(1, 0), const Point(2, 0), const Point(3, 0), const Point(4, 0),
    const Point(0, 1), const Point(4, 1),
    const Point(0, 2), const Point(4, 2),
    const Point(1, 2), const Point(3, 2),
    const Point(2, 3),
  ];
  
  Set<Point<int>> states = tiles.toSet();
  Random rand = Random(id);
  for (int i = 0; i < 5; i++) {
    _toggleSimulated(states, tiles[rand.nextInt(tiles.length)], tiles);
  }
  return LevelData(id: id, tiles: tiles, startingOnTiles: states.toList());
}

// Star Shape
LevelData _createStarLevel(int id) {
  List<Point<int>> tiles = [
    const Point(2, 0),
    const Point(1, 1), const Point(3, 1),
    const Point(0, 2), const Point(2, 2), const Point(4, 2),
    const Point(1, 3), const Point(3, 3),
    const Point(2, 4),
    const Point(0, 4), const Point(4, 4),
    const Point(0, 5), const Point(2, 5), const Point(4, 5),
    const Point(1, 6), const Point(3, 6),
    const Point(2, 7),
  ];
  
  Set<Point<int>> states = tiles.toSet();
  Random rand = Random(id);
  for (int i = 0; i < 7; i++) {
    _toggleSimulated(states, tiles[rand.nextInt(tiles.length)], tiles);
  }
  return LevelData(id: id, tiles: tiles, startingOnTiles: states.toList());
}

// Complex Spiral Shape
LevelData _createComplexSpiralLevel(int id) {
  List<Point<int>> tiles = [
    const Point(0, 0), const Point(1, 0), const Point(2, 0), const Point(3, 0), const Point(4, 0), const Point(5, 0),
    const Point(0, 1), const Point(5, 1),
    const Point(0, 2), const Point(1, 2), const Point(2, 2), const Point(3, 2), const Point(4, 2), const Point(5, 2),
    const Point(1, 3), const Point(5, 3),
    const Point(1, 4), const Point(2, 4), const Point(3, 4), const Point(4, 4), const Point(5, 4),
    const Point(2, 5), const Point(5, 5),
    const Point(2, 6), const Point(3, 6), const Point(4, 6), const Point(5, 6),
    const Point(3, 7), const Point(5, 7),
    const Point(3, 8), const Point(4, 8), const Point(5, 8),
  ];
  
  Set<Point<int>> states = tiles.toSet();
  Random rand = Random(id);
  for (int i = 0; i < 8; i++) {
    _toggleSimulated(states, tiles[rand.nextInt(tiles.length)], tiles);
  }
  return LevelData(id: id, tiles: tiles, startingOnTiles: states.toList());
}

// ============ EXISTING HELPER FUNCTIONS (kept as is) ============

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

LevelData _generateSquareLevel(int id, int size, int complexity) {
  List<Point<int>> tiles = [];
  for (int x = 0; x < size; x++) {
    for (int y = 0; y < size; y++) {
      tiles.add(Point(x, y));
    }
  }
  Set<Point<int>> states = tiles.toSet();
  Random rand = Random(id);
  for (int i = 0; i < complexity; i++) {
    _toggleSimulated(states, tiles[rand.nextInt(tiles.length)], tiles);
  }
  return LevelData(id: id, tiles: tiles, startingOnTiles: states.toList());
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