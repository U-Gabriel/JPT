import 'package:flutter/material.dart';

class CreateGroupPlantPage extends StatefulWidget {
  final int objectProfileId;
  const CreateGroupPlantPage({super.key, required this.objectProfileId});

  @override
  State<CreateGroupPlantPage> createState() => _CreateGroupPlantPageState();
}

class _CreateGroupPlantPageState extends State<CreateGroupPlantPage> {
  final _formKey = GlobalKey<FormState>();

  // Contrôleurs pour les champs
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _fertilityController = TextEditingController();
  final TextEditingController _tempController = TextEditingController();
  final TextEditingController _humidityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Nouvelle Configuration",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.green),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Définissez les paramètres idéaux pour votre plante.",
                  style: TextStyle(color: Colors.grey, fontSize: 14)),
              const SizedBox(height: 30),

              _buildFieldTitle("Nom de la configuration"),
              _buildTextField(_nameController, "Ex: Ma Lavande Salon", Icons.label_outline),

              const SizedBox(height: 20),
              _buildFieldTitle("Objectif Fertilité (%)"),
              _buildTextField(_fertilityController, "Ex: 45", Icons.opacity, isNumber: true),

              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildFieldTitle("Temp. idéale (°C)"),
                        _buildTextField(_tempController, "22", Icons.thermostat, isNumber: true),
                      ],
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildFieldTitle("Humidité Air (%)"),
                        _buildTextField(_humidityController, "60", Icons.air, isNumber: true),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFieldTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, IconData icon, {bool isNumber = false}) {
    return TextFormField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: Colors.green),
        filled: true,
        fillColor: Colors.grey[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.grey[200]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.grey[200]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.green, width: 2),
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: () {
          // Logique de création à venir
          print("Création pour l'objet ID: ${widget.objectProfileId}");
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
        child: const Text("Enregistrer la configuration",
            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
      ),
    );
  }
}