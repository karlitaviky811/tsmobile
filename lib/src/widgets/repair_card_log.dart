import 'package:flutter/material.dart';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:tsmobile/src/widgets/buy_spare_part.dart';
import 'package:tsmobile/src/widgets/repair_log_thumbnails.dart';

class RepairLogCard extends StatefulWidget {
  final Map<String, dynamic> reparacion;

  RepairLogCard({required this.reparacion});

  @override
  _RepairLogCardState createState() => _RepairLogCardState();
}

class _RepairLogCardState extends State<RepairLogCard> {
  final ImagePicker _picker = ImagePicker();
  List<String> imagePaths = [];
  late Map<String, dynamic> reparacion;
  TextEditingController _dateController = TextEditingController();


  @override
  void initState() {
    super.initState();
    reparacion = Map<String, dynamic>.from(widget.reparacion);
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
          reparacion[imageType] = pickedFile.path;  // Actualizar el mapa mutable
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
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Título de la reparación',
              ),
              onChanged: (value) {
                setState(() {
                  reparacion['titulo'] = value;
                });
              },
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Estado:'),
                Chip(
                  label: Text(reparacion['estado']),
                  backgroundColor: _getChipColor(reparacion['estado']),
                  avatar: Icon(
                    _getChipIcon(reparacion['estado']),
                    color: Colors.white,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    side: const BorderSide(color: Colors.transparent),
                  ),
                ),
              ],
            ),
            TextField(
              controller: _dateController,
              decoration: InputDecoration(
                labelText: 'Fecha de reparación',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () => _selectDate(context),
                ),
              ),
              readOnly: true,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Servicios'),
                MultiSelectDialogField(
                  items: [
                    MultiSelectItem<String>('Servicio 1', 'Servicio 1'),
                    MultiSelectItem<String>('Servicio 2', 'Servicio 2'),
                    // Agrega más servicios aquí
                  ],
                  title: const Text('Servicios realizados'),
                  selectedColor: Colors.blue,
                  buttonIcon: const Icon(Icons.list),
                  buttonText: const Text('Seleccione uno o más servicios'),
                  initialValue: reparacion['selectedServicios'].cast<String>(),
                  onConfirm: (values) {
                    setState(() {
                      reparacion['selectedServicios'] = values.cast<String>();
                    });
                  },
                ),
              ],
            ),
            CheckboxListTile(
              title: const Text('¿Necesita repuesto?'),
              value: reparacion['necesitaRepuesto'],
              onChanged: (bool? value) {
                setState(() {
                  reparacion['necesitaRepuesto'] = value ?? false;
                  if (value == true) {
                    reparacion['estado'] = 'Solicitud de Repuesto';
                  } else {
                    reparacion['estado'] = 'Reparación';
                  }
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
                    selectedColor: Colors.blue,
                    buttonIcon: const Icon(Icons.list),
                    buttonText: const Text('Seleccione uno o más repuestos'),
                    initialValue: reparacion['selectedRepuestos'].cast<String>(),
                    onConfirm: (values) {
                      setState(() {
                        reparacion['selectedRepuestos'] = values.cast<String>();
                      });
                    },
                  ),
                  TextField(
                    decoration: const InputDecoration(labelText: 'Observaciones'),
                    onChanged: (value) {
                      setState(() {
                        reparacion['observaciones'] = value;
                      });
                    },
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (imagePaths.length < 5) {
                        await _pickImage(context, 'imagenPresupuestoRepuesto${imagePaths.length}');
                      } else {
                        _showToast(context, 'Solo se pueden cargar hasta 5 imágenes');
                      }
                    },
                    child: const Text('Adjuntar imágenes de presupuesto'),
                  ),
                  if (imagePaths.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: Text('Imágenes cargadas:', style: TextStyle(fontWeight: FontWeight.bold)),
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
              if (widget.reparacion['estado'] == 'Sin stock')
                BuySparePart(
                  reparacion: const {
                    'nombreRepuesto': '',
                    'montoRepuesto': '',
                    'presupuestoRepuesto': '',
                  },
                ),
              //_MoreDetailsTicket(widget: widget),
              TextField(
            decoration:
                const InputDecoration(labelText: 'Comentarios generales'),
            onChanged: (value) {
              widget.reparacion['comentariosGenerales'] = value;
            },
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xff051937),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            onPressed: (){},
            icon: const Icon(Icons.save, color: Colors.white),
            label: const Text('Guardar', style: TextStyle(color: Colors.white)),
          )
          ],
        ),
      ),
    );
  }
}

