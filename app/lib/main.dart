import 'package:app/app_config.dart';
import 'package:app/providers/cart_provider.dart';
import 'package:app/providers/plant_provider_my_List.dart';
import 'package:app/services/object_profile_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:provider/provider.dart';

import 'bloc/object_profile/object_profile_event.dart';
import 'routes/app_routes.dart';
import 'core/theme.dart';
import 'providers/nav_provider.dart';
import 'providers/auth_provider.dart';
import 'providers/plant_provider.dart';
import 'bloc/object_profile/object_profile_bloc.dart';
import 'bloc/object_profile_my_list/object_profile_my_list_bloc.dart';
import 'bloc/object_profile_my_list/object_profile_my_list_event.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialisation de Stripe
  Stripe.publishableKey = "pk_live_51TUCKxC9bnvlKMDcxWFcmDuo0FfvsekqWLcXjiubsL3RbYaDdU6jB1DdImjzbdontIGd97u7ZJY1J0ZcHZR1Sr6Y00XnD4EgvB";

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NavProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: const RootApp(),
    ),
  );
}

class RootApp extends StatelessWidget {
  const RootApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final token = authProvider.accessToken;
    final personIdStr = authProvider.userId;

    if (token == null || token.isEmpty || personIdStr == null) {
      return MaterialApp(
        title: 'Jackpot App',
        theme: appTheme,
        routes: appRoutes,
        initialRoute: '/',
      );
    }

    final personId = int.parse(personIdStr);

    return MultiBlocProvider(
      providers: [
        BlocProvider<ObjectProfileBloc>(
          create: (_) => ObjectProfileBloc(
            service: ObjectProfileService(),
            token: token,
            personId: personId,
          )..add(LoadProfiles()),
        ),
        BlocProvider<ObjectProfileMyListBloc>(
          create: (_) => ObjectProfileMyListBloc(
            service: ObjectProfileService(),
            token: token,
            personId: personId,
          )..add(LoadProfilesMyList()),
        ),
      ],
      child: MaterialApp(
        title: 'Jackpot App',
        theme: appTheme,
        routes: appRoutes,
        initialRoute: '/',
      ),
    );
  }
}
