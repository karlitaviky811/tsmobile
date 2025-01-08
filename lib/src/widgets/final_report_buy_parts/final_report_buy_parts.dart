import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:tsmobile/src/models/images_model.dart';
import 'package:tsmobile/src/providers/provider_invoice_spare_parts.dart';
import 'package:http/http.dart' as http;
import 'package:tsmobile/src/widgets/image_uploader_new.dart';
import 'package:tsmobile/src/widgets/images_loaders/image_uploader_buy_spare_part_technical.dart';
import 'package:tsmobile/src/widgets/images_loaders/image_uploader_invoice_spare_parts.dart';
import 'package:tsmobile/src/services/send_file_service.dart';
import 'package:tsmobile/src/widgets/images_loaders/image_uploader_spare_parts.dart';

class InvoiceSparePartFinal extends StatefulWidget {
  final List<ImageData> initialImages;
  final double budgetAmount;
  final int requestId;
  final bool showButtons;

  InvoiceSparePartFinal({
    Key? key,
    required this.initialImages,
    required this.budgetAmount,
    required this.requestId,
    required this.showButtons,
  }) : super(key: key);

  @override
  _InvoiceSparePartState createState() => _InvoiceSparePartState();
}

class _InvoiceSparePartState extends State<InvoiceSparePartFinal> {
  @override
  void initState() {
    super.initState();
    budgetAmount = widget.budgetAmount;
    //_fetchImagesAndBudget(widget.requestId);
  }

  Map<String, List<ImageData>> _images = {
    'budget': [],
    'part': [],
    'invoice': [],
  };
  late double budgetAmount;

  Future<void> _fetchImagesAndBudget(int requestId) async {
    try {
      print('Fetching images and budget for requestId: $requestId');
      await _fetchAllImages();
      print('Fetched all images successfully for requestId: $requestId');
    } catch (e) {
      print('Error during fetch for requestId $requestId: $e');
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

    if (budgetResponse.statusCode == 200 &&
        partResponse.statusCode == 200 &&
        invoiceResponse.statusCode == 200) {
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
    final data = {'status': 8};
    final imageProvider =
        Provider.of<ImageProviderTechnicalInvoice>(context, listen: false);

    await sendUpdateDataVisitPartRequestPresupuest(
        data, widget.requestId, imageProvider.newImagePaths);
  }

  Future<void> sendUpdateDataVisitPartRequestPresupuest(
      Map<String, dynamic> data, int idTicket, List<String> imagePaths) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    try {
      final response = await http.put(
        Uri.parse(
            'http://3.137.100.242:3000/api/v1/part-requests/${widget.requestId}'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(data),
      );

      var jsonResponse = jsonDecode(response.body);

      if (response.statusCode == 200) {
        for (String path in imagePaths) {
          await sendFile(File(path), 'PartRequest',
              jsonResponse['data']['id'].toString(), 'invoice');
        }

        if (mounted) {
          setState(() {});
        }

        Fluttertoast.showToast(
            msg: "Factura enviada éxitosamente",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        Fluttertoast.showToast(
            msg: "Error al enviar factura",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } catch (e) {
      Fluttertoast.showToast(
          msg: "Error al enviar datos",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
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
        } else {
          final budgetImages = snapshot.data!['budget']!;
          final partImages = snapshot.data!['part']!;
          final invoiceImages = snapshot.data!['invoice']!;
          print('Images loaded successfully.');
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ExpansionTile(
              title: const Text('Detalles de la compra del repuesto'),
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (budgetAmount > 0.0)
                      Text(
                          'Monto del Presupuesto: \$${budgetAmount.toStringAsFixed(2)}'),
                    partImages.isEmpty
                        ? const Text(
                            'No se encontraron imágenes del repuesto solicitado.')
                        : ImageUploaderSpareParts(
                            initialImages: partImages,
                            showAddButton: false,
                          ),
                    budgetImages.isEmpty
                        ? const Text(
                            'No se encontraron imágenes del presupuesto.')
                        : ImageUploaderBuySparePartTechnical(
                            initialImages: budgetImages,
                            showAddButton: false,
                          ),
                    invoiceImages.isEmpty && widget.showButtons == false
                        ? const Text(
                            'No se encontraron imágenes de la factura.')
                        : ImageUploaderInvoiceThecnical(
                            initialImages: invoiceImages,
                            showAddButton: widget
                                .showButtons, // Mostrar botón condicionalmente
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
              ],
            ),
          );
        }
      },
    );
  }
}
