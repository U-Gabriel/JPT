import 'dart:io';
import 'package:app/ui/pages/widget/tools/ui_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shimmer/shimmer.dart';
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
  bool isUploading = false;
  final ImagePicker _picker = ImagePicker();

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
      if (mounted) {
        setState(() {
          avatars = list.where((a) => a.pathPicture.isNotEmpty).toList();
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => isLoading = false);
    }
  }

  /// Dialogue de confirmation pour l'upload photo
  Future<void> _confirmAndUpload(XFile pickedFile) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Confirmer la photo"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Voulez-vous utiliser cette photo pour votre objet ?"),
            const SizedBox(height: 15),
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.file(File(pickedFile.path), height: 150, fit: BoxFit.cover),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Rejeter", style: TextStyle(color: Colors.red)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Confirmer", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      _executeUpload(pickedFile);
    }
  }

  Future<void> _executeUpload(XFile pickedFile) async {
    setState(() => isUploading = true);
    final token = context.read<AuthProvider>().accessToken!;

    bool success = await AvatarService().uploadCustomAvatar(
      idObjectProfile: widget.objectProfileId,
      imageFile: File(pickedFile.path),
      token: token,
    );

    if (mounted) {
      setState(() => isUploading = false);
      if (success) {
        // 1. ON VIDE LE CACHE DE L'IMAGE
        await NetworkImage(selectedPath).evict();

        _showSnackBar("Image mise à jour ! Patientez avant la mise à jour.", Colors.green);

        // 2. ON POP AVEC UN RESULTAT
        Navigator.pop(context, true);
      } else {
        _showSnackBar("Erreur lors de l'envoi.", Colors.red);
      }
    }
  }

  void _showSnackBar(String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: color, behavior: SnackBarBehavior.floating),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text("Personnaliser mon objet",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              // TEXTE D'INTRODUCTION
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                child: Text(
                  "Personnalisez votre objet pour le différencier des autres et lui donner un look unique.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[600], fontSize: 14, height: 1.4),
                ),
              ),

              // APERÇU
              _buildHeaderPreview(),

              // BOUTON APPAREIL PHOTO (Unique et centré)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                child: _actionButton(
                  label: "Prendre une photo live",
                  icon: Icons.camera_enhance_rounded,
                  color: Colors.green,
                  onTap: () async {
                    final XFile? photo = await _picker.pickImage(source: ImageSource.camera, imageQuality: 70);
                    if (photo != null) _confirmAndUpload(photo);
                  },
                ),
              ),

              const SizedBox(height: 10),
              _buildDividerSeparator(),

              // GRILLE D'AVATARS
              Expanded(
                child: isLoading ? _buildShimmerGrid() : _buildAvatarGrid(),
              ),

              // BOUTON DE CONFIRMATION AVATAR
              _buildConfirmButton(),
            ],
          ),

          if (isUploading)
            Container(
              color: Colors.black54,
              child: const Center(child: CircularProgressIndicator(color: Colors.white)),
            ),
        ],
      ),
    );
  }

  Widget _buildHeaderPreview() {
    return Container(
      height: 160,
      width: double.infinity,
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 20, offset: const Offset(0, 10))
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: ImageHelper.buildPlantImage(path: selectedPath),
      ),
    );
  }

  Widget _buildDividerSeparator() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 5),
      child: Row(
        children: [
          Expanded(child: Divider()),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Text("OU AVATARS", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey)),
          ),
          Expanded(child: Divider()),
        ],
      ),
    );
  }

  Widget _actionButton({required String label, required IconData icon, required Color color, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: color.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 5))],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 12),
            Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(25),
      physics: const BouncingScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, crossAxisSpacing: 15, mainAxisSpacing: 15,
      ),
      itemCount: avatars.length,
      itemBuilder: (context, index) {
        final avatar = avatars[index];
        bool isSelected = selectedPath == avatar.pathPicture;
        return GestureDetector(
          onTap: () => setState(() => selectedPath = avatar.pathPicture),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: isSelected ? Colors.green : Colors.transparent, width: 3),
              boxShadow: isSelected ? [BoxShadow(color: Colors.green.withOpacity(0.2), blurRadius: 8)] : null,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(17),
              child: ImageHelper.buildPlantImage(path: avatar.pathPicture),
            ),
          ),
        );
      },
    );
  }

  Widget _buildConfirmButton() {
    // On n'affiche le bouton que si le chemin sélectionné est différent du chemin initial
    // pour éviter les requêtes inutiles
    return Padding(
      padding: const EdgeInsets.fromLTRB(25, 10, 25, 30),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 55),
          backgroundColor: Colors.black87,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 0,
        ),
          // DANS ChangeOpPpPage.dart (Bouton de confirmation final)
          onPressed: () async {
              final token = context.read<AuthProvider>().accessToken!;
              final personId = int.parse(context.read<AuthProvider>().userId!);

              bool success = await ObjectProfileService().updateObjectProfile(
              idPerson: personId,
              idObjectProfile: widget.objectProfileId,
              token: token,
              otherFields: {"path_picture": selectedPath},
              );

              if (success && mounted) {
              // 1. On vide le cache de l'image sélectionnée
              await NetworkImage(selectedPath).evict();

              _showSnackBar("Modifications enregistrées", Colors.green);

              // 2. CRITIQUE : On retourne simplement "true" à la page précédente
              // Ne pas utiliser pushNamedAndRemoveUntil ici !
              Navigator.pop(context, true);
              }
            },

        child: const Text("ENREGISTRER L'AVATAR",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
      ),
    );
  }

  Widget _buildShimmerGrid() {
    return GridView.count(
      crossAxisCount: 3, padding: const EdgeInsets.all(25), crossAxisSpacing: 15, mainAxisSpacing: 15,
      children: List.generate(6, (index) => Shimmer.fromColors(
        baseColor: Colors.grey[200]!, highlightColor: Colors.grey[50]!,
        child: Container(decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20))),
      )),
    );
  }
}