import 'package:tsmobile/src/features/main/screens/detail_ticket.dart';
import 'package:tsmobile/src/features/main/screens/profile_user.dart';
import 'package:tsmobile/src/features/main/screens/reservation_screen.dart';
import 'package:tsmobile/src/features/main/screens/reservations_screen.dart';
import 'package:tsmobile/src/features/main/screens/tab1_page.dart';
import 'package:flutter/material.dart';
import 'package:tsmobile/src/features/main/screens/tabs_page.dart';

class MainRouter {
  static Map<String, Widget Function(BuildContext)> getRoutes() {
    Map<String, Widget Function(BuildContext)> routes = {};

    routes.addAll({
      TabsPage.route: (BuildContext context) => const TabsPage(),
      ReservationScreen.route: (BuildContext context) => const ReservationScreen(),
      ReservationsScreenCLient.route: (BuildContext context) =>const ReservationsScreenCLient(),
      ExpandableOptions.route : (BuildContext context) =>const ExpandableOptions(),
      ProfileUser.route : (BuildContext context) =>  const ProfileUser()
    });

    return routes;
  }
}
