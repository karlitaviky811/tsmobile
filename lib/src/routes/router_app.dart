import 'package:flutter/material.dart';
import 'package:tsmobile/src/features/auth/router/router_auth.dart';
import 'package:tsmobile/src/features/main/router/main_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RouterApp {
  static Future<String> getInitialRoute() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    // Aquí podrías añadir lógica adicional para validar el token si es necesario
    if (token != null) {
      return 'home-tabs-route'; // Redirigir al home si el token es válido
    } else {
      return 'welcome-route'; // Redirigir al login si no hay token
    }
  }

  static Map<String, Widget Function(BuildContext)> getRoutes() {
    Map<String, Widget Function(BuildContext)> routes = {};
  
    routes.addAll(AuthRouter.getRoutes());
    routes.addAll(MainRouter.getRoutes());

    return routes;
  }
}
