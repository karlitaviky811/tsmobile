import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tsmobile/src/models/part_request.dart';
import 'package:tsmobile/src/models/visit_model.dart';
import 'package:tsmobile/src/providers/visit_provider.dart';
import 'package:tsmobile/src/services/tabulator_service.dart';
import 'package:tsmobile/src/services/tecnical_visitis_service.dart';
import 'package:http/http.dart' as http;

import 'package:tsmobile/src/widgets/edit_visit_card_log.dart';

class RepairLogCard extends StatefulWidget {
  final String ticketId;
  late Visit visit;

  var type;

  RepairLogCard(
      {required this.ticketId, required this.visit, required this.type});

  @override
  _RepairLogCardState createState() => _RepairLogCardState();
}

class _RepairLogCardState extends State<RepairLogCard> {
  final ImagePicker _picker = ImagePicker();
  late TextEditingController _tituloController;
  late TextEditingController _dateController;
  List<String> _initialValues = [];
  List<MultiSelectItem<String>> _items = [];
  final TabulatorService _tabulatorService = TabulatorService();
  List<Repuesto> partRequests = [];
  @override
  void initState() {
    super.initState();
    _tituloController = TextEditingController();
    _dateController = TextEditingController();
    _fetchVisitDetails();
    _fetchPartRequests();
  
  }

  Color _getChipColor(int estado) {
    switch (estado) {
      case 1:
        return Colors.lightBlue.shade300;
      case 2:
        return Colors.lightGreen.shade300;
      case 3:
        return Colors.deepOrange.shade200;
      case 4:
        return Colors.deepPurple.shade200;
      case 5:
        return Colors.pink.shade200;
      default:
        return Colors.grey.shade300;
    }
  }

  String _getChipLabel(int estado) {
    switch (estado) {
      case 1:
        return 'Reparación';
      case 2:
        return 'Solicitud de repuesto';
      case 3:
        return 'Sin stock';
      case 4:
        return 'Envío de presupuesto';
      case 5:
        return 'Compra externa';
      default:
        return 'Otro';
    }
  }

  IconData _getChipIcon(int estado) {
    switch (estado) {
      case 1:
        return Icons.build;
      case 2:
        return Icons.shopping_cart;
      case 3:
        return Icons.warning;
      case 4:
        return Icons.attach_money;
      case 5:
        return Icons.shopping_bag;
      default:
        return Icons.info;
    }
  }

  Future<void> _fetchVisitDetails() async {
    final visitProvider = Provider.of<VisitProvider>(context, listen: false);
    await visitProvider.fetchVisitById(widget.visit.id.toString());
    final visit = visitProvider.fetchVisitById(widget.visit.id.toString());
    final visitData = visitProvider.visitData;
    if (visitData != null) {
        _loadTabulators();
      setState(() {
        widget.visit = visitData;
        _tituloController.text = visitData.title;
        _dateController.text =
            visitData.visitDate.toIso8601String().split('T')[0];
      });
    }
  }

  Future<void> fetchVisitsById() async {
    var providerVisit = Provider.of<VisitProvider>(context, listen: false);
    providerVisit.fetchVisitById(widget.visit.id.toString());
    widget.visit = providerVisit.visitData!;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: widget.visit.visitDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != widget.visit.visitDate) {
      setState(() {
        widget.visit.visitDate = picked;
        _dateController.text = picked.toIso8601String().split('T')[0];
      });
    }
  }

  Future<void> _loadTabulators() async {
    final tabulatorData = await _tabulatorService.fetchTabulators();
    if (tabulatorData != null && tabulatorData.containsKey('data')) {
      List<dynamic> data = tabulatorData['data'];

      print('services ${widget.visit.services}');
      setState(() {
        _items = data
            .map(
                (item) => MultiSelectItem<String>(item['n'], item['repuestos']))
            .toList();
      });
      _initialValues =
          widget.visit.services.map((service) => service.toString()).toList();
    }
  }

  Future<void> _fetchPartRequests() async {
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
    final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      if (data.containsKey('data')) {
        final List<dynamic> partRequestsJson = data['data'];
        setState(() {
          partRequests = partRequestsJson.isNotEmpty
              ? partRequestsJson.map((json) => Repuesto.fromJson(json)).toList()
              : [];
        });
      } else {
        setState(() {
          partRequests = [];
        });
      }
    } else {
      print('Error fetching part requests: ${response.body}');
      setState(() {
        partRequests = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        width: double.infinity,
        child: Card(
          color: Colors.white,
          elevation: 20,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Chip(
                          label: Text(_getChipLabel(widget.visit.status)),
                          backgroundColor: _getChipColor(widget.visit.status),
                          avatar: Icon(
                            _getChipIcon(widget.visit.status),
                            color: Colors.white,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            side: const BorderSide(color: Colors.transparent),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _tituloController,
                      decoration: const InputDecoration(
                        labelText: 'Título de la reparación',
                        labelStyle:
                            TextStyle(color: Colors.black54, fontSize: 16),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey, width: 1),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xff051937), width: 1),
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          widget.visit.title = value;
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _dateController,
                      decoration: InputDecoration(
                        labelText: 'Fecha de reparación',
                        labelStyle: const TextStyle(
                            color: Colors.black54, fontSize: 16),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.calendar_today,
                              color: Color(0xff051937)),
                          onPressed: () => _selectDate(context),
                        ),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey, width: 1),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xff051937), width: 1),
                        ),
                      ),
                      readOnly: true,
                    ),
                    const SizedBox(height: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Servicios',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              color: Colors.black54),
                        ),
                        MultiSelectDialogField(
                          items: _items,
                          title: const Text('Servicios realizados'),
                          backgroundColor: Colors.white,
                          selectedColor: const Color(0xff051937),
                          buttonIcon:
                              const Icon(Icons.list, color: Color(0xff051937)),
                          buttonText: const Text(
                            'Seleccione uno o más servicios',
                            style: TextStyle(
                                color: Color(0xff051937), fontSize: 16),
                          ),
                          initialValue: _initialValues,
                          onConfirm: (values) {
                            setState(() {
                              _initialValues = values.cast<String>();
                              widget.visit.selectedServicios = _initialValues;
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    Center(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff051937),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 10),
                        ),
                        onPressed: () async {
                          var serviceVisit = VisitService();
                          Map<String, dynamic> params = {
                            "services": widget.visit.selectedServicios,
                            "spareparts":
                                widget.visit.visitDate.toIso8601String(),
                            "observations":
                                'Probando el update de la visita deberian estar asociados los servicios por visita',
                          };
                          Map<String, dynamic> data = {
                            "title": widget.visit.title,
                            "visit_date":
                                widget.visit.visitDate.toIso8601String(),
                            "services": widget.visit.selectedServicios,
                            "observations": widget.visit.observations,
                            "tabulator_id": 50,
                            "meta": jsonEncode(params)
                          };
                          final Map<String, dynamic> dataVisit = {
                            'visit_date':
                                widget.visit.visitDate.toIso8601String(),
                            'title': widget.visit.title,
                            "services": widget.visit.selectedServicios,
                            'ticket_id': widget.ticketId
                          };

                          if (widget.type == 'Agregar Nueva Visita') {
                            var createVisit =
                                await serviceVisit.sendDataVisit(dataVisit);
                            if (createVisit == true) {
                              await _fetchVisitDetails;
                              await _loadTabulators();
                            }

                            Fluttertoast.showToast(
                                msg:
                                    "Detalles de la visita guardados exitosamente",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.green,
                                textColor: Colors.white,
                                fontSize: 16.0);
                          } else {
                            var res = await serviceVisit.sendUpdateDataVisit(
                                data, widget.visit.id);
                            if (res == true) {
                              await _fetchVisitDetails();
                              await _loadTabulators();
                            }

                            Fluttertoast.showToast(
                                msg: "Visita actualizada exitosamente",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.green,
                                textColor: Colors.white,
                                fontSize: 16.0);
                          }
                        },
                        icon: const Icon(Icons.save, color: Colors.white),
                        label: const Text('Guardar',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
