import 'package:app/ui/pages/widget/tools/step_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../../../models/cart_item.dart';
import '../../../models/address_person.dart';
import '../../../services/person_service.dart';
import '../../../providers/auth_provider.dart';
import '../utils/app_theme_tokens.dart';

class OrderAddressPage extends StatefulWidget {
  const OrderAddressPage({super.key});

  @override
  State<OrderAddressPage> createState() => _OrderAddressPageState();
}

class _OrderAddressPageState extends State<OrderAddressPage> {
  final PersonService _personService = PersonService();

  // States
  List<AddressPerson> _savedAddresses = [];
  List<dynamic> _suggestions = []; // Pour l'aide à la saisie
  bool _isLoading = true;
  bool _showNewAddressForm = false;
  bool _setAsDefault = false;
  AddressPerson? _selectedAddress;

  // Controllers
  final _titleCtrl = TextEditingController();
  final _addr1Ctrl = TextEditingController();
  final _addr2Ctrl = TextEditingController();
  final _zipCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();
  final _countryCtrl = TextEditingController(text: "France");

  @override
  void initState() {
    super.initState();
    _loadData();
    // On écoute les changements pour rafraîchir l'état du bouton valider
    _addr1Ctrl.addListener(_updateState);
    _zipCtrl.addListener(_updateState);
    _cityCtrl.addListener(_updateState);
    _titleCtrl.addListener(_updateState);
  }

  void _updateState() => setState(() {});

  void _loadData() async {
    final token = context.read<AuthProvider>().accessToken!;
    final addresses = await _personService.fetchAddresses(token);
    setState(() {
      _savedAddresses = addresses;
      _selectedAddress = null; // Rien de coché par défaut

      // LOGIQUE AUTOMATIQUE :
      // Si la liste est vide, on déplie le formulaire immédiatement
      if (addresses.isEmpty) {
        _showNewAddressForm = true;
      }

      _isLoading = false;
    });
  }

  // Vérifie si le formulaire est valide (Tout sauf complément)
  bool get _isFormValid {
    return _titleCtrl.text.isNotEmpty &&
        _addr1Ctrl.text.isNotEmpty &&
        _zipCtrl.text.isNotEmpty &&
        _cityCtrl.text.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final List<CartItem> selectedItems = ModalRoute.of(context)!.settings.arguments as List<CartItem>;

    return Scaffold(
      backgroundColor: AppT.ivory,
      appBar: AppBar(
        title: const Text("Livraison", style: TextStyle(color: AppT.ink, fontWeight: FontWeight.w900, fontSize: 18)),
        centerTitle: true, backgroundColor: Colors.white, elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, color: AppT.ink, size: 20), onPressed: () => Navigator.pop(context)),
      ),
      body: _isLoading
          ? _buildShimmerLoading()
          : SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const StepProgressBar(percent: 0.50),
            const SizedBox(height: 24),

            if (_savedAddresses.isNotEmpty) ...[
              const Text("VOS ADRESSES", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13, letterSpacing: 1)),
              const SizedBox(height: 12),
              SizedBox(
                height: 160,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _savedAddresses.length,
                  itemBuilder: (context, index) => _buildAddressCard(_savedAddresses[index]),
                ),
              ),
              const SizedBox(height: 24),
            ],

            _buildExpandableNewAddress(),

            const SizedBox(height: 32),
            const Text("RÉSUMÉ COMMANDE", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13, letterSpacing: 1)),
            const SizedBox(height: 16),
            ...selectedItems.map((item) => _buildSummaryTile(item)).toList(),
            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomBar(selectedItems),
    );
  }

  Widget _buildAddressCard(AddressPerson addr) {
    bool isSelected = _selectedAddress?.idAddress == addr.idAddress;
    return GestureDetector(
      onTap: () => setState(() {
        _selectedAddress = addr;
        _showNewAddressForm = false;
      }),
      child: Container(
        width: 220,
        margin: const EdgeInsets.only(right: 12, bottom: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppT.ink : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: isSelected ? Border.all(color: AppT.gold, width: 2) : null,
          boxShadow: AppT.cardShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(addr.isDefault ? Icons.star : Icons.location_on, color: isSelected ? AppT.gold : AppT.muted, size: 20),
                if (isSelected) const Icon(Icons.check_circle, color: AppT.gold, size: 20),
              ],
            ),
            const Spacer(),
            Text(addr.title.isEmpty ? "Adresse" : addr.title, style: TextStyle(fontWeight: FontWeight.bold, color: isSelected ? Colors.white : AppT.ink)),
            Text("${addr.addressLine1}, ${addr.city}", maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 11, color: isSelected ? Colors.white70 : AppT.muted)),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandableNewAddress() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // On n'affiche le bouton "déroulant" que s'il y a déjà des adresses enregistrées
        if (_savedAddresses.isNotEmpty)
          InkWell(
            onTap: () => setState(() {
              _showNewAddressForm = !_showNewAddressForm;
              if (_showNewAddressForm) _selectedAddress = null;
            }),
            child: Row(
              children: [
                Icon(_showNewAddressForm ? Icons.remove_circle_outline : Icons.add_circle_outline, color: AppT.gold),
                const SizedBox(width: 8),
                const Text("Utiliser une autre adresse", style: TextStyle(fontWeight: FontWeight.bold, color: AppT.ink)),
              ],
            ),
          )
        else
        // Si aucune adresse, on affiche juste un titre fixe
          const Text("AJOUTER UNE ADRESSE DE LIVRAISON", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13, letterSpacing: 1)),

        if (_showNewAddressForm) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: AppT.cardShadow),
            child: Column(
              children: [
                _input(_titleCtrl, "Nom de l'adresse (Maison, Bureau...)", Icons.label_outline),
                const SizedBox(height: 12),

                // --- CHAMP ADRESSE AVEC AIDE ---
                TextField(
                  controller: _addr1Ctrl,
                  style: const TextStyle(fontSize: 13),
                  onChanged: (val) async {
                    if (val.length > 3) {
                      final res = await _personService.searchAddressSuggestions(val);
                      setState(() => _suggestions = res);
                    } else {
                      setState(() => _suggestions = []);
                    }
                  },
                  decoration: InputDecoration(
                    hintText: "Saisissez votre adresse...",
                    prefixIcon: const Icon(Icons.map_outlined, size: 18, color: AppT.gold),
                    filled: true, fillColor: AppT.ivory,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  ),
                ),
                if (_suggestions.isNotEmpty) _buildSuggestionsList(),

                const SizedBox(height: 12),
                _input(_addr2Ctrl, "Complément (Appartement, Étage...)", Icons.add_home_work_outlined),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: _input(_zipCtrl, "Code Postal", Icons.numbers)),
                    const SizedBox(width: 12),
                    Expanded(child: _input(_cityCtrl, "Ville", Icons.location_city)),
                  ],
                ),
                const SizedBox(height: 12),
                _input(_countryCtrl, "Pays", Icons.public),
                const SizedBox(height: 12),
                SwitchListTile(
                  title: const Text("Définir par défaut", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                  contentPadding: EdgeInsets.zero,
                  value: _setAsDefault,
                  activeColor: AppT.gold,
                  onChanged: (v) => setState(() => _setAsDefault = v),
                )
              ],
            ),
          )
        ]
      ],
    );
  }

  Widget _buildSuggestionsList() {
    return Container(
      constraints: const BoxConstraints(maxHeight: 200),
      margin: const EdgeInsets.only(top: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppT.ivory),
      ),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: _suggestions.length,
        itemBuilder: (context, index) {
          final props = _suggestions[index]['properties'];
          return ListTile(
            dense: true,
            title: Text(props['label'], style: const TextStyle(fontSize: 12)),
            onTap: () {
              setState(() {
                _addr1Ctrl.text = props['name'] ?? "";
                _zipCtrl.text = props['postcode'] ?? "";
                _cityCtrl.text = props['city'] ?? "";
                _suggestions = [];
              });
            },
          );
        },
      ),
    );
  }

  Widget _input(TextEditingController ctrl, String hint, IconData icon) {
    return TextField(
      controller: ctrl,
      style: const TextStyle(fontSize: 13),
      decoration: InputDecoration(
        hintText: hint, prefixIcon: Icon(icon, size: 18, color: AppT.gold),
        filled: true, fillColor: AppT.ivory,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      ),
    );
  }

  Widget _buildSummaryTile(CartItem item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          const Icon(Icons.circle, size: 6, color: AppT.gold),
          const SizedBox(width: 12),
          Expanded(child: Text(item.title, style: const TextStyle(fontSize: 12))),
          Text("${item.quantity} x ${item.effectivePrice}€", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildBottomBar(List<CartItem> items) {
    double total = items.fold(0, (sum, item) => sum + (item.effectivePrice * item.quantity));

    // Logique de validation globale
    bool canProceed = false;
    String buttonText = "CHOISIR UNE ADRESSE";

    if (_showNewAddressForm) {
      canProceed = _isFormValid;
      buttonText = canProceed ? "VALIDER CETTE ADRESSE" : "REMPLIR LES CHAMPS";
    } else {
      canProceed = _selectedAddress != null;
      buttonText = canProceed ? "PAYER ${total.toStringAsFixed(2)}€" : "CHOISIR UNE ADRESSE";
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      child: SafeArea(
        child: ElevatedButton(
          onPressed: canProceed ? () async {
            AddressPerson addressToUse;

            if (_showNewAddressForm) {
              addressToUse = AddressPerson(
                title: _titleCtrl.text,
                addressLine1: _addr1Ctrl.text,
                addressLine2: _addr2Ctrl.text,
                postalCode: _zipCtrl.text,
                city: _cityCtrl.text,
                country: _countryCtrl.text,
                isDefault: _setAsDefault,
              );
              final token = context.read<AuthProvider>().accessToken!;
              await _personService.saveAddress(token, addressToUse.toJson());
            } else {
              addressToUse = _selectedAddress!;
            }

            Navigator.pushNamed(context, '/order_payment_page', arguments: {
              'address': addressToUse,
              'items': items,
            });
          } : null, // GRISE SI PAS OK
          style: ElevatedButton.styleFrom(
            backgroundColor: AppT.ink,
            disabledBackgroundColor: Colors.grey.shade300, // Couleur grisée
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 56),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          ),
          child: Text(buttonText, style: const TextStyle(fontWeight: FontWeight.w900)),
        ),
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Simule la barre de progression
            Container(
              height: 10,
              width: double.infinity,
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5)),
            ),
            const SizedBox(height: 24),

            // Titre section
            Container(width: 100, height: 13, color: Colors.white),
            const SizedBox(height: 12),

            // Liste horizontale d'adresses fantômes
            SizedBox(
              height: 160,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 3,
                itemBuilder: (_, __) => Container(
                  width: 220,
                  margin: const EdgeInsets.only(right: 12, bottom: 8),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Titre section résumé
            Container(width: 150, height: 13, color: Colors.white),
            const SizedBox(height: 16),

            // Lignes de résumé fantômes
            ...List.generate(3, (index) => Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Row(
                children: [
                  const CircleAvatar(radius: 3, backgroundColor: Colors.white),
                  const SizedBox(width: 12),
                  Container(width: 150, height: 10, color: Colors.white),
                  const Spacer(),
                  Container(width: 60, height: 10, color: Colors.white),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }

}