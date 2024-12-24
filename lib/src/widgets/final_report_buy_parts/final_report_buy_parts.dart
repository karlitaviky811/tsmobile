import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
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
  final List<ImageData> initialImages;
  final double budgetAmount;
  final String requestId;

  InvoiceSparePartFinal({
    required this.initialImages,
    required this.budgetAmount,
    required this.requestId,
  });

  @override
  _InvoiceSparePartState createState() => _InvoiceSparePartState();
}

class _InvoiceSparePartState extends State<InvoiceSparePartFinal> {
  List<ImageData> _partImages = [];
  List<ImageData> _budgetImages = [];
  List<ImageData> _invoiceImages = [];
  late double budgetAmount;

  @override
  void initState() {
    super.initState();
    budgetAmount = widget.budgetAmount;
    _fetchImagesAndBudget();
  }

  Future<void> _fetchImagesAndBudget() async {
    try {
      print('Fetching images and budget started');
      await _getImagesForRequest(int.parse(widget.requestId), 'part', _partImages);
      await _getImagesForRequest(int.parse(widget.requestId), 'budget', _budgetImages);
      await _getImagesForRequest(int.parse(widget.requestId), 'invoice', _invoiceImages);
      print('Fetched all images successfully.');
    } catch (e) {
      print('Error during fetch: $e');
      throw e; // Rethrow the exception after logging it
    }
  }

  Future<void> _getImagesForRequest(
      int requestId, String collectionName, List<ImageData> targetList) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    print('Fetching images for $collectionName...');
    final response = await http
        .get(
          Uri.parse(
              'http://3.137.100.242:3000/api/v1/media?model_type=PartRequest&model_id=$requestId&collection_name=$collectionName'),
          headers: {
            'Content-Type': 'application/json',
            "Accept": "application/json",
            'Authorization': 'Bearer $token',
          },
        )
        .timeout(Duration(seconds: 15)); // Set a timeout for the request

    print('Response status for $collectionName: ${response.statusCode}');
    print('Response body for $collectionName: ${response.body}');

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      if (jsonResponse['success'] == true) {
        List<dynamic> data = jsonResponse['data'];
        if (data.isEmpty) {
          print('No images found for $collectionName.');
        } else if (mounted) {
          setState(() {
            targetList.addAll(data.map((item) => ImageData.fromJson(item)).toList());
          });
          print('Images fetched for $collectionName: ${targetList.length}');
        }
      } else {
        print('Error fetching images from $collectionName: ${response.statusCode}');
      }
    } else {
      print('Error fetching images from $collectionName: ${response.statusCode}');
    }
  }

  Future<void> _submitForm() async {
    final imageProvider = Provider.of<ImageProviderTechnicalInvoice>(context, listen: false);
    for (String path in imageProvider.newImagePaths) {
      await sendFile(
          File(path), 'PartRequest', widget.requestId.toString(), 'invoice');
    }

    // Limpiar imágenes después de guardarlas
    imageProvider.clearImages();

    print("Factura comprada y enviada");
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _fetchImagesAndBudget(),
      builder: (context, snapshot) {
        print('Snapshot state: ${snapshot.connectionState} ${context}');
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          print('Error snapshot: ${snapshot.error}');
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          print('Images loaded successfully.');
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
                    _partImages.isEmpty
                        ? Text('No se encontraron imágenes del repuesto solicitado.')
                        : ImageUploaderSparePartsNew(
                            initialImages: _partImages,
                            showAddButton: false,
                          ),
                    _budgetImages.isEmpty
                        ? Text('No se encontraron imágenes del presupuesto.')
                        : ImageUploaderBuySparePartTechnical(
                            initialImages: _budgetImages,
                            showAddButton: false,
                          ),
                    _invoiceImages.isEmpty
                        ? Text('No se encontraron imágenes de la factura.')
                        : ImageUploaderInvoiceThecnical(
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
