import 'package:app/ui/pages/my_plant_page_no_login.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/nav_provider.dart';
import '../../providers/auth_provider.dart';
import 'shopping_page.dart';
import 'advise_page.dart';

import 'package:app/ui/pages/my_plant_page_no_login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../providers/nav_provider.dart';
import '../../providers/auth_provider.dart';
import 'shopping_page.dart';
import 'advise_page.dart';

class HomePageNoLogin extends StatelessWidget {
  const HomePageNoLogin({super.key});

  static const List<Widget> _pages = [
    AdvisePage(),        // Index 0
    MyPlantPageNoLogin(), // Index 1
    ShoppingPage(),       // Index 2
  ];

  /// Génère dynamiquement le titre de l'AppBar selon l'index
  String _getAppBarTitle(int index) {
    switch (index) {
      case 0:
        return "Conseils & Expertises";
      case 2:
        return "Boutique GDOME";
      default:
        return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    final navProvider = Provider.of<NavProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);

    final currentIndex = navProvider.selectedIndex;
    final isMyPlantPage = currentIndex == 1;

    const Color appBgColor = Color(0xFFF4F7F5);

    return Scaffold(
      backgroundColor: appBgColor,
      // 🌟 L'APP BAR DYNAMIQUE ET PREMIUM
      appBar: isMyPlantPage
          ? null // Totalement invisible sur la page d'accueil personnalisée
          : AppBar(
        backgroundColor: appBgColor,
        elevation: 0, // Supprime l'ombre vieillissante
        scrolledUnderElevation: 0, // Reste propre même au scroll
        automaticallyImplyLeading: false,

        // À gauche : Le favicon de l'entreprise au format SVG
        leading: Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: SvgPicture.asset(
            'assets/logo/favicon_original.svg', // Ton favicon épuré
            alignment: Alignment.center,
          ),
        ),
        leadingWidth: 44, // Ajuste la zone pour l'icône de gauche

        // Au centre : Le titre adapté à l'onglet en cours
        title: Text(
          _getAppBarTitle(currentIndex),
          style: const TextStyle(
            color: Color(0xFF1D1D1F),
            fontSize: 18,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.3,
          ),
        ),
        centerTitle: false, // Alignement gauche moderne (style iOS/Apple)

        // À droite : Le bouton profil retravaillé
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  )
                ],
              ),
              child: IconButton(
                icon: const Icon(Icons.person_outline_rounded, color: Color(0xFF1D1D1F), size: 22),
                onPressed: () {
                  if (authProvider.isAuthenticated) {
                    Navigator.pushNamed(context, '/profile');
                  } else {
                    Navigator.pushNamed(context, '/login');
                  }
                },
                tooltip: 'Profil',
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        // On n'applique le SafeArea du haut que si l'AppBar n'est pas là
        top: isMyPlantPage,
        child: _pages[currentIndex],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 15,
              offset: const Offset(0, -4),
            )
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: navProvider.setIndex,
          selectedItemColor: const Color(0xFF1E7B43),
          unselectedItemColor: Colors.grey.shade400,
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          elevation: 0, // Géré par le Container parent pour un effet plus doux
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
          items: const [
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(bottom: 4.0),
                child: Icon(Icons.chat_bubble_outline_rounded, size: 22),
              ),
              activeIcon: Padding(
                padding: EdgeInsets.only(bottom: 4.0),
                child: Icon(Icons.chat_bubble_rounded, size: 22),
              ),
              label: 'Conseils',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(bottom: 4.0),
                child: Icon(Icons.local_florist_outlined, size: 22),
              ),
              activeIcon: Padding(
                padding: EdgeInsets.only(bottom: 4.0),
                child: Icon(Icons.local_florist_rounded, size: 22),
              ),
              label: 'My Plant',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(bottom: 4.0),
                child: Icon(Icons.shopping_bag_outlined, size: 22),
              ),
              activeIcon: Padding(
                padding: EdgeInsets.only(bottom: 4.0),
                child: Icon(Icons.shopping_bag_rounded, size: 22),
              ),
              label: 'Magasin',
            ),
          ],
        ),
      ),
    );
  }
}