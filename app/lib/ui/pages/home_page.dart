import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../providers/nav_provider.dart';
import '../../providers/auth_provider.dart';
import 'my_plant_page.dart';
import 'shopping_page.dart';
import 'advise_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const List<Widget> _pages = [
    AdvisePage(),         // Index 0
    MyPlantPage(),        // Index 1 (Ta page avec ses vraies plantes connectées)
    ShoppingPage(),       // Index 2
  ];

  /// Génère dynamiquement le titre de l'AppBar selon l'onglet
  String _getAppBarTitle(BuildContext context, int index) {
    final l10n = AppLocalizations.of(context)!;
    switch (index) {
      case 0:
        return l10n.homeTitleAdvise;      // ➔ "Conseils & Expertises"
      case 1:
        return l10n.homeTitleEquipment;   // ➔ "Mes Équipements"
      case 2:
        return l10n.homeTitleShop;       // ➔ "Boutique GDOME"
      default:
        return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    final navProvider = Provider.of<NavProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);

    final currentIndex = navProvider.selectedIndex;

    const Color appBgColor = Color(0xFFF4F7F5);

    return Scaffold(
      backgroundColor: appBgColor,
      // 🌟 L'APP BAR PREMIUM POUR UTILISATEUR CONNECTÉ
      appBar: AppBar(
        backgroundColor: appBgColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,

        // À gauche : Ton favicon
        leading: Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: SvgPicture.asset(
            'assets/logo/favicon_original.svg',
            alignment: Alignment.center,
          ),
        ),
        leadingWidth: 44,

        // Au centre : Le titre dynamique
        title: Text(
          _getAppBarTitle(context, currentIndex),
          style: const TextStyle(
            color: Color(0xFF1D1D1F),
            fontSize: 18,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.3,
          ),
        ),
        centerTitle: false, // Alignement iOS/Modern propre

        // À droite : Actions adaptées (Pas de redirection login ici puisqu'il est connecté)
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
                  // Il est connecté, donc on l'envoie direct sur son profil
                  Navigator.pushNamed(context, '/profile');
                },
                tooltip: AppLocalizations.of(context)!.homeTooltipMyProfile,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
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
          selectedItemColor: const Color(0xFF1E7B43), // Ton vert GDOME
          unselectedItemColor: Colors.grey.shade400,
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
          items: [
            BottomNavigationBarItem(
              icon: const Padding(
                padding: EdgeInsets.only(bottom: 4.0),
                child: Icon(Icons.chat_bubble_outline_rounded, size: 22),
              ),
              activeIcon: const Padding(
                padding: EdgeInsets.only(bottom: 4.0),
                child: Icon(Icons.chat_bubble_rounded, size: 22),
              ),
              label: AppLocalizations.of(context)!.navTabAdvise,
            ),
            BottomNavigationBarItem(
              icon: const Padding(
                padding: EdgeInsets.only(bottom: 4.0),
                child: Icon(Icons.local_florist_outlined, size: 22),
              ),
              activeIcon: const Padding(
                padding: EdgeInsets.only(bottom: 4.0),
                child: Icon(Icons.local_florist_rounded, size: 22),
              ),
              label: AppLocalizations.of(context)!.navTabMyObjects,
            ),
            BottomNavigationBarItem(
              icon: const Padding(
                padding: EdgeInsets.only(bottom: 4.0),
                child: Icon(Icons.shopping_bag_outlined, size: 22),
              ),
              activeIcon: const Padding(
                padding: EdgeInsets.only(bottom: 4.0),
                child: Icon(Icons.shopping_bag_rounded, size: 22),
              ),
              label: AppLocalizations.of(context)!.navTabShop,
            ),
          ],
        ),
      ),
    );
  }
}