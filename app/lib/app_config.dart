import 'package:app/models/plant_type.dart';

class AppConfig {
  static const String url = "http://10.0.2.2";
  static const String url_s = "http://localhost";
  static const String url_dataset = "http://51.77.141.175";
  static const String port = "3000";

  static String get baseUrl => "$url:$port";
  static String get baseUrlS => url_s;
  static String get baseUrlDataset => url_dataset;

  static String get loginEndpoint => "$baseUrl/login_app";
  static String get signupEndpoint => "$baseUrl/register";
  static String get requestPasswordResetEndpoint => "$baseUrl/auth/request-password-reset";
  static String get resetPasswordEndpoint => "$baseUrl/auth/user/reset_password";

  static String objectProfilesEndpointList() => "$baseUrl/object_profile/resume/byperson";
  static String objectProfilesEndpointListFavoris() => "$baseUrl/object_profile/resume/favoris/byperson";
  static String objectProfilesEndpointDetails() => "$baseUrl/object_profile/detail/byop";

  static String PlantTypeEndpointSearch() => "$baseUrl/plant_type/search/bytitle";


  // old function
  static String objectProfilesEndpoint(String personId) => "$baseUrl/person/$personId/object-profiles";
  static String updateObjectProfileEndpoint(String id) => "$baseUrl/api/object-profile/$id";
  static String objectProfilesFavorisEndpoint(String personId) => "$baseUrl/person/$personId/object-profiles/favoris";
}