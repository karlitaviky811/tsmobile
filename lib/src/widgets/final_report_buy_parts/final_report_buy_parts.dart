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
  final bool showButtons; // Nuevo parámetro

  InvoiceSparePartFinal({
    required this.initialImages,
    required this.budgetAmount,
    required this.requestId,
    required this.showButtons, // Valor por defecto
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
      await _fetchAllImages();
      print('Fetched all images successfully.');
    } catch (e) {
      print('Error during fetch: $e');
      throw e; // Rethrow the exception after logging it
    }
  }

  Future<Map<String, List<ImageData>>> _fetchAllImages() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    final budgetResponse = await http.get(
      Uri.parse(
          'http://3.137.100.242:3000/api/v1/media?model_type=PartRequest&model_id=${widget.requestId}&collection_name=budget'),
      headers: {
        'Content-Type': 'application/json',
        "Accept": "application/json",
        'Authorization': 'Bearer $token',
      },
    );

    final partResponse = await http.get(
      Uri.parse(
          'http://3.137.100.242:3000/api/v1/media?model_type=PartRequest&model_id=${widget.requestId}&collection_name=part'),
      headers: {
        'Content-Type': 'application/json',
        "Accept": "application/json",
        'Authorization': 'Bearer $token',
      },
    );

    final invoiceResponse = await http.get(
      Uri.parse(
          'http://3.137.100.242:3000/api/v1/media?model_type=PartRequest&model_id=${widget.requestId}&collection_name=invoice'),
      headers: {
        'Content-Type': 'application/json',
        "Accept": "application/json",
        'Authorization': 'Bearer $token',
      },
    );

    if (budgetResponse.statusCode == 200 && partResponse.statusCode == 200 && invoiceResponse.statusCode == 200) {
      List<dynamic> budgetData = json.decode(budgetResponse.body)['data'];
      List<dynamic> partData = json.decode(partResponse.body)['data'];
      List<dynamic> invoiceData = json.decode(invoiceResponse.body)['data'];
      return {
        'budget': budgetData.map((item) => ImageData.fromJson(item)).toList(),
        'part': partData.map((item) => ImageData.fromJson(item)).toList(),
        'invoice': invoiceData.map((item) => ImageData.fromJson(item)).toList(),
      };
    } else {
      throw Exception('Error fetching images');
    }
  }

  Future<void> _submitForm() async {
    final imageProvider =
        Provider.of<ImageProviderTechnicalInvoice>(context, listen: false);
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
    return FutureBuilder<Map<String, List<ImageData>>>(
      future: _fetchAllImages(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No hay imágenes disponibles.'));
        } else {
          final budgetImages = snapshot.data!['budget']!;
          final partImages = snapshot.data!['part']!;
          final invoiceImages = snapshot.data!['invoice']!;
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
                    partImages.isEmpty
                        ? Text(
                            'No se encontraron imágenes del repuesto solicitado.')
                        : ImageUploaderSparePartsNew(
                            initialImages: partImages,
                            showAddButton: false,
                          ),
                    budgetImages.isEmpty
                        ? Text('No se encontraron imágenes del presupuesto.')
                        : ImageUploaderBuySparePartTechnical(
                            initialImages: budgetImages,
                            showAddButton: false,
                          ),
                    invoiceImages.isEmpty
                        ? Text('No se encontraron imágenes de la factura.')
                        : ImageUploaderInvoiceThecnical(
                            initialImages: invoiceImages,
                            showAddButton: widget.showButtons, // Mostrar botón condicionalmente
                          ),
                    if (widget.showButtons)
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