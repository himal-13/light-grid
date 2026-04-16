import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/hive_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _soundEnabled = true;
  bool _musicEnabled = true;

  @override
  void initState() {
    super.initState();
    _soundEnabled = HiveService.getSoundEnabled();
    _musicEnabled = HiveService.getMusicEnabled();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          'SETTINGS',
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold, letterSpacing: 2),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        child: Column(
          children: [
            _buildSettingTile(
              'Sound Effects',
              'Toggle gameplay sounds',
              _soundEnabled,
              (val) {
                setState(() => _soundEnabled = val);
                HiveService.setSoundEnabled(val);
              },
            ),
            const Divider(color: Colors.white10, height: 40),
            _buildSettingTile(
              'Background Music',
              'Toggle ambient atmosphere',
              _musicEnabled,
              (val) {
                setState(() => _musicEnabled = val);
                HiveService.setMusicEnabled(val);
              },
            ),
            const Spacer(),
            Text(
              'LIGHT GRID v1.0.0',
              style: GoogleFonts.outfit(color: Colors.white24, fontSize: 12),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingTile(String title, String subtitle, bool value, Function(bool) onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.outfit(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            Text(
              subtitle,
              style: GoogleFonts.outfit(
                fontSize: 14,
                color: Colors.white54,
              ),
            ),
          ],
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: Colors.cyanAccent,
          activeTrackColor: Colors.cyanAccent.withOpacity(0.3),
          inactiveThumbColor: Colors.blueGrey,
          inactiveTrackColor: Colors.white12,
        ),
      ],
    );
  }
}
