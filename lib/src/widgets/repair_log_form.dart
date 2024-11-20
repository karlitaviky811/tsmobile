

import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:tsmobile/src/widgets/repair_card_log.dart';


class RepairLogFormData extends StatefulWidget {
  final List<Map<String, dynamic>> initialReparaciones;

  RepairLogFormData({required this.initialReparaciones});

  @override
  _RepairLogFormDataState createState() => _RepairLogFormDataState();
}

class _RepairLogFormDataState extends State<RepairLogFormData> {
  late List<Map<String, dynamic>> reparaciones;

  @override
  void initState() {
    super.initState();
    reparaciones = widget.initialReparaciones;
  }

  void _agregarNuevaReparacion() {
    setState(() {
      reparaciones.add({
        'titulo': '',
        'estado': 'Solicitud de Repuesto',
        'selectedDate': null,
        'selectedServicios': <String>[],
        'necesitaRepuesto': false,
        'selectedRepuestos': <String>[],
        'presupuestoRepuesto': '',
        'comentarios': '',
        'imagenSolicitud': '',
        'imagenPresupuesto': '',
        'imagenReparacion': '',
        'comentariosGenerales': '',
        'presupuestoAceptado': false,
        'nombreRepuesto': '',
        'precioRepuesto': '',
        'repuestoSolicitado': false,
        'estadoCompraRepuesto': 'Enviada',
      });
    });
  }

  Future<void> _selectDate(BuildContext context, Map<String, dynamic> reparacion) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != reparacion['selectedDate']) {
      setState(() {
        reparacion['selectedDate'] = picked;
      });
    }
  }

  Future<void> _pickImage(BuildContext context, Map<String, dynamic> reparacion, String tipo) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        if (tipo == 'solicitud') {
          reparacion['imagenSolicitud'] = pickedFile.path;
        } else if (tipo == 'presupuesto') {
          reparacion['imagenPresupuesto'] = pickedFile.path;
        } else if (tipo == 'reparacion') {
          reparacion['imagenReparacion'] = pickedFile.path;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: reparaciones.length + 1,
      itemBuilder: (context, index) {
        if (index == reparaciones.length) {
          return Center(
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff051937),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: _agregarNuevaReparacion,
              icon: Icon(Icons.add, color: Colors.white),
              label: Text('Añadir nueva reparación', style: TextStyle(color: Colors.white)),
            ),
          );
        }

        final reparacion = reparaciones[index];

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ExpansionTile(
            title: Text(reparacion['titulo'] == '' ? 'Nueva reparación' : reparacion['titulo']),
            children: [
              RepairLogCard(
                reparacion: reparacion,
                selectDate: _selectDate,
                pickImage: _pickImage,
                onSave: () {
                  // Lógica para manejar el guardado de cada formulario
                  print('Guardado reparación: ${reparacion['titulo']}');
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
