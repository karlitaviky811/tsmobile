import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tsmobile/src/models/images_model.dart';
import 'package:tsmobile/src/providers/provider_invoice_spare_parts.dart';
import 'package:tsmobile/src/services/send_file_service.dart';
import 'package:tsmobile/src/widgets/image_uploader_new.dart';
import 'package:tsmobile/src/widgets/images_loaders/image_uploader_buy_spare_part_technical.dart';
import 'package:tsmobile/src/widgets/images_loaders/image_uploader_invoice_spare_parts.dart';
import 'package:http/http.dart' as http;

class InvoiceSparePartFinal extends StatefulWidget {
  final int visitId;
  final List<ImageData> initialImages;

  InvoiceSparePartFinal({
    required this.visitId,
    required this.initialImages,
  });

  @override
  _InvoiceSparePartState createState() => _InvoiceSparePartState();
}

class _InvoiceSparePartState extends State<InvoiceSparePartFinal> {
  List<ImageData> _partImages = [];
  List<ImageData> _budgetImages = [];
  List<ImageData> _invoiceImages = [];
  double budgetAmount = 0.0;

  @override
  void initState() {
    super.initState();
    _fetchImagesAndBudget();
  }

  Future<void> _fetchImagesAndBudget() async {
    try {
      await getImagesForRequest1(widget.visitId, 'part', _partImages);
      await getImagesForRequest2(widget.visitId, 'budget', _budgetImages);
      await getImagesForRequest3(widget.visitId, 'invoice', _invoiceImages);
    } catch (e) {
      print('Error during fetch: $e');
      throw e; // Rethrow the exception after logging it
    }
  }

  Future<void> getImagesForRequest1(
      int requestId, String collectionName, List<ImageData> targetList) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    print('Fetching images for $collectionName...');
    final response = await http.get(
      Uri.parse(
          'http://3.137.100.242:3000/api/v1/media?model_type=PartRequest&model_id=$requestId&collection_name=$collectionName'),
      headers: {
        'Content-Type': 'application/json',
        "Accept": "application/json",
        'Authorization': 'Bearer $token',
      },
    );

    print('Response status for $collectionName: ${response.statusCode}');

    var data = json.decode(response.body)['success'];

    final responseBody = json.decode(response.body);
    print('response $responseBody');

    if (responseBody['status'] == true) {
      List<dynamic> data = json.decode(response.body)['data'];
      if (mounted) {
        setState(() {
          targetList
              .addAll(data.map((item) => ImageData.fromJson(item)).toList());
        });
        print('Images fetched for $collectionName: ${targetList.length}');
      }
    } else {
      print(
          'Error fetching images from $collectionName: ${response.statusCode}');
    }
  }

  Future<void> getImagesForRequest2(
      int requestId, String collectionName, List<ImageData> targetList) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    print('Fetching images for $collectionName...');
    final response = await http.get(
      Uri.parse(
          'http://3.137.100.242:3000/api/v1/media?model_type=PartRequest&model_id=$requestId&collection_name=$collectionName'),
      headers: {
        'Content-Type': 'application/json',
        "Accept": "application/json",
        'Authorization': 'Bearer $token',
      },
    );

    print('Response status for $collectionName: ${response.statusCode}');

    final responseBody = json.decode(response.body);
    print('response $responseBody');
    if (responseBody['status'] == true) {
      List<dynamic> data = json.decode(response.body)['data'];
      if (mounted) {
        setState(() {
          targetList
              .addAll(data.map((item) => ImageData.fromJson(item)).toList());
        });
        print('Images fetched for $collectionName: ${targetList.length}');
      }
    } else {
      print(
          'Error fetching images from $collectionName: ${response.statusCode}');
    }
  }

  Future<void> getImagesForRequest3(
      int requestId, String collectionName, List<ImageData> targetList) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    print('Fetching images for $collectionName...');
    final response = await http.get(
      Uri.parse(
          'http://3.137.100.242:3000/api/v1/media?model_type=PartRequest&model_id=$requestId&collection_name=$collectionName'),
      headers: {
        'Content-Type': 'application/json',
        "Accept": "application/json",
        'Authorization': 'Bearer $token',
      },
    );

    print('Response status for $collectionName: ${response.statusCode}');

    final responseBody = json.decode(response.body);
    print('response $responseBody');
    if (responseBody['status'] == true) {
      List<dynamic> data = json.decode(response.body)['data'];
      if (mounted) {
        setState(() {
          targetList
              .addAll(data.map((item) => ImageData.fromJson(item)).toList());
        });
        print('Images fetched for $collectionName: ${targetList.length}');
      }
    } else {
      print(
          'Error fetching images from $collectionName: ${response.statusCode}');
    }
  }

  Future<void> getBudgetAmount(int requestId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    print('Fetching budget amount...');
    final response = await http.get(
      Uri.parse('http://3.137.100.242:3000/api/v1/part-requests/$requestId'),
      headers: {
        'Content-Type': 'application/json',
        "Accept": "application/json",
        'Authorization': 'Bearer $token',
      },
    );

    print('Response status for budget amount: ${response.statusCode}');

    if (response.statusCode == 200) {
      var data = json.decode(response.body)['data'];
      if (mounted) {
        setState(() {
          budgetAmount = data['budget_amount']?.toDouble() ?? 0.0;
        });
        print('Budget amount fetched: $budgetAmount');
      }
    } else {
      print('Error fetching budget amount: ${response.statusCode}');
    }
  }

  Future<void> _submitForm() async {
    final imageProvider =
        Provider.of<ImageProviderTechnicalInvoice>(context, listen: false);
    for (String path in imageProvider.newImagePaths) {
      await sendFile(
          File(path), 'PartRequest', widget.visitId.toString(), 'invoice');
    }

    // Limpiar imágenes después de guardarlas
    imageProvider.clearImages();

    print("Factura comprada y enviada");
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _fetchImagesAndBudget(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          return ExpansionTile(
            title: const Text('Detalles de la compra del repuesto'),
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (budgetAmount > 0.0)
                      Text(
                          'Monto del Presupuesto: \$${budgetAmount.toStringAsFixed(2)}'),
                    const Text(
                      'Imágenes del Repuesto Solicitado',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    ImageUploaderSparePartsNew(
                      initialImages: _partImages,
                      showAddButton: false,
                    ),
                    const Text(
                      'Imágenes del Presupuesto',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    ImageUploaderBuySparePartTechnical(
                      initialImages: _budgetImages,
                      showAddButton: false,
                    ),
                    const Text(
                      'Imágenes de la Factura',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    ImageUploaderInvoiceThecnical(
                      initialImages: _invoiceImages,
                      showAddButton: false,
                    ),
                    Consumer<ImageProviderTechnicalInvoice>(
                      builder: (context, imageProvider, child) {
                        return ElevatedButton.icon(
                          onPressed: imageProvider.newImagePaths.isNotEmpty
                              ? _submitForm
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          icon: const Icon(Icons.check, color: Colors.white),
                          label: const Text(
                            'He comprado el repuesto',
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        }
      },
    );
  }
}
