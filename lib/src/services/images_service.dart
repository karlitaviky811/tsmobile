import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tsmobile/src/models/images_model.dart';

class ImagesService {
 
 Future<Map<String, List<ImageData>>> fetchAllImages(int requestId) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('auth_token');

  Future<List<ImageData>> fetchImages(String collectionName) async {
    final response = await http.get(
      Uri.parse(
          'http://3.137.100.242:3000/api/v1/media?model_type=PartRequest&model_id=$requestId&collection_name=$collectionName'),
      headers: {
        'Content-Type': 'application/json',
        "Accept": "application/json",
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body)['data'];
      return data.map((item) => ImageData.fromJson(item)).toList();
    } else {
      throw Exception('Error fetching $collectionName images');
    }
  }

  try {
    final budgetImages = fetchImages('budget');
    final partImages = fetchImages('part');
    final invoiceImages = fetchImages('invoice');

    return {
      'budget': await budgetImages,
      'part': await partImages,
      'invoice': await invoiceImages,
    };
  } catch (e) {
    throw Exception('Error fetching images: $e');
  }
}

}
