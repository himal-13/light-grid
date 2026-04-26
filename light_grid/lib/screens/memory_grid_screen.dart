import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flame/game.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/memory_grid_provider.dart';
import '../game/memory_grid_game.dart';

class MemoryGridScreen extends StatefulWidget {
  const MemoryGridScreen({super.key});

  @override
  State<MemoryGridScreen> createState() => _MemoryGridScreenState();
}

class _MemoryGridScreenState extends State<MemoryGridScreen> {
  late MemoryGridGame _game;

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<MemoryGridProvider>(context, listen: false);
    _game = MemoryGridGame(provider);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Consumer<MemoryGridProvider>(
        builder: (context, provider, child) {
          // Check if grid size changed to refresh the game
          // In a real scenario we might need more robust sync
          
          return SafeArea(
            child: Column(
              children: [
                _buildHeader(context, provider),
                Expanded(
                  child: Center(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return GameWidget(game: _game);
                      },
                    ),
                  ),
                ),
                _buildStatus(provider),
                const SizedBox(height: 40),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context, MemoryGridProvider provider) {
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
                'MEMORY MODE',
                style: GoogleFonts.outfit(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.pinkAccent,
                ),
              ),
              Text(
                'LEVEL ${provider.currentLevel + 1}',
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildStatus(MemoryGridProvider provider) {
    String text = '';
    Color color = Colors.white;

    switch (provider.state) {
      case MemoryGameState.showing:
        text = 'MEMORIZE THE GRID';
        color = Colors.pinkAccent;
        break;
      case MemoryGameState.playing:
        text = 'TAP THE TILES';
        color = Colors.cyanAccent;
        break;
      case MemoryGameState.success:
        text = 'EXCELLENT!';
        color = Colors.greenAccent;
        break;
      case MemoryGameState.failure:
        text = 'TRY AGAIN';
        color = Colors.redAccent;
        break;
    }

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: Text(
        text,
        key: ValueKey(text),
        style: GoogleFonts.outfit(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: color,
          letterSpacing: 2,
        ),
      ),
    );
  }
}
