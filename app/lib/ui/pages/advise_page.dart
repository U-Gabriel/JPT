import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart'; // N'oublie pas l'import
import '../../providers/auth_provider.dart';
import '../../services/faq_service.dart';

class AdvisePage extends StatefulWidget {
  const AdvisePage({super.key});

  @override
  State<AdvisePage> createState() => _AdvisePageState();
}

class _AdvisePageState extends State<AdvisePage> {
  final FaqService _faqService = FaqService();
  final TextEditingController _searchController = TextEditingController();

  List<dynamic> _tags = [];
  List<dynamic> _faqs = [];
  int? _selectedTagId = 3;
  int? _expandedFaqId;
  bool _isLoadingTags = true;
  bool _isLoadingFaqs = true;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  void _loadInitialData() async {
    final tags = await _faqService.fetchTags();
    setState(() {
      _tags = tags;
      _isLoadingTags = false;
    });
    _performSearch();
  }

  void _performSearch() async {
    setState(() => _isLoadingFaqs = true);
    final faqs = await _faqService.searchFaqs(
      idTag: _selectedTagId,
      titleSearch: _searchController.text,
    );
    setState(() {
      _faqs = faqs;
      _isLoadingFaqs = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFD),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (authProvider.isLoggedIn) _buildNoticeSection(context),

              const Padding(
                padding: EdgeInsets.fromLTRB(22, 10, 22, 5),
                child: Text(
                  "FAQ Centre d'aide",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: Color(0xFF1D1D1F)),
                ),
              ),

              const Padding(
                padding: EdgeInsets.fromLTRB(22, 20, 22, 12),
                child: Text(
                  "Catégories",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blueGrey),
                ),
              ),

              // --- SHIMMER POUR LES TAGS ---
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: _isLoadingTags
                    ? _buildTagShimmer()
                    : Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: _tags.map((tag) => _buildTagCard(tag)).toList(),
                ),
              ),

              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _buildSearchBar(),
              ),
              const SizedBox(height: 30),

              // --- SHIMMER POUR LES FAQS ---
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _isLoadingFaqs
                    ? _buildFaqShimmer()
                    : _faqs.isEmpty
                    ? _buildEmptyState()
                    : Column(
                  children: _faqs.map((faq) => _buildFaqCard(faq)).toList(),
                ),
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  // --- SQUELETTE SHIMMER POUR LES TAGS ---
  Widget _buildTagShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: List.generate(5, (index) => Container(
          width: 80 + (index * 10).toDouble(),
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
        )),
      ),
    );
  }

  // --- SQUELETTE SHIMMER POUR LES FAQS ---
  Widget _buildFaqShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        children: List.generate(3, (index) => Container(
          margin: const EdgeInsets.only(bottom: 16),
          height: 70,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
          ),
        )),
      ),
    );
  }

  // ... (Garde tes widgets _buildSearchBar, _buildTagCard, _buildFaqCard, _buildNoticeSection tels quels)

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (value) => _performSearch(),
        decoration: InputDecoration(
          hintText: "Rechercher une question précise...",
          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 15),
          prefixIcon: const Icon(Icons.search_rounded, color: Colors.green, size: 26),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 18),
        ),
      ),
    );
  }

  Widget _buildTagCard(dynamic tag) {
    bool isSelected = _selectedTagId == tag['id_tag'];
    Color baseColor = _hexToColor(tag['color_code'] ?? "#2ecc71");

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTagId = isSelected ? null : tag['id_tag'];
        });
        _performSearch();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? baseColor : Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isSelected ? baseColor : Colors.grey.shade200,
            width: 2,
          ),
          boxShadow: isSelected
              ? [
            BoxShadow(
              color: baseColor.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ]
              : [],
        ),
        child: Text(
          tag['title'],
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildFaqCard(dynamic faq) {
    bool isExpanded = _expandedFaqId == faq['id_faq'];

    return GestureDetector(
      onTap: () {
        setState(() {
          _expandedFaqId = isExpanded ? null : faq['id_faq'];
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: isExpanded ? Colors.green.withOpacity(0.5) : Colors.transparent,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isExpanded ? 0.08 : 0.03),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    faq['question'],
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: isExpanded ? FontWeight.bold : FontWeight.w600,
                      color: const Color(0xFF1D1D1F),
                    ),
                  ),
                ),
                AnimatedRotation(
                  turns: isExpanded ? 0.5 : 0,
                  duration: const Duration(milliseconds: 300),
                  child: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: isExpanded ? Colors.green : Colors.grey,
                  ),
                ),
              ],
            ),
            if (isExpanded) ...[
              const SizedBox(height: 15),
              const Divider(height: 1, color: Color(0xFFF2F2F7)),
              const SizedBox(height: 15),
              Text(
                faq['answer'],
                style: TextStyle(
                  fontSize: 14,
                  height: 1.6,
                  color: Colors.blueGrey.shade700,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildNoticeSection(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 20, 20, 10),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF27AE60), Color(0xFF2ECC71)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.tips_and_updates_outlined, color: Colors.white, size: 28),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Votre avis nous fait grandir",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Une suggestion ? Aidez-nous à améliorer GDOME.",
                      style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.3),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () => Navigator.pushNamed(context, '/notice_page'),
              style: TextButton.styleFrom(
                backgroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              child: const Text(
                "Partager mon expérience",
                style: TextStyle(color: Color(0xFF27AE60), fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 30),
          Icon(Icons.search_off_rounded, size: 60, color: Colors.grey.shade300),
          const SizedBox(height: 10),
          const Text("Aucune réponse trouvée", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Color _hexToColor(String hex) {
    hex = hex.replaceAll('#', '');
    if (hex.length == 6) hex = 'FF$hex';
    return Color(int.parse(hex, radix: 16));
  }
}