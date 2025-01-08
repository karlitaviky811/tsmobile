import 'package:flutter/material.dart';
import 'package:tsmobile/src/services/map_coordinates.dart';

class GeolocationProvider with ChangeNotifier {
   GeolocationService _coordinateService = GeolocationService();
  String _coordinateString = '';

  String get coordinates => _coordinateString;

  Future<void> getCoordinates(latitude, longitude) async {
    _coordinateString = await _coordinateService.getAddressFromCoordinates(latitude, longitude);
    notifyListeners();
  }

}
