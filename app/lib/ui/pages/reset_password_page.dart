import 'package:app/l10n/generated/app_localizations.dart';
import 'package:app/l10n/generated/app_localizations_en.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submitReset() async {
    if (!_formKey.currentState!.validate()) return;

    final args = ModalRoute.of(context)?.settings.arguments;

    if (args == null || args is! Map<String, dynamic>) {
      _showErrorSnackBar(AppLocalizations.of(context)!.retrySessionExpire);
      return;
    }

    final String email = args['email'] ?? "";
    final String code = args['code'] ?? "";
    final String newPassword = _passwordController.text.trim();

    setState(() => _isLoading = true);

    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    // 1. On modifie le mot de passe sur le serveur
    final successReset = await authProvider.finalizePasswordReset(
      email: email,
      code: code,
      newPassword: newPassword,
    );

    if (!successReset) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      _showErrorSnackBar(AppLocalizations.of(context)!.expiredCode);
      return;
    }

    // 2. ÉTAPE MAGIQUE : Connexion automatique immédiate
    // On utilise les infos qu'on vient de saisir
    final successLogin = await authProvider.login(email, newPassword);

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (successLogin) {
      // On affiche quand même un petit succès avant d'entrer
      _showAutoLoginDialog();
    } else {
      // Si l'auto-login échoue (rare), on renvoie vers le login classique
      _showErrorSnackBar(AppLocalizations.of(context)!.passwordChangeNoConnected);
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    }
  }

  void _showAutoLoginDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 60),
            const SizedBox(height: 20),
            Text(AppLocalizations.of(context)!.updatePassword, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 10),
            Text(AppLocalizations.of(context)!.autoLoginLoading, textAlign: TextAlign.center),
            const SizedBox(height: 20),
            const CircularProgressIndicator(color: Colors.green),
          ],
        ),
      ),
    );

    // On attend 2 secondes pour que l'utilisateur voit le succès, puis on le redirige vers l'accueil
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
      }
    });
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Icon(Icons.check_circle, color: Colors.green, size: 60),
        content: Text(
          AppLocalizations.of(context)!.successPasswordConnectOk,
          textAlign: TextAlign.center,
        ),
        actions: [
          Center(
            child: ElevatedButton(
              onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: Text(AppLocalizations.of(context)!.loginBackMaj, style: TextStyle(color: Colors.white)),
            ),
          )
        ],
      ),
    );
  }

  void _showErrorSnackBar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: Colors.redAccent, behavior: SnackBarBehavior.floating),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, leading: const BackButton(color: Colors.black)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Text(AppLocalizations.of(context)!.newPasswordLine,
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF1B5E20), height: 1.1)),
                const SizedBox(height: 12),
                Text(AppLocalizations.of(context)!.createNewStrongPassword,
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 16)),

                const SizedBox(height: 40),

                _buildInputField(
                  label: AppLocalizations.of(context)!.newPassword,
                  controller: _passwordController,
                  obscure: _obscurePassword,
                  toggle: () => setState(() => _obscurePassword = !_obscurePassword),
                ),

                const SizedBox(height: 24),

                _buildInputField(
                  label: AppLocalizations.of(context)!.confirmationThePassword,
                  controller: _confirmPasswordController,
                  obscure: _obscureConfirm,
                  toggle: () => setState(() => _obscureConfirm = !_obscureConfirm),
                  validator: (val) {
                    if (val != _passwordController.text) return "Les mots de passe ne correspondent pas";
                    return null;
                  },
                ),

                const SizedBox(height: 48),

                SizedBox(
                  width: double.infinity,
                  height: 58,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _submitReset,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2E7D32),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 0,
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(AppLocalizations.of(context)!.resetMaj, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required bool obscure,
    required VoidCallback toggle,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: obscure,
          // --- AJOUTS ICI ---
          textInputAction: label.contains(AppLocalizations.of(context)!.confirmation)
              ? TextInputAction.done  // Affiche "Valider" sur le dernier champ
              : TextInputAction.next, // Affiche "Suivant" sur le premier champ
          onFieldSubmitted: (_) {
            if (label.contains(AppLocalizations.of(context)!.confirmation)) {
              _submitReset(); // Valide si on est sur le dernier champ
            }
          },
          // ------------------
          validator: validator ?? (val) => val != null && val.length < 6 ? AppLocalizations.of(context)!.limitChar : null,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey.shade50,
            suffixIcon: IconButton(
              icon: Icon(obscure ? Icons.visibility_off : Icons.visibility, color: Colors.grey),
              onPressed: toggle,
            ),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.grey.shade200)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Colors.green, width: 2)),
            errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Colors.redAccent)),
            focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Colors.redAccent, width: 2)),
          ),
        ),
      ],
    );
  }
}