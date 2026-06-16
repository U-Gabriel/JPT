import 'package:app/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../../providers/auth_provider.dart';
import '../../services/user_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final UserService _userService = UserService();
  Future<Map<String, dynamic>?>? _profileFuture;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.isLoggedIn && authProvider.accessToken != null) {
      _profileFuture = _userService.fetchMyProfile();
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    // Sécurité Redirection si déconnecté
    if (!authProvider.isLoggedIn) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, '/');
      });
      return const SizedBox.shrink();
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // Fond ultra clair moderne
      body: FutureBuilder<Map<String, dynamic>?>(
        future: _profileFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildLoadingSkeleton();
          }

          // Si l'API échoue, on prend les valeurs de secours du SharedPreferences
          final userData = snapshot.data ?? authProvider.userData ?? {};
          final String pseudo = userData['pseudo'] ?? authProvider.pseudo ?? AppLocalizations.of(context)!.user;
          final String email = userData['mail'] ?? AppLocalizations.of(context)!.noAddressEmail;
          final String name = "${userData['firstname'] ?? ''} ${userData['surname'] ?? ''}".trim();

          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // --- HEADER PREMIUM AVEC DÉGRADÉ ---
              SliverAppBar(
                expandedHeight: 210,
                pinned: true,
                elevation: 0,
                backgroundColor: const Color(0xFF4CAF50),
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF2E7D32), Color(0xFF4CAF50)],
                      ),
                    ),
                    child: SafeArea(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 20),
                          CircleAvatar(
                            radius: 42,
                            backgroundColor: Colors.white.withOpacity(0.2),
                            child: CircleAvatar(
                              radius: 38,
                              backgroundColor: Colors.white,
                              child: Text(
                                pseudo.substring(0, 1).toUpperCase(),
                                style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF2E7D32)),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            pseudo,
                            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // --- CONTENU ---
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // --- CARD INFOS PERSONNELLES ---
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 15, offset: const Offset(0, 8)),
                          ],
                        ),
                        child: Column(
                          children: [
                            _buildInfoRow(Icons.person_outline, AppLocalizations.of(context)!.identity, name.isEmpty ? AppLocalizations.of(context)!.noSpecified : name),
                            const Divider(height: 24, thickness: 0.8),
                            _buildInfoRow(Icons.mail_outline, AppLocalizations.of(context)!.email, email),
                          ],
                        ),
                      ),

                      const SizedBox(height: 28),

                      Text(
                        AppLocalizations.of(context)!.manageMyApp,
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                      ),

                      const SizedBox(height: 16),

                      // --- GRILLE DES CARD-BOUTONS (BENTO GRID STYLE) ---
                      GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 1.2,
                        children: [
                          _buildMenuCard(
                            context,
                            icon: Icons.lock_reset_outlined,
                            title: AppLocalizations.of(context)!.security,
                            subtitle: AppLocalizations.of(context)!.changePassword,
                            color: Colors.orange,
                            route: '/forgot_password',
                          ),
                          _buildMenuCard(
                            context,
                            icon: Icons.devices_other,
                            title: AppLocalizations.of(context)!.myItems,
                            subtitle: AppLocalizations.of(context)!.manageMyDevices,
                            color: Colors.blue,
                            route: '/my_objects_catalog',
                          ),
                          _buildMenuCard(
                            context,
                            icon: Icons.star_border_rounded,
                            title: AppLocalizations.of(context)!.myFavorites,
                            subtitle: AppLocalizations.of(context)!.favoritesItems,
                            color: Colors.pink,
                            route: '/my_favorites_catalog',
                          ),
                          _buildMenuCard(
                            context,
                            icon: Icons.help_outline_rounded,
                            title: AppLocalizations.of(context)!.faq,
                            subtitle: AppLocalizations.of(context)!.helpCenter,
                            color: Colors.teal,
                            route: '/profile_faq',
                          ),
                        ],
                      ),


                      const SizedBox(height: 16), // Même espacement que la grille

                      _buildFullWidthMenuCard(
                        context,
                        icon: Icons.rate_review_outlined,
                        title: AppLocalizations.of(context)!.leaveReview,
                        subtitle: AppLocalizations.of(context)!.shareExperience,
                        color: Colors.purple,
                        route: '/notice_page',
                      ),

                      const SizedBox(height: 35),

                      // --- BOUTON DÉCONNEXION MODERNE ---
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: TextButton.icon(
                          onPressed: () async {
                            await authProvider.logout();
                            if (context.mounted) Navigator.pushReplacementNamed(context, '/');
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.red.shade50,
                            foregroundColor: Colors.red.shade700,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                          ),
                          icon: const Icon(Icons.logout_rounded, size: 22),
                          label: Text(AppLocalizations.of(context)!.logOut, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // --- WIDGET LIGNE D'INFO PERSO ---
  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: const Color(0xFFF1F3F5), borderRadius: BorderRadius.circular(12)),
          child: Icon(icon, color: Colors.grey.shade700, size: 22),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 12, color: Colors.black54, fontWeight: FontWeight.w500)),
              const SizedBox(height: 2),
              Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.black87)),
            ],
          ),
        ),
      ],
    );
  }

  // --- WIDGET CARD BOUTON UNIQUE ---
  Widget _buildMenuCard(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String subtitle,
        required Color color,
        required String route,
      }) {
    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: () => Navigator.pushNamed(context, route),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(14)),
              child: Icon(icon, color: color, size: 26),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 11, color: Colors.black45),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // --- SQUELETTE DE CHARGEMENT SHIMMER ---
  Widget _buildLoadingSkeleton() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(height: 210, color: Colors.white),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Container(height: 120, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24))),
                  const SizedBox(height: 40),
                  Row(
                    children: [
                      Expanded(child: Container(height: 110, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)))),
                      const SizedBox(width: 16),
                      Expanded(child: Container(height: 110, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)))),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildFullWidthMenuCard(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String subtitle,
        required Color color,
        required String route,
      }) {
    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: () => Navigator.pushNamed(context, route),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 12, color: Colors.black45),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: Colors.grey.shade400, size: 24),
          ],
        ),
      ),
    );
  }
}