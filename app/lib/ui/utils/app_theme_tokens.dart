import 'package:flutter/material.dart';

class AppT {
  static const ink = Color(0xFF1C1C1E);
  static const ivory = Color(0xFFFAF9F6);
  static const gold = Color(0xFFC9A96E);
  static const muted = Color(0xFF8A8A8E);
  static const subtle = Color(0xFFE5E3DC);

  static List<BoxShadow> cardShadow = [
    BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 20, offset: const Offset(0, 8)),
  ];

  static TextStyle title = const TextStyle(
    fontSize: 26, fontWeight: FontWeight.w800, color: ink, letterSpacing: -0.8,
  );
}