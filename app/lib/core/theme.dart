import 'package:flutter/material.dart';

// 🌟 Notre couleur signature GDOME (Blanc cassé légèrement teinté de vert/gris)
const Color appBgColor = Color(0xFFEFF3F0);

final ThemeData appTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.green,
    // 🔥 On force le ColorScheme à adopter notre couleur de fond pour toutes les surfaces de base
    surface: appBgColor,
  ),
  useMaterial3: true,

  // 🔥 On configure globalement le comportement de TOUTES les AppBars de l'application
  appBarTheme: const AppBarTheme(
    backgroundColor: appBgColor,
    elevation: 0,
    scrolledUnderElevation: 0,
    surfaceTintColor: Colors.transparent, // Évite le reflet violet de Material 3 au scroll
    iconTheme: IconThemeData(color: Color(0xFF1D1D1F)),
    titleTextStyle: TextStyle(
      color: Color(0xFF1D1D1F),
      fontSize: 18,
      fontWeight: FontWeight.w800,
      letterSpacing: -0.3,
    ),
  ),

  // Optionnel : Tu peux aussi forcer la couleur de fond par défaut des Scaffolds ici
  scaffoldBackgroundColor: appBgColor,
);