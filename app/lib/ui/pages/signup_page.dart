import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../providers/auth_provider.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  // On ne garde que les 4 contrôleurs nécessaires
  final _emailController = TextEditingController();
  final _pseudoController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _pseudoController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submitSignup() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    // On envoie des chaînes vides pour firstname/surname/phone car l'API les attend peut-être
    // mais l'utilisateur ne les voit plus.
    final success = await authProvider.signup(
      email: _emailController.text.trim(),
      pseudo: _pseudoController.text.trim(),
      password: _passwordController.text.trim(),
      firstname: _pseudoController.text.trim(), // On utilise le pseudo par défaut
      surname: "",
      numberPhone: "",
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (success) {
      // On passe les infos à la page de validation pour pouvoir appeler l'API finale
      Navigator.pushNamed(
          context,
          '/signup_validation',
          arguments: {
            'pseudo': _pseudoController.text.trim(),
            'email': _emailController.text.trim(),
            'password': _passwordController.text.trim(),
          }
      );
    } else {
      _showErrorDialog("Échec de l'inscription. Ce pseudo ou cet email est peut-être déjà utilisé.");
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Oups !"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("OK", style: TextStyle(color: Color(0xFF2E7D32), fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background soft gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.green.shade50, Colors.white],
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    // Logo réduit si clavier ouvert pour laisser de la place
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      height: isKeyboardVisible ? 60 : 120,
                      child: SvgPicture.asset(
                        'assets/logo/logo_complet.svg',
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      "Créer un compte",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF1B5E20),
                        letterSpacing: -1,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Rejoignez l'aventure GDOME en quelques secondes.",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 15),
                    ),
                    const SizedBox(height: 32),

                    // --- CHAMPS DE SAISIE ---
                    _buildInputField(
                      controller: _pseudoController,
                      label: "Pseudo",
                      hint: "Comment doit-on vous appeler ?",
                      icon: Icons.person_outline_rounded,
                      validator: (v) => v == null || v.isEmpty ? "Choisissez un pseudo" : null,
                    ),
                    const SizedBox(height: 18),
                    _buildInputField(
                      controller: _emailController,
                      label: "Email",
                      hint: "votre@email.com",
                      icon: Icons.alternate_email_rounded,
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) => v == null || !v.contains('@') ? "Email invalide" : null,
                    ),
                    const SizedBox(height: 18),
                    _buildInputField(
                      controller: _passwordController,
                      label: "Mot de passe",
                      hint: "••••••••",
                      icon: Icons.lock_outline_rounded,
                      isPassword: true,
                      obscureText: _obscurePassword,
                      togglePassword: () => setState(() => _obscurePassword = !_obscurePassword),
                      validator: (v) => v != null && v.length < 6 ? "Minimum 6 caractères" : null,
                    ),
                    const SizedBox(height: 18),
                    _buildInputField(
                      controller: _confirmPasswordController,
                      label: "Confirmation",
                      hint: "Confirmez votre mot de passe",
                      icon: Icons.shield_outlined,
                      isPassword: true,
                      obscureText: _obscureConfirm,
                      togglePassword: () => setState(() => _obscureConfirm = !_obscureConfirm),
                      validator: (v) => v != _passwordController.text ? "Les mots de passe diffèrent" : null,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _submitSignup(),
                    ),

                    const SizedBox(height: 40),

                    // --- BOUTON INSCRIPTION ---
                    SizedBox(
                      width: double.infinity,
                      height: 58,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _submitSignup,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2E7D32),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        child: _isLoading
                            ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                            : const Text("S'INSCRIRE", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // --- FOOTER ---
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Déjà un compte ?", style: TextStyle(color: Colors.grey.shade600)),
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("Se connecter", style: TextStyle(color: Color(0xFF2E7D32), fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget réutilisable pour un design de champ cohérent et pro
  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    bool obscureText = false,
    VoidCallback? togglePassword,
    TextInputType? keyboardType,
    TextInputAction textInputAction = TextInputAction.next,
    Function(String)? onFieldSubmitted,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black87)),
        ),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          onFieldSubmitted: onFieldSubmitted,
          validator: validator,
          style: const TextStyle(fontSize: 15),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
            prefixIcon: Icon(icon, color: const Color(0xFF2E7D32), size: 20),
            suffixIcon: isPassword
                ? IconButton(
              icon: Icon(obscureText ? Icons.visibility_off : Icons.visibility, color: Colors.grey.shade400, size: 18),
              onPressed: togglePassword,
            )
                : null,
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: Colors.grey.shade200, width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xFF2E7D32), width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Colors.redAccent, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Colors.redAccent, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}