import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tsmobile/src/models/images_model.dart';
import 'package:tsmobile/src/providers/image_provider_spare_parts.dart';
import 'package:tsmobile/src/services/send_file_service.dart';
import 'package:tsmobile/src/widgets/images_loaders/image_uploader_spare_parts.dart';

class BuySparePartInitial extends StatefulWidget {
  final Map<String, dynamic> reparacion;
  final int visitId;
  final String name;
  final String observation;

  BuySparePartInitial({
    required this.reparacion,
    required this.visitId,
    required this.name,
    required this.observation,
  });

  @override
  _BuySparePartInitialState createState() => _BuySparePartInitialState();
}

class _BuySparePartInitialState extends State<BuySparePartInitial> {
  List<String> imagePaths = [];
  late Map<String, dynamic> reparacion;

  @override
  void initState() {
    super.initState();
    reparacion = Map<String, dynamic>.from(widget.reparacion);
  }

  Future<List<ImageData>> _fetchImages() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');
    final response = await http.get(
      Uri.parse(
          '${dotenv.env['API_URL']}media?model_type=PartRequest&model_id=${widget.visitId}&collection_name=part'),
      headers: {
        'Content-Type': 'application/json',
        "Accept": "application/json",
        'Authorization': 'Bearer $token',
      },
    );

    print('response ${response}');
    var jsonResponse = jsonDecode(response.body);

    if (jsonResponse['success'] == true) {
      List<dynamic> data = json.decode(response.body)['data'];
      return data.map((item) => ImageData.fromJson(item)).toList();
    } else {
      print('Error fetching images: ${response.statusCode}');
      return [];
    }
  }

  

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ImageData>>(
      future: _fetchImages(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: const Text('No hay imágenes disponiblessssssss.'));
        } else {
          final images = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ExpansionTile(
              title: const Text('Imagenes del repuesto solicitado'),
              children: [
                ImageUploaderSpareParts(
                  initialImages: images,
                  showAddButton: false,
                )
              ],
            ),
          );
        }
      },
    );
  }
}
