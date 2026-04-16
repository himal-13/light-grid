import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flame/game.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/game_provider.dart';
import '../game/light_grid_game.dart';
import '../widgets/dialog_widgets.dart';

class GameScreen extends StatefulWidget {
  final int levelIndex;
  const GameScreen({super.key, required this.levelIndex});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late LightGridGame _game;

  @override
  void initState() {
    super.initState();
    // Use addPostFrameCallback to initialize level in provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<GameProvider>(context, listen: false);
      provider.loadLevel(widget.levelIndex);
      _game = LightGridGame(provider);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Consumer<GameProvider>(
        builder: (context, provider, child) {
          // Check for win condition and show dialog
          if (provider.isLevelComplete) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              showWinDialog(context, provider);
            });
          }

          return SafeArea(
            child: Column(
              children: [
                _buildHeader(context, provider),
                Expanded(
                  child: provider.tileStates.isEmpty 
                    ? const Center(child: CircularProgressIndicator()) 
                    : GameWidget(game: _game),
                ),
                _buildFooter(context, provider),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context, GameProvider provider) {
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
                'LEVEL ${provider.currentLevelIndex + 1}',
                style: GoogleFonts.outfit(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.cyanAccent,
                ),
              ),
              Text(
                'MOVES: ${provider.moves}',
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              provider.resetLevel();
              _game.refresh();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context, GameProvider provider) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildActionButton(
            label: 'HINT',
            icon: Icons.lightbulb_outline,
            onPressed: () {
              final hint = provider.getHint();
              if (hint != null) {
                // We could highlight the tile in Flame, but for now just show a snackbar
                // In a real app we'd trigger an animation in the game
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Hint: Tap at ${hint.x}, ${hint.y}'),
                    duration: const Duration(seconds: 1),
                    backgroundColor: Colors.blueGrey.shade900,
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({required String label, required IconData icon, required VoidCallback onPressed}) {
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white24),
            ),
            child: Icon(icon, color: Colors.white70, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: GoogleFonts.outfit(fontSize: 12, color: Colors.white70),
          ),
        ],
      ),
    );
  }
}
