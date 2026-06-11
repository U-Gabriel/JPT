import 'package:app/models/plant_type.dart';
import 'package:app/ui/pages/shopping_page.dart';

class AppConfig {
  static const String url = "https://gdome.fr/api";
  static const String url_s = "https://gdome.fr/api";
  static const String url_dataset = "https://gdome.fr/api";

  static const int defaultPlantId = 5;
  static const String defaultPlantTitle = "Joker";

  static String get baseUrl => url;
  static String get baseUrlS => url_s;
  static String get baseUrlDataset => url_dataset;

  static String get loginEndpoint => "$baseUrl/login_app";
  static String get signupEndpoint => "$baseUrl/register";
  static String get sendMailEndpoint => "$baseUrl/register/send_mail";
  static String get validateAccountEndpoint => "$baseUrl/register/validate_account";
  static String get requestForgotPasswordResetEndpoint => "$baseUrl/login_app/forgot_password";
  static String get requestConfimationSimpleForgotPasswordResetEndpoint => "$baseUrl/login_app/forgot_password/confirmation_simple";
  static String get requestModificationPasswordResetEndpoint => "$baseUrl/login_app/forgot_password/modification";
  static String get requestPasswordResetEndpoint => "$baseUrl/auth/request-password-reset";
  static String get resetPasswordEndpoint => "$baseUrl/auth/user/reset_password";

  //profile
  static String get profileEndpoint => "$baseUrl/persons/me";
  static String get categoryCatalogEndpoint => "$baseUrl/categories/my_catalog";
  static String get categoryFavoritesEndpoint => "$baseUrl/categories/my_favorites";

  static String objectProfilesEndpointCreate() => "$baseUrl/object_profile/create/init";
  static String objectProfilesEndpointList() => "$baseUrl/object_profile/resume/byperson";
  static String objectProfilesEndpointListFavoris() => "$baseUrl/object_profile/resume/favoris/byperson";
  static String objectProfilesEndpointDetails() => "$baseUrl/object_profile/detail/byop";
  static String get avatarListEndpoint => "$baseUrl/avatar/get/list/state/null";
  static String get avatarUpdateEndpoint => "$baseUrl/avatar/upload/object_profile";
  static String objectProfileEndpointUpdate() => "$baseUrl/object_profile/update/byobjectprofile";
  static String objectProfilesEndpointDelete() => "$baseUrl/object_profile/delete/byobjectprofile";

  static String PlantTypeEndpointSearch() => "$baseUrl/plant_type/search/bytitle";

  static String GroupPlantTypeEndpointCreate() => "$baseUrl/group_plant_type/create/byid";
  static String GroupPlantTypeEndpointGet() => "$baseUrl/group_plant_type/resume";
  static String GroupPlantTypeEndpointDelete() => "$baseUrl/group_plant_type/delete/byid";
  static String GroupPlantTypeEndpointAssign() => "$baseUrl/group_plant_type/patch/assignation/byid";

  //tag && notice && faq
  static String get tagsEndpoint => "$baseUrl/tags";
  static String get tagsLvlOneEndpoint => "$baseUrl/tags/lvl/1";
  static String get noticeCreateEndpoint => "$baseUrl/notice/create";
  static String get faqByTagEndpoint => "$baseUrl/faqs/tag";

  //shopping
  static String get ShoppingPageEndpoint => "$baseUrl/shop/catalog";
  static String catalogDetails = "$baseUrl/shop/catalog/details";
  static String cartCount = "$baseUrl/shop/cart/count";
  static String cartAdd= "$baseUrl/shop/cart/add";
  static String get cartList => "$baseUrl/shop/cart/list";
  static String get cartDelete => "$baseUrl/shop/cart/delete";

  //facturation shopping address
  static String get addressEndpoint => "$baseUrl/person/address";
  static String get addressListEndpoint => "$baseUrl/person/address/list";
  static String get createPaymentIntentEndpoint => "$baseUrl/payment/create-intent";
  static String get geoApiGouv => "https://api-adresse.data.gouv.fr/search/";

  // old function
  static String objectProfilesEndpoint(String personId) => "$baseUrl/person/$personId/object-profiles";
  static String updateObjectProfileEndpoint(String id) => "$baseUrl/api/object-profile/$id";
  static String objectProfilesFavorisEndpoint(String personId) => "$baseUrl/person/$personId/object-profiles/favoris";
}