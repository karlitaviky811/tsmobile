import 'package:flutter/material.dart';
import 'package:tsmobile/src/features/auth/screens/login_screen.dart';
import 'package:tsmobile/src/features/auth/screens/register_screen.dart';
import 'package:tsmobile/src/features/auth/screens/welcome_screen.dart';

import '../screens/index.dart';

class AuthRouter {
  static Map<String, Widget Function(BuildContext)> getRoutes() {
    Map<String, Widget Function(BuildContext)> routes = {};

    routes.addAll({
      LoginScreen.route: (BuildContext context) => LoginScreen(),
      RegisterScreen.route: (BuildContext context) => RegisterScreen(),
      WelcomeScreen.route: (BuildContext context) => WelcomeScreen(),
    });

    return routes;
  }
}
