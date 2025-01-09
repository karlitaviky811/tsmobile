import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_select_flutter/chip_display/multi_select_chip_display.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tsmobile/src/models/images_model.dart';
import 'package:tsmobile/src/models/part_request_model.dart';
import 'package:tsmobile/src/models/visit_model.dart';
import 'package:tsmobile/src/providers/image_provider_visit.dart';

import 'package:tsmobile/src/providers/visit_provider.dart';
import 'package:tsmobile/src/services/tabulator_service.dart';
import 'package:tsmobile/src/services/tecnical_visitis_service.dart';
import 'package:http/http.dart' as http;

import 'package:tsmobile/src/widgets/images_loaders/image_uploader_visits.dart';

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
  bool _isEditing = false;
  late Visit _initialVisit;
  int _currentPage = 1;
  bool _isLoadingMore = false;
  bool _hasMoreData = true;
  final ValueNotifier<List<ImageData>> _imagesSendNotifier = ValueNotifier([]);
  late Future<void> _loadTicketFuture;

  @override
  void initState() {
    super.initState();
    _tituloController = TextEditingController();
    _dateController = TextEditingController();
    _loadTicketFuture = _loadData();
  }

  Future<void> _loadData() async {
    await Future.wait([
      _fetchVisitDetails(),
      _fetchPartRequests(),
      _loadTabulators(),
      _fetchImages(),
    ]);
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
    if (visitData != null && mounted) {
      setState(() {
        widget.visit = visitData;
        _initialVisit =
            Visit.fromJson(visitData.toJson()); // Store initial data
        _tituloController.text = visitData.title;
        _dateController.text =
            visitData.visitDate.toIso8601String().split('T')[0];
        _initialValues = List<String>.from(
            visitData.services); // Initialize with existing services
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
    if (_isLoadingMore || !_hasMoreData) return;

    setState(() {
      _isLoadingMore = true;
    });

    final tabulatorData = await _tabulatorService.fetchTabulators(
        page: _currentPage, ticketId: int.parse(widget.ticketId));
    if (tabulatorData != null && tabulatorData.containsKey('data')) {
      List<dynamic> data = tabulatorData['data'];

      if (!mounted) return; // Verificar si el widget sigue montado

      setState(() {
        _items.addAll(data
            .map(
                (item) => MultiSelectItem<String>(item['n'], item['repuestos']))
            .toList());
        _currentPage++;
        _isLoadingMore = false;
        _hasMoreData = data.isNotEmpty;
      });
    } else {
      setState(() {
        _isLoadingMore = false;
        _hasMoreData = false;
      });
    }
  }

  Future<void> _fetchPartRequests() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    print('token ${widget.visit.id}');
    final response = await http.get(
      Uri.parse(
          '${dotenv.env['API_URL']}part-requests?technical_visit_id=${widget.visit.id}&page=1'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    jsonDecode(response.body);
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

  Future<void> _reloadVisits() async {
    final visitProvider = Provider.of<VisitProvider>(context, listen: false);
    await visitProvider.fetchVisitsByTicket(widget.ticketId);
  }

  Future<void> _fetchImages() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth_token');
      if (token == null) {
        throw Exception('Token is null');
      }

      final response = await http.get(
        Uri.parse(
            '${dotenv.env['API_URL']}media?model_type=Visit&model_id=${widget.visit.id}&collection_name=visit'),
        headers: {
          'Content-Type': 'application/json',
          "Accept": "application/json",
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body)['data'];
        _imagesSendNotifier.value =
            data.map((item) => ImageData.fromJson(item)).toList();
      } else {
        print('Error fetching images: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching images: $e');
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fetchImages();
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
            child: FutureBuilder(
              future: _loadTicketFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else {
                  return Column(
                    children: [
                      Column(
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
                                      label: Text(
                                        _getChipLabel(widget.visit.status),
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                      backgroundColor:
                                          _getChipColor(widget.visit.status),
                                      avatar: Icon(
                                        _getChipIcon(widget.visit.status),
                                        color: Colors.white,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(25.0),
                                        side: const BorderSide(
                                            color: Colors.transparent),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                TextField(
                                  controller: _tituloController,
                                  decoration: const InputDecoration(
                                    labelText: 'Título de la visita',
                                    labelStyle: TextStyle(
                                        color: Colors.black54, fontSize: 16),
                                    filled: true,
                                    fillColor: Colors.white,
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      widget.visit.title = value;
                                    });
                                  },
                                  enabled: _isEditing ||
                                      widget.type == 'Agregar Nueva Visita',
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
                                    filled: true,
                                    fillColor: Colors.white,
                                  ),
                                  readOnly: true,
                                  enabled: _isEditing ||
                                      widget.type == 'Agregar Nueva Visita',
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
                                    Container(
                                      constraints: const BoxConstraints(
                                        maxHeight: 300, // Altura máxima
                                      ),
                                      child: NotificationListener<
                                          ScrollNotification>(
                                        onNotification:
                                            (ScrollNotification scrollInfo) {
                                          if (scrollInfo.metrics.pixels ==
                                                  scrollInfo.metrics
                                                      .maxScrollExtent &&
                                              !_isLoadingMore) {
                                            _loadTabulators();
                                          }
                                          return true;
                                        },
                                        child: SingleChildScrollView(
                                          child: Column(
                                            children: [
                                              MultiSelectDialogField(
                                                items: _items,
                                                title: const Text(
                                                  'Servicios realizados',
                                                  style: TextStyle(
                                                    fontFamily: 'Poppins',
                                                  ),
                                                ),
                                                backgroundColor: Colors.white,
                                                selectedColor:
                                                    const Color(0xff051937),
                                                buttonIcon: const Icon(
                                                    Icons.list,
                                                    color: Color(0xff051937)),
                                                buttonText: const Text(
                                                  'Seleccione uno o más servicios',
                                                  style: TextStyle(
                                                    color: Color(0xff051937),
                                                    fontSize: 16,
                                                    fontFamily: 'Poppins',
                                                  ),
                                                ),
                                                initialValue: _initialValues,
                                                onConfirm: (values) {
                                                  setState(() {
                                                    _initialValues =
                                                        values.cast<String>();
                                                    widget.visit
                                                            .selectedServicios =
                                                        _initialValues;
                                                  });
                                                },
                                                searchable: true,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  border: Border.all(
                                                    color: (_isEditing ||
                                                            widget.type ==
                                                                'Agregar Nueva Visita')
                                                        ? Colors.grey
                                                        : Colors.transparent,
                                                    width: 1,
                                                  ),
                                                ),
                                                chipDisplay:
                                                    MultiSelectChipDisplay(
                                                  chipColor:
                                                      const Color(0xff051937),
                                                  textStyle: const TextStyle(
                                                    color: Colors.white,
                                                    fontFamily: 'Poppins',
                                                  ),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  scroll: true,
                                                  onTap: (value) {
                                                    setState(() {
                                                      _initialValues
                                                          .remove(value);
                                                      widget.visit
                                                              .selectedServicios =
                                                          _initialValues;
                                                    });
                                                  },
                                                ),
                                              ),
                                              const SizedBox(height: 16),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                ValueListenableBuilder<List<ImageData>>(
                                  valueListenable: _imagesSendNotifier,
                                  builder: (context, imagesSend, child) {
                                    return ImageUploaderVisits(
                                        initialImages: imagesSend,
                                        showAddButton: _isEditing
                                        // Mostrar o no el botón de añadir imágenes
                                        );
                                  },
                                ),
                                const SizedBox(height: 30),
                                Center(
                                  child: _isEditing ||
                                          widget.type == 'Agregar Nueva Visita'
                                      ? ElevatedButton.icon(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                const Color(0xff051937),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 30, vertical: 10),
                                          ),
                                          onPressed: () async {
                                            var serviceVisit = VisitService();

                                            // Obtener imágenes del proveedor
                                            await sendDataVisit(
                                                context, serviceVisit);
                                          },
                                          icon: const Icon(Icons.save,
                                              color: Colors.white),
                                          label: const Text('Guardar',
                                              style: TextStyle(
                                                  color: Colors.white)),
                                        )
                                      : ElevatedButton.icon(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                const Color(0xff051937),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 30, vertical: 10),
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              _isEditing = true;
                                            });
                                          },
                                          icon: const Icon(Icons.edit,
                                              color: Colors.white),
                                          label: const Text('Editar',
                                              style: TextStyle(
                                                  color: Colors.white)),
                                        ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<void> sendDataVisit(
      BuildContext context, VisitService serviceVisit) async {
    // Obtener imágenes del proveedor
    final imageProvider =
        Provider.of<ImagesVisitProviderModel>(context, listen: false);
    List<String> imagePaths = imageProvider.newImagePaths;
    List<File> imageFiles = imagePaths.map((path) => File(path)).toList();

    Map<String, dynamic> params = {
      "services": widget.visit.selectedServicios.isNotEmpty
          ? widget.visit.selectedServicios
          : _initialValues,
      "spareparts": widget.visit.visitDate.toIso8601String(),
      "observations":
          'Probando el update de la visita deberian estar asociados los servicios por visita',
    };
    Map<String, dynamic> data = {
      "title": widget.visit.title,
      "visit_date": widget.visit.visitDate.toIso8601String(),
      "services": widget.visit.selectedServicios.isNotEmpty
          ? widget.visit.selectedServicios
          : _initialValues,
      "observations": widget.visit.observations,
      "tabulator_id": 50,
      "meta": jsonEncode(params)
    };
    final Map<String, dynamic> dataVisit = {
      'visit_date': widget.visit.visitDate.toIso8601String(),
      'title': widget.visit.title,
      "services": widget.visit.selectedServicios.isNotEmpty
          ? widget.visit.selectedServicios
          : _initialValues,
      'ticket_id': widget.ticketId
    };
    print('Data: ${widget.type}');
    if (widget.type == 'Nuevo') {

      var createVisit = await serviceVisit.sendDataVisit(dataVisit, imageFiles);
      _loadTicketFuture = _loadData();
   
      setState(() {
        imagePaths.clear();
      });
      Fluttertoast.showToast(
          msg: "Detalles de la visita guardados exitosamente",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      var res = await serviceVisit.sendUpdateDataVisit(
          data, widget.visit.id, imageFiles);
      _loadTicketFuture = _loadData();
      setState(() {
        imagePaths.clear();
      });
      Fluttertoast.showToast(
          msg: "Visita actualizada exitosamente",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
    }
    await _reloadVisits(); // Recargar visitas después de guardar

    if (mounted) {
      setState(() {
        _isEditing = false;
      });
    }
  }
}
