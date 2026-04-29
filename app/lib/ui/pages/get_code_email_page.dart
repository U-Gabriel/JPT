import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class GetCodeEmailPage extends StatefulWidget {
  const GetCodeEmailPage({super.key});

  @override
  State<GetCodeEmailPage> createState() => _GetCodeEmailPageState();
}

class _GetCodeEmailPageState extends State<GetCodeEmailPage> {
  final TextEditingController _codeController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  late Timer _timer;
  int _start = 60;
  bool _canResend = false;
  bool _isVerifying = false;

  @override
  void initState() {
    super.initState();
    startTimer();
    // Optionnel : ouvre le clavier automatiquement à l'arrivée sur la page
    Future.delayed(const Duration(milliseconds: 500), () {
      _focusNode.requestFocus();
    });
  }

  void startTimer() {
    setState(() { _start = 60; _canResend = false; });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_start == 0) {
        setState(() { timer.cancel(); _canResend = true; });
      } else {
        setState(() { _start--; });
      }
    });
  }

  Future<void> _handleVerification(String email) async {
    final code = _codeController.text.trim();

    // --- AJOUT DE LA VALIDATION ICI ---
    if (code.isEmpty) {
      _showSnackBar("Veuillez entrer le code reçu par mail.");
      return;
    }

    if (code.length < 6) {
      _showSnackBar("Le code doit comporter 6 chiffres.");
      return;
    }
    // ----------------------------------

    setState(() => _isVerifying = true);

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final bool isSuccess = await authProvider.verifyResetCode(email, code);

    if (!mounted) return;
    setState(() => _isVerifying = false);

    if (isSuccess) {
      // Dans GetCodeEmailPage, quand le code est bon :
      Navigator.pushNamed(
        context,
        '/reset_password',
        arguments: {
          'email': email,
          'code': _codeController.text.trim(),
        },
      );
    } else {
      _showErrorDialog();
    }
  }

// Petite fonction helper pour afficher un message rapide en bas
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.orange.shade800,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.error_outline, color: Colors.red),
            SizedBox(width: 10),
            Text("Code invalide"),
          ],
        ),
        content: const Text("Le code saisi est incorrect ou a expiré. Veuillez réessayer."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("OK", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    _codeController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String email = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
              onPressed: () => Navigator.pop(context)
          )
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              const SizedBox(height: 20),
              // Animation ou Icône
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(color: Colors.green.shade50, shape: BoxShape.circle),
                child: Icon(Icons.security_rounded, size: 60, color: Colors.green.shade700),
              ),
              const SizedBox(height: 32),
              const Text(
                "Vérification",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: Color(0xFF1B5E20), letterSpacing: -1),
              ),
              const SizedBox(height: 16),
              Text(
                "Entrez le code à 6 chiffres envoyé à",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, color: Colors.grey.shade600),
              ),
              Text(
                email,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 50),

              // Champ Code OTP Professionnel
              TextField(
                controller: _codeController,
                focusNode: _focusNode,
                keyboardType: TextInputType.number,
                maxLength: 6,
                textAlign: TextAlign.center,
                autofocus: true,
                style: const TextStyle(fontSize: 35, fontWeight: FontWeight.bold, letterSpacing: 15, color: Color(0xFF2E7D32)),
                // Validation au clavier (Touche "OK" ou "Terminer")
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _handleVerification(email),
                // Auto-validation quand 6 chiffres sont saisis
                onChanged: (value) {
                  if (value.length == 6) _handleVerification(email);
                },
                decoration: InputDecoration(
                  hintText: "000000",
                  hintStyle: TextStyle(color: Colors.grey.shade300, letterSpacing: 15),
                  counterText: "", // Cache le compteur de caractères
                  filled: true,
                  fillColor: Colors.grey.shade50,
                  contentPadding: const EdgeInsets.symmetric(vertical: 20),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.grey.shade200),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(color: Color(0xFF2E7D32), width: 2),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // Bouton Confirmer
              SizedBox(
                width: double.infinity,
                height: 58,
                child: ElevatedButton(
                  onPressed: _isVerifying ? null : () => _handleVerification(email),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E7D32),
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: _isVerifying
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("CONFIRMER", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),

              const SizedBox(height: 30),

              // Section Renvoi
              _canResend
                  ? TextButton(
                onPressed: () async {
                  final success = await Provider.of<AuthProvider>(context, listen: false).requestPasswordReset(email);
                  if (success) startTimer();
                },
                child: Text("Renvoyer le code", style: TextStyle(color: Colors.green.shade800, fontWeight: FontWeight.bold)),
              )
                  : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Renvoyer le code dans ", style: TextStyle(color: Colors.grey)),
                  Text("${_start}s", style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}