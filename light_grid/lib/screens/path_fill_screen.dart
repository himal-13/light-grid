import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flame/game.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/path_fill_provider.dart';
import '../game/path_fill_game.dart';

class PathFillScreen extends StatefulWidget {
  final int levelIndex;

  const PathFillScreen({
    super.key, 
    required this.levelIndex,
  });

  @override
  State<PathFillScreen> createState() => _PathFillScreenState();
}

class _PathFillScreenState extends State<PathFillScreen> {
  late PathFillGame _game;
  bool _dialogShown = false;

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<PathFillProvider>(context, listen: false);
    provider.loadLevel(widget.levelIndex);
    _game = PathFillGame(provider);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Consumer<PathFillProvider>(
        builder: (context, provider, child) {
          if (provider.isLevelComplete && !_dialogShown) {
            _dialogShown = true;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _showWinDialog(context, provider);
            });
          }

          return SafeArea(
            child: Column(
              children: [
                _buildHeader(context, provider),
                const SizedBox(height: 20),
                Text(
                  'FILL ALL TILES IN ONE SLIDE',
                  style: GoogleFonts.outfit(
                    color: Colors.white54,
                    fontSize: 12,
                    letterSpacing: 2,
                  ),
                ),
                Expanded(
                  child: GameWidget(game: _game),
                ),
                _buildFooter(context, provider),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context, PathFillProvider provider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          Column(
            children: [
              Text(
                'PATH FILL',
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  color: Colors.white70,
                  letterSpacing: 2,
                ),
              ),
              Text(
                'LEVEL ${provider.currentLevelIndex + 1}',
                style: GoogleFonts.outfit(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.cyanAccent,
                ),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              provider.loadLevel(provider.currentLevelIndex);
              _game.refresh();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context, PathFillProvider provider) {
    int total = provider.currentLevel.tiles.length;
    int current = provider.currentPath.length;
    double progress = total > 0 ? current / total : 0;

    return Padding(
      padding: const EdgeInsets.only(bottom: 40, left: 40, right: 40),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'PROGRESS',
                style: GoogleFonts.outfit(color: Colors.white38, fontSize: 10),
              ),
              Text(
                '$current / $total',
                style: GoogleFonts.outfit(color: Colors.cyanAccent, fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.white10,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.cyanAccent),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }

  void _showWinDialog(BuildContext context, PathFillProvider provider) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey.shade900,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'LEVEL COMPLETE!',
          textAlign: TextAlign.center,
          style: GoogleFonts.outfit(color: Colors.cyanAccent, fontWeight: FontWeight.bold),
        ),
        content: Text(
          'You filled the path perfectly.',
          textAlign: TextAlign.center,
          style: GoogleFonts.outfit(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text('EXIT', style: GoogleFonts.outfit(color: Colors.white54)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.cyanAccent,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _dialogShown = false;
                provider.nextLevel();
                _game.refresh();
              });
            },
            child: Text('NEXT LEVEL', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
