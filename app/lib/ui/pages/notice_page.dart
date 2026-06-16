import 'package:app/l10n/generated/app_localizations.dart';
import 'package:app/services/tag_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer/shimmer.dart'; // Import pour le chargement élégant
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

    try {
      final fetchedObjects = await objService.fetchObjectProfilesList();
      final fetchedTags = await TagService().fetchTags();

      setState(() {
        objects = fetchedObjects;
        tags = fetchedTags;
        isLoading = false;
      });
    } catch (e) {
      debugPrint("!!! Erreur lors du chargement des données : $e");
      setState(() => isLoading = false);
    }
  }

  Future<void> _submit() async {
    // Le selectedObjectId n'est plus requis dans la validation
    if (!_formKey.currentState!.validate() || selectedTagId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.completeAllField)),
      );
      return;
    }

    setState(() => isLoading = true);

    final auth = Provider.of<AuthProvider>(context, listen: false);
    final res = await NoticeService().createNotice(
      idPerson: int.parse(auth.userId!),
      title: _titleController.text,
      content: _contentController.text,
      idObjectProfile: selectedObjectId,
      idTag: selectedTagId!,
    );

    setState(() => isLoading = false);

    if (res['status'] == "OK") {
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(res['message'] ?? AppLocalizations.of(context)!.thanksForFeedback), backgroundColor: Colors.green),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(res['message'] ?? AppLocalizations.of(context)!.occurredError), backgroundColor: Colors.red),
        );
      }
    }
  }

  // --- SHIMMER LOADING UI ---
  Widget _buildShimmerLoader() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        child: Column(
          children: [
            Container(height: 60, width: 60, color: Colors.white),
            const SizedBox(height: 20),
            Container(height: 30, width: 250, color: Colors.white),
            const SizedBox(height: 30),
            ...List.generate(5, (index) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Container(height: 55, width: double.infinity, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15))),
            )),
          ],
        ),
      ),
    );
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
      backgroundColor: const Color(0xFFF8FBF8),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: Text(
          AppLocalizations.of(context)!.commentsMaj,
          style: TextStyle(color: Color(0xFF2D3E50), fontWeight: FontWeight.w600, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? _buildShimmerLoader()
          : SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset('assets/logo/logo_complet.svg', height: 60),
              const SizedBox(height: 20),
              Text(
                AppLocalizations.of(context)!.experienceBack,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF2D3E50)),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  AppLocalizations.of(context)!.experienceBackDesc,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15, color: Colors.blueGrey.shade700, height: 1.5, fontStyle: FontStyle.italic),
                ),
              ),
              const SizedBox(height: 30),

              TextFormField(
                controller: _titleController,
                decoration: _buildInputDecoration(AppLocalizations.of(context)!.noticeSubject, Icons.title),
                validator: (v) => (v == null || v.isEmpty) ? AppLocalizations.of(context)!.enterTitle : null,
              ),
              const SizedBox(height: 16),

              // OBJET
              DropdownButtonFormField<int>(
                value: selectedObjectId,
                decoration: _buildInputDecoration(AppLocalizations.of(context)!.itemConcerned, Icons.sensors),
                items: objects.map<DropdownMenuItem<int>>((ObjectProfile obj) {
                  return DropdownMenuItem<int>(
                    value: obj.idObjectProfile,
                    child: Text(obj.title, style: const TextStyle(fontSize: 15)),
                  );
                }).toList(),
                onChanged: (val) => setState(() => selectedObjectId = val),
                icon: const Icon(Icons.arrow_drop_down_circle_outlined, color: Colors.green),
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<int>(
                value: selectedTagId,
                decoration: _buildInputDecoration(AppLocalizations.of(context)!.categoryD, Icons.label_outline),
                items: tags.map<DropdownMenuItem<int>>((dynamic tag) {
                  return DropdownMenuItem<int>(
                    value: tag['id_tag'] as int,
                    child: Text(tag['title'].toString(), style: const TextStyle(fontSize: 15)),
                  );
                }).toList(),
                onChanged: (val) => setState(() => selectedTagId = val),
                validator: (v) => v == null ? AppLocalizations.of(context)!.selectCategory : null,
                icon: const Icon(Icons.arrow_drop_down_circle_outlined, color: Colors.green),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _contentController,
                maxLines: 5,
                decoration: _buildInputDecoration(AppLocalizations.of(context)!.yourMessage, Icons.chat_bubble_outline).copyWith(
                  alignLabelWithHint: true,
                ),
                validator: (v) => (v == null || v.isEmpty) ? AppLocalizations.of(context)!.noEmptyContent : null,
              ),
              const SizedBox(height: 35),

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
                  child: Text(
                    AppLocalizations.of(context)!.sendBackMaj,
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