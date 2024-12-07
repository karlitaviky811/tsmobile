import 'dart:convert';
import 'package:http/http.dart' as http;

class ItemService {
  final String apiUrl = "https://example.com/api/items";  // URL del endpoint ficticio

  Future<List<Item>> getItems() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      List<dynamic> itemsJson = jsonDecode(response.body);
      return itemsJson.map((json) => Item.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load items');
    }
  }
}

class Item {
  final String name;
  final List<String> tags;

  Item(this.name, this.tags);

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      json['name'],
      List<String>.from(json['tags']),
    );
  }
}
