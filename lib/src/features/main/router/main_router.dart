import 'package:tsmobile/src/features/main/screens/reservation_screen.dart';
import 'package:tsmobile/src/features/main/screens/reservations_screen.dart';
import 'package:tsmobile/src/features/main/screens/tabs_page.dart';
import 'package:flutter/material.dart';

class MainRouter {
  static Map<String, Widget Function(BuildContext)> getRoutes() {
    Map<String, Widget Function(BuildContext)> routes = {};

    routes.addAll({
      TabsPage.route: (BuildContext context) => TabsPage(),
      ReservationScreen.route: (BuildContext context) => ReservationScreen(),
      ReservationsScreenCLient.route: (BuildContext context) =>ReservationsScreenCLient()
    });

    return routes;
  }
}
