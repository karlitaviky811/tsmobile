import 'package:tsmobile/src/features/main/screens/accept_decline_ticket.dart';
import 'package:tsmobile/src/features/main/screens/detail_ticket.dart';
import 'package:tsmobile/src/features/main/screens/detail_ticket_accept_decline_view.dart';
import 'package:tsmobile/src/features/main/screens/profile_user.dart';
import 'package:tsmobile/src/features/main/screens/reservation_screen.dart';
import 'package:tsmobile/src/features/main/screens/reservations_screen.dart';
import 'package:tsmobile/src/features/main/screens/tab1_page.dart';
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
      ReservationScreen.route: (BuildContext context) =>
          const ReservationScreen(),
      ReservationsScreenCLient.route: (BuildContext context) =>
          const ReservationsScreenCLient(),
      ExpandableOptions.route: (BuildContext context) =>
          const ExpandableOptions(),
      ProfileUser.route: (BuildContext context) => const ProfileUser(),
      AcceptDeclineTicket.route: (BuildContext context) =>
          const AcceptDeclineTicket(ticketId: 0),
      TicketDetailPageView.route: (BuildContext context) =>
          TicketDetailPageView(),
      TicketAcceptedProgressDetailPage.route: (BuildContext context) =>
          TicketAcceptedProgressDetailPage(
            ticket: tickets[0],
          )
    });

    return routes;
  }
}
