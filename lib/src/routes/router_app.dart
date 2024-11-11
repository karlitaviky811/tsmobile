
import 'package:flutter/material.dart';
import 'package:tsmobile/src/features/auth/router/router_auth.dart';
import 'package:tsmobile/src/features/main/router/main_router.dart';

class RouterApp {
  static const String initialRoute = 'welcome-route';

  static Map<String, Widget Function(BuildContext)> getRoutes() {
    Map<String, Widget Function(BuildContext)> routes = {};
  
    routes.addAll(AuthRouter.getRoutes());
    routes.addAll(MainRouter.getRoutes());

    return routes;
  }

  // static Route<dynamic> onGenerateRoute(RouteSettings settings) {
  //   return RouterMain.onGenerateRoute(settings);
  // }
}
