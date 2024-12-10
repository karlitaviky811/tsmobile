import 'dart:convert';
import 'package:http/http.dart' as http;


class GeolocationService {
Future<String> getAddressFromCoordinates(double latitude, double longitude) async {
  final url = 'https://nominatim.openstreetmap.org/reverse?format=json&lat=$latitude&lon=$longitude&addressdetails=1';

  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    final Map<String, dynamic> data = jsonDecode(response.body);
    if (data['address'] != null) {
      return data['address']['road'] + ', ' + data['address']['city'];
    } else {
      return 'No se encontró ninguna dirección para estas coordenadas';
    }
  } else {
    throw Exception('Fallo en la geocodificación inversa');
  }
}

}