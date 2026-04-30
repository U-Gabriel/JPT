import 'package:app/services/tag_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart'; // N'oublie pas d'ajouter flutter_svg dans pubspec.yaml
import '../../providers/auth_provider.dart';
import '../../services/notice_service.dart';
import '../../services/object_profile_service.dart';
import '../../models/object_profile.dart';

class NoticePage extends StatefulWidget {
  const NoticePage({super.key});

  @override
  State<NoticePage> createState() => _NoticePageState();
}

class _NoticePageState extends State<NoticePage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  int? selectedObjectId;
  int? selectedTagId;
  List<ObjectProfile> objects = [];
  List<dynamic> tags = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final objService = ObjectProfileService();
    final noticeService = NoticeService();

    try {
      // Récupération des données avec le Token
      final fetchedObjects = await objService.fetchObjectProfilesList(auth.userId!, auth.accessToken!);
      final fetchedTags = await TagService().fetchTags(auth.accessToken!);

      setState(() {
        objects = fetchedObjects;
        tags = fetchedTags;
        isLoading = false;
      });
    } catch (e) {
      debugPrint("💥 Erreur lors du chargement des données : $e");
      setState(() => isLoading = false);
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() || selectedObjectId == null || selectedTagId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Veuillez compléter tous les champs")),
      );
      return;
    }

    setState(() => isLoading = true);

    final auth = Provider.of<AuthProvider>(context, listen: false);
    final res = await NoticeService().createNotice(
      idPerson: int.parse(auth.userId!),
      title: _titleController.text,
      content: _contentController.text,
      idObjectProfile: selectedObjectId!,
      idTag: selectedTagId!,
      token: auth.accessToken!,
    );

    setState(() => isLoading = false);

    if (res['status'] == "OK") {
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(res['message'] ?? "Merci pour votre retour !"), backgroundColor: Colors.green),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(res['message'] ?? "Une erreur est survenue"), backgroundColor: Colors.red),
        );
      }
    }
  }

  InputDecoration _buildInputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: Colors.green),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide(color: Colors.grey.shade200)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Colors.green, width: 2)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FBF8), // Fond très légèrement vert/gris
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: const Text(
          "COMMENTAIRES",
          style: TextStyle(
              color: Color(0xFF2D3E50),
              fontWeight: FontWeight.w600,
              fontSize: 18
          ),
        ), // Petit rappel du favicon
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.green))
          : SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Logo complet
              SvgPicture.asset('assets/logo/logo_complet.svg', height: 60),
              const SizedBox(height: 20),
              const Text(
                "Votre expérience nous intéresse",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF2D3E50)),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  "Parce qu'on sait que tout n'est pas toujours parfait et qu'un bug peut arriver, votre retour est précieux. Que ce soit pour un souci technique ou une idée pour améliorer nos produits, nous sommes à votre écoute pour faire progresser l'aventure GDOME chaque jour.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.blueGrey.shade700,
                      height: 1.5,
                      fontStyle: FontStyle.italic
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Champ Titre
              TextFormField(
                controller: _titleController,
                decoration: _buildInputDecoration("Sujet de l'avis", Icons.title),
                validator: (v) => (v == null || v.isEmpty) ? "Saisissez un titre" : null,
              ),
              const SizedBox(height: 16),

              // Dropdown Objets (Corrigé pour éviter l'erreur de type)
              DropdownButtonFormField<int>(
                value: selectedObjectId,
                decoration: _buildInputDecoration("Objet concerné", Icons.sensors),
                items: objects.map<DropdownMenuItem<int>>((ObjectProfile obj) {
                  return DropdownMenuItem<int>(
                    value: obj.idObjectProfile,
                    child: Text(obj.title, style: const TextStyle(fontSize: 15)),
                  );
                }).toList(),
                onChanged: (val) => setState(() => selectedObjectId = val),
                validator: (v) => v == null ? "Sélectionnez un objet" : null,
                icon: const Icon(Icons.arrow_drop_down_circle_outlined, color: Colors.green),
              ),
              const SizedBox(height: 16),

              // Dropdown Tags (Corrigé pour éviter l'erreur de type)
              DropdownButtonFormField<int>(
                value: selectedTagId,
                decoration: _buildInputDecoration("Catégorie", Icons.label_outline),
                items: tags.map<DropdownMenuItem<int>>((dynamic tag) {
                  return DropdownMenuItem<int>(
                    value: tag['id_tag'] as int,
                    child: Text(tag['title'].toString(), style: const TextStyle(fontSize: 15)),
                  );
                }).toList(),
                onChanged: (val) => setState(() => selectedTagId = val),
                validator: (v) => v == null ? "Sélectionnez une catégorie" : null,
                icon: const Icon(Icons.arrow_drop_down_circle_outlined, color: Colors.green),
              ),
              const SizedBox(height: 16),

              // Champ Contenu (Grand texte)
              TextFormField(
                controller: _contentController,
                maxLines: 5,
                decoration: _buildInputDecoration("Votre message", Icons.chat_bubble_outline).copyWith(
                  alignLabelWithHint: true,
                ),
                validator: (v) => (v == null || v.isEmpty) ? "Le contenu ne peut pas être vide" : null,
              ),
              const SizedBox(height: 35),

              // Bouton de validation
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    elevation: 3,
                    shadowColor: Colors.green.withOpacity(0.4),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  child: const Text(
                    "ENVOYER MON RETOUR",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1.1),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}