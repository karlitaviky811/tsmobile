import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tsmobile/src/core/theme/app.styles.dart';
import 'package:tsmobile/src/models/part_request.dart';
import 'package:http/http.dart' as http;
import 'package:tsmobile/src/models/visit_model.dart';
import 'package:tsmobile/src/services/tecnical_visitis_service.dart';

class RepuestoScreen extends StatefulWidget {
  final Visit visit;

  RepuestoScreen({required this.visit});

  @override
  _RepuestoScreenState createState() => _RepuestoScreenState();
}

class _RepuestoScreenState extends State<RepuestoScreen> {
  List<Repuesto> repuestos = [];
  String repuestoName = '';
  List<String> imagePaths = [];
  List<Repuesto> partRequests = [];
  TextEditingController _repuestoController = TextEditingController();
  TextEditingController _comentariosGeneralesController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchPartRequests();
  }

  Future<void> _fetchPartRequests() async {
    print(
        'Fetching part requests from http://3.137.100.242:3000/api/v1/part-requests?technical_visit_id=${widget.visit.id}&page=1');

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');
    final response = await http.get(
      Uri.parse(
          'http://3.137.100.242:3000/api/v1/part-requests?technical_visit_id=${widget.visit.id}&page=1'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      if (data.containsKey('data')) {
        final List<dynamic> partRequestsJson = data['data'];
        setState(() {
          partRequests =
              partRequestsJson.map((json) => Repuesto.fromJson(json)).toList();
        });
      }
    } else {
      print('Error fetching part requests: ${response.body}');
    }
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        imagePaths.add(pickedFile.path);
      });
    }
  }

  void _showToast(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        action: SnackBarAction(
          label: 'OK',
          onPressed: ScaffoldMessenger.of(context).hideCurrentSnackBar,
        ),
      ),
    );
  }

  Future<void> _submitForm() async {
    // Aquí va la lógica para enviar la solicitud de repuesto
    // Utiliza los valores en _repuestoController.text, _comentariosGeneralesController.text, e imagePaths
    print('Solicitud enviada con los siguientes datos:');
    print('Repuesto: ${_repuestoController.text}');
    print('Observaciones: ${_comentariosGeneralesController.text}');
    print('Imágenes adjuntas: $imagePaths');

    Map<String, dynamic> repuestos = {
      "title": _repuestoController,
      "technical_visit_id": widget.visit.id,
      "observations": _comentariosGeneralesController,
    };
    var serviceVisit = new VisitService();
    var res = await serviceVisit.sendUpdateDataVisitPartRequest(
        repuestos, widget.visit.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Nombre del repuesto',
                labelStyle: TextStyle(color: Colors.black54, fontSize: 16),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 1),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xff051937), width: 1),
                ),
              ),
              controller: _repuestoController,
            ),
            const SizedBox(height: 10),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Observaciones',
                labelStyle: TextStyle(color: Colors.black54, fontSize: 16),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 1),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xff051937), width: 1),
                ),
              ),
              controller: _comentariosGeneralesController,
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                if (imagePaths.length < 5) {
                  await _pickImage();
                } else {
                  _showToast('Solo se pueden cargar hasta 5 imágenes');
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff051937),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Adjuntar imágenes de repuesto',
                  style: TextStyle(color: Colors.white)),
            ),
            if (imagePaths.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      'Imágenes cargadas:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Wrap(
                    children: imagePaths.map((path) {
                      return Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Image.file(
                          File(path),
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _submitForm,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff051937),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Enviar solicitud',
                  style: TextStyle(color: Colors.white)),
            ),
            partRequests.isEmpty
                ? Text('No hay solicitudes de repuesto.')
                : Expanded(
                    child: ListView.builder(
                      itemCount: partRequests.length,
                      itemBuilder: (context, index) {
                        final request = partRequests[index];
                        return ListTile(
                          title: Text(
                            request.name ?? 'Repuesto Desconocido',
                            style: AppStyle.txtPoppinsRegular12Gray,
                          ),
                          subtitle: Text(
                            request.observation,
                            style: AppStyle.txtPoppinsRegular12Gray,
                          ),
                          trailing: Chip(
                            label: Text(request.status == 1
                                ? 'Solicitado'
                                : 'Entregado'),
                            backgroundColor: request.status == 1
                                ? Colors.orange
                                : Colors.green,
                          ),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
