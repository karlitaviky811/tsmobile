import 'package:flutter/material.dart';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:tsmobile/src/models/visit_model.dart';
import 'package:tsmobile/src/widgets/buy_spare_part.dart';

class RepairLogCard extends StatefulWidget {
  final Map<String, dynamic> reparacion;
    final Visit visit;

  RepairLogCard({required this.reparacion, required this.visit});

  @override
  _RepairLogCardState createState() => _RepairLogCardState();
}

class _RepairLogCardState extends State<RepairLogCard> {
  final ImagePicker _picker = ImagePicker();
  List<String> imagePaths = [];
  late Map<String, dynamic> reparacion;
  TextEditingController _dateController = TextEditingController();
  late TextEditingController _tituloController;

  late TextEditingController _observacionesController;
  late TextEditingController _comentariosGeneralesController;

  @override
  void initState() {
    super.initState();
    reparacion = Map<String, dynamic>.from(widget.reparacion);
    _tituloController = TextEditingController(text: reparacion['titulo']);
    _observacionesController =
        TextEditingController(text: reparacion['observaciones']);
    _comentariosGeneralesController =
        TextEditingController(text: reparacion['comentariosGenerales']);
    _comentariosGeneralesController =
        TextEditingController(text: reparacion['comentariosGenerales']);
    _dateController.text = reparacion['selectedDate'] != null
        ? reparacion['selectedDate'].toLocal().toString().split(' ')[0]
        : '';
  }

  Future<void> _pickImage(BuildContext context, String imageType) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        if (imagePaths.length < 5) {
          imagePaths.add(pickedFile.path);
          reparacion[imageType] = pickedFile.path; // Actualizar el mapa mutable
        } else {
          _showToast(context, 'Solo se pueden cargar hasta 5 imágenes');
        }
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: reparacion['selectedDate'] ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      setState(() {
        reparacion['selectedDate'] = pickedDate;
        _dateController.text = pickedDate.toLocal().toString().split(' ')[0];
      });
    }
  }

  void _showToast(BuildContext context, String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  Color _getChipColor(String estado) {
    switch (estado) {
      case 'Reparación':
        return Colors.lightBlue.shade300;
      case 'Solicitud de repuesto':
        return Colors.lightGreen.shade300;
      case 'Sin stock':
        return Colors.deepOrange.shade200;
      case 'Envío de presupuesto':
        return Colors.deepPurple.shade200;
      case 'Compra externa':
        return Colors.pink.shade200;
      default:
        return Colors.grey.shade300;
    }
  }

  IconData _getChipIcon(String estado) {
    switch (estado) {
      case 'Reparación':
        return Icons.build;
      case 'Solicitud de repuesto':
        return Icons.shopping_cart;
      case 'Sin stock':
        return Icons.warning;
      case 'Envío de presupuesto':
        return Icons.attach_money;
      case 'Compra externa':
        return Icons.shopping_bag;
      default:
        return Icons.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Chip(
                  label: Text(widget.visit.status.toString()),
                  backgroundColor: _getChipColor(widget.visit.status.toString()),
                  avatar: Icon(
                    _getChipIcon(widget.visit.status.toString()),
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
                labelStyle: TextStyle(color: Colors.black54, fontSize: 16),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 1),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xff051937), width: 1),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  reparacion['titulo'] = value;
                });
              },
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _dateController,
              decoration: InputDecoration(
                labelText: 'Fecha de reparación',
                labelStyle:
                    const TextStyle(color: Colors.black54, fontSize: 16),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.calendar_today,
                      color: Color(0xff051937)),
                  onPressed: () => _selectDate(context),
                ),
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 1),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xff051937), width: 1),
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
                  items: [
                    MultiSelectItem<String>('Servicio 1', 'Servicio 1'),
                    MultiSelectItem<String>('Servicio 2', 'Servicio 2'),
                    // Agrega más servicios aquí
                  ],
                  title: const Text('Servicios realizados'),
                  backgroundColor: Colors.white,
                  selectedColor: const Color(0xff051937),
                  buttonIcon: const Icon(Icons.list, color: Color(0xff051937)),
                  buttonText: const Text(
                    'Seleccione uno o más servicios',
                    style: TextStyle(color: Color(0xff051937), fontSize: 16),
                  ),
                  initialValue: reparacion['selectedServicios'].cast<String>(),
                  onConfirm: (values) {
                    setState(() {
                      reparacion['selectedServicios'] = values.cast<String>();
                    });
                  },
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.grey, width: 1),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            CheckboxListTile(
              title: const Text('¿Necesita repuesto?'),
              value: reparacion['necesitaRepuesto'],
              onChanged: (bool? value) {
                setState(() {
                  reparacion['necesitaRepuesto'] = value ?? false;
                  reparacion['estado'] =
                      value == true ? 'Solicitud de Repuesto' : 'Reparación';
                });
              },
            ),
            if (reparacion['necesitaRepuesto'])
              ExpansionTile(
                title: const Text('Solicitud de repuesto'),
                children: [
                  MultiSelectDialogField(
                    items: [
                      MultiSelectItem<String>('Repuesto 1', 'Repuesto 1'),
                      MultiSelectItem<String>('Repuesto 2', 'Repuesto 2'),
                      // Agrega más repuestos aquí
                    ],
                    title: const Text('Repuestos necesarios'),
                    backgroundColor: Colors.white,
                    selectedColor: const Color(0xff051937),
                    buttonIcon:
                        const Icon(Icons.list, color: Color(0xff051937)),
                    buttonText: const Text(
                      'Seleccione uno o más repuestos',
                      style: TextStyle(color: Color(0xff051937), fontSize: 16),
                    ),
                    initialValue:
                        reparacion['selectedRepuestos'].cast<String>(),
                    onConfirm: (values) {
                      setState(() {
                        reparacion['selectedRepuestos'] = values.cast<String>();
                      });
                    },
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.grey, width: 1),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'Observaciones',
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
                        reparacion['observaciones'] = value;
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () async {
                      if (imagePaths.length < 5) {
                        await _pickImage(context,
                            'imagenPresupuestoRepuesto${imagePaths.length}');
                      } else {
                        _showToast(
                            context, 'Solo se pueden cargar hasta 5 imágenes');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff051937),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('Adjuntar imágenes de presupuesto',
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
                ],
              ),
            if (reparacion['estado'] == 'Sin stock')
              BuySparePart(
                reparacion: const {
                  'nombreRepuesto': '',
                  'montoRepuesto': '',
                  'presupuestoRepuesto': '',
                },
              ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff051937),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                ),
                onPressed: () {},
                icon: const Icon(Icons.save, color: Colors.white),
                label: const Text('Guardar',
                    style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
    ;
  }
}



