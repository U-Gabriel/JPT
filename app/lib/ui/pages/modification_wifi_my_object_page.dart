import 'package:flutter/material.dart';

class ModificationWifiMyObjectPage extends StatefulWidget {
  final int objectProfileId;
  final String title;

  const ModificationWifiMyObjectPage({
    super.key,
    required this.objectProfileId,
    required this.title,
  });

  @override
  State<ModificationWifiMyObjectPage> createState() => _ModificationWifiMyObjectPageState();
}

class _ModificationWifiMyObjectPageState extends State<ModificationWifiMyObjectPage> {
  final TextEditingController _ssidController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isUpdating = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Configuration WiFi", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.green),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- HEADER ---
            Center(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.network_wifi, size: 60, color: Colors.green),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              "Mise à jour pour ${widget.title}",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              "Assurez-vous que votre objet est à portée lors de la modification.",
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
            const SizedBox(height: 40),

            // --- CHAMPS DE SAISIE ---
            _buildTextField(
              controller: _ssidController,
              label: "Nom du réseau (SSID)",
              hint: "Ex: MaBox_WiFi",
              icon: Icons.wifi,
            ),
            const SizedBox(height: 20),
            _buildTextField(
              controller: _passwordController,
              label: "Mot de passe",
              hint: "••••••••",
              icon: Icons.lock_outline,
              isPassword: true,
            ),

            const SizedBox(height: 60),

            // --- BOUTON VALIDER ---
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _isUpdating ? null : _handleUpdate,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 2,
                ),
                child: _isUpdating
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                  "Modifier mon WiFi",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool isPassword = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: isPassword && !_isPasswordVisible,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: Colors.green),
            suffixIcon: isPassword
                ? IconButton(
              icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off),
              onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
            )
                : null,
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: Colors.green, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }

  void _handleUpdate() {
    if (_ssidController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Veuillez remplir tous les champs")),
      );
      return;
    }

    // On passe à la page suivante avec les données
    Navigator.pushNamed(
      context,
      '/modification_wifi_connect',
      arguments: {
        'objectProfileId': widget.objectProfileId,
        'title': widget.title,
        'ssid': _ssidController.text,
        'password': _passwordController.text,
        'isModification': true
      },
    );
  }
}