import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MyPlantPageNoLogin extends StatelessWidget {
  const MyPlantPageNoLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFD), // Fond style Apple / Premium
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(height: 20),

            // 1. SECTION LOGO & BIENVENUE
            _buildHeaderSection(),

            const SizedBox(height: 30),

            // 2. LES BOUTONS D'ACTION PRINCIPAUX (Connexion / Inscription)
            _buildAuthActions(context),

            const SizedBox(height: 40),

            // 3. LA STORYLINE DE L'ENTREPRISE (Bento Grid de présentation)
            _buildCompanyStory(context),

            const SizedBox(height: 40),

            // 4. SECTION D'AIDE & DÉCOUVERTE (Lien vers la FAQ)
            _buildHelpSection(context),

            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }

  /// Section d'en-tête avec logo et message de bienvenue chaleureux
  Widget _buildHeaderSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          // Utilisation du logo complet avec couleurs
          Hero(
            tag: 'app_logo',
            child: SvgPicture.asset(
              'assets/logo/logo_complet.svg',
              height: 75,
              semanticsLabel: 'GDOME Logo',
            ),
          ),
          const SizedBox(height: 25),
          // Badge "Savoir-faire Français"
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.05),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.blue.withOpacity(0.15), width: 1),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("🇫🇷", style: TextStyle(fontSize: 14)),
                const SizedBox(width: 6),
                Text(
                  "Création connectée française",
                  style: TextStyle(
                    color: Colors.blue.shade900,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          const Text(
            "Bienvenue chez GDOME",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: Color(0xFF1D1D1F),
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              "L'écosystème domotique qui réinvente votre relation avec la nature et votre intérieur.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey.shade600,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Bloc des actions d'authentification élégant
  Widget _buildAuthActions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          // Bouton Rejoindre / Inscription (Principal)
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: const LinearGradient(
                colors: [Color(0xFF1E7B43), Color(0xFF2ECC71)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF2ECC71).withOpacity(0.25),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/signup'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: const Text(
                "Créer mon compte GDOME",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ),
          const SizedBox(height: 14),
          // Bouton Connexion (Secondaire)
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => Navigator.pushNamed(context, '/login'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: BorderSide(color: Colors.grey.shade300, width: 1.5),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                backgroundColor: Colors.white,
              ),
              child: const Text(
                "Je me connecte",
                style: TextStyle(color: Color(0xFF1D1D1F), fontWeight: FontWeight.w600, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Présentation de la vision de l'entreprise sous forme de Bento Grid moderne
  Widget _buildCompanyStory(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Notre Vision",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF1D1D1F)),
          ),
          const SizedBox(height: 16),

          // Grille asymétrique
          Row(
            children: [
              // Carte 1 : Les pots connectés (Actuel)
              Expanded(
                flex: 11,
                child: _buildBentoCard(
                  title: "Pots Intelligents",
                  description: "Vos plantes dictent leurs besoins en temps réel grâce à nos capteurs haute précision.",
                  icon: Icons.local_florist_rounded,
                  color: const Color(0xFFE8F5E9),
                  iconColor: Colors.green.shade700,
                ),
              ),
              const SizedBox(width: 14),
              // Carte 2 : L'avenir (Gamelles...)
              Expanded(
                flex: 9,
                child: _buildBentoCard(
                  title: "Demain...",
                  description: "Un écosystème en expansion : gamelles connectées, soin des animaux et confort global.",
                  icon: Icons.pets_rounded,
                  color: const Color(0xFFFFF3E0),
                  iconColor: Colors.orange.shade700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          // Carte 3 : Large pour le manifeste de la jeune pousse française
          _buildBentoCard(
            title: "Une jeune pousse passionnée",
            description: "GDOME est une toute nouvelle entreprise française. Notre mission est d'allier le respect du vivant à l'intelligence de la maison connectée, sans compromis sur le design.",
            icon: Icons.auto_awesome_rounded,
            color: Colors.white,
            iconColor: Colors.teal,
            isLarge: true,
          ),
        ],
      ),
    );
  }

  /// Constructeur de cartes Bento générique pour un code propre
  Widget _buildBentoCard({
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required Color iconColor,
    bool isLarge = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.black.withOpacity(0.03), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6, offset: const Offset(0, 2))
              ],
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF1D1D1F)),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade700,
                height: 1.4,
                fontWeight: FontWeight.w400
            ),
          ),
        ],
      ),
    );
  }

  /// Section d'aide redirigeant vers la FAQ personnalisée du profil
  Widget _buildHelpSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, '/profile_faq'),
        borderRadius: BorderRadius.circular(24),
        child: Ink(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF111112), // Carte sombre style technologique
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Des questions sur nos objets ?",
                      style: TextStyle(color: Colors.grey.shade300, fontSize: 13, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "Explorez notre Centre d'aide",
                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}