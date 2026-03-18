import 'package:app/ui/pages/add_my_object_page.dart';
import 'package:flutter/material.dart';
import '../ui/pages/add_connect_my_object_page.dart';
import '../ui/pages/add_name_my_object_page.dart';
import '../ui/pages/add_wifi_information_page.dart';
import '../ui/pages/advise_page.dart';
import '../ui/pages/auth_wrapper_redirection.dart';
import '../ui/pages/buy_my_object_page.dart';
import '../ui/pages/create_group_plant_page.dart';
import '../ui/pages/event_page.dart';
import '../ui/pages/forgot_password_page.dart';
import '../ui/pages/get_code_email_page.dart';
import '../ui/pages/group_plant_type_page.dart';
import '../ui/pages/modification_wifi_connect_page.dart';
import '../ui/pages/modification_wifi_my_object_page.dart';
import '../ui/pages/my_plant_page.dart';
import '../ui/pages/my_plant_page_login.dart';
import '../ui/pages/plant_detail_known_page.dart';
import '../ui/pages/profile_page.dart';
import '../ui/pages/login_page.dart';
import '../ui/pages/reset_password_page.dart';
import '../ui/pages/signup_page.dart';


final Map<String, WidgetBuilder> appRoutes = {
  '/': (context) => const AuthWrapper(),
  '/advise': (_) => const AdvisePage(),
  '/plant': (_) => const MyPlantPage(),
  '/plant_login': (_) => const MyPlantPageLogin(),
  '/event': (_) => const EventPage(),
  '/profile': (_) => const ProfilePage(),
  '/login': (_) => const LoginPage(),
  '/forgot_password': (_) => const ForgotPasswordPage(),
  '/signup': (_) => const SignupPage(),
  '/get_code_email': (_) => const GetCodeEmailPage(),
  '/reset_password': (_) => const ResetPasswordPage(),
  '/add_my_object': (_) => const AddMyObjectPage(),
  '/add_name_my_object': (_) => const AddNameMyObjectPage(),
  '/add_wifi_information': (_) => const AddWifiInformationPage(),
  '/add_connect_my_object': (_) => const AddConnectMyObjectPage(),
  '/buy_my_object': (_) => const BuyMyObjectPage(),
  '/modification_wifi_my_object': (context) {
    final Map<String, dynamic> args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    return ModificationWifiMyObjectPage(
      objectProfileId: args['objectProfileId'] as int,
      title: args['title'] as String,
    );
  },
  '/modification_wifi_connect': (context) {
    final Map<String, dynamic> args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    return ModificationWifiConnectPage(
      objectProfileId: args['objectProfileId'] as int,
      title: args['title'] as String,
      ssid: args['ssid'] as String,
      password: args['password'] as String,
    );
  },
  '/plant_detail_known': (context) {
    final int plantId = ModalRoute.of(context)!.settings.arguments as int;
    return PlantDetailKnownPage(plantId: plantId);
  },
  '/create_group_plant': (context) {
    final Map<String, dynamic> args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    return CreateGroupPlantPage(
      objectProfileId: args['objectProfileId'] as int,
      plantId: args['plantId'] as int,
    );
  },
  '/group_plant_type': (context) {
    final Map<String, dynamic> args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    return GroupPlantTypePage(
      objectProfileId: args['objectProfileId'] as int,
      plantId: args['plantId'] as int,
    );
  },



};
