
import 'package:tsmobile/src/features/main/screens/chat_screen.dart';
import 'package:tsmobile/src/features/main/screens/detail_ticket_accept_decline_view.dart';
import 'package:tsmobile/src/features/main/screens/profile_user.dart';
import 'package:flutter/material.dart';
import 'package:tsmobile/src/features/main/screens/tabs_page.dart';
import 'package:tsmobile/src/interfaces/ticket.dart';

import '../screens/ticket_accepted_progress.dart';

class MainRouter {
  static Map<String, Widget Function(BuildContext)> getRoutes() {
    Map<String, Widget Function(BuildContext)> routes = {};
    final List<Ticket> tickets = [
      Ticket(
          id: '1',
          title: 'Problema con la conexión',
          description: 'No puedo conectar a internet.'),
      Ticket(
          id: '2',
          title: 'Error en la aplicación',
          description: 'La aplicación se cierra inesperadamente.'),
    ];
    routes.addAll({
      TabsPage.route: (BuildContext context) => const TabsPage(),
      ProfileUser.route: (BuildContext context) => const ProfileUser(),
      TicketDetailPageView.route: (BuildContext context) =>
          TicketDetailPageView(),
      TicketAcceptedProgressDetailPage.route: (BuildContext context) =>
          TicketAcceptedProgressDetailPage(
            ticket: tickets[0],
          ),
      ChatScreen.route : (BuildContext context) =>
          ChatScreen(),
    });

    return routes;
  }
}
