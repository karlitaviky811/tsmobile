import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tsmobile/src/models/auth_model.dart';
import 'package:tsmobile/src/models/tickets_model.dart';
import 'package:tsmobile/src/services/service_ticket_service.dart';
import 'package:tsmobile/src/services/user_service.dart';

class UserProvider with ChangeNotifier {
  List<ServiceTicket> _tickets = [];
  User? _user;
  bool _isLoading = false;
  final UserService _userService = UserService();

  List<ServiceTicket> get tickets => _tickets;
  User? get user => _user;
  bool get isLoading => _isLoading;

  Future<void> obatinUserData() async {
    _isLoading = true;

    try {
      final res = await _userService.fetchUserData();

      // Simular la obtención de datos del usuario desde un servicio

      _user = User(
          id: res!.id,
          name: res!.name,
          email: res!.email,
          address: res.address,
          nameComercial: res.nameComercial,
          agency: res.agency,
          phone: res.phone,
          latitude: '10.20',
          longitude: '10.20',
          geographicalcoordinates: '',
          ntickets: 0,
          nrejectedtickets: 0,
          qualification: 0);

      _isLoading = false;

      notifyListeners();
    } catch (e) {
      print('Error al cargar la data del user: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
