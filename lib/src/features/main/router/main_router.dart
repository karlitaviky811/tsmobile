import 'package:tsmobile/src/features/main/screens/detail_ticket.dart';
import 'package:tsmobile/src/features/main/screens/profile_user.dart';
import 'package:tsmobile/src/features/main/screens/reservation_screen.dart';
import 'package:tsmobile/src/features/main/screens/reservations_screen.dart';
import 'package:tsmobile/src/features/main/screens/tab1_page.dart';
import 'package:flutter/material.dart';

class MainRouter {
  static Map<String, Widget Function(BuildContext)> getRoutes() {
    Map<String, Widget Function(BuildContext)> routes = {};

    routes.addAll({
      HomeScreen.route: (BuildContext context) => const HomeScreen(),
      ReservationScreen.route: (BuildContext context) => const ReservationScreen(),
      ReservationsScreenCLient.route: (BuildContext context) =>const ReservationsScreenCLient(),
      ExpandableOptions.route : (BuildContext context) =>const ExpandableOptions(),
      ProfileUser.route : (BuildContext context) => const ProfileUser()
    });

    return routes;
  }
}
