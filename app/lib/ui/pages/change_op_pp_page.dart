import 'package:app/ui/pages/widget/tools/ui_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart'; // Importez shimmer
import '../../../providers/auth_provider.dart';
import '../../../services/avatar_service.dart';
import '../../../services/object_profile_service.dart';
import '../../models/avatar.dart';

class ChangeOpPpPage extends StatefulWidget {
  final int objectProfileId;
  final String currentPath;

  const ChangeOpPpPage({super.key, required this.objectProfileId, required this.currentPath});

  @override
  State<ChangeOpPpPage> createState() => _ChangeOpPpPageState();
}

class _ChangeOpPpPageState extends State<ChangeOpPpPage> {
  late String selectedPath;
  List<Avatar> avatars = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    selectedPath = widget.currentPath;
    _loadAvatars();
  }

  void _loadAvatars() async {
    final token = context.read<AuthProvider>().accessToken!;
    try {
      final list = await AvatarService().fetchAvatars(token);
      setState(() {
        // FILTRE : On ne garde que les avatars qui ont un chemin d'image non vide
        avatars = list.where((a) => a.pathPicture.isNotEmpty).toList();
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  // Widget pour l'effet de chargement Shimmer
  Widget _buildShimmerGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, crossAxisSpacing: 10, mainAxisSpacing: 10,
      ),
      itemCount: 9,
      itemBuilder: (context, index) => Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  void _updateProfile() async {
    final token = context.read<AuthProvider>().accessToken!;
    final personId = int.parse(context.read<AuthProvider>().userId!);

    bool success = await ObjectProfileService().updateObjectProfile(
      idPerson: personId,
      idObjectProfile: widget.objectProfileId,
      token: token,
      otherFields: {"path_picture": selectedPath},
    );

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Félicitations ! Photo modifiée"), backgroundColor: Colors.green),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Avatar de l'objet", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // TEXTE D'ACCOMPAGNEMENT
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
            child: Text(
              "Différenciez votre objet en lui trouvant un avatar unique !",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
                fontStyle: FontStyle.italic,
              ),
            ),
          ),

          // APERÇU EN HAUT
          Container(
            height: 200,
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(color: Colors.black12, blurRadius: 10, spreadRadius: 2)
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: ImageHelper.buildPlantImage(path: selectedPath),
            ),
          ),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Divider(thickness: 1),
          ),

          // LISTE DES CHOIX
          Expanded(
            child: isLoading
                ? _buildShimmerGrid()
                : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: avatars.length,
              itemBuilder: (context, index) {
                final avatar = avatars[index];
                bool isSelected = selectedPath == avatar.pathPicture;

                return GestureDetector(
                  onTap: () => setState(() => selectedPath = avatar.pathPicture),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: isSelected ? Colors.green : Colors.grey.withOpacity(0.2),
                        width: isSelected ? 3 : 1,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: isSelected
                          ? [BoxShadow(color: Colors.green.withOpacity(0.3), blurRadius: 4)]
                          : null,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(9),
                      child: ImageHelper.buildPlantImage(path: avatar.pathPicture),
                    ),
                  ),
                );
              },
            ),
          ),

          // BOUTON VALIDER
          Padding(
            padding: const EdgeInsets.all(20),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 55),
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                elevation: 5,
              ),
              onPressed: _updateProfile,
              child: const Text(
                "CONFIRMER LE CHOIX",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}