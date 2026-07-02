// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get welcomeMessage => 'Welcome to GDOME';

  @override
  String get loginButton => 'Login';

  @override
  String get errorMessage => 'An error occurred, please try again.';

  @override
  String get myPlantPageNoLogin => '=======================';

  @override
  String get signupButton => 'Create my GDOME account';

  @override
  String get frenchCreation => 'French connected creation';

  @override
  String get welcomeGdome => 'Welcome to GDOME';

  @override
  String get systemeSentence => 'The smart home ecosystem that reimagines your relationship with nature and your home.';

  @override
  String get iConnect => 'I\'m logging in';

  @override
  String get ourVision => 'Our vision';

  @override
  String get smartPots => 'Smart pots';

  @override
  String get plantNeed => 'Your plants communicate their needs in real time thanks to our high-precision sensors.';

  @override
  String get tomorrow => 'Tomorrow...';

  @override
  String get bowlNeed => 'A growing ecosystem: smart pet bowls, pet care, and overall comfort.';

  @override
  String get newComany => 'A new company with you';

  @override
  String get newComanyDesc => 'GDOME is a brand-new French company. Our mission is to combine respect for life with the smart features of the connected home, without compromising on design.';

  @override
  String get objectQuestion => 'Do you have any questions about our products?';

  @override
  String get faqDiscovery => 'Explore our Help Center';

  @override
  String get myPlantPage => '=======================';

  @override
  String get myFavorites => 'My Favorites';

  @override
  String get noFoundItems => 'No items found.';

  @override
  String get myList => 'My List';

  @override
  String get emptyStateWidget => '=======================';

  @override
  String get myFavoritesEmptyTitle => 'No favorites yet';

  @override
  String get myFavoritesEmptySubtitle => 'Add your favorite plants to find them here in a heartbeat.';

  @override
  String get myListEmptyTitle => 'Your collection is empty';

  @override
  String get myListEmptySubtitle => 'Start adding your GDOME smart devices to track their health in real time.';

  @override
  String get loginPage => '=======================';

  @override
  String get incorrectId => 'Incorrect credentials. Please try again.';

  @override
  String get happySeeYou => 'It\'s great to see you again!';

  @override
  String get cultivateInside => 'Cultivate your inner well-being.';

  @override
  String get email => 'Email';

  @override
  String get emailExample => 'your@email.com';

  @override
  String get invalidEmail => 'Invalid email format';

  @override
  String get password => 'Password';

  @override
  String get suspension => '••••••••';

  @override
  String get tooShortPassword => 'Password too short';

  @override
  String get forgotPassword => 'Forgot password ?';

  @override
  String get loginMaj => 'LOGIN';

  @override
  String get noAccount => 'No account yet?';

  @override
  String get signUp => 'Sign up';

  @override
  String get signupPage => '=======================';

  @override
  String get signUpFailure => 'Sign up failed. This username or email may already be in use.';

  @override
  String get oops => 'Oops!';

  @override
  String get ok => 'OK';

  @override
  String get createAnAccount => 'Create an account';

  @override
  String get joinAdventure => 'Join the GDOME adventure in just a few seconds.';

  @override
  String get pseudo => 'Pseudo';

  @override
  String get pseudoQuestion => 'How should we call you?';

  @override
  String get confirmation => 'Confirmation';

  @override
  String get confirmationQuestion => 'Confirm your password';

  @override
  String get differentPasswords => 'Passwords do not match';

  @override
  String get signUpMaj => 'SIGN UP';

  @override
  String get alreadyAccount => 'Already have an account?';

  @override
  String get login => 'Login';

  @override
  String get signupValidationPage => '=======================';

  @override
  String get welcome => 'Welcome !';

  @override
  String get startMaj => 'START';

  @override
  String get verification => 'Verification';

  @override
  String signupValidationDesc(Object userEmail) {
    return 'Enter the 6-digit code sent to\n$userEmail';
  }

  @override
  String signupResendCodeTimer(Object seconds) {
    return 'Resend code in $seconds s';
  }

  @override
  String get signupResendCode => 'Resend code';

  @override
  String get sendNewCode => 'A new code has been sent!';

  @override
  String get failureSendTryLater => 'Failed to send. Please try again later.';

  @override
  String get accountValidationMaj => 'VALIDATE MY ACCOUNT';

  @override
  String get profilePage => '=======================';

  @override
  String get user => 'User';

  @override
  String get noAddressEmail => 'No email address';

  @override
  String get identity => 'Identity';

  @override
  String get noSpecified => 'Not specified';

  @override
  String get manageMyApp => 'Manage my application';

  @override
  String get security => 'Security';

  @override
  String get changePassword => 'Change password';

  @override
  String get myItems => 'My items';

  @override
  String get manageMyDevices => 'Manage my devices';

  @override
  String get favoritesItems => 'Favorite items';

  @override
  String get faq => 'FAQ';

  @override
  String get helpCenter => 'Help Center';

  @override
  String get leaveReview => 'Leave my review';

  @override
  String get shareExperience => 'Share your experience and help us improve !';

  @override
  String get logOut => 'Log out';

  @override
  String get forgotPasswordPage => '=======================';

  @override
  String get failureSendMail => 'An error occurred while sending the email. Please check your connection or the entered address.';

  @override
  String get retry => 'Retry';

  @override
  String get enterMailRetrieve => 'Enter the email address associated with your account. We will send you a code to reset your password.';

  @override
  String get sendTheCodeMaj => 'SEND THE CODE';

  @override
  String get back => 'Back';

  @override
  String get yourEmail => 'Your Email';

  @override
  String get enterYourEmail => 'Please enter your email';

  @override
  String get getCodeEmailPage => '=======================';

  @override
  String get enterMailReceived => 'Please enter the code received by email.';

  @override
  String get codeContainLimit => 'The code must contain 6 digits.';

  @override
  String get invalidCode => 'Invalid code';

  @override
  String get incorrectCode => 'The code entered is incorrect or has expired. Please try again.';

  @override
  String get enterCodeDigits => 'Enter the 6-digit code sent to';

  @override
  String get hintZeroSix => '000000';

  @override
  String get confirmationMaj => 'CONFIRM';

  @override
  String get signupResendCodeIn => 'Resend code in ';

  @override
  String get resetPasswordPage => '=======================';

  @override
  String get retrySessionExpire => 'Session expired. Please try again.';

  @override
  String get expiredCode => 'The code has expired or is invalid.';

  @override
  String get passwordChangeNoConnected => 'Password changed, but connection error. Please log in manually.';

  @override
  String get updatePassword => 'Password updated !';

  @override
  String get autoLoginLoading => 'Automatic login in progress...';

  @override
  String get successPasswordConnectOk => 'Password successfully changed! You can now log in.';

  @override
  String get loginBackMaj => 'BACK TO LOGIN';

  @override
  String get newPasswordLine => 'New\npassword';

  @override
  String get createNewStrongPassword => 'Create a strong password to secure your account.';

  @override
  String get newPassword => 'New password';

  @override
  String get confirmationThePassword => 'Confirm password';

  @override
  String get resetMaj => 'RESET';

  @override
  String get limitChar => 'Minimum 6 characters';

  @override
  String get myObjectProfilePage => '=======================';

  @override
  String get connectedDevices => 'My Connected Devices';

  @override
  String get failureChargeCategories => 'Unable to load your categories.';

  @override
  String get noDevicesForMoment => 'No device registered at the moment.';

  @override
  String get myFavoriteCatalogPage => '=======================';

  @override
  String get myFavoritesMajD => 'My Favorites';

  @override
  String get failureChargeFavorites => 'Unable to load your favorites.';

  @override
  String get noFavoritesForMoment => 'No favorites at the moment';

  @override
  String get noticePage => '=======================';

  @override
  String get completeAllField => 'Please complete the required fields';

  @override
  String get thanksForFeedback => 'Thank you for your feedback !';

  @override
  String get occurredError => 'An error occurred';

  @override
  String get commentsMaj => 'COMMENTS';

  @override
  String get experienceBack => 'We value your experience';

  @override
  String get experienceBackDesc => 'Because we know that things aren\'t always perfect, your feedback is valuable to help the new GDOME adventure improve every day.';

  @override
  String get noticeSubject => 'Subject of the notice';

  @override
  String get enterTitle => 'Enter a title';

  @override
  String get itemConcerned => 'Concerned item (Optional)';

  @override
  String get categoryD => 'Category';

  @override
  String get selectCategory => 'Select a category';

  @override
  String get yourMessage => 'Your message';

  @override
  String get noEmptyContent => 'Content cannot be empty';

  @override
  String get sendBackMaj => 'SUBMIT MY FEEDBACK';

  @override
  String get shoppingPage => '=======================';

  @override
  String get modelSearch => 'Search for a model...';

  @override
  String get allD => 'All';

  @override
  String get noAvailableProduct => 'No product available';

  @override
  String cartArticlesAdded(Object qty) {
    return '$qty item(s) added to the cart!';
  }

  @override
  String get failureAddAskTry => 'Error while adding. Please try again.';

  @override
  String get gdomeMaj => 'GDOME';

  @override
  String get theExperience => 'The experience';

  @override
  String get technicalSpecifications => 'Technical specifications';

  @override
  String productInStock(Object count) {
    return 'In stock ($count units)';
  }

  @override
  String get outOfStock => 'Currently out of stock';

  @override
  String get productNotFound => 'Product not found';

  @override
  String get backToCatalogMaj => 'BACK TO CATALOG';

  @override
  String get shoppingProductBottomBarPage => '=======================';

  @override
  String get buyNowMaj => 'BUY NOW';

  @override
  String get outOfStockMaj => 'OUT OF STOCK';

  @override
  String get shoppingProductTrustPage => '=======================';

  @override
  String get badgeSecurePay => 'Secure\nPayment';

  @override
  String get badgeHighPrecision => 'High\nPrecision Design';

  @override
  String get badgeSatisfaction => 'Satisfaction\nGuaranteed';

  @override
  String get plantDetailKnownPage => '=======================';

  @override
  String get plantNotFound => 'Plant not found';

  @override
  String get descriptionD => 'Description';

  @override
  String get expertTips => 'Expert tips';

  @override
  String get lifeCalendar => 'Life Calendar';

  @override
  String get scientificName => 'Scientific name: ';

  @override
  String get unknownD => 'Unknown';

  @override
  String get familyD => 'Family';

  @override
  String plantFamilyLabel(Object familyName) {
    return 'Family: $familyName';
  }

  @override
  String get metricHeight => 'Height';

  @override
  String get metricSun => 'Sun/day';

  @override
  String get metricPlanting => 'Planting';

  @override
  String get plantNoSpecificAdvise => 'No specific advice available.';

  @override
  String get needsAndEnv => 'Needs & Environment';

  @override
  String get plantExposure => 'Exposure';

  @override
  String get plantGround => 'Soil';

  @override
  String get seasonSpring => 'Spring';

  @override
  String get seasonSummer => 'Summer';

  @override
  String get seasonAutumn => 'Autumn';

  @override
  String get seasonWinter => 'Winter';

  @override
  String get orderValidationPage => '=======================';

  @override
  String get congratulationsD => 'Congratulations!';

  @override
  String get validateOrder => 'Your order has been successfully validated and is being prepared.';

  @override
  String get yourOrderMaj => 'YOUR ORDER';

  @override
  String get deliveryAddressMaj => 'DELIVERY ADDRESS';

  @override
  String get totalAmountPaidD => 'Total amount paid';

  @override
  String get backToHomeMaj => 'BACK TO HOME';

  @override
  String get trackMyOrdersD => 'Track my orders';

  @override
  String get orderPaymentPage => '=======================';

  @override
  String get summaryD => 'Summary';

  @override
  String get deliveryToMAJ => 'DELIVERY TO';

  @override
  String get subtotalD => 'Subtotal';

  @override
  String get deliveryD => 'Delivery';

  @override
  String get freeD => 'Free';

  @override
  String get totalMaj => 'TOTAL';

  @override
  String get unableToInitThePayment => 'Unable to initialize the payment.';

  @override
  String paymentNotFinalized(Object errorMessage) {
    return 'Payment not finalized: $errorMessage';
  }

  @override
  String get paymentErrorGeneric => 'An error occurred during payment. Please try again.';

  @override
  String btnConfirmAndPay(Object price) {
    return 'CONFIRM AND PAY $price';
  }

  @override
  String get orderAddressPage => '=======================';

  @override
  String get franceD => 'France';

  @override
  String get yourAddressMaj => 'YOUR ADDRESSES';

  @override
  String get orderSummaryMaj => 'ORDER SUMMARY';

  @override
  String get addressD => 'Address';

  @override
  String get useAnotherAddress => 'Use another address';

  @override
  String get addAnDeliveryAddressMaj => 'ADD A DELIVERY ADDRESS';

  @override
  String get nameAddressD => 'Address name (Home, Office...)';

  @override
  String get enterAddressD => 'Enter your address...';

  @override
  String get additionalInformationD => 'Additional information (Apartment, Floor...)';

  @override
  String get postalCodeD => 'Postal Code';

  @override
  String get cityD => 'City';

  @override
  String get countryD => 'Country';

  @override
  String get setAsDefaultD => 'Set as default';

  @override
  String get chooseAnAddressMaj => 'CHOOSE AN ADDRESS';

  @override
  String get validateAddressMaj => 'VALIDATE THIS ADDRESS';

  @override
  String get fillInTheFieldsMaj => 'FILL IN THE FIELDS';

  @override
  String btnConfirmOrderMaj(Object price) {
    return 'CONFIRM $price';
  }

  @override
  String get btnChooseAddressMaj => 'CHOOSE AN ADDRESS';

  @override
  String get modificationWifiMyObjectPage => '=======================';

  @override
  String get wifiConfigTitle => 'WiFi Configuration';

  @override
  String wifiUpdateForObject(Object objectTitle) {
    return 'Update for $objectTitle';
  }

  @override
  String get wifiRangeWarning => 'Make sure your device is within range during modification.';

  @override
  String get wifiSsidLabel => 'Network Name (SSID)';

  @override
  String get exampleWifiSsidLabel => 'Ex: MyBox_1234';

  @override
  String get wifiPasswordLabel => 'Password';

  @override
  String get wifiBtnModify => 'Modify my WiFi';

  @override
  String get wifiErrorEmptyFields => 'Please fill in all fields';

  @override
  String get modificationWifiConnectPage => '=======================';

  @override
  String get wifiConnectSuccessHeader => 'Configuration successful!';

  @override
  String get wifiConnectSearchHeader => 'Connecting to network';

  @override
  String get wifiConnectSeconds => 'seconds';

  @override
  String get wifiConnectWait => 'Please wait...';

  @override
  String get wifiConnectBtnFinish => 'Finish';

  @override
  String get wifiConnectBtnRetry => 'Retry';

  @override
  String get wifiConnectLedStatus => 'Device LED Status';

  @override
  String get wifiStatusSearchTitle => 'Searching for device...';

  @override
  String get wifiStatusSearchSubtitle => 'Make sure the device is nearby and turned on. Activate manual mode on your device and press the BLUE button.';

  @override
  String get wifiStatusProcessingTitle => 'Attempting to connect...';

  @override
  String get wifiStatusProcessingSubtitle => 'The device is trying to join your WiFi. The LED should blink.';

  @override
  String get wifiStatusSuccessTitle => 'All set!';

  @override
  String get wifiStatusSuccessSubtitle => 'The device is now connected. The blue LED should turn off.';

  @override
  String get wifiStatusErrorTitle => 'An error occurred';

  @override
  String get wifiStatusErrorSubtitleFallback => 'Please check that your WiFi SSID and password are correct.';

  @override
  String get wifiErrorBluetoothOff => 'Bluetooth is disabled. Please enable it to configure your device.';

  @override
  String get wifiStatusBluetoothErrorTitle => 'Bluetooth Required';

  @override
  String get wifiStatusBluetoothErrorSubtitle => 'Your Bluetooth is turned off. Please enable it in your phone settings to allow detection of your GDOME object.';

  @override
  String get wifiErrorScanFailed => 'Unable to scan surroundings.';

  @override
  String get wifiErrorConnectionLost => 'Connection with the device lost.';

  @override
  String get wifiErrorTimeout => 'The device is taking too long to respond.';

  @override
  String get wifiErrorWrongProfile => 'This pot belongs to another profile. Action denied. Please check pot ownership.';

  @override
  String wifiErrorConnectionFailed(Object ssid) {
    return 'The device could not connect to $ssid.';
  }

  @override
  String get homePageNoLogin => '=======================';

  @override
  String get homeTitleAdvise => 'Advice & Expertise';

  @override
  String get homeTitleShop => 'GDOME Shop';

  @override
  String get homeTooltipProfile => 'Profile';

  @override
  String get navTabAdvise => 'Advice';

  @override
  String get navTabMyObjects => 'My objects';

  @override
  String get navTabShop => 'Shop';

  @override
  String get homePage => '=======================';

  @override
  String get homeTitleEquipment => 'My Equipment';

  @override
  String get homeTooltipMyProfile => 'My Profile';

  @override
  String get addConnectMyObjectPage => '=======================';

  @override
  String get addObjTitle => 'Connection';

  @override
  String get addObjStepTitle => 'Let\'s connect your device!';

  @override
  String addObjStepDesc(Object plantName) {
    return 'We will finally be able to connect your $plantName to our device. Press the blue button on the device so our application can detect it.';
  }

  @override
  String get addObjDefaultPlantName => 'your plant';

  @override
  String get addObjRecapPlant => 'Plant';

  @override
  String get addObjRecapNetwork => 'Network';

  @override
  String get addObjRecapUnknown => 'Unknown';

  @override
  String get addObjRecapId => 'Device ID';

  @override
  String get addObjStatusCreating => 'Creating your plant profile...';

  @override
  String get addObjStatusSearching => 'Searching for device...';

  @override
  String get addObjBtnSearching => 'Searching...';

  @override
  String get addObjBtnCreating => 'Creating profile...';

  @override
  String get addObjBtnStart => 'Start connection';

  @override
  String get addObjDialogAlreadyLinkedTitle => 'Device already linked';

  @override
  String addObjDialogAlreadyLinkedDesc(Object flowerName) {
    return 'This device is already linked to the flower \'$flowerName\'.\n\nPlease delete the associated flower in your settings first.';
  }

  @override
  String get addObjDialogBtnUnderstand => 'UNDERSTOOD';

  @override
  String get addObjDialogSuccessTitle => 'Congratulations!';

  @override
  String addObjDialogSuccessDesc(Object plantName) {
    return 'Your $plantName is configured and activated!';
  }

  @override
  String get addObjErrorNoResponse => 'The device is no longer responding. Profile canceled.';

  @override
  String get addObjErrorWifiFailed => 'The device could not connect to Wi-Fi. The profile was canceled.';

  @override
  String get addObjErrorNoResponseConn => 'The device is no longer responding. Connection canceled.';

  @override
  String get loginD => 'Login';

  @override
  String get plantDetailContent => '=======================';

  @override
  String get plantDetailTitle => 'Plant Details';

  @override
  String get plantDetailNoDescription => 'No description available';

  @override
  String get plantDetailBtnClose => 'Close';

  @override
  String get plantDetailSectionControls => 'Controls';

  @override
  String get plantDetailWrapper => '=======================';

  @override
  String get noAvailableToken => 'Token no available';

  @override
  String get sensorValue => '=======================';

  @override
  String get noAvailableD => 'No available';

  @override
  String get objectConnectionController => '=======================';

  @override
  String get apiErrorTitle => 'API Error';

  @override
  String get apiErrorCreateProfileFailed => 'Unable to create the device, please check your internet connection.';

  @override
  String get plantControlSwitches => '=======================';

  @override
  String get plantControlReasonAuto => 'Manual watering unavailable: automatic mode is already managing your plant optimally.';

  @override
  String get plantControlReasonOffline => 'Cannot water: the device is offline.';

  @override
  String get plantControlBtnWatering => 'WATERING IN PROGRESS...';

  @override
  String get plantControlBtnAuto => 'AUTOMATIC WATERING';

  @override
  String get plantControlBtnStart => 'START WATERING';

  @override
  String get plantItemMyListWidget => '=======================';

  @override
  String get plantItemUnknownName => 'Unknown name';

  @override
  String get plantStatusDanger => 'In danger';

  @override
  String get plantStatusWarning => 'Needs attention';

  @override
  String get plantStatusHealthy => 'Healthy';

  @override
  String get plantStatusUnknown => 'Unknown';

  @override
  String get authRequiredDialog => '=======================';

  @override
  String get authRequiredTitle => 'Login Required';

  @override
  String get authRequiredMessage => 'To access this feature, please log in or sign up. It\'s free and only takes a few minutes.';

  @override
  String get authRequiredBtnLogin => 'LOG IN';

  @override
  String get authRequiredBtnLater => 'LATER';

  @override
  String get connectionErrorDialog => '=======================';

  @override
  String get connErrorDefaultTitle => 'Connection Error';

  @override
  String get connErrorDefaultMessage => 'A connection error occurred. Please try again.';

  @override
  String get connErrorBtnCancel => 'Cancel';

  @override
  String get connErrorBtnRetry => 'Retry';

  @override
  String get deleteConfirmDialog => '=======================';

  @override
  String get deleteD => 'Delete';

  @override
  String get successDialog => '=======================';

  @override
  String get validateD => 'Validate';

  @override
  String get wifiErrorDialog => '=======================';

  @override
  String get wifiErrorD => 'Wi-Fi Error';

  @override
  String get productCard => '=======================';

  @override
  String get shopProductPromoBadge => 'SALE';

  @override
  String get shopProductOutOfStock => 'Out of stock';

  @override
  String shopProductInStock(Object stock) {
    return 'In stock ($stock)';
  }

  @override
  String get stepProgressBar => '=======================';

  @override
  String progressBarCompleted(Object percent) {
    return '$percent% completed';
  }

  @override
  String get addMyObjectPage => '=======================';

  @override
  String get newObjectD => 'New object';

  @override
  String get addObjectMainTitle => 'Link your device';

  @override
  String get addObjectExplanation => 'If you own a JackPote smart device, you\'re in the right place! Let\'s start by linking your device to the app. To begin: which plant is this device for?';

  @override
  String get addObjectFieldName => 'Plant name';

  @override
  String get addObjectFieldHint => 'Search for a plant (e.g., Ficus...)';

  @override
  String get addObjectBtnNotFound => 'I can\'t find my plant';

  @override
  String get addObjectBtnOtherUsage => 'Device other than a pot';

  @override
  String get addObjectOtherUsageDefaultTitle => 'Smart device';

  @override
  String get addObjectShopText => 'If you haven\'t purchased your JackPote yet, let\'s head over to our store to grab one!';

  @override
  String get addObjectShopBtn => 'Go to store';

  @override
  String get buyMyObjectPage => '=======================';

  @override
  String get gdomeStoreD => 'Store GDOME';

  @override
  String get welcomeStoreD => 'Welcome to the store !\nComing soon... Stay tuned!';

  @override
  String get bowlDetailPage => '=======================';

  @override
  String get detailsBowlsD => 'Détails Gamelle (Bowl)';

  @override
  String bowlPageProfileId(Object id) {
    return 'Bowl Page - Profile ID: $id';
  }

  @override
  String get specificAnimalDesignWillBeHere => 'The specific animal design will be integrated here.';

  @override
  String get addWifiInformationPage => '=======================';

  @override
  String get wifiInfoTitle => 'Wi-Fi Information';

  @override
  String get wifiInfoDescription => 'In order for your GDOME device to communicate with you, it must be connected to your home network — the one that will be available when you’re away.';

  @override
  String get wifiPasswordHint => 'Your Wi-Fi password';

  @override
  String get wifiEmptyFieldsError => 'Please fill in all Wi-Fi fields';

  @override
  String get nextButton => 'Next';

  @override
  String get addNameSpeMyObjectPage => '=======================';

  @override
  String get defaultObjectTitle => 'Your object';

  @override
  String get customConfigTitle => 'Custom Configuration';

  @override
  String get customConfigGiveNameTitle => 'Name Your Object';

  @override
  String get customConfigGiveNameDescription => 'Your object is not related to plants. Choose a name to distinguish it in the list.';

  @override
  String get customConfigInputLabel => 'Connected Object Name';

  @override
  String get customConfigInputHint => 'e.g., Living Room Sensor, Desk GDOME...';

  @override
  String get customConfigEmptyNameError => 'The object name is required!';

  @override
  String get continueButton => 'Continue';

  @override
  String get advisePage => '=======================';

  @override
  String get helpCenterTitle => 'Help Center';

  @override
  String get faqCategoriesLabel => 'Categories';

  @override
  String get faqSearchHint => 'Search for a specific question...';

  @override
  String get faqFeedbackNoticeTitle => 'Your feedback helps us grow';

  @override
  String get faqFeedbackNoticeSubtitle => 'Any suggestions? Help us improve GDOME.';

  @override
  String get faqFeedbackNoticeButton => 'Share my experience';

  @override
  String get faqNoResultsFound => 'No answers found';

  @override
  String get plantDetailPage => '=======================';

  @override
  String get sessionExpired => 'Session expired';

  @override
  String get errorPrefix => 'Error:';

  @override
  String get addedToFavorites => 'Added to favorites...';

  @override
  String get removedFromFavorites => 'Removed from favorites...';

  @override
  String get deviceOptionsTitle => 'Device options';

  @override
  String get wateringSettingsTitle => 'Watering settings';

  @override
  String get wateringSettingsSubtitle => 'Adjust automatic watering targets';

  @override
  String get modifyWifiTitle => 'Modify Wi-Fi';

  @override
  String get modifyWifiSubtitle => 'Change the device\'s network';

  @override
  String get helpFaqTitle => 'Help & FAQ';

  @override
  String get helpFaqSubtitle => 'Frequently asked questions and user guide';

  @override
  String get groupPrefix => 'Group:';

  @override
  String get stateSensorsTitle => 'Sensor status';

  @override
  String get noDescription => 'No description';

  @override
  String get aboutTitle => 'About';

  @override
  String get maintenanceAdviceTitle => 'Maintenance advice';

  @override
  String get noMaintenanceAdvice => 'No maintenance advice for now.';

  @override
  String get deviceOptionsSectionTitle => 'Device options';

  @override
  String get wateringParamsTitle => 'Watering parameters';

  @override
  String get wifiModificationTitle => 'Wi-Fi modification';

  @override
  String get wifiModificationSubtitle => 'Reconnect or change the device\'s network';

  @override
  String get helpFaqObjectSubtitle => 'Frequently asked questions and device guide';

  @override
  String get deleteObjectTitle => 'Delete this device';

  @override
  String get deleteObjectSubtitle => 'Permanently unlink the connected pot';

  @override
  String get connectedStable => 'Device properly connected to the application';

  @override
  String get connectedUnstable => 'Lost contact with the plant!';

  @override
  String get autoModeActive => 'AUTOMATIC MODE ACTIVE';

  @override
  String get manualModeActive => 'MANUAL MODE ACTIVE';

  @override
  String get autoModeDesc => 'Automatic mode is active: the pot will behave according to the optimal parameters defined for your plant.';

  @override
  String get manualModeDesc => 'Warning! The pot will not make any watering decisions. This mode allows for remote monitoring and watering. Note that maintaining this permanent connection is particularly energy-consuming. To preserve battery autonomy, we advise you to use this feature with moderation and to regularly monitor your device\'s battery level.';

  @override
  String get deleteDialogTitle => 'Delete settings';

  @override
  String deleteDialogMessage(Object plantTitle) {
    return 'Do you really want to delete your plant $plantTitle ?';
  }

  @override
  String get deleteSuccess => 'Profile successfully deleted';

  @override
  String get deleteForbidden => 'Impossible: the device is connected and in AUTO mode.';

  @override
  String get deleteError => 'Error during deletion.';

  @override
  String get sensorTemp => 'Temperature';

  @override
  String get sensorFertility => 'Fertility';

  @override
  String get sensorHumAir => 'Air Humidity';

  @override
  String get sensorLight => 'Brightness';

  @override
  String sensorTarget(Object target) {
    return 'Target: $target';
  }

  @override
  String sunExposureToday(Object status) {
    return 'SUN EXPOSURE TODAY: $status';
  }

  @override
  String get analysisProTitle => 'PRO ANALYSIS AUTO';

  @override
  String get analysisLoading => 'Analysis in progress...';

  @override
  String get uvNoData => 'No brightness data received today.';

  @override
  String get uvLowData => 'Low brightness today. Your plant lacks a bit of clarity to fully flourish.';

  @override
  String get uvMediumData => 'Gentle sunlight. A balanced light bath for your plant\'s energy.';

  @override
  String get uvHighData => 'High exposure! Monitor the status of the leaves anyway, the sun is hitting hard today.';

  @override
  String get uvExtremeData => 'Extreme radiation! Risk of burning. Protect your plant or move the object to the shade.';

  @override
  String get uvDisplayNone => 'None';

  @override
  String get uvDisplayLow => 'Low';

  @override
  String get uvDisplayModerate => 'Moderate';

  @override
  String get uvDisplayHigh => 'High';

  @override
  String get uvDisplayVeryHigh => 'Very High';

  @override
  String get uvDisplayCritical => 'Critical!';
}
