import 'dart:math';

class LevelData {
  final int id;
  final List<Point<int>> tiles;
  final List<Point<int>> startingOnTiles;

  LevelData({
    required this.id,
    required this.tiles,
    required this.startingOnTiles,
  });

  // Helper to check if a tile exists in this level
  bool hasTile(int x, int y) {
    return tiles.any((p) => p.x == x && p.y == y);
  }
}

class ProgressData {
  final int levelId;
  final bool isUnlocked;
  final int bestMoves;
  final int stars;

  ProgressData({
    required this.levelId,
    this.isUnlocked = false,
    this.bestMoves = 0,
    this.stars = 0,
  });

  Map<String, dynamic> toJson() => {
    'levelId': levelId,
    'isUnlocked': isUnlocked,
    'bestMoves': bestMoves,
    'stars': stars,
  };

  factory ProgressData.fromJson(Map<dynamic, dynamic> json) => ProgressData(
    levelId: json['levelId'],
    isUnlocked: json['isUnlocked'] ?? false,
    bestMoves: json['bestMoves'] ?? 0,
    stars: json['stars'] ?? 0,
  );
}
