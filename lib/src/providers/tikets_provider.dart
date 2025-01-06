import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tsmobile/src/models/tickets_model.dart';
import 'package:tsmobile/src/services/service_ticket_service.dart';
import 'package:tsmobile/src/services/tecnical_visitis_service.dart';
import 'package:http/http.dart' as http;
class TicketProvider with ChangeNotifier {
  List<ServiceTicket> _tickets = [];
  ServiceTicket? _ticketInfo;
  bool _isLoading = false;
  final TicketService _ticketService = TicketService();
  int _currentPage = 1;
  bool _hasMore = true;
  bool get hasMore => _hasMore;
  List<ServiceTicket> get tickets => _tickets;
  ServiceTicket? get ticketInfo => _ticketInfo;
  bool get isLoading => _isLoading;
  Timer? _debounce;
   
  
  Future<void> loadTickets({int page = 1, String query = ''}) async {
  if (_isLoading) return;

    _isLoading = true;


    try {
      // Implementa la lógica para cargar los tickets de la página 'page'.
      // Esta es una llamada de ejemplo, ajústala según tu lógica de API.
      final response = await _ticketService.fetchServiceTickets(page);

      if (response.isNotEmpty) {
        if (page == 1) {
          _tickets = response;
            notifyListeners();
        } else {
          _tickets.addAll(response);
            notifyListeners();
        }
        _currentPage = page;
        _hasMore = response.length == 20; // Cambia 20 por el tamaño de tu página.
      } else {
        _hasMore = false;
      }
    } catch (e) {
      print('Error loading tickets: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshTickets() async {
    _currentPage = 1;
    _tickets.clear();
    _hasMore = true;
    await loadTickets(page: _currentPage);
  }

  Future<void> loadMoreTickets() async {
    if (_hasMore) {
      await loadTickets(page: _currentPage + 1);
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

    Future<void> searchTicketByTag(String searchQuery, String filter) async {
    _isLoading = true;

    try {
      // Obtener el ticket como un objeto ServiceTicket
      ServiceTicket ticket = await _ticketService.fetchServiceTicketById(searchQuery);
      _ticketInfo = ticket;
      notifyListeners();
    } catch (e) {
      print('Error al cargar el ticket: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  Future<void> updateTicket(
      ServiceTicket ticket, Map<String, dynamic> data) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth_token');
      
      if (token != null) {
        await _ticketService.updateTickets(
            ticket.serviceCallId.toString(), data, token);

        final Map<String, dynamic> dataVisit = {
          'visit_date': data['start_date'],
          'title': data['additional_notes'],
          'ticket_id': ticket.serviceCallId.toString()
        };
        try {
          final visistService = VisitService();
          await visistService.sendDataVisit(dataVisit);

          loadTicketById(ticket.serviceCallId.toString()); // Update the list of tickets after updating a ticket
        } catch (err) {
          print('Error al actualizar el ticket: $err');
        }
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

   void searchTickets(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(seconds: 4), () {
      loadTickets(query: query);
    });
  }

  Future<List<ServiceTicket>> fetchTicketsFromApi(int page, String query) async {
    final url = 'http://3.137.100.242:3000/api/v1/tickets?filter[title]=$query&page=$page';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as List;
      return data.map((json) => ServiceTicket.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load tickets');
    }
  }
}





