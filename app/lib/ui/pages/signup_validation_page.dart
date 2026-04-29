import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../providers/auth_provider.dart';

class SignupValidationPage extends StatefulWidget {
  const SignupValidationPage({super.key});

  @override
  State<SignupValidationPage> createState() => _SignupValidationPageState();
}

class _SignupValidationPageState extends State<SignupValidationPage> {
  final List<TextEditingController> _controllers = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  int _timerSeconds = 60;
  Timer? _timer;
  bool _isResending = false;
  bool _isValidating = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    setState(() => _timerSeconds = 60);
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timerSeconds == 0) {
        timer.cancel();
      } else {
        setState(() => _timerSeconds--);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var c in _controllers) {
      c.dispose();
    }
    for (var f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  String get _fullCode => _controllers.map((c) => c.text).join();

  Future<void> _handleResend(String email) async {
    // 1. On bloque le bouton immédiatement
    setState(() => _isResending = true);

    try {
      final auth = Provider.of<AuthProvider>(context, listen: false);
      // 2. Appel API
      final success = await auth.sendValidationMail(email);

      if (success) {
        // 3. On relance le timer SEULEMENT si le mail est parti
        _startTimer();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Un nouveau code a été envoyé !"),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Échec de l'envoi. Réessayez plus tard."),
              backgroundColor: Colors.orange,
            ),
          );
        }
      }
    } catch (e) {
      debugPrint("Erreur lors du renvoi : $e");
    } finally {
      // 4. Quoi qu'il arrive (succès ou erreur), on libère le bouton
      if (mounted) {
        setState(() => _isResending = false);
      }
    }
  }

  Future<void> _verifyCode(Map<String, dynamic> args) async {
    if (_fullCode.length < 6) return;

    setState(() => _isValidating = true);
    final auth = Provider.of<AuthProvider>(context, listen: false);

    final result = await auth.validateAccount(
      pseudo: args['pseudo'],
      mail: args['email'],
      password: args['password'],
      code: _fullCode,
    );

    setState(() => _isValidating = false);

    if (result['success']) {
      _showSuccessDialog(result['message']);
    } else {
      _showErrorSnackBar(result['message']);
    }
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Center(
        child: SingleChildScrollView(
          child: AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            title: const Column(
              children: [
                Icon(Icons.check_circle_rounded, color: Color(0xFF2E7D32), size: 80),
                SizedBox(height: 16),
                Text(
                  "Bienvenue !",
                  style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1B5E20), fontSize: 24),
                ),
              ],
            ),
            content: Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade700, fontSize: 16),
            ),
            actionsPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            actions: [
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    // Ferme la popup
                    Navigator.of(ctx).pop();

                    // Redirection vers la racine.
                    // L'AuthWrapper va détecter isAuthenticated = true
                    // et reconstruire la HomePage proprement.
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/',
                          (route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E7D32),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                  child: const Text("COMMENCER", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, iconTheme: const IconThemeData(color: Colors.black)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            children: [
              SvgPicture.asset('assets/logo/logo_complet.svg', height: 80),
              const SizedBox(height: 40),
              const Text("Vérification", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF1B5E20))),
              const SizedBox(height: 12),
              Text(
                "Saisissez le code de 6 chiffres envoyé à\n${args['email']}",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 15, height: 1.5),
              ),
              const SizedBox(height: 40),

              // --- GRILLE DES 6 CHIFFRES ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(6, (index) => _buildDigitBox(index, args)),
              ),

              const SizedBox(height: 40),

              // --- TIMER & RENVOI ---
              _timerSeconds > 0
                  ? Text("Renvoyer le code dans $_timerSeconds s", style: TextStyle(color: Colors.grey.shade500, fontWeight: FontWeight.w500))
                  : TextButton(
                onPressed: _isResending ? null : () => _handleResend(args['email']),
                child: _isResending
                    ? const CircularProgressIndicator(strokeWidth: 2)
                    : const Text("Renvoyer un code", style: TextStyle(color: Color(0xFF2E7D32), fontWeight: FontWeight.bold, fontSize: 16)),
              ),

              const SizedBox(height: 50),

              // --- BOUTON VALIDER ---
              SizedBox(
                width: double.infinity,
                height: 58,
                child: ElevatedButton(
                  onPressed: _isValidating || _fullCode.length < 6 ? null : () => _verifyCode(args),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E7D32),
                    disabledBackgroundColor: Colors.grey.shade300,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                  child: _isValidating
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("VALIDER MON COMPTE", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.1)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDigitBox(int index, Map<String, dynamic> args) {
    return SizedBox(
      width: 45,
      height: 55,
      child: TextFormField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF2E7D32)),
        decoration: InputDecoration(
          counterText: "",
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF2E7D32), width: 2)),
          filled: true,
          fillColor: Colors.green.withOpacity(0.05),
        ),
        onChanged: (value) {
          if (value.isNotEmpty && index < 5) {
            _focusNodes[index + 1].requestFocus();
          } else if (value.isEmpty && index > 0) {
            _focusNodes[index - 1].requestFocus();
          }
          if (_fullCode.length == 6) {
            _verifyCode(args); // Auto-submit quand le 6ème chiffre est tapé
          }
        },
      ),
    );
  }
}