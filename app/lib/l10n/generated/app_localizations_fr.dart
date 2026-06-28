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
  String get myPlantPageNoLogin => '=======================';

  @override
  String get signupButton => 'Créer mon compte GDOME';

  @override
  String get frenchCreation => 'Création connectée française';

  @override
  String get welcomeGdome => 'Bienvenue chez GDOME';

  @override
  String get systemeSentence => 'L\'écosystème domotique qui réinvente votre relation avec la nature et votre intérieur.';

  @override
  String get iConnect => 'Je me connecte';

  @override
  String get ourVision => 'Notre vision';

  @override
  String get smartPots => 'Pots Intelligents';

  @override
  String get plantNeed => 'Vos plantes dictent leurs besoins en temps réel grâce à nos capteurs haute précision.';

  @override
  String get tomorrow => 'Demain...';

  @override
  String get bowlNeed => 'Un écosystème en expansion : gamelles connectées, soin des animaux et confort global.';

  @override
  String get newComany => 'Une jeune pousse passionnée';

  @override
  String get newComanyDesc => 'GDOME est une toute nouvelle entreprise française. Notre mission est d\'allier le respect du vivant à l\'intelligence de la maison connectée, sans compromis sur le design.';

  @override
  String get objectQuestion => 'Des questions sur nos objets ?';

  @override
  String get faqDiscovery => 'Explorez notre Centre d\'aide';

  @override
  String get myPlantPage => '=======================';

  @override
  String get myFavorites => 'Mes favoris';

  @override
  String get noFoundItems => 'Aucun objets trouvés.';

  @override
  String get myList => 'Ma Liste';

  @override
  String get emptyStateWidget => '=======================';

  @override
  String get myFavoritesEmptyTitle => 'Aucun favori pour l\'instant';

  @override
  String get myFavoritesEmptySubtitle => 'Ajoute tes objets en favoris pour les retrouver ici en un clin d\'œil.';

  @override
  String get myListEmptyTitle => 'Ta collection est vide';

  @override
  String get myListEmptySubtitle => 'Commence à ajouter tes objets connectés GDOME pour suivre leur santé en temps réel.';

  @override
  String get loginPage => '=======================';

  @override
  String get incorrectId => 'Identifiants incorrects. Veuillez réessayer.';

  @override
  String get happySeeYou => 'Heureux de vous revoir !';

  @override
  String get cultivateInside => 'Cultivez votre bien-être intérieur.';

  @override
  String get email => 'Email';

  @override
  String get emailExample => 'votre@email.com';

  @override
  String get invalidEmail => 'Format d\'email invalide';

  @override
  String get password => 'Mot de passe';

  @override
  String get suspension => '••••••••';

  @override
  String get tooShortPassword => 'Mot de passe trop court';

  @override
  String get forgotPassword => 'Mot de passe oublié ?';

  @override
  String get loginMaj => 'SE CONNECTER';

  @override
  String get noAccount => 'Pas encore de compte ?';

  @override
  String get signUp => 'Inscrivez-vous';

  @override
  String get signupPage => '=======================';

  @override
  String get signUpFailure => 'Échec de l\'inscription. Ce pseudo ou cet email est peut-être déjà utilisé.';

  @override
  String get oops => 'Oups !';

  @override
  String get ok => 'OK';

  @override
  String get createAnAccount => 'Créer un compte';

  @override
  String get joinAdventure => 'Rejoignez l\'aventure GDOME en quelques secondes.';

  @override
  String get pseudo => 'Pseudo';

  @override
  String get pseudoQuestion => 'Comment doit-on vous appeler ?';

  @override
  String get confirmation => 'Confirmation';

  @override
  String get confirmationQuestion => 'Confirmez votre mot de passe';

  @override
  String get differentPasswords => 'Les mots de passe diffèrent';

  @override
  String get signUpMaj => 'S\'INSCRIRE';

  @override
  String get alreadyAccount => 'Déjà un compte ?';

  @override
  String get login => 'Se connecter';

  @override
  String get signupValidationPage => '=======================';

  @override
  String get welcome => 'Bienvenue !';

  @override
  String get startMaj => 'COMMENCER';

  @override
  String get verification => 'Vérification';

  @override
  String signupValidationDesc(Object userEmail) {
    return 'Saisissez le code de 6 chiffres envoyé à\n$userEmail';
  }

  @override
  String signupResendCodeTimer(Object seconds) {
    return 'Renvoyer le code dans $seconds s';
  }

  @override
  String get signupResendCode => 'Renvoyer le code';

  @override
  String get sendNewCode => 'Un nouveau code a été envoyé !';

  @override
  String get failureSendTryLater => 'Échec de l\'envoi. Réessayez plus tard.';

  @override
  String get accountValidationMaj => 'VALIDER MON COMPTE';

  @override
  String get profilePage => '=======================';

  @override
  String get user => 'Utilisateur';

  @override
  String get noAddressEmail => 'Pas d\'adresse email';

  @override
  String get identity => 'Identité';

  @override
  String get noSpecified => 'Non renseigné';

  @override
  String get manageMyApp => 'Gérer mon application';

  @override
  String get security => 'Sécurité';

  @override
  String get changePassword => 'Modifier le mot de passe';

  @override
  String get myItems => 'Mes objets';

  @override
  String get manageMyDevices => 'Gérer mes appareils';

  @override
  String get favoritesItems => 'Éléments préférés';

  @override
  String get faq => 'FAQ';

  @override
  String get helpCenter => 'Centre d\'aide';

  @override
  String get leaveReview => 'Donner mon avis';

  @override
  String get shareExperience => 'Partagez votre expérience et aidez-nous à nous améliorer !';

  @override
  String get logOut => 'Se déconnecter';

  @override
  String get forgotPasswordPage => '=======================';

  @override
  String get failureSendMail => 'Une erreur est survenue lors de l\'envoi du mail. Vérifiez votre connexion ou l\'adresse saisie.';

  @override
  String get retry => 'Réessayer';

  @override
  String get enterMailRetrieve => 'Entrez l\'adresse e-mail associée à votre compte. Nous vous enverrons un code pour réinitialiser votre mot de passe.';

  @override
  String get sendTheCodeMaj => 'ENVOYER LE CODE';

  @override
  String get back => 'Retour';

  @override
  String get yourEmail => 'Votre Email';

  @override
  String get enterYourEmail => 'Veuillez entrer votre email';

  @override
  String get getCodeEmailPage => '=======================';

  @override
  String get enterMailReceived => 'Veuillez entrer le code reçu par mail.';

  @override
  String get codeContainLimit => 'Le code doit comporter 6 chiffres.';

  @override
  String get invalidCode => 'Code invalide';

  @override
  String get incorrectCode => 'Le code saisi est incorrect ou a expiré. Veuillez réessayer.';

  @override
  String get enterCodeDigits => 'Entrez le code à 6 chiffres envoyé à';

  @override
  String get hintZeroSix => '000000';

  @override
  String get confirmationMaj => 'CONFIRMER';

  @override
  String get signupResendCodeIn => 'Renvoyer le code dans ';

  @override
  String get resetPasswordPage => '=======================';

  @override
  String get retrySessionExpire => 'Session expirée. Veuillez recommencer.';

  @override
  String get expiredCode => 'Le code a expiré ou est invalide.';

  @override
  String get passwordChangeNoConnected => 'Mot de passe changé, mais erreur de connexion. Connectez-vous manuellement.';

  @override
  String get updatePassword => 'Mot de passe mis à jour !';

  @override
  String get autoLoginLoading => 'Connexion automatique en cours...';

  @override
  String get successPasswordConnectOk => 'Mot de passe modifié avec succès ! Vous pouvez maintenant vous connecter.';

  @override
  String get loginBackMaj => 'RETOUR À LA CONNEXION';

  @override
  String get newPasswordLine => 'Nouveau\nmot de passe';

  @override
  String get createNewStrongPassword => 'Créez un mot de passe fort pour sécuriser votre compte.';

  @override
  String get newPassword => 'Nouveau mot de passe';

  @override
  String get confirmationThePassword => 'Confirmer le mot de passe';

  @override
  String get resetMaj => 'RÉINITIALISER';

  @override
  String get limitChar => '6 caractères minimum';

  @override
  String get myObjectProfilePage => '=======================';

  @override
  String get connectedDevices => 'Mes Objets Connectés';

  @override
  String get failureChargeCategories => 'Impossible de charger vos catégories.';

  @override
  String get noDevicesForMoment => 'Aucun objet enregistré pour le moment.';

  @override
  String get myFavoriteCatalogPage => '=======================';

  @override
  String get myFavoritesMajD => 'Mes Favoris';

  @override
  String get failureChargeFavorites => 'Impossible de charger vos favoris.';

  @override
  String get noFavoritesForMoment => 'Aucun favori pour le moment';

  @override
  String get noticePage => '=======================';

  @override
  String get completeAllField => 'Veuillez compléter les champs obligatoires';

  @override
  String get thanksForFeedback => 'Merci pour votre retour !';

  @override
  String get occurredError => 'Une erreur est survenue';

  @override
  String get commentsMaj => 'COMMENTAIRES';

  @override
  String get experienceBack => 'Votre expérience nous intéresse';

  @override
  String get experienceBackDesc => 'Parce qu\'on sait que tout n\'est pas toujours parfait, votre retour est précieux pour faire progresser la nouvelle aventure GDOME chaque jour.';

  @override
  String get noticeSubject => 'Sujet de l\'avis';

  @override
  String get enterTitle => 'Saisissez un titre';

  @override
  String get itemConcerned => 'Objet concerné (Optionnel)';

  @override
  String get categoryD => 'Catégorie';

  @override
  String get selectCategory => 'Sélectionnez une catégorie';

  @override
  String get yourMessage => 'Votre message';

  @override
  String get noEmptyContent => 'Le contenu ne peut pas être vide';

  @override
  String get sendBackMaj => 'ENVOYER MON RETOUR';

  @override
  String get shoppingPage => '=======================';

  @override
  String get modelSearch => 'Rechercher un modèle...';

  @override
  String get allD => 'Tous';

  @override
  String get noAvailableProduct => 'Aucun produit disponible';

  @override
  String cartArticlesAdded(Object qty) {
    return '$qty article(s) ajouté(s) au panier !';
  }

  @override
  String get failureAddAskTry => 'Erreur lors de l\'ajout. Réessayez.';

  @override
  String get gdomeMaj => 'GDOME';

  @override
  String get theExperience => 'L\'expérience';

  @override
  String get technicalSpecifications => 'Fiche technique';

  @override
  String productInStock(Object count) {
    return 'En stock ($count unités)';
  }

  @override
  String get outOfStock => 'Actuellement épuisé';

  @override
  String get productNotFound => 'Produit introuvable';

  @override
  String get backToCatalogMaj => 'RETOURNER AU CATALOGUE';

  @override
  String get shoppingProductBottomBarPage => '=======================';

  @override
  String get buyNowMaj => 'ACHETER MAINTENANT';

  @override
  String get outOfStockMaj => 'ÉPUISÉ';

  @override
  String get shoppingProductTrustPage => '=======================';

  @override
  String get badgeSecurePay => 'Paiement\nSécurisé';

  @override
  String get badgeHighPrecision => 'Conception\n Haute Précision';

  @override
  String get badgeSatisfaction => 'Satisfaction\nAssurée';

  @override
  String get plantDetailKnownPage => '=======================';

  @override
  String get plantNotFound => 'Plante introuvable';

  @override
  String get descriptionD => 'Description';

  @override
  String get expertTips => 'Conseils d\'expert';

  @override
  String get lifeCalendar => 'Calendrier de vie';

  @override
  String get scientificName => 'Nom scientifique : ';

  @override
  String get unknownD => 'Inconnue';

  @override
  String get familyD => 'Famille';

  @override
  String plantFamilyLabel(Object familyName) {
    return 'Famille : $familyName';
  }

  @override
  String get metricHeight => 'Hauteur';

  @override
  String get metricSun => 'Soleil/j';

  @override
  String get metricPlanting => 'Plantation';

  @override
  String get plantNoSpecificAdvise => 'Pas de conseils spécifiques.';

  @override
  String get needsAndEnv => 'Besoins & Environnement';

  @override
  String get plantExposure => 'Exposition';

  @override
  String get plantGround => 'Sol';

  @override
  String get seasonSpring => 'Printemps';

  @override
  String get seasonSummer => 'Été';

  @override
  String get seasonAutumn => 'Automne';

  @override
  String get seasonWinter => 'Hiver';

  @override
  String get orderValidationPage => '=======================';

  @override
  String get congratulationsD => 'Félicitations !';

  @override
  String get validateOrder => 'Votre commande a été validée avec succès et est en cours de préparation.';

  @override
  String get yourOrderMaj => 'VOTRE COMMANDE';

  @override
  String get deliveryAddressMaj => 'ADRESSE DE LIVRAISON';

  @override
  String get totalAmountPaidD => 'Montant total réglé';

  @override
  String get backToHomeMaj => 'RETOURNER À L\'ACCUEIL';

  @override
  String get trackMyOrdersD => 'Suivre mes commandes';

  @override
  String get orderPaymentPage => '=======================';

  @override
  String get summaryD => 'Récapitulatif';

  @override
  String get deliveryToMAJ => 'LIVRAISON À';

  @override
  String get subtotalD => 'Sous-total';

  @override
  String get deliveryD => 'Livraison';

  @override
  String get freeD => 'Offerte';

  @override
  String get totalMaj => 'TOTAL';

  @override
  String get unableToInitThePayment => 'Impossible d\'initialiser le paiement.';

  @override
  String paymentNotFinalized(Object errorMessage) {
    return 'Paiement non finalisé : $errorMessage';
  }

  @override
  String get paymentErrorGeneric => 'Une erreur est survenue lors du paiement. Veuillez réessayer.';

  @override
  String btnConfirmAndPay(Object price) {
    return 'CONFIRMER ET PAYER $price';
  }

  @override
  String get orderAddressPage => '=======================';

  @override
  String get franceD => 'France';

  @override
  String get yourAddressMaj => 'VOS ADRESSES';

  @override
  String get orderSummaryMaj => 'RÉSUMÉ COMMANDE';

  @override
  String get addressD => 'Adresse';

  @override
  String get useAnotherAddress => 'Utiliser une autre adresse';

  @override
  String get addAnDeliveryAddressMaj => 'AJOUTER UNE ADRESSE DE LIVRAISON';

  @override
  String get nameAddressD => 'Nom de l\'adresse (Maison, Bureau...)';

  @override
  String get enterAddressD => 'Saisissez votre adresse...';

  @override
  String get additionalInformationD => 'Complément (Appartement, Étage...)';

  @override
  String get postalCodeD => 'Code Postal';

  @override
  String get cityD => 'Ville';

  @override
  String get countryD => 'Pays';

  @override
  String get setAsDefaultD => 'Définir par défaut';

  @override
  String get chooseAnAddressMaj => 'CHOISIR UNE ADRESSE';

  @override
  String get validateAddressMaj => 'VALIDER CETTE ADRESSE';

  @override
  String get fillInTheFieldsMaj => 'REMPLIR LES CHAMPS';

  @override
  String btnConfirmOrderMaj(Object price) {
    return 'CONFIRMER $price';
  }

  @override
  String get btnChooseAddressMaj => 'CHOISIR UNE ADRESSE';

  @override
  String get modificationWifiMyObjectPage => '=======================';

  @override
  String get wifiConfigTitle => 'Configuration WiFi';

  @override
  String wifiUpdateForObject(Object objectTitle) {
    return 'Mise à jour pour $objectTitle';
  }

  @override
  String get wifiRangeWarning => 'Assurez-vous que votre objet est à portée lors de la modification.';

  @override
  String get wifiSsidLabel => 'Nom du réseau (SSID)';

  @override
  String get exampleWifiSsidLabel => 'Ex: MaBox_WiFi';

  @override
  String get wifiPasswordLabel => 'Mot de passe';

  @override
  String get wifiBtnModify => 'Modifier mon WiFi';

  @override
  String get wifiErrorEmptyFields => 'Veuillez remplir tous les champs';

  @override
  String get modificationWifiConnectPage => '=======================';

  @override
  String get wifiConnectSuccessHeader => 'Configuration réussie !';

  @override
  String get wifiConnectSearchHeader => 'Connexion au réseau';

  @override
  String get wifiConnectSeconds => 'secondes';

  @override
  String get wifiConnectWait => 'Veuillez patienter...';

  @override
  String get wifiConnectBtnFinish => 'Terminer';

  @override
  String get wifiConnectBtnRetry => 'Réessayer';

  @override
  String get wifiConnectLedStatus => 'Statut LED de l\'objet';

  @override
  String get wifiStatusSearchTitle => 'Recherche de l\'objet...';

  @override
  String get wifiStatusSearchSubtitle => 'Assurez-vous que l\'objet est à proximité et allumé. Activer le mode manuel de votre objet puis appuyer sur le bouton BLEU.';

  @override
  String get wifiStatusProcessingTitle => 'Tentative de connexion...';

  @override
  String get wifiStatusProcessingSubtitle => 'L\'objet essaie de rejoindre votre WiFi. La LED doit clignoter.';

  @override
  String get wifiStatusSuccessTitle => 'Tout est prêt !';

  @override
  String get wifiStatusSuccessSubtitle => 'L\'objet est maintenant connecté. La LED bleu doit disparaître.';

  @override
  String get wifiStatusErrorTitle => 'Une erreur est survenue';

  @override
  String get wifiStatusErrorSubtitleFallback => 'Vérifiez que votre SSID et mot de passe WiFi sont corrects.';

  @override
  String get wifiErrorBluetoothOff => 'Bluetooth désactivé. Veuillez l\'activer.';

  @override
  String get wifiErrorScanFailed => 'Impossible de scanner les environs.';

  @override
  String get wifiErrorConnectionLost => 'Connexion avec l\'objet perdue.';

  @override
  String get wifiErrorTimeout => 'L\'objet met trop de temps à répondre.';

  @override
  String get wifiErrorWrongProfile => 'Ce pot appartient à un autre Profil créé. Action refusée. Vérifier l\'identitée de pots';

  @override
  String wifiErrorConnectionFailed(Object ssid) {
    return 'L\'objet n\'a pas pu se connecter à $ssid.';
  }

  @override
  String get homePageNoLogin => '=======================';

  @override
  String get homeTitleAdvise => 'Conseils & Expertises';

  @override
  String get homeTitleShop => 'Boutique GDOME';

  @override
  String get homeTooltipProfile => 'Profil';

  @override
  String get navTabAdvise => 'Conseils';

  @override
  String get navTabMyObjects => 'Mes objets';

  @override
  String get navTabShop => 'Magasin';

  @override
  String get homePage => '=======================';

  @override
  String get homeTitleEquipment => 'Mes Équipements';

  @override
  String get homeTooltipMyProfile => 'Mon Profil';

  @override
  String get addConnectMyObjectPage => '=======================';

  @override
  String get addObjTitle => 'Connexion';

  @override
  String get addObjStepTitle => 'Connectons votre objet !';

  @override
  String addObjStepDesc(Object plantName) {
    return 'Nous allons enfin pouvoir connecter votre $plantName à notre objet. Appuyez sur le bouton bleu de l\'objet pour que notre application puisse le détecter.';
  }

  @override
  String get addObjDefaultPlantName => 'votre plante';

  @override
  String get addObjRecapPlant => 'Plante';

  @override
  String get addObjRecapNetwork => 'Réseau';

  @override
  String get addObjRecapUnknown => 'Inconnu';

  @override
  String get addObjRecapId => 'ID Objet';

  @override
  String get addObjStatusCreating => 'Création de votre profil plante...';

  @override
  String get addObjStatusSearching => 'Recherche de l\'objet...';

  @override
  String get addObjBtnSearching => 'Recherche...';

  @override
  String get addObjBtnCreating => 'Création profil...';

  @override
  String get addObjBtnStart => 'Lancer la connexion';

  @override
  String get addObjDialogAlreadyLinkedTitle => 'Objet déjà associé';

  @override
  String addObjDialogAlreadyLinkedDesc(Object flowerName) {
    return 'Cet objet est déjà lié à la fleur \'$flowerName\'.\n\nVeuillez d\'abord supprimer la fleur associée dans vos paramètres.';
  }

  @override
  String get addObjDialogBtnUnderstand => 'COMPRIS';

  @override
  String get addObjDialogSuccessTitle => 'Félicitations !';

  @override
  String addObjDialogSuccessDesc(Object plantName) {
    return 'Votre $plantName est configurée et activée !';
  }

  @override
  String get addObjErrorNoResponse => 'L\'objet ne répond plus. Profil annulé.';

  @override
  String get addObjErrorWifiFailed => 'L\'objet n\'a pas pu se connecter au Wi-Fi. Le profil a été annulé.';

  @override
  String get addObjErrorNoResponseConn => 'L\'objet ne répond plus. Connexion annulée.';

  @override
  String get loginD => 'Connexion';

  @override
  String get plantDetailContent => '=======================';

  @override
  String get plantDetailTitle => 'Détail de la plante';

  @override
  String get plantDetailNoDescription => 'Pas de description';

  @override
  String get plantDetailBtnClose => 'Fermer';

  @override
  String get plantDetailSectionControls => 'Contrôles';

  @override
  String get plantDetailWrapper => '=======================';

  @override
  String get noAvailableToken => 'Token non disponible';

  @override
  String get sensorValue => '=======================';

  @override
  String get noAvailableD => 'Non disponible';

  @override
  String get objectConnectionController => '=======================';

  @override
  String get apiErrorTitle => 'Erreur API';

  @override
  String get apiErrorCreateProfileFailed => 'Impossible de créer l\'objet, vérifiez votre connexion internet.';

  @override
  String get plantControlSwitches => '=======================';

  @override
  String get plantControlReasonAuto => 'Arrosage manuel indisponible : le mode automatique gère déjà votre plante de façon optimale.';

  @override
  String get plantControlReasonOffline => 'Impossible d\'arroser : l\'objet est hors ligne.';

  @override
  String get plantControlBtnWatering => 'ARROSAGE EN COURS...';

  @override
  String get plantControlBtnAuto => 'ARROSAGE AUTOMATIQUE';

  @override
  String get plantControlBtnStart => 'LANCER L\'ARROSAGE';

  @override
  String get plantItemMyListWidget => '=======================';

  @override
  String get plantItemUnknownName => 'Nom inconnu';

  @override
  String get plantStatusDanger => 'En danger';

  @override
  String get plantStatusWarning => 'À surveiller';

  @override
  String get plantStatusHealthy => 'En bonne santé';

  @override
  String get plantStatusUnknown => 'Inconnu';

  @override
  String get authRequiredDialog => '=======================';

  @override
  String get authRequiredTitle => 'Besoin de connexion';

  @override
  String get authRequiredMessage => 'Pour accéder à cette fonctionnalité, veuillez vous connecter ou vous inscrire. C\'est gratuit et ne prend que quelques minutes.';

  @override
  String get authRequiredBtnLogin => 'SE CONNECTER';

  @override
  String get authRequiredBtnLater => 'PLUS TARD';

  @override
  String get connectionErrorDialog => '=======================';

  @override
  String get connErrorDefaultTitle => 'Erreur de connexion';

  @override
  String get connErrorDefaultMessage => 'Une erreur de connexion est survenue. Veuillez réessayer.';

  @override
  String get connErrorBtnCancel => 'Annuler';

  @override
  String get connErrorBtnRetry => 'Réessayer';

  @override
  String get deleteConfirmDialog => '=======================';

  @override
  String get deleteD => 'Supprimer';

  @override
  String get successDialog => '=======================';

  @override
  String get validateD => 'Valider';

  @override
  String get wifiErrorDialog => '=======================';

  @override
  String get wifiErrorD => 'Erreur Wi-Fi';

  @override
  String get productCard => '=======================';

  @override
  String get shopProductPromoBadge => 'PROMO';

  @override
  String get shopProductOutOfStock => 'Indisponible';

  @override
  String shopProductInStock(Object stock) {
    return 'En stock ($stock)';
  }

  @override
  String get stepProgressBar => '=======================';

  @override
  String progressBarCompleted(Object percent) {
    return '$percent% complété';
  }

  @override
  String get addMyObjectPage => '=======================';

  @override
  String get newObjectD => 'Nouvel objet';

  @override
  String get addObjectMainTitle => 'Associez votre objet';

  @override
  String get addObjectExplanation => 'Si vous possédez un objet connecté GDOME, vous êtes au bon endroit ! Commençons par associer votre objet à l\'application. Pour débuter : à quelle plante cet objet sera-t-il destiné ?';

  @override
  String get addObjectFieldName => 'Nom de la plante';

  @override
  String get addObjectFieldHint => 'Rechercher une plante (ex: Ficus...)';

  @override
  String get addObjectBtnNotFound => 'Je ne trouve pas ma plante';

  @override
  String get addObjectBtnOtherUsage => 'Objet différent d\'un pot';

  @override
  String get addObjectOtherUsageDefaultTitle => 'Objet connecté';

  @override
  String get addObjectShopText => 'Si vous n\'avez pas encore acheté votre objet GDOME, allons dans notre boutique pour nous dégoter votre pot !';

  @override
  String get addObjectShopBtn => 'Aller à la boutique';

  @override
  String get buyMyObjectPage => '=======================';

  @override
  String get gdomeStoreD => 'Boutique GDOME';

  @override
  String get welcomeStoreD => 'Bienvenue dans la boutique !\nProchainement accessible... Restez connectés !';

  @override
  String get bowlDetailPage => '=======================';

  @override
  String get detailsBowlsD => 'Détails Gamelle (Bowl)';

  @override
  String bowlPageProfileId(Object id) {
    return 'Page Gamelle - Profil ID: $id';
  }

  @override
  String get specificAnimalDesignWillBeHere => 'Le design spécifique des animaux sera intégré ici.';

  @override
  String get addWifiInformationPage => '=======================';

  @override
  String get wifiInfoTitle => 'Informations WIFI';

  @override
  String get wifiInfoDescription => 'Pour que votre objet GDOME puisse communiquer avec vous, il doit être connecté à votre réseau domestique, celui qui sera disponible lorsque vous ne serez plus là.';

  @override
  String get wifiPasswordHint => 'Votre mot de passe wifi';

  @override
  String get wifiEmptyFieldsError => 'Veuillez remplir tous les champs wifi';

  @override
  String get nextButton => 'Suivant';

  @override
  String get addNameSpeMyObjectPage => '=======================';

  @override
  String get defaultObjectTitle => 'Votre objet';

  @override
  String get customConfigTitle => 'Configuration personnalisée';

  @override
  String get customConfigGiveNameTitle => 'Donnez un nom à votre Objet';

  @override
  String get customConfigGiveNameDescription => 'Votre objet n\'est pas en rapport avec les plantes. Choisissez un nom pour différencier votre objet dans la liste.';

  @override
  String get customConfigInputLabel => 'Nom de l\'objet connecté';

  @override
  String get customConfigInputHint => 'Ex: Capteur Salon, GDOME Bureau...';

  @override
  String get customConfigEmptyNameError => 'Le nom de l\'objet est obligatoire !';

  @override
  String get continueButton => 'Continuer';

  @override
  String get advisePage => '=======================';

  @override
  String get helpCenterTitle => 'Centre d\'aide';

  @override
  String get faqCategoriesLabel => 'Catégories';

  @override
  String get faqSearchHint => 'Rechercher une question précise...';

  @override
  String get faqFeedbackNoticeTitle => 'Votre avis nous fait grandir';

  @override
  String get faqFeedbackNoticeSubtitle => 'Une suggestion ? Aidez-nous à améliorer GDOME.';

  @override
  String get faqFeedbackNoticeButton => 'Partager mon expérience';

  @override
  String get faqNoResultsFound => 'Aucune réponse trouvée';

  @override
  String get plantDetailPage => '=======================';

  @override
  String get sessionExpired => 'Session expirée';

  @override
  String get errorPrefix => 'Erreur :';

  @override
  String get addedToFavorites => 'Ajout aux favoris...';

  @override
  String get removedFromFavorites => 'Retrait des favoris...';

  @override
  String get deviceOptionsTitle => 'Options de l\'appareil';

  @override
  String get wateringSettingsTitle => 'Réglages d\'arrosage';

  @override
  String get wateringSettingsSubtitle => 'Ajuster les cibles d\'arrosage automatique';

  @override
  String get modifyWifiTitle => 'Modifier le Wi-Fi';

  @override
  String get modifyWifiSubtitle => 'Changer le réseau réseau de l\'objet';

  @override
  String get helpFaqTitle => 'Aide & FAQ';

  @override
  String get helpFaqSubtitle => 'Questions fréquentes et guide d\'utilisation';

  @override
  String get groupPrefix => 'Groupe:';

  @override
  String get stateSensorsTitle => 'État des capteurs';

  @override
  String get noDescription => 'Pas de description';

  @override
  String get aboutTitle => 'À propos';

  @override
  String get maintenanceAdviceTitle => 'Conseil d\'entretien';

  @override
  String get noMaintenanceAdvice => 'Aucun conseil d\'entretien pour le moment.';

  @override
  String get deviceOptionsSectionTitle => 'Options de l\'objet';

  @override
  String get wateringParamsTitle => 'Paramètres d\'arrosage';

  @override
  String get wifiModificationTitle => 'Modification Wi-Fi';

  @override
  String get wifiModificationSubtitle => 'Reconnecter ou changer le réseau de l\'objet';

  @override
  String get helpFaqObjectSubtitle => 'Questions fréquentes et guide de l\'objet';

  @override
  String get deleteObjectTitle => 'Supprimer cet objet';

  @override
  String get deleteObjectSubtitle => 'Dissocier définitivement le pot connecté';

  @override
  String get connectedStable => 'Objet bien connecté à l\'application';

  @override
  String get connectedUnstable => 'Perte de contact avec la plante !';

  @override
  String get autoModeActive => 'MODE AUTOMATIQUE ACTIVÉ';

  @override
  String get manualModeActive => 'MODE MANUEL ACTIVÉ';

  @override
  String get autoModeDesc => 'Le mode automatique est activé : le pot se comportera selon les paramètres optimaux définis pour votre plante.';

  @override
  String get manualModeDesc => 'Attention ! Le pot ne prendra aucune décision d\'arrosage. Ce mode permet la surveillance et l\'arrosage à distance. Notez que le maintien de cette connexion permanente est particulièrement énergivore. Afin de préserver l\'autonomie de la batterie, nous vous conseillons d\'utiliser cette fonctionnalité avec modération et de surveiller régulièrement le niveau d\'énergie de votre objet.';

  @override
  String get deleteDialogTitle => 'Supprimer les réglages';

  @override
  String deleteDialogMessage(Object plantTitle) {
    return 'Voulez-vous vraiment supprimer votre plante $plantTitle ?';
  }

  @override
  String get deleteSuccess => 'Profil supprimé avec succès';

  @override
  String get deleteForbidden => 'Impossible : l\'objet est connecté et en mode AUTO.';

  @override
  String get deleteError => 'Erreur lors de la suppression.';

  @override
  String get sensorTemp => 'Température';

  @override
  String get sensorFertility => 'Fertilité';

  @override
  String get sensorHumAir => 'Humidité Air';

  @override
  String get sensorLight => 'Luminosité';

  @override
  String sensorTarget(Object target) {
    return 'Cible: $target';
  }

  @override
  String sunExposureToday(Object status) {
    return 'EXPOSITION SOLEIL AUJOURD\'HUI : $status';
  }

  @override
  String get analysisProTitle => 'ANALYSE PRO';

  @override
  String get analysisLoading => 'Analyse en cours...';

  @override
  String get uvNoData => 'Aucune donnée de luminosité reçue aujourd\'hui.';

  @override
  String get uvLowData => 'Luminosité faible aujourd\'hui. Votre plante manque un peu de clarté pour s\'épanouir pleinement.';

  @override
  String get uvMediumData => 'Ensoleillement doux. Un bain de lumière équilibré pour l\'énergie de votre plante.';

  @override
  String get uvHighData => 'Exposition forte ! Surveillez l\'état des feuilles tout de même, le soleil tape fort aujourd\'hui.';

  @override
  String get uvExtremeData => 'Rayonnement extrême ! Risque de brûlure. Protégez votre plante ou déplacez l\'objet à l\'ombre.';

  @override
  String get uvDisplayNone => 'Aucune';

  @override
  String get uvDisplayLow => 'Faible';

  @override
  String get uvDisplayModerate => 'Modéré';

  @override
  String get uvDisplayHigh => 'Élevé';

  @override
  String get uvDisplayVeryHigh => 'Très Élevé';

  @override
  String get uvDisplayCritical => 'Critique !';
}
