import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tsmobile/src/models/tickets_model.dart';
import 'package:tsmobile/src/services/service_ticket_service.dart';

class TticketProvider with ChangeNotifier {
  final TicketService _serviceTicket = TicketService();
  List<ServiceTicket> _tickets = [];

  List<ServiceTicket> get tickets => _tickets;

  Future<void> loadTickets() async {
    _tickets = await _serviceTicket.fetchServiceTickets();
    notifyListeners();
  }

  Future<void> updateTickets(idTicket, data) async {
    _tickets = await _serviceTicket.updateTickets(idTicket, data);
    notifyListeners();
  }
}
