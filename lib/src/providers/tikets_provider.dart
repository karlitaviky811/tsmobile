import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tsmobile/src/models/tickets_model.dart';
import 'package:tsmobile/src/services/service_ticket_service.dart';

class TicketProvider with ChangeNotifier {
  List<ServiceTicket> _tickets = [];
  ServiceTicket? _ticketInfo;
  bool _isLoading = false;
  final TicketService _ticketService = TicketService();

  List<ServiceTicket> get tickets => _tickets;
  ServiceTicket? get ticketInfo => _ticketInfo;
  bool get isLoading => _isLoading;

  Future<void> loadTickets() async {
    _isLoading = true;

    try {
      _tickets = await _ticketService.fetchServiceTickets();
      notifyListeners();
    } catch (e) {
      print('Error al cargar los tickets: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadTicketById(String id) async {
    _isLoading = true;
  
    try {
      // Obtener el ticket como un objeto ServiceTicket
      ServiceTicket ticket = await _ticketService.fetchServiceTicketById(id);
      _ticketInfo = ticket;
        notifyListeners();
    } catch (e) {
      print('Error al cargar el ticket: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  Future<void> updateTicket(ServiceTicket ticket, Map<String, dynamic> data) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth_token');
      if (token != null) {
        await _ticketService.updateTickets(ticket.serviceCallId.toString(), data, token);
        loadTicketById(ticket.serviceCallId.toString()); // Update the list of tickets after updating a ticket
      }
    } catch (e) {
      print('Error al actualizar el ticket: $e');
    }
  }

  void acceptTicket(ServiceTicket ticket) {
    updateTicket(ticket, {
      'status': 'Accepted',
    });
  }

  void rejectTicket(ServiceTicket ticket) {
    updateTicket(ticket, {
      'status': 'Rejected',
    });
  }
}
