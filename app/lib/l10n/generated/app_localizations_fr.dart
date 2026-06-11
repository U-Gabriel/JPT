// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get welcomeMessage => 'Bienvenue sur GDOME';

  @override
  String get loginButton => 'Se connecter';

  @override
  String get errorMessage => 'Une erreur est survenue, veuillez réessayer.';

  @override
  String get signupButton => 'Créer mon compte GDOME';

  @override
  String get frenchCreation => 'Création connectée française';
}
