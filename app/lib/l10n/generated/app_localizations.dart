import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr')
  ];

  /// No description provided for @welcomeMessage.
  ///
  /// In fr, this message translates to:
  /// **'Bienvenue sur GDOME'**
  String get welcomeMessage;

  /// No description provided for @loginButton.
  ///
  /// In fr, this message translates to:
  /// **'Se connecter'**
  String get loginButton;

  /// No description provided for @errorMessage.
  ///
  /// In fr, this message translates to:
  /// **'Une erreur est survenue, veuillez réessayer.'**
  String get errorMessage;

  /// No description provided for @myPlantPageNoLogin.
  ///
  /// In fr, this message translates to:
  /// **'======================='**
  String get myPlantPageNoLogin;

  /// No description provided for @signupButton.
  ///
  /// In fr, this message translates to:
  /// **'Créer mon compte GDOME'**
  String get signupButton;

  /// No description provided for @frenchCreation.
  ///
  /// In fr, this message translates to:
  /// **'Création connectée française'**
  String get frenchCreation;

  /// No description provided for @welcomeGdome.
  ///
  /// In fr, this message translates to:
  /// **'Bienvenue chez GDOME'**
  String get welcomeGdome;

  /// No description provided for @systemeSentence.
  ///
  /// In fr, this message translates to:
  /// **'L\'écosystème domotique qui réinvente votre relation avec la nature et votre intérieur.'**
  String get systemeSentence;

  /// No description provided for @iConnect.
  ///
  /// In fr, this message translates to:
  /// **'Je me connecte'**
  String get iConnect;

  /// No description provided for @ourVision.
  ///
  /// In fr, this message translates to:
  /// **'Notre vision'**
  String get ourVision;

  /// No description provided for @smartPots.
  ///
  /// In fr, this message translates to:
  /// **'Pots Intelligents'**
  String get smartPots;

  /// No description provided for @plantNeed.
  ///
  /// In fr, this message translates to:
  /// **'Vos plantes dictent leurs besoins en temps réel grâce à nos capteurs haute précision.'**
  String get plantNeed;

  /// No description provided for @tomorrow.
  ///
  /// In fr, this message translates to:
  /// **'Demain...'**
  String get tomorrow;

  /// No description provided for @bowlNeed.
  ///
  /// In fr, this message translates to:
  /// **'Un écosystème en expansion : gamelles connectées, soin des animaux et confort global.'**
  String get bowlNeed;

  /// No description provided for @newComany.
  ///
  /// In fr, this message translates to:
  /// **'Une jeune pousse passionnée'**
  String get newComany;

  /// No description provided for @newComanyDesc.
  ///
  /// In fr, this message translates to:
  /// **'GDOME est une toute nouvelle entreprise française. Notre mission est d\'allier le respect du vivant à l\'intelligence de la maison connectée, sans compromis sur le design.'**
  String get newComanyDesc;

  /// No description provided for @objectQuestion.
  ///
  /// In fr, this message translates to:
  /// **'Des questions sur nos objets ?'**
  String get objectQuestion;

  /// No description provided for @faqDiscovery.
  ///
  /// In fr, this message translates to:
  /// **'Explorez notre Centre d\'aide'**
  String get faqDiscovery;

  /// No description provided for @myPlantPage.
  ///
  /// In fr, this message translates to:
  /// **'======================='**
  String get myPlantPage;

  /// No description provided for @myFavorites.
  ///
  /// In fr, this message translates to:
  /// **'Mes favoris'**
  String get myFavorites;

  /// No description provided for @noFoundItems.
  ///
  /// In fr, this message translates to:
  /// **'Aucun objets trouvés.'**
  String get noFoundItems;

  /// No description provided for @myList.
  ///
  /// In fr, this message translates to:
  /// **'Ma Liste'**
  String get myList;

  /// No description provided for @emptyStateWidget.
  ///
  /// In fr, this message translates to:
  /// **'======================='**
  String get emptyStateWidget;

  /// No description provided for @myFavoritesEmptyTitle.
  ///
  /// In fr, this message translates to:
  /// **'Aucun favori pour l\'instant'**
  String get myFavoritesEmptyTitle;

  /// No description provided for @myFavoritesEmptySubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Ajoute tes objets en favoris pour les retrouver ici en un clin d\'œil.'**
  String get myFavoritesEmptySubtitle;

  /// No description provided for @myListEmptyTitle.
  ///
  /// In fr, this message translates to:
  /// **'Ta collection est vide'**
  String get myListEmptyTitle;

  /// No description provided for @myListEmptySubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Commence à ajouter tes objets connectés GDOME pour suivre leur santé en temps réel.'**
  String get myListEmptySubtitle;

  /// No description provided for @loginPage.
  ///
  /// In fr, this message translates to:
  /// **'======================='**
  String get loginPage;

  /// No description provided for @incorrectId.
  ///
  /// In fr, this message translates to:
  /// **'Identifiants incorrects. Veuillez réessayer.'**
  String get incorrectId;

  /// No description provided for @happySeeYou.
  ///
  /// In fr, this message translates to:
  /// **'Heureux de vous revoir !'**
  String get happySeeYou;

  /// No description provided for @cultivateInside.
  ///
  /// In fr, this message translates to:
  /// **'Cultivez votre bien-être intérieur.'**
  String get cultivateInside;

  /// No description provided for @email.
  ///
  /// In fr, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @emailExample.
  ///
  /// In fr, this message translates to:
  /// **'votre@email.com'**
  String get emailExample;

  /// No description provided for @invalidEmail.
  ///
  /// In fr, this message translates to:
  /// **'Format d\'email invalide'**
  String get invalidEmail;

  /// No description provided for @password.
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe'**
  String get password;

  /// No description provided for @suspension.
  ///
  /// In fr, this message translates to:
  /// **'••••••••'**
  String get suspension;

  /// No description provided for @tooShortPassword.
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe trop court'**
  String get tooShortPassword;

  /// No description provided for @forgotPassword.
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe oublié ?'**
  String get forgotPassword;

  /// No description provided for @loginMaj.
  ///
  /// In fr, this message translates to:
  /// **'SE CONNECTER'**
  String get loginMaj;

  /// No description provided for @noAccount.
  ///
  /// In fr, this message translates to:
  /// **'Pas encore de compte ?'**
  String get noAccount;

  /// No description provided for @signUp.
  ///
  /// In fr, this message translates to:
  /// **'Inscrivez-vous'**
  String get signUp;

  /// No description provided for @signupPage.
  ///
  /// In fr, this message translates to:
  /// **'======================='**
  String get signupPage;

  /// No description provided for @signUpFailure.
  ///
  /// In fr, this message translates to:
  /// **'Échec de l\'inscription. Ce pseudo ou cet email est peut-être déjà utilisé.'**
  String get signUpFailure;

  /// No description provided for @oops.
  ///
  /// In fr, this message translates to:
  /// **'Oups !'**
  String get oops;

  /// No description provided for @ok.
  ///
  /// In fr, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @createAnAccount.
  ///
  /// In fr, this message translates to:
  /// **'Créer un compte'**
  String get createAnAccount;

  /// No description provided for @joinAdventure.
  ///
  /// In fr, this message translates to:
  /// **'Rejoignez l\'aventure GDOME en quelques secondes.'**
  String get joinAdventure;

  /// No description provided for @pseudo.
  ///
  /// In fr, this message translates to:
  /// **'Pseudo'**
  String get pseudo;

  /// No description provided for @pseudoQuestion.
  ///
  /// In fr, this message translates to:
  /// **'Comment doit-on vous appeler ?'**
  String get pseudoQuestion;

  /// No description provided for @confirmation.
  ///
  /// In fr, this message translates to:
  /// **'Confirmation'**
  String get confirmation;

  /// No description provided for @confirmationQuestion.
  ///
  /// In fr, this message translates to:
  /// **'Confirmez votre mot de passe'**
  String get confirmationQuestion;

  /// No description provided for @differentPasswords.
  ///
  /// In fr, this message translates to:
  /// **'Les mots de passe diffèrent'**
  String get differentPasswords;

  /// No description provided for @signUpMaj.
  ///
  /// In fr, this message translates to:
  /// **'S\'INSCRIRE'**
  String get signUpMaj;

  /// No description provided for @alreadyAccount.
  ///
  /// In fr, this message translates to:
  /// **'Déjà un compte ?'**
  String get alreadyAccount;

  /// No description provided for @login.
  ///
  /// In fr, this message translates to:
  /// **'Se connecter'**
  String get login;

  /// No description provided for @signupValidationPage.
  ///
  /// In fr, this message translates to:
  /// **'======================='**
  String get signupValidationPage;

  /// No description provided for @welcome.
  ///
  /// In fr, this message translates to:
  /// **'Bienvenue !'**
  String get welcome;

  /// No description provided for @startMaj.
  ///
  /// In fr, this message translates to:
  /// **'COMMENCER'**
  String get startMaj;

  /// No description provided for @verification.
  ///
  /// In fr, this message translates to:
  /// **'Vérification'**
  String get verification;

  /// No description provided for @signupValidationDesc.
  ///
  /// In fr, this message translates to:
  /// **'Saisissez le code de 6 chiffres envoyé à\n{userEmail}'**
  String signupValidationDesc(Object userEmail);

  /// No description provided for @signupResendCodeTimer.
  ///
  /// In fr, this message translates to:
  /// **'Renvoyer le code dans {seconds} s'**
  String signupResendCodeTimer(Object seconds);

  /// No description provided for @signupResendCode.
  ///
  /// In fr, this message translates to:
  /// **'Renvoyer le code'**
  String get signupResendCode;

  /// No description provided for @sendNewCode.
  ///
  /// In fr, this message translates to:
  /// **'Un nouveau code a été envoyé !'**
  String get sendNewCode;

  /// No description provided for @failureSendTryLater.
  ///
  /// In fr, this message translates to:
  /// **'Échec de l\'envoi. Réessayez plus tard.'**
  String get failureSendTryLater;

  /// No description provided for @accountValidationMaj.
  ///
  /// In fr, this message translates to:
  /// **'VALIDER MON COMPTE'**
  String get accountValidationMaj;

  /// No description provided for @profilePage.
  ///
  /// In fr, this message translates to:
  /// **'======================='**
  String get profilePage;

  /// No description provided for @user.
  ///
  /// In fr, this message translates to:
  /// **'Utilisateur'**
  String get user;

  /// No description provided for @noAddressEmail.
  ///
  /// In fr, this message translates to:
  /// **'Pas d\'adresse email'**
  String get noAddressEmail;

  /// No description provided for @identity.
  ///
  /// In fr, this message translates to:
  /// **'Identité'**
  String get identity;

  /// No description provided for @noSpecified.
  ///
  /// In fr, this message translates to:
  /// **'Non renseigné'**
  String get noSpecified;

  /// No description provided for @manageMyApp.
  ///
  /// In fr, this message translates to:
  /// **'Gérer mon application'**
  String get manageMyApp;

  /// No description provided for @security.
  ///
  /// In fr, this message translates to:
  /// **'Sécurité'**
  String get security;

  /// No description provided for @changePassword.
  ///
  /// In fr, this message translates to:
  /// **'Modifier le mot de passe'**
  String get changePassword;

  /// No description provided for @myItems.
  ///
  /// In fr, this message translates to:
  /// **'Mes objets'**
  String get myItems;

  /// No description provided for @manageMyDevices.
  ///
  /// In fr, this message translates to:
  /// **'Gérer mes appareils'**
  String get manageMyDevices;

  /// No description provided for @favoritesItems.
  ///
  /// In fr, this message translates to:
  /// **'Éléments préférés'**
  String get favoritesItems;

  /// No description provided for @faq.
  ///
  /// In fr, this message translates to:
  /// **'FAQ'**
  String get faq;

  /// No description provided for @helpCenter.
  ///
  /// In fr, this message translates to:
  /// **'Centre d\'aide'**
  String get helpCenter;

  /// No description provided for @leaveReview.
  ///
  /// In fr, this message translates to:
  /// **'Donner mon avis'**
  String get leaveReview;

  /// No description provided for @shareExperience.
  ///
  /// In fr, this message translates to:
  /// **'Partagez votre expérience et aidez-nous à nous améliorer !'**
  String get shareExperience;

  /// No description provided for @logOut.
  ///
  /// In fr, this message translates to:
  /// **'Se déconnecter'**
  String get logOut;

  /// No description provided for @forgotPasswordPage.
  ///
  /// In fr, this message translates to:
  /// **'======================='**
  String get forgotPasswordPage;

  /// No description provided for @failureSendMail.
  ///
  /// In fr, this message translates to:
  /// **'Une erreur est survenue lors de l\'envoi du mail. Vérifiez votre connexion ou l\'adresse saisie.'**
  String get failureSendMail;

  /// No description provided for @retry.
  ///
  /// In fr, this message translates to:
  /// **'Réessayer'**
  String get retry;

  /// No description provided for @enterMailRetrieve.
  ///
  /// In fr, this message translates to:
  /// **'Entrez l\'adresse e-mail associée à votre compte. Nous vous enverrons un code pour réinitialiser votre mot de passe.'**
  String get enterMailRetrieve;

  /// No description provided for @sendTheCodeMaj.
  ///
  /// In fr, this message translates to:
  /// **'ENVOYER LE CODE'**
  String get sendTheCodeMaj;

  /// No description provided for @back.
  ///
  /// In fr, this message translates to:
  /// **'Retour'**
  String get back;

  /// No description provided for @yourEmail.
  ///
  /// In fr, this message translates to:
  /// **'Votre Email'**
  String get yourEmail;

  /// No description provided for @enterYourEmail.
  ///
  /// In fr, this message translates to:
  /// **'Veuillez entrer votre email'**
  String get enterYourEmail;

  /// No description provided for @getCodeEmailPage.
  ///
  /// In fr, this message translates to:
  /// **'======================='**
  String get getCodeEmailPage;

  /// No description provided for @enterMailReceived.
  ///
  /// In fr, this message translates to:
  /// **'Veuillez entrer le code reçu par mail.'**
  String get enterMailReceived;

  /// No description provided for @codeContainLimit.
  ///
  /// In fr, this message translates to:
  /// **'Le code doit comporter 6 chiffres.'**
  String get codeContainLimit;

  /// No description provided for @invalidCode.
  ///
  /// In fr, this message translates to:
  /// **'Code invalide'**
  String get invalidCode;

  /// No description provided for @incorrectCode.
  ///
  /// In fr, this message translates to:
  /// **'Le code saisi est incorrect ou a expiré. Veuillez réessayer.'**
  String get incorrectCode;

  /// No description provided for @enterCodeDigits.
  ///
  /// In fr, this message translates to:
  /// **'Entrez le code à 6 chiffres envoyé à'**
  String get enterCodeDigits;

  /// No description provided for @hintZeroSix.
  ///
  /// In fr, this message translates to:
  /// **'000000'**
  String get hintZeroSix;

  /// No description provided for @confirmationMaj.
  ///
  /// In fr, this message translates to:
  /// **'CONFIRMER'**
  String get confirmationMaj;

  /// No description provided for @signupResendCodeIn.
  ///
  /// In fr, this message translates to:
  /// **'Renvoyer le code dans '**
  String get signupResendCodeIn;

  /// No description provided for @resetPasswordPage.
  ///
  /// In fr, this message translates to:
  /// **'======================='**
  String get resetPasswordPage;

  /// No description provided for @retrySessionExpire.
  ///
  /// In fr, this message translates to:
  /// **'Session expirée. Veuillez recommencer.'**
  String get retrySessionExpire;

  /// No description provided for @expiredCode.
  ///
  /// In fr, this message translates to:
  /// **'Le code a expiré ou est invalide.'**
  String get expiredCode;

  /// No description provided for @passwordChangeNoConnected.
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe changé, mais erreur de connexion. Connectez-vous manuellement.'**
  String get passwordChangeNoConnected;

  /// No description provided for @updatePassword.
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe mis à jour !'**
  String get updatePassword;

  /// No description provided for @autoLoginLoading.
  ///
  /// In fr, this message translates to:
  /// **'Connexion automatique en cours...'**
  String get autoLoginLoading;

  /// No description provided for @successPasswordConnectOk.
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe modifié avec succès ! Vous pouvez maintenant vous connecter.'**
  String get successPasswordConnectOk;

  /// No description provided for @loginBackMaj.
  ///
  /// In fr, this message translates to:
  /// **'RETOUR À LA CONNEXION'**
  String get loginBackMaj;

  /// No description provided for @newPasswordLine.
  ///
  /// In fr, this message translates to:
  /// **'Nouveau\nmot de passe'**
  String get newPasswordLine;

  /// No description provided for @createNewStrongPassword.
  ///
  /// In fr, this message translates to:
  /// **'Créez un mot de passe fort pour sécuriser votre compte.'**
  String get createNewStrongPassword;

  /// No description provided for @newPassword.
  ///
  /// In fr, this message translates to:
  /// **'Nouveau mot de passe'**
  String get newPassword;

  /// No description provided for @confirmationThePassword.
  ///
  /// In fr, this message translates to:
  /// **'Confirmer le mot de passe'**
  String get confirmationThePassword;

  /// No description provided for @resetMaj.
  ///
  /// In fr, this message translates to:
  /// **'RÉINITIALISER'**
  String get resetMaj;

  /// No description provided for @limitChar.
  ///
  /// In fr, this message translates to:
  /// **'6 caractères minimum'**
  String get limitChar;

  /// No description provided for @myObjectProfilePage.
  ///
  /// In fr, this message translates to:
  /// **'======================='**
  String get myObjectProfilePage;

  /// No description provided for @connectedDevices.
  ///
  /// In fr, this message translates to:
  /// **'Mes Objets Connectés'**
  String get connectedDevices;

  /// No description provided for @failureChargeCategories.
  ///
  /// In fr, this message translates to:
  /// **'Impossible de charger vos catégories.'**
  String get failureChargeCategories;

  /// No description provided for @noDevicesForMoment.
  ///
  /// In fr, this message translates to:
  /// **'Aucun objet enregistré pour le moment.'**
  String get noDevicesForMoment;

  /// No description provided for @myFavoriteCatalogPage.
  ///
  /// In fr, this message translates to:
  /// **'======================='**
  String get myFavoriteCatalogPage;

  /// No description provided for @myFavoritesMajD.
  ///
  /// In fr, this message translates to:
  /// **'Mes Favoris'**
  String get myFavoritesMajD;

  /// No description provided for @failureChargeFavorites.
  ///
  /// In fr, this message translates to:
  /// **'Impossible de charger vos favoris.'**
  String get failureChargeFavorites;

  /// No description provided for @noFavoritesForMoment.
  ///
  /// In fr, this message translates to:
  /// **'Aucun favori pour le moment'**
  String get noFavoritesForMoment;

  /// No description provided for @noticePage.
  ///
  /// In fr, this message translates to:
  /// **'======================='**
  String get noticePage;

  /// No description provided for @completeAllField.
  ///
  /// In fr, this message translates to:
  /// **'Veuillez compléter les champs obligatoires'**
  String get completeAllField;

  /// No description provided for @thanksForFeedback.
  ///
  /// In fr, this message translates to:
  /// **'Merci pour votre retour !'**
  String get thanksForFeedback;

  /// No description provided for @occurredError.
  ///
  /// In fr, this message translates to:
  /// **'Une erreur est survenue'**
  String get occurredError;

  /// No description provided for @commentsMaj.
  ///
  /// In fr, this message translates to:
  /// **'COMMENTAIRES'**
  String get commentsMaj;

  /// No description provided for @experienceBack.
  ///
  /// In fr, this message translates to:
  /// **'Votre expérience nous intéresse'**
  String get experienceBack;

  /// No description provided for @experienceBackDesc.
  ///
  /// In fr, this message translates to:
  /// **'Parce qu\'on sait que tout n\'est pas toujours parfait, votre retour est précieux pour faire progresser la nouvelle aventure GDOME chaque jour.'**
  String get experienceBackDesc;

  /// No description provided for @noticeSubject.
  ///
  /// In fr, this message translates to:
  /// **'Sujet de l\'avis'**
  String get noticeSubject;

  /// No description provided for @enterTitle.
  ///
  /// In fr, this message translates to:
  /// **'Saisissez un titre'**
  String get enterTitle;

  /// No description provided for @itemConcerned.
  ///
  /// In fr, this message translates to:
  /// **'Objet concerné (Optionnel)'**
  String get itemConcerned;

  /// No description provided for @categoryD.
  ///
  /// In fr, this message translates to:
  /// **'Catégorie'**
  String get categoryD;

  /// No description provided for @selectCategory.
  ///
  /// In fr, this message translates to:
  /// **'Sélectionnez une catégorie'**
  String get selectCategory;

  /// No description provided for @yourMessage.
  ///
  /// In fr, this message translates to:
  /// **'Votre message'**
  String get yourMessage;

  /// No description provided for @noEmptyContent.
  ///
  /// In fr, this message translates to:
  /// **'Le contenu ne peut pas être vide'**
  String get noEmptyContent;

  /// No description provided for @sendBackMaj.
  ///
  /// In fr, this message translates to:
  /// **'ENVOYER MON RETOUR'**
  String get sendBackMaj;

  /// No description provided for @shoppingPage.
  ///
  /// In fr, this message translates to:
  /// **'======================='**
  String get shoppingPage;

  /// No description provided for @modelSearch.
  ///
  /// In fr, this message translates to:
  /// **'Rechercher un modèle...'**
  String get modelSearch;

  /// No description provided for @allD.
  ///
  /// In fr, this message translates to:
  /// **'Tous'**
  String get allD;

  /// No description provided for @noAvailableProduct.
  ///
  /// In fr, this message translates to:
  /// **'Aucun produit disponible'**
  String get noAvailableProduct;

  /// No description provided for @cartArticlesAdded.
  ///
  /// In fr, this message translates to:
  /// **'{qty} article(s) ajouté(s) au panier !'**
  String cartArticlesAdded(Object qty);

  /// No description provided for @failureAddAskTry.
  ///
  /// In fr, this message translates to:
  /// **'Erreur lors de l\'ajout. Réessayez.'**
  String get failureAddAskTry;

  /// No description provided for @gdomeMaj.
  ///
  /// In fr, this message translates to:
  /// **'GDOME'**
  String get gdomeMaj;

  /// No description provided for @theExperience.
  ///
  /// In fr, this message translates to:
  /// **'L\'expérience'**
  String get theExperience;

  /// No description provided for @technicalSpecifications.
  ///
  /// In fr, this message translates to:
  /// **'Fiche technique'**
  String get technicalSpecifications;

  /// No description provided for @productInStock.
  ///
  /// In fr, this message translates to:
  /// **'En stock ({count} unités)'**
  String productInStock(Object count);

  /// No description provided for @outOfStock.
  ///
  /// In fr, this message translates to:
  /// **'Actuellement épuisé'**
  String get outOfStock;

  /// No description provided for @productNotFound.
  ///
  /// In fr, this message translates to:
  /// **'Produit introuvable'**
  String get productNotFound;

  /// No description provided for @backToCatalogMaj.
  ///
  /// In fr, this message translates to:
  /// **'RETOURNER AU CATALOGUE'**
  String get backToCatalogMaj;

  /// No description provided for @shoppingProductBottomBarPage.
  ///
  /// In fr, this message translates to:
  /// **'======================='**
  String get shoppingProductBottomBarPage;

  /// No description provided for @buyNowMaj.
  ///
  /// In fr, this message translates to:
  /// **'ACHETER MAINTENANT'**
  String get buyNowMaj;

  /// No description provided for @outOfStockMaj.
  ///
  /// In fr, this message translates to:
  /// **'ÉPUISÉ'**
  String get outOfStockMaj;

  /// No description provided for @shoppingProductTrustPage.
  ///
  /// In fr, this message translates to:
  /// **'======================='**
  String get shoppingProductTrustPage;

  /// No description provided for @badgeSecurePay.
  ///
  /// In fr, this message translates to:
  /// **'Paiement\nSécurisé'**
  String get badgeSecurePay;

  /// No description provided for @badgeHighPrecision.
  ///
  /// In fr, this message translates to:
  /// **'Conception\n Haute Précision'**
  String get badgeHighPrecision;

  /// No description provided for @badgeSatisfaction.
  ///
  /// In fr, this message translates to:
  /// **'Satisfaction\nAssurée'**
  String get badgeSatisfaction;

  /// No description provided for @plantDetailKnownPage.
  ///
  /// In fr, this message translates to:
  /// **'======================='**
  String get plantDetailKnownPage;

  /// No description provided for @plantNotFound.
  ///
  /// In fr, this message translates to:
  /// **'Plante introuvable'**
  String get plantNotFound;

  /// No description provided for @descriptionD.
  ///
  /// In fr, this message translates to:
  /// **'Description'**
  String get descriptionD;

  /// No description provided for @expertTips.
  ///
  /// In fr, this message translates to:
  /// **'Conseils d\'expert'**
  String get expertTips;

  /// No description provided for @lifeCalendar.
  ///
  /// In fr, this message translates to:
  /// **'Calendrier de vie'**
  String get lifeCalendar;

  /// No description provided for @scientificName.
  ///
  /// In fr, this message translates to:
  /// **'Nom scientifique : '**
  String get scientificName;

  /// No description provided for @unknownD.
  ///
  /// In fr, this message translates to:
  /// **'Inconnue'**
  String get unknownD;

  /// No description provided for @familyD.
  ///
  /// In fr, this message translates to:
  /// **'Famille'**
  String get familyD;

  /// No description provided for @plantFamilyLabel.
  ///
  /// In fr, this message translates to:
  /// **'Famille : {familyName}'**
  String plantFamilyLabel(Object familyName);

  /// No description provided for @metricHeight.
  ///
  /// In fr, this message translates to:
  /// **'Hauteur'**
  String get metricHeight;

  /// No description provided for @metricSun.
  ///
  /// In fr, this message translates to:
  /// **'Soleil/j'**
  String get metricSun;

  /// No description provided for @metricPlanting.
  ///
  /// In fr, this message translates to:
  /// **'Plantation'**
  String get metricPlanting;

  /// No description provided for @plantNoSpecificAdvise.
  ///
  /// In fr, this message translates to:
  /// **'Pas de conseils spécifiques.'**
  String get plantNoSpecificAdvise;

  /// No description provided for @needsAndEnv.
  ///
  /// In fr, this message translates to:
  /// **'Besoins & Environnement'**
  String get needsAndEnv;

  /// No description provided for @plantExposure.
  ///
  /// In fr, this message translates to:
  /// **'Exposition'**
  String get plantExposure;

  /// No description provided for @plantGround.
  ///
  /// In fr, this message translates to:
  /// **'Sol'**
  String get plantGround;

  /// No description provided for @seasonSpring.
  ///
  /// In fr, this message translates to:
  /// **'Printemps'**
  String get seasonSpring;

  /// No description provided for @seasonSummer.
  ///
  /// In fr, this message translates to:
  /// **'Été'**
  String get seasonSummer;

  /// No description provided for @seasonAutumn.
  ///
  /// In fr, this message translates to:
  /// **'Automne'**
  String get seasonAutumn;

  /// No description provided for @seasonWinter.
  ///
  /// In fr, this message translates to:
  /// **'Hiver'**
  String get seasonWinter;

  /// No description provided for @orderValidationPage.
  ///
  /// In fr, this message translates to:
  /// **'======================='**
  String get orderValidationPage;

  /// No description provided for @congratulationsD.
  ///
  /// In fr, this message translates to:
  /// **'Félicitations !'**
  String get congratulationsD;

  /// No description provided for @validateOrder.
  ///
  /// In fr, this message translates to:
  /// **'Votre commande a été validée avec succès et est en cours de préparation.'**
  String get validateOrder;

  /// No description provided for @yourOrderMaj.
  ///
  /// In fr, this message translates to:
  /// **'VOTRE COMMANDE'**
  String get yourOrderMaj;

  /// No description provided for @deliveryAddressMaj.
  ///
  /// In fr, this message translates to:
  /// **'ADRESSE DE LIVRAISON'**
  String get deliveryAddressMaj;

  /// No description provided for @totalAmountPaidD.
  ///
  /// In fr, this message translates to:
  /// **'Montant total réglé'**
  String get totalAmountPaidD;

  /// No description provided for @backToHomeMaj.
  ///
  /// In fr, this message translates to:
  /// **'RETOURNER À L\'ACCUEIL'**
  String get backToHomeMaj;

  /// No description provided for @trackMyOrdersD.
  ///
  /// In fr, this message translates to:
  /// **'Suivre mes commandes'**
  String get trackMyOrdersD;

  /// No description provided for @orderPaymentPage.
  ///
  /// In fr, this message translates to:
  /// **'======================='**
  String get orderPaymentPage;

  /// No description provided for @summaryD.
  ///
  /// In fr, this message translates to:
  /// **'Récapitulatif'**
  String get summaryD;

  /// No description provided for @deliveryToMAJ.
  ///
  /// In fr, this message translates to:
  /// **'LIVRAISON À'**
  String get deliveryToMAJ;

  /// No description provided for @subtotalD.
  ///
  /// In fr, this message translates to:
  /// **'Sous-total'**
  String get subtotalD;

  /// No description provided for @deliveryD.
  ///
  /// In fr, this message translates to:
  /// **'Livraison'**
  String get deliveryD;

  /// No description provided for @freeD.
  ///
  /// In fr, this message translates to:
  /// **'Offerte'**
  String get freeD;

  /// No description provided for @totalMaj.
  ///
  /// In fr, this message translates to:
  /// **'TOTAL'**
  String get totalMaj;

  /// No description provided for @unableToInitThePayment.
  ///
  /// In fr, this message translates to:
  /// **'Impossible d\'initialiser le paiement.'**
  String get unableToInitThePayment;

  /// No description provided for @paymentNotFinalized.
  ///
  /// In fr, this message translates to:
  /// **'Paiement non finalisé : {errorMessage}'**
  String paymentNotFinalized(Object errorMessage);

  /// No description provided for @paymentErrorGeneric.
  ///
  /// In fr, this message translates to:
  /// **'Une erreur est survenue lors du paiement. Veuillez réessayer.'**
  String get paymentErrorGeneric;

  /// No description provided for @btnConfirmAndPay.
  ///
  /// In fr, this message translates to:
  /// **'CONFIRMER ET PAYER {price}'**
  String btnConfirmAndPay(Object price);

  /// No description provided for @orderAddressPage.
  ///
  /// In fr, this message translates to:
  /// **'======================='**
  String get orderAddressPage;

  /// No description provided for @franceD.
  ///
  /// In fr, this message translates to:
  /// **'France'**
  String get franceD;

  /// No description provided for @yourAddressMaj.
  ///
  /// In fr, this message translates to:
  /// **'VOS ADRESSES'**
  String get yourAddressMaj;

  /// No description provided for @orderSummaryMaj.
  ///
  /// In fr, this message translates to:
  /// **'RÉSUMÉ COMMANDE'**
  String get orderSummaryMaj;

  /// No description provided for @addressD.
  ///
  /// In fr, this message translates to:
  /// **'Adresse'**
  String get addressD;

  /// No description provided for @useAnotherAddress.
  ///
  /// In fr, this message translates to:
  /// **'Utiliser une autre adresse'**
  String get useAnotherAddress;

  /// No description provided for @addAnDeliveryAddressMaj.
  ///
  /// In fr, this message translates to:
  /// **'AJOUTER UNE ADRESSE DE LIVRAISON'**
  String get addAnDeliveryAddressMaj;

  /// No description provided for @nameAddressD.
  ///
  /// In fr, this message translates to:
  /// **'Nom de l\'adresse (Maison, Bureau...)'**
  String get nameAddressD;

  /// No description provided for @enterAddressD.
  ///
  /// In fr, this message translates to:
  /// **'Saisissez votre adresse...'**
  String get enterAddressD;

  /// No description provided for @additionalInformationD.
  ///
  /// In fr, this message translates to:
  /// **'Complément (Appartement, Étage...)'**
  String get additionalInformationD;

  /// No description provided for @postalCodeD.
  ///
  /// In fr, this message translates to:
  /// **'Code Postal'**
  String get postalCodeD;

  /// No description provided for @cityD.
  ///
  /// In fr, this message translates to:
  /// **'Ville'**
  String get cityD;

  /// No description provided for @countryD.
  ///
  /// In fr, this message translates to:
  /// **'Pays'**
  String get countryD;

  /// No description provided for @setAsDefaultD.
  ///
  /// In fr, this message translates to:
  /// **'Définir par défaut'**
  String get setAsDefaultD;

  /// No description provided for @chooseAnAddressMaj.
  ///
  /// In fr, this message translates to:
  /// **'CHOISIR UNE ADRESSE'**
  String get chooseAnAddressMaj;

  /// No description provided for @validateAddressMaj.
  ///
  /// In fr, this message translates to:
  /// **'VALIDER CETTE ADRESSE'**
  String get validateAddressMaj;

  /// No description provided for @fillInTheFieldsMaj.
  ///
  /// In fr, this message translates to:
  /// **'REMPLIR LES CHAMPS'**
  String get fillInTheFieldsMaj;

  /// No description provided for @btnConfirmOrderMaj.
  ///
  /// In fr, this message translates to:
  /// **'CONFIRMER {price}'**
  String btnConfirmOrderMaj(Object price);

  /// No description provided for @btnChooseAddressMaj.
  ///
  /// In fr, this message translates to:
  /// **'CHOISIR UNE ADRESSE'**
  String get btnChooseAddressMaj;

  /// No description provided for @modificationWifiMyObjectPage.
  ///
  /// In fr, this message translates to:
  /// **'======================='**
  String get modificationWifiMyObjectPage;

  /// No description provided for @wifiConfigTitle.
  ///
  /// In fr, this message translates to:
  /// **'Configuration WiFi'**
  String get wifiConfigTitle;

  /// No description provided for @wifiUpdateForObject.
  ///
  /// In fr, this message translates to:
  /// **'Mise à jour pour {objectTitle}'**
  String wifiUpdateForObject(Object objectTitle);

  /// No description provided for @wifiRangeWarning.
  ///
  /// In fr, this message translates to:
  /// **'Assurez-vous que votre objet est à portée lors de la modification.'**
  String get wifiRangeWarning;

  /// No description provided for @wifiSsidLabel.
  ///
  /// In fr, this message translates to:
  /// **'Nom du réseau (SSID)'**
  String get wifiSsidLabel;

  /// No description provided for @exampleWifiSsidLabel.
  ///
  /// In fr, this message translates to:
  /// **'Ex: MaBox_WiFi'**
  String get exampleWifiSsidLabel;

  /// No description provided for @wifiPasswordLabel.
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe'**
  String get wifiPasswordLabel;

  /// No description provided for @wifiBtnModify.
  ///
  /// In fr, this message translates to:
  /// **'Modifier mon WiFi'**
  String get wifiBtnModify;

  /// No description provided for @wifiErrorEmptyFields.
  ///
  /// In fr, this message translates to:
  /// **'Veuillez remplir tous les champs'**
  String get wifiErrorEmptyFields;

  /// No description provided for @modificationWifiConnectPage.
  ///
  /// In fr, this message translates to:
  /// **'======================='**
  String get modificationWifiConnectPage;

  /// No description provided for @wifiConnectSuccessHeader.
  ///
  /// In fr, this message translates to:
  /// **'Configuration réussie !'**
  String get wifiConnectSuccessHeader;

  /// No description provided for @wifiConnectSearchHeader.
  ///
  /// In fr, this message translates to:
  /// **'Connexion au réseau'**
  String get wifiConnectSearchHeader;

  /// No description provided for @wifiConnectSeconds.
  ///
  /// In fr, this message translates to:
  /// **'secondes'**
  String get wifiConnectSeconds;

  /// No description provided for @wifiConnectWait.
  ///
  /// In fr, this message translates to:
  /// **'Veuillez patienter...'**
  String get wifiConnectWait;

  /// No description provided for @wifiConnectBtnFinish.
  ///
  /// In fr, this message translates to:
  /// **'Terminer'**
  String get wifiConnectBtnFinish;

  /// No description provided for @wifiConnectBtnRetry.
  ///
  /// In fr, this message translates to:
  /// **'Réessayer'**
  String get wifiConnectBtnRetry;

  /// No description provided for @wifiConnectLedStatus.
  ///
  /// In fr, this message translates to:
  /// **'Statut LED de l\'objet'**
  String get wifiConnectLedStatus;

  /// No description provided for @wifiStatusSearchTitle.
  ///
  /// In fr, this message translates to:
  /// **'Recherche de l\'objet...'**
  String get wifiStatusSearchTitle;

  /// No description provided for @wifiStatusSearchSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Assurez-vous que l\'objet est à proximité et allumé. Activer le mode manuel de votre objet puis appuyer sur le bouton BLEU.'**
  String get wifiStatusSearchSubtitle;

  /// No description provided for @wifiStatusProcessingTitle.
  ///
  /// In fr, this message translates to:
  /// **'Tentative de connexion...'**
  String get wifiStatusProcessingTitle;

  /// No description provided for @wifiStatusProcessingSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'L\'objet essaie de rejoindre votre WiFi. La LED doit clignoter.'**
  String get wifiStatusProcessingSubtitle;

  /// No description provided for @wifiStatusSuccessTitle.
  ///
  /// In fr, this message translates to:
  /// **'Tout est prêt !'**
  String get wifiStatusSuccessTitle;

  /// No description provided for @wifiStatusSuccessSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'L\'objet est maintenant connecté. La LED bleu doit disparaître.'**
  String get wifiStatusSuccessSubtitle;

  /// No description provided for @wifiStatusErrorTitle.
  ///
  /// In fr, this message translates to:
  /// **'Une erreur est survenue'**
  String get wifiStatusErrorTitle;

  /// No description provided for @wifiStatusErrorSubtitleFallback.
  ///
  /// In fr, this message translates to:
  /// **'Vérifiez que votre SSID et mot de passe WiFi sont corrects.'**
  String get wifiStatusErrorSubtitleFallback;

  /// No description provided for @wifiErrorBluetoothOff.
  ///
  /// In fr, this message translates to:
  /// **'Bluetooth désactivé. Veuillez l\'activer.'**
  String get wifiErrorBluetoothOff;

  /// No description provided for @wifiErrorScanFailed.
  ///
  /// In fr, this message translates to:
  /// **'Impossible de scanner les environs.'**
  String get wifiErrorScanFailed;

  /// No description provided for @wifiErrorConnectionLost.
  ///
  /// In fr, this message translates to:
  /// **'Connexion avec l\'objet perdue.'**
  String get wifiErrorConnectionLost;

  /// No description provided for @wifiErrorTimeout.
  ///
  /// In fr, this message translates to:
  /// **'L\'objet met trop de temps à répondre.'**
  String get wifiErrorTimeout;

  /// No description provided for @wifiErrorWrongProfile.
  ///
  /// In fr, this message translates to:
  /// **'Ce pot appartient à un autre Profil créé. Action refusée. Vérifier l\'identitée de pots'**
  String get wifiErrorWrongProfile;

  /// No description provided for @wifiErrorConnectionFailed.
  ///
  /// In fr, this message translates to:
  /// **'L\'objet n\'a pas pu se connecter à {ssid}.'**
  String wifiErrorConnectionFailed(Object ssid);

  /// No description provided for @homePageNoLogin.
  ///
  /// In fr, this message translates to:
  /// **'======================='**
  String get homePageNoLogin;

  /// No description provided for @homeTitleAdvise.
  ///
  /// In fr, this message translates to:
  /// **'Conseils & Expertises'**
  String get homeTitleAdvise;

  /// No description provided for @homeTitleShop.
  ///
  /// In fr, this message translates to:
  /// **'Boutique GDOME'**
  String get homeTitleShop;

  /// No description provided for @homeTooltipProfile.
  ///
  /// In fr, this message translates to:
  /// **'Profil'**
  String get homeTooltipProfile;

  /// No description provided for @navTabAdvise.
  ///
  /// In fr, this message translates to:
  /// **'Conseils'**
  String get navTabAdvise;

  /// No description provided for @navTabMyObjects.
  ///
  /// In fr, this message translates to:
  /// **'Mes objets'**
  String get navTabMyObjects;

  /// No description provided for @navTabShop.
  ///
  /// In fr, this message translates to:
  /// **'Magasin'**
  String get navTabShop;

  /// No description provided for @homePage.
  ///
  /// In fr, this message translates to:
  /// **'======================='**
  String get homePage;

  /// No description provided for @homeTitleEquipment.
  ///
  /// In fr, this message translates to:
  /// **'Mes Équipements'**
  String get homeTitleEquipment;

  /// No description provided for @homeTooltipMyProfile.
  ///
  /// In fr, this message translates to:
  /// **'Mon Profil'**
  String get homeTooltipMyProfile;

  /// No description provided for @addConnectMyObjectPage.
  ///
  /// In fr, this message translates to:
  /// **'======================='**
  String get addConnectMyObjectPage;

  /// No description provided for @addObjTitle.
  ///
  /// In fr, this message translates to:
  /// **'Connexion'**
  String get addObjTitle;

  /// No description provided for @addObjStepTitle.
  ///
  /// In fr, this message translates to:
  /// **'Connectons votre objet !'**
  String get addObjStepTitle;

  /// No description provided for @addObjStepDesc.
  ///
  /// In fr, this message translates to:
  /// **'Nous allons enfin pouvoir connecter votre {plantName} à notre objet. Appuyez sur le bouton bleu de l\'objet pour que notre application puisse le détecter.'**
  String addObjStepDesc(Object plantName);

  /// No description provided for @addObjDefaultPlantName.
  ///
  /// In fr, this message translates to:
  /// **'votre plante'**
  String get addObjDefaultPlantName;

  /// No description provided for @addObjRecapPlant.
  ///
  /// In fr, this message translates to:
  /// **'Plante'**
  String get addObjRecapPlant;

  /// No description provided for @addObjRecapNetwork.
  ///
  /// In fr, this message translates to:
  /// **'Réseau'**
  String get addObjRecapNetwork;

  /// No description provided for @addObjRecapUnknown.
  ///
  /// In fr, this message translates to:
  /// **'Inconnu'**
  String get addObjRecapUnknown;

  /// No description provided for @addObjRecapId.
  ///
  /// In fr, this message translates to:
  /// **'ID Objet'**
  String get addObjRecapId;

  /// No description provided for @addObjStatusCreating.
  ///
  /// In fr, this message translates to:
  /// **'Création de votre profil plante...'**
  String get addObjStatusCreating;

  /// No description provided for @addObjStatusSearching.
  ///
  /// In fr, this message translates to:
  /// **'Recherche de l\'objet...'**
  String get addObjStatusSearching;

  /// No description provided for @addObjBtnSearching.
  ///
  /// In fr, this message translates to:
  /// **'Recherche...'**
  String get addObjBtnSearching;

  /// No description provided for @addObjBtnCreating.
  ///
  /// In fr, this message translates to:
  /// **'Création profil...'**
  String get addObjBtnCreating;

  /// No description provided for @addObjBtnStart.
  ///
  /// In fr, this message translates to:
  /// **'Lancer la connexion'**
  String get addObjBtnStart;

  /// No description provided for @addObjDialogAlreadyLinkedTitle.
  ///
  /// In fr, this message translates to:
  /// **'Objet déjà associé'**
  String get addObjDialogAlreadyLinkedTitle;

  /// No description provided for @addObjDialogAlreadyLinkedDesc.
  ///
  /// In fr, this message translates to:
  /// **'Cet objet est déjà lié à la fleur \'{flowerName}\'.\n\nVeuillez d\'abord supprimer la fleur associée dans vos paramètres.'**
  String addObjDialogAlreadyLinkedDesc(Object flowerName);

  /// No description provided for @addObjDialogBtnUnderstand.
  ///
  /// In fr, this message translates to:
  /// **'COMPRIS'**
  String get addObjDialogBtnUnderstand;

  /// No description provided for @addObjDialogSuccessTitle.
  ///
  /// In fr, this message translates to:
  /// **'Félicitations !'**
  String get addObjDialogSuccessTitle;

  /// No description provided for @addObjDialogSuccessDesc.
  ///
  /// In fr, this message translates to:
  /// **'Votre {plantName} est configurée et activée !'**
  String addObjDialogSuccessDesc(Object plantName);

  /// No description provided for @addObjErrorNoResponse.
  ///
  /// In fr, this message translates to:
  /// **'L\'objet ne répond plus. Profil annulé.'**
  String get addObjErrorNoResponse;

  /// No description provided for @addObjErrorWifiFailed.
  ///
  /// In fr, this message translates to:
  /// **'L\'objet n\'a pas pu se connecter au Wi-Fi. Le profil a été annulé.'**
  String get addObjErrorWifiFailed;

  /// No description provided for @addObjErrorNoResponseConn.
  ///
  /// In fr, this message translates to:
  /// **'L\'objet ne répond plus. Connexion annulée.'**
  String get addObjErrorNoResponseConn;

  /// No description provided for @loginD.
  ///
  /// In fr, this message translates to:
  /// **'Connexion'**
  String get loginD;

  /// No description provided for @plantDetailContent.
  ///
  /// In fr, this message translates to:
  /// **'======================='**
  String get plantDetailContent;

  /// No description provided for @plantDetailTitle.
  ///
  /// In fr, this message translates to:
  /// **'Détail de la plante'**
  String get plantDetailTitle;

  /// No description provided for @plantDetailNoDescription.
  ///
  /// In fr, this message translates to:
  /// **'Pas de description'**
  String get plantDetailNoDescription;

  /// No description provided for @plantDetailBtnClose.
  ///
  /// In fr, this message translates to:
  /// **'Fermer'**
  String get plantDetailBtnClose;

  /// No description provided for @plantDetailSectionControls.
  ///
  /// In fr, this message translates to:
  /// **'Contrôles'**
  String get plantDetailSectionControls;

  /// No description provided for @plantDetailWrapper.
  ///
  /// In fr, this message translates to:
  /// **'======================='**
  String get plantDetailWrapper;

  /// No description provided for @noAvailableToken.
  ///
  /// In fr, this message translates to:
  /// **'Token non disponible'**
  String get noAvailableToken;

  /// No description provided for @sensorValue.
  ///
  /// In fr, this message translates to:
  /// **'======================='**
  String get sensorValue;

  /// No description provided for @noAvailableD.
  ///
  /// In fr, this message translates to:
  /// **'Non disponible'**
  String get noAvailableD;

  /// No description provided for @objectConnectionController.
  ///
  /// In fr, this message translates to:
  /// **'======================='**
  String get objectConnectionController;

  /// No description provided for @apiErrorTitle.
  ///
  /// In fr, this message translates to:
  /// **'Erreur API'**
  String get apiErrorTitle;

  /// No description provided for @apiErrorCreateProfileFailed.
  ///
  /// In fr, this message translates to:
  /// **'Impossible de créer l\'objet, vérifiez votre connexion internet.'**
  String get apiErrorCreateProfileFailed;

  /// No description provided for @plantControlSwitches.
  ///
  /// In fr, this message translates to:
  /// **'======================='**
  String get plantControlSwitches;

  /// No description provided for @plantControlReasonAuto.
  ///
  /// In fr, this message translates to:
  /// **'Arrosage manuel indisponible : le mode automatique gère déjà votre plante de façon optimale.'**
  String get plantControlReasonAuto;

  /// No description provided for @plantControlReasonOffline.
  ///
  /// In fr, this message translates to:
  /// **'Impossible d\'arroser : l\'objet est hors ligne.'**
  String get plantControlReasonOffline;

  /// No description provided for @plantControlBtnWatering.
  ///
  /// In fr, this message translates to:
  /// **'ARROSAGE EN COURS...'**
  String get plantControlBtnWatering;

  /// No description provided for @plantControlBtnAuto.
  ///
  /// In fr, this message translates to:
  /// **'ARROSAGE AUTOMATIQUE'**
  String get plantControlBtnAuto;

  /// No description provided for @plantControlBtnStart.
  ///
  /// In fr, this message translates to:
  /// **'LANCER L\'ARROSAGE'**
  String get plantControlBtnStart;

  /// No description provided for @plantItemMyListWidget.
  ///
  /// In fr, this message translates to:
  /// **'======================='**
  String get plantItemMyListWidget;

  /// No description provided for @plantItemUnknownName.
  ///
  /// In fr, this message translates to:
  /// **'Nom inconnu'**
  String get plantItemUnknownName;

  /// No description provided for @plantStatusDanger.
  ///
  /// In fr, this message translates to:
  /// **'En danger'**
  String get plantStatusDanger;

  /// No description provided for @plantStatusWarning.
  ///
  /// In fr, this message translates to:
  /// **'À surveiller'**
  String get plantStatusWarning;

  /// No description provided for @plantStatusHealthy.
  ///
  /// In fr, this message translates to:
  /// **'En bonne santé'**
  String get plantStatusHealthy;

  /// No description provided for @plantStatusUnknown.
  ///
  /// In fr, this message translates to:
  /// **'Inconnu'**
  String get plantStatusUnknown;

  /// No description provided for @authRequiredDialog.
  ///
  /// In fr, this message translates to:
  /// **'======================='**
  String get authRequiredDialog;

  /// No description provided for @authRequiredTitle.
  ///
  /// In fr, this message translates to:
  /// **'Besoin de connexion'**
  String get authRequiredTitle;

  /// No description provided for @authRequiredMessage.
  ///
  /// In fr, this message translates to:
  /// **'Pour accéder à cette fonctionnalité, veuillez vous connecter ou vous inscrire. C\'est gratuit et ne prend que quelques minutes.'**
  String get authRequiredMessage;

  /// No description provided for @authRequiredBtnLogin.
  ///
  /// In fr, this message translates to:
  /// **'SE CONNECTER'**
  String get authRequiredBtnLogin;

  /// No description provided for @authRequiredBtnLater.
  ///
  /// In fr, this message translates to:
  /// **'PLUS TARD'**
  String get authRequiredBtnLater;

  /// No description provided for @connectionErrorDialog.
  ///
  /// In fr, this message translates to:
  /// **'======================='**
  String get connectionErrorDialog;

  /// No description provided for @connErrorDefaultTitle.
  ///
  /// In fr, this message translates to:
  /// **'Erreur de connexion'**
  String get connErrorDefaultTitle;

  /// No description provided for @connErrorDefaultMessage.
  ///
  /// In fr, this message translates to:
  /// **'Une erreur de connexion est survenue. Veuillez réessayer.'**
  String get connErrorDefaultMessage;

  /// No description provided for @connErrorBtnCancel.
  ///
  /// In fr, this message translates to:
  /// **'Annuler'**
  String get connErrorBtnCancel;

  /// No description provided for @connErrorBtnRetry.
  ///
  /// In fr, this message translates to:
  /// **'Réessayer'**
  String get connErrorBtnRetry;

  /// No description provided for @deleteConfirmDialog.
  ///
  /// In fr, this message translates to:
  /// **'======================='**
  String get deleteConfirmDialog;

  /// No description provided for @deleteD.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer'**
  String get deleteD;

  /// No description provided for @successDialog.
  ///
  /// In fr, this message translates to:
  /// **'======================='**
  String get successDialog;

  /// No description provided for @validateD.
  ///
  /// In fr, this message translates to:
  /// **'Valider'**
  String get validateD;

  /// No description provided for @wifiErrorDialog.
  ///
  /// In fr, this message translates to:
  /// **'======================='**
  String get wifiErrorDialog;

  /// No description provided for @wifiErrorD.
  ///
  /// In fr, this message translates to:
  /// **'Erreur Wi-Fi'**
  String get wifiErrorD;

  /// No description provided for @productCard.
  ///
  /// In fr, this message translates to:
  /// **'======================='**
  String get productCard;

  /// No description provided for @shopProductPromoBadge.
  ///
  /// In fr, this message translates to:
  /// **'PROMO'**
  String get shopProductPromoBadge;

  /// No description provided for @shopProductOutOfStock.
  ///
  /// In fr, this message translates to:
  /// **'Indisponible'**
  String get shopProductOutOfStock;

  /// No description provided for @shopProductInStock.
  ///
  /// In fr, this message translates to:
  /// **'En stock ({stock})'**
  String shopProductInStock(Object stock);

  /// No description provided for @stepProgressBar.
  ///
  /// In fr, this message translates to:
  /// **'======================='**
  String get stepProgressBar;

  /// No description provided for @progressBarCompleted.
  ///
  /// In fr, this message translates to:
  /// **'{percent}% complété'**
  String progressBarCompleted(Object percent);

  /// No description provided for @addMyObjectPage.
  ///
  /// In fr, this message translates to:
  /// **'======================='**
  String get addMyObjectPage;

  /// No description provided for @newObjectD.
  ///
  /// In fr, this message translates to:
  /// **'Nouvel objet'**
  String get newObjectD;

  /// No description provided for @addObjectMainTitle.
  ///
  /// In fr, this message translates to:
  /// **'Associez votre objet'**
  String get addObjectMainTitle;

  /// No description provided for @addObjectExplanation.
  ///
  /// In fr, this message translates to:
  /// **'Si vous possédez un objet connecté GDOME, vous êtes au bon endroit ! Commençons par associer votre objet à l\'application. Pour débuter : à quelle plante cet objet sera-t-il destiné ?'**
  String get addObjectExplanation;

  /// No description provided for @addObjectFieldName.
  ///
  /// In fr, this message translates to:
  /// **'Nom de la plante'**
  String get addObjectFieldName;

  /// No description provided for @addObjectFieldHint.
  ///
  /// In fr, this message translates to:
  /// **'Rechercher une plante (ex: Ficus...)'**
  String get addObjectFieldHint;

  /// No description provided for @addObjectBtnNotFound.
  ///
  /// In fr, this message translates to:
  /// **'Je ne trouve pas ma plante'**
  String get addObjectBtnNotFound;

  /// No description provided for @addObjectBtnOtherUsage.
  ///
  /// In fr, this message translates to:
  /// **'Objet différent d\'un pot'**
  String get addObjectBtnOtherUsage;

  /// No description provided for @addObjectOtherUsageDefaultTitle.
  ///
  /// In fr, this message translates to:
  /// **'Objet connecté'**
  String get addObjectOtherUsageDefaultTitle;

  /// No description provided for @addObjectShopText.
  ///
  /// In fr, this message translates to:
  /// **'Si vous n\'avez pas encore acheté votre objet GDOME, allons dans notre boutique pour nous dégoter votre pot !'**
  String get addObjectShopText;

  /// No description provided for @addObjectShopBtn.
  ///
  /// In fr, this message translates to:
  /// **'Aller à la boutique'**
  String get addObjectShopBtn;

  /// No description provided for @buyMyObjectPage.
  ///
  /// In fr, this message translates to:
  /// **'======================='**
  String get buyMyObjectPage;

  /// No description provided for @gdomeStoreD.
  ///
  /// In fr, this message translates to:
  /// **'Boutique GDOME'**
  String get gdomeStoreD;

  /// No description provided for @welcomeStoreD.
  ///
  /// In fr, this message translates to:
  /// **'Bienvenue dans la boutique !\nProchainement accessible... Restez connectés !'**
  String get welcomeStoreD;

  /// No description provided for @bowlDetailPage.
  ///
  /// In fr, this message translates to:
  /// **'======================='**
  String get bowlDetailPage;

  /// No description provided for @detailsBowlsD.
  ///
  /// In fr, this message translates to:
  /// **'Détails Gamelle (Bowl)'**
  String get detailsBowlsD;

  /// No description provided for @bowlPageProfileId.
  ///
  /// In fr, this message translates to:
  /// **'Page Gamelle - Profil ID: {id}'**
  String bowlPageProfileId(Object id);

  /// No description provided for @specificAnimalDesignWillBeHere.
  ///
  /// In fr, this message translates to:
  /// **'Le design spécifique des animaux sera intégré ici.'**
  String get specificAnimalDesignWillBeHere;

  /// No description provided for @addWifiInformationPage.
  ///
  /// In fr, this message translates to:
  /// **'======================='**
  String get addWifiInformationPage;

  /// No description provided for @wifiInfoTitle.
  ///
  /// In fr, this message translates to:
  /// **'Informations WIFI'**
  String get wifiInfoTitle;

  /// No description provided for @wifiInfoDescription.
  ///
  /// In fr, this message translates to:
  /// **'Pour que votre objet GDOME puisse communiquer avec vous, il doit être connecté à votre réseau domestique, celui qui sera disponible lorsque vous ne serez plus là.'**
  String get wifiInfoDescription;

  /// No description provided for @wifiPasswordHint.
  ///
  /// In fr, this message translates to:
  /// **'Votre mot de passe wifi'**
  String get wifiPasswordHint;

  /// No description provided for @wifiEmptyFieldsError.
  ///
  /// In fr, this message translates to:
  /// **'Veuillez remplir tous les champs wifi'**
  String get wifiEmptyFieldsError;

  /// No description provided for @nextButton.
  ///
  /// In fr, this message translates to:
  /// **'Suivant'**
  String get nextButton;

  /// No description provided for @addNameSpeMyObjectPage.
  ///
  /// In fr, this message translates to:
  /// **'======================='**
  String get addNameSpeMyObjectPage;

  /// No description provided for @defaultObjectTitle.
  ///
  /// In fr, this message translates to:
  /// **'Votre objet'**
  String get defaultObjectTitle;

  /// No description provided for @customConfigTitle.
  ///
  /// In fr, this message translates to:
  /// **'Configuration personnalisée'**
  String get customConfigTitle;

  /// No description provided for @customConfigGiveNameTitle.
  ///
  /// In fr, this message translates to:
  /// **'Donnez un nom à votre Objet'**
  String get customConfigGiveNameTitle;

  /// No description provided for @customConfigGiveNameDescription.
  ///
  /// In fr, this message translates to:
  /// **'Votre objet n\'est pas en rapport avec les plantes. Choisissez un nom pour différencier votre objet dans la liste.'**
  String get customConfigGiveNameDescription;

  /// No description provided for @customConfigInputLabel.
  ///
  /// In fr, this message translates to:
  /// **'Nom de l\'objet connecté'**
  String get customConfigInputLabel;

  /// No description provided for @customConfigInputHint.
  ///
  /// In fr, this message translates to:
  /// **'Ex: Capteur Salon, GDOME Bureau...'**
  String get customConfigInputHint;

  /// No description provided for @customConfigEmptyNameError.
  ///
  /// In fr, this message translates to:
  /// **'Le nom de l\'objet est obligatoire !'**
  String get customConfigEmptyNameError;

  /// No description provided for @continueButton.
  ///
  /// In fr, this message translates to:
  /// **'Continuer'**
  String get continueButton;

  /// No description provided for @advisePage.
  ///
  /// In fr, this message translates to:
  /// **'======================='**
  String get advisePage;

  /// No description provided for @helpCenterTitle.
  ///
  /// In fr, this message translates to:
  /// **'Centre d\'aide'**
  String get helpCenterTitle;

  /// No description provided for @faqCategoriesLabel.
  ///
  /// In fr, this message translates to:
  /// **'Catégories'**
  String get faqCategoriesLabel;

  /// No description provided for @faqSearchHint.
  ///
  /// In fr, this message translates to:
  /// **'Rechercher une question précise...'**
  String get faqSearchHint;

  /// No description provided for @faqFeedbackNoticeTitle.
  ///
  /// In fr, this message translates to:
  /// **'Votre avis nous fait grandir'**
  String get faqFeedbackNoticeTitle;

  /// No description provided for @faqFeedbackNoticeSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Une suggestion ? Aidez-nous à améliorer GDOME.'**
  String get faqFeedbackNoticeSubtitle;

  /// No description provided for @faqFeedbackNoticeButton.
  ///
  /// In fr, this message translates to:
  /// **'Partager mon expérience'**
  String get faqFeedbackNoticeButton;

  /// No description provided for @faqNoResultsFound.
  ///
  /// In fr, this message translates to:
  /// **'Aucune réponse trouvée'**
  String get faqNoResultsFound;

  /// No description provided for @plantDetailPage.
  ///
  /// In fr, this message translates to:
  /// **'======================='**
  String get plantDetailPage;

  /// No description provided for @sessionExpired.
  ///
  /// In fr, this message translates to:
  /// **'Session expirée'**
  String get sessionExpired;

  /// No description provided for @errorPrefix.
  ///
  /// In fr, this message translates to:
  /// **'Erreur :'**
  String get errorPrefix;

  /// No description provided for @addedToFavorites.
  ///
  /// In fr, this message translates to:
  /// **'Ajout aux favoris...'**
  String get addedToFavorites;

  /// No description provided for @removedFromFavorites.
  ///
  /// In fr, this message translates to:
  /// **'Retrait des favoris...'**
  String get removedFromFavorites;

  /// No description provided for @deviceOptionsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Options de l\'appareil'**
  String get deviceOptionsTitle;

  /// No description provided for @wateringSettingsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Réglages d\'arrosage'**
  String get wateringSettingsTitle;

  /// No description provided for @wateringSettingsSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Ajuster les cibles d\'arrosage automatique'**
  String get wateringSettingsSubtitle;

  /// No description provided for @modifyWifiTitle.
  ///
  /// In fr, this message translates to:
  /// **'Modifier le Wi-Fi'**
  String get modifyWifiTitle;

  /// No description provided for @modifyWifiSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Changer le réseau réseau de l\'objet'**
  String get modifyWifiSubtitle;

  /// No description provided for @helpFaqTitle.
  ///
  /// In fr, this message translates to:
  /// **'Aide & FAQ'**
  String get helpFaqTitle;

  /// No description provided for @helpFaqSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Questions fréquentes et guide d\'utilisation'**
  String get helpFaqSubtitle;

  /// No description provided for @groupPrefix.
  ///
  /// In fr, this message translates to:
  /// **'Groupe:'**
  String get groupPrefix;

  /// No description provided for @stateSensorsTitle.
  ///
  /// In fr, this message translates to:
  /// **'État des capteurs'**
  String get stateSensorsTitle;

  /// No description provided for @noDescription.
  ///
  /// In fr, this message translates to:
  /// **'Pas de description'**
  String get noDescription;

  /// No description provided for @aboutTitle.
  ///
  /// In fr, this message translates to:
  /// **'À propos'**
  String get aboutTitle;

  /// No description provided for @maintenanceAdviceTitle.
  ///
  /// In fr, this message translates to:
  /// **'Conseil d\'entretien'**
  String get maintenanceAdviceTitle;

  /// No description provided for @noMaintenanceAdvice.
  ///
  /// In fr, this message translates to:
  /// **'Aucun conseil d\'entretien pour le moment.'**
  String get noMaintenanceAdvice;

  /// No description provided for @deviceOptionsSectionTitle.
  ///
  /// In fr, this message translates to:
  /// **'Options de l\'objet'**
  String get deviceOptionsSectionTitle;

  /// No description provided for @wateringParamsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Paramètres d\'arrosage'**
  String get wateringParamsTitle;

  /// No description provided for @wifiModificationTitle.
  ///
  /// In fr, this message translates to:
  /// **'Modification Wi-Fi'**
  String get wifiModificationTitle;

  /// No description provided for @wifiModificationSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Reconnecter ou changer le réseau de l\'objet'**
  String get wifiModificationSubtitle;

  /// No description provided for @helpFaqObjectSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Questions fréquentes et guide de l\'objet'**
  String get helpFaqObjectSubtitle;

  /// No description provided for @deleteObjectTitle.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer cet objet'**
  String get deleteObjectTitle;

  /// No description provided for @deleteObjectSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Dissocier définitivement le pot connecté'**
  String get deleteObjectSubtitle;

  /// No description provided for @connectedStable.
  ///
  /// In fr, this message translates to:
  /// **'Objet bien connecté à l\'application'**
  String get connectedStable;

  /// No description provided for @connectedUnstable.
  ///
  /// In fr, this message translates to:
  /// **'Perte de contact avec la plante !'**
  String get connectedUnstable;

  /// No description provided for @autoModeActive.
  ///
  /// In fr, this message translates to:
  /// **'MODE AUTOMATIQUE ACTIVÉ'**
  String get autoModeActive;

  /// No description provided for @manualModeActive.
  ///
  /// In fr, this message translates to:
  /// **'MODE MANUEL ACTIVÉ'**
  String get manualModeActive;

  /// No description provided for @autoModeDesc.
  ///
  /// In fr, this message translates to:
  /// **'Le mode automatique est activé : le pot se comportera selon les paramètres optimaux définis pour votre plante.'**
  String get autoModeDesc;

  /// No description provided for @manualModeDesc.
  ///
  /// In fr, this message translates to:
  /// **'Attention ! Le pot ne prendra aucune décision d\'arrosage. Ce mode permet la surveillance et l\'arrosage à distance. Notez que le maintien de cette connexion permanente est particulièrement énergivore. Afin de préserver l\'autonomie de la batterie, nous vous conseillons d\'utiliser cette fonctionnalité avec modération et de surveiller régulièrement le niveau de batterie de votre objet.'**
  String get manualModeDesc;

  /// No description provided for @deleteDialogTitle.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer les réglages'**
  String get deleteDialogTitle;

  /// No description provided for @deleteDialogMessage.
  ///
  /// In fr, this message translates to:
  /// **'Voulez-vous vraiment supprimer votre plante {plantTitle} ?'**
  String deleteDialogMessage(Object plantTitle);

  /// No description provided for @deleteSuccess.
  ///
  /// In fr, this message translates to:
  /// **'Profil supprimé avec succès'**
  String get deleteSuccess;

  /// No description provided for @deleteForbidden.
  ///
  /// In fr, this message translates to:
  /// **'Impossible : l\'objet est connecté et en mode AUTO.'**
  String get deleteForbidden;

  /// No description provided for @deleteError.
  ///
  /// In fr, this message translates to:
  /// **'Erreur lors de la suppression.'**
  String get deleteError;

  /// No description provided for @sensorTemp.
  ///
  /// In fr, this message translates to:
  /// **'Température'**
  String get sensorTemp;

  /// No description provided for @sensorFertility.
  ///
  /// In fr, this message translates to:
  /// **'Fertilité'**
  String get sensorFertility;

  /// No description provided for @sensorHumAir.
  ///
  /// In fr, this message translates to:
  /// **'Humidité Air'**
  String get sensorHumAir;

  /// No description provided for @sensorLight.
  ///
  /// In fr, this message translates to:
  /// **'Luminosité'**
  String get sensorLight;

  /// No description provided for @sensorTarget.
  ///
  /// In fr, this message translates to:
  /// **'Cible: {target}'**
  String sensorTarget(Object target);

  /// No description provided for @sunExposureToday.
  ///
  /// In fr, this message translates to:
  /// **'EXPOSITION SOLEIL AUJOURD\'HUI : {status}'**
  String sunExposureToday(Object status);

  /// No description provided for @analysisProTitle.
  ///
  /// In fr, this message translates to:
  /// **'ANALYSE PRO AUTO'**
  String get analysisProTitle;

  /// No description provided for @analysisLoading.
  ///
  /// In fr, this message translates to:
  /// **'Analyse en cours...'**
  String get analysisLoading;

  /// No description provided for @uvNoData.
  ///
  /// In fr, this message translates to:
  /// **'Aucune donnée de luminosité reçue aujourd\'hui.'**
  String get uvNoData;

  /// No description provided for @uvLowData.
  ///
  /// In fr, this message translates to:
  /// **'Luminosité faible aujourd\'hui. Votre plante manque un peu de clarté pour s\'épanouir pleinement.'**
  String get uvLowData;

  /// No description provided for @uvMediumData.
  ///
  /// In fr, this message translates to:
  /// **'Ensoleillement doux. Un bain de lumière équilibré pour l\'énergie de votre plante.'**
  String get uvMediumData;

  /// No description provided for @uvHighData.
  ///
  /// In fr, this message translates to:
  /// **'Exposition forte ! Surveillez l\'état des feuilles tout de même, le soleil tape fort aujourd\'hui.'**
  String get uvHighData;

  /// No description provided for @uvExtremeData.
  ///
  /// In fr, this message translates to:
  /// **'Rayonnement extrême ! Risque de brûlure. Protégez votre plante ou déplacez l\'objet à l\'ombre.'**
  String get uvExtremeData;

  /// No description provided for @uvDisplayNone.
  ///
  /// In fr, this message translates to:
  /// **'Aucune'**
  String get uvDisplayNone;

  /// No description provided for @uvDisplayLow.
  ///
  /// In fr, this message translates to:
  /// **'Faible'**
  String get uvDisplayLow;

  /// No description provided for @uvDisplayModerate.
  ///
  /// In fr, this message translates to:
  /// **'Modéré'**
  String get uvDisplayModerate;

  /// No description provided for @uvDisplayHigh.
  ///
  /// In fr, this message translates to:
  /// **'Élevé'**
  String get uvDisplayHigh;

  /// No description provided for @uvDisplayVeryHigh.
  ///
  /// In fr, this message translates to:
  /// **'Très Élevé'**
  String get uvDisplayVeryHigh;

  /// No description provided for @uvDisplayCritical.
  ///
  /// In fr, this message translates to:
  /// **'Critique !'**
  String get uvDisplayCritical;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'fr': return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
