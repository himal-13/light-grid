import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/game_provider.dart';
import '../screens/game_screen.dart';

void showWinDialog(BuildContext context, GameProvider provider) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      backgroundColor: Colors.blueGrey.shade900,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 20),
          Icon(Icons.stars, color: Colors.yellowAccent, size: 64),
          const SizedBox(height: 20),
          Text(
            'LEVEL COMPLETE!',
            style: GoogleFonts.outfit(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'MOVES: ${provider.moves}',
            style: GoogleFonts.outfit(color: Colors.white70),
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildDialogButton(
                context,
                'MENU',
                Colors.white12,
                () {
                  Navigator.pop(context); // Dialog
                  Navigator.pop(context); // Game
                },
              ),
              const SizedBox(width: 15),
              _buildDialogButton(
                context,
                'NEXT',
                Colors.cyanAccent,
                () {
                  Navigator.pop(context); // Dialog
                  if (provider.currentLevelIndex + 1 < 30) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GameScreen(levelIndex: provider.currentLevelIndex + 1),
                      ),
                    );
                  }
                },
                textColor: Colors.black,
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

Widget _buildDialogButton(BuildContext context, String label, Color color, VoidCallback onPressed, {Color textColor = Colors.white}) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
    ),
    onPressed: onPressed,
    child: Text(
      label,
      style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: textColor),
    ),
  );
}
