import 'package:app/models/plant_type.dart';
import 'package:app/ui/pages/shopping_page.dart';

class AppConfig {
  static const String url = "http://51.77.141.175";
  static const String url_s = "http://51.77.141.175";
  static const String url_dataset = "http://51.77.141.175";
  static const String port = "3000";

  static String get baseUrl => "$url:$port";
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

  static String objectProfilesEndpointCreate() => "$baseUrl/object_profile/create/init";
  static String objectProfilesEndpointList() => "$baseUrl/object_profile/resume/byperson";
  static String objectProfilesEndpointListFavoris() => "$baseUrl/object_profile/resume/favoris/byperson";
  static String objectProfilesEndpointDetails() => "$baseUrl/object_profile/detail/byop";
  static String objectProfileEndpointUpdate() => "$baseUrl/object_profile/update/byobjectprofile";
  static String objectProfilesEndpointDelete() => "$baseUrl/object_profile/delete/byobjectprofile";

  static String PlantTypeEndpointSearch() => "$baseUrl/plant_type/search/bytitle";

  static String GroupPlantTypeEndpointCreate() => "$baseUrl/group_plant_type/create/byid";
  static String GroupPlantTypeEndpointGet() => "$baseUrl/group_plant_type/resume";
  static String GroupPlantTypeEndpointDelete() => "$baseUrl/group_plant_type/delete/byid";
  static String GroupPlantTypeEndpointAssign() => "$baseUrl/group_plant_type/patch/assignation/byid";

  //tag && notice && faq
  static String get tagsEndpoint => "$baseUrl/tags";
  static String get noticeCreateEndpoint => "$baseUrl/notice/create";
  static String get faqByTagEndpoint => "$baseUrl/faqs/tag";

  //shopping
  static String get ShoppingPageEndpoint => "$baseUrl/shop/catalog";

  // old function
  static String objectProfilesEndpoint(String personId) => "$baseUrl/person/$personId/object-profiles";
  static String updateObjectProfileEndpoint(String id) => "$baseUrl/api/object-profile/$id";
  static String objectProfilesFavorisEndpoint(String personId) => "$baseUrl/person/$personId/object-profiles/favoris";
}