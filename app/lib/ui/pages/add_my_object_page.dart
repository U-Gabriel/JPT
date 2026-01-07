import 'package:app/ui/pages/widget/tools/step_progress_bar.dart';
import 'package:flutter/material.dart';

class AddMyObjectPage extends StatefulWidget {
  const AddMyObjectPage({Key? key}) : super(key: key);

  @override
  State<AddMyObjectPage> createState() => _AddMyObjectPageState();
}

class _AddMyObjectPageState extends State<AddMyObjectPage> {
  final TextEditingController _plantController = TextEditingController();

  @override
  void dispose() {
    _plantController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajouter une plante'),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: Container(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const StepProgressBar(percent: 0.0),

              const SizedBox(height: 30),

              const Text(
                'Ajout d\'une plante',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              const Text(
                "Si vous avez déjà un objet vous êtes au bon endroit ! Connectons votre objet à votre application !",
                style: TextStyle(fontSize: 15, color: Colors.black54, height: 1.4),
              ),

              const SizedBox(height: 40),

              TextField(
                controller: _plantController,
                decoration: InputDecoration(
                  labelText: 'Quelle est votre plante ?',
                  hintText: 'Ex: Monstera, Cactus...',
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: const Icon(Icons.yard_outlined),
                ),
              ),

              const SizedBox(height: 25),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/add_name_my_object',
                      arguments: _plantController.text,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[700],
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    elevation: 0,
                  ),
                  child: const Text("Valider", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),

              const SizedBox(height: 60),

              const Divider(),
              const SizedBox(height: 30),
              const Text(
                "Si vous n'avez pas encore acheté votre JackPote, allons dans notre boutique pour nous dégoter votre pot !",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.black45, fontStyle: FontStyle.italic),
              ),
              const SizedBox(height: 15),
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/buy_my_object');
                  },
                  child: Text(
                    "Aller à la boutique",
                    style: TextStyle(color: Colors.green[700], fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}