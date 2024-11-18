import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tsmobile/src/core/theme/app.styles.dart';

class RepairLogFormData extends StatelessWidget {
  final ValueNotifier<List<Map<String, dynamic>>> reparacionesNotifier;

  RepairLogFormData(
      {Key? key, List<Map<String, dynamic>> initialReparaciones = const []})
      : reparacionesNotifier =
            ValueNotifier<List<Map<String, dynamic>>>(initialReparaciones),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Bitácora de reparación',
              textAlign: TextAlign.left,
              style: AppStyle.txtPoppinsMedium18Black,
            ),
          ),
          ValueListenableBuilder<List<Map<String, dynamic>>>(
            valueListenable: reparacionesNotifier,
            builder: (context, reparaciones, _) {
              return Column(
                children: reparaciones.map((reparacion) {
                  return _buildReparacionItem(context, reparacion);
                }).toList(),
              );
            },
          ),
          ElevatedButton(
            onPressed: _agregarNuevaReparacion,
            child: const Text('Agregar una nueva reparación'),
          ),
        ],
      ),
    );
  }

  Widget _buildReparacionItem(
      BuildContext context, Map<String, dynamic> reparacion) {
    return ExpansionTile(
      title: Text(
          'Reparación ${reparacionesNotifier.value.indexOf(reparacion) + 1}'),
      children: [
        _buildReparacionForm(context, reparacion),
      ],
    );
  }

  Widget _buildReparacionForm(
      BuildContext context, Map<String, dynamic> reparacion) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Estado:'),
                Chip(
                  label: Text(reparacion['estado']),
                  backgroundColor: _getChipColor(reparacion['estado']),
                ),
              ],
            ),
            ListTile(
              title: const Text('Fecha de reparación'),
              subtitle: Text(reparacion['selectedDate'] == null
                  ? 'Seleccione una fecha'
                  : reparacion['selectedDate'].toLocal().toString()),
              trailing: const Icon(Icons.calendar_today),
              onTap: () => _selectDate(context, reparacion),
            ),
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
                reparacion['selectedServicios'] = values.cast<String>();
                reparacionesNotifier.notifyListeners();
              },
            ),
            ValueListenableBuilder<bool>(
              valueListenable:
                  ValueNotifier<bool>(reparacion['necesitaRepuesto']),
              builder: (context, necesitaRepuesto, child) {
                return Column(
                  children: [
                    CheckboxListTile(
                      title: const Text('¿Necesita repuesto?'),
                      value: necesitaRepuesto,
                      onChanged: (bool? value) {
                        reparacion['necesitaRepuesto'] = value ?? false;
                        if (value == true) {
                          reparacion['estado'] = 'Solicitud de Repuesto';
                        } else {
                          reparacion['estado'] = 'Reparación';
                        }
                        reparacionesNotifier.notifyListeners();
                      },
                    ),
                    if (necesitaRepuesto)
                      Column(
                        children: [
                          MultiSelectDialogField(
                            items: [
                              MultiSelectItem<String>(
                                  'Repuesto 1', 'Repuesto 1'),
                              MultiSelectItem<String>(
                                  'Repuesto 2', 'Repuesto 2'),
                              // Agrega más repuestos aquí
                            ],
                            title: const Text('Repuestos necesarios'),
                            selectedColor: Colors.blue,
                            buttonIcon: const Icon(Icons.list),
                            buttonText: const Text('Seleccione uno o más repuestos'),
                            initialValue:
                                reparacion['selectedRepuestos'].cast<String>(),
                            onConfirm: (values) {
                              reparacion['selectedRepuestos'] =
                                  values.cast<String>();
                              reparacionesNotifier.notifyListeners();
                            },
                          ),
                          TextField(
                            decoration:
                                const InputDecoration(labelText: 'Observaciones'),
                            onChanged: (value) {
                              reparacion['observaciones'] = value;
                              reparacionesNotifier.notifyListeners();
                            },
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              await _pickImage(
                                  context, reparacion, 'solicitud');
                            },
                            child: const Text('Adjuntar imagen de solicitud'),
                          ),
                        ],
                      ),
                  ],
                );
              },
            ),
            ValueListenableBuilder<bool>(
              valueListenable:
                  ValueNotifier<bool>(reparacion['repuestoSolicitado']),
              builder: (context, repuestoSolicitado, child) {
                return repuestoSolicitado
                    ? Column(
                        children: [
                          TextField(
                            decoration: const InputDecoration(
                                labelText: 'Presupuesto del repuesto'),
                            onChanged: (value) {
                              reparacion['presupuestoRepuesto'] = value;
                              reparacion['estado'] =
                                  'Presupuesto de compra de repuesto';
                              reparacionesNotifier.notifyListeners();
                            },
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              await _pickImage(
                                  context, reparacion, 'presupuesto');
                            },
                            child: const Text('Adjuntar imagen de presupuesto'),
                          ),
                          TextField(
                            decoration:
                                const InputDecoration(labelText: 'Comentarios'),
                            onChanged: (value) {
                              reparacion['comentarios'] = value;
                              reparacionesNotifier.notifyListeners();
                            },
                          ),
                        ],
                      )
                    : Container();
              },
            ),
            ElevatedButton(
              onPressed: () async {
                await _pickImage(context, reparacion, 'reparacion');
              },
              child: const Text('Adjuntar imagen de reparación'),
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Comentarios generales'),
              onChanged: (value) {
                reparacion['comentariosGenerales'] = value;
                reparacionesNotifier.notifyListeners();
              },
            ),
            ElevatedButton(
              onPressed: () {
                if (!reparacion['necesitaRepuesto'] ||
                    (reparacion['necesitaRepuesto'] &&
                        !reparacion['repuestoSolicitado'])) {
                  // Implementación para guardar la reparación
                  _guardarReparacion(context, reparacion);
                }
              },
              child: const Text('Guardar reparación'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(
      BuildContext context, Map<String, dynamic> reparacion) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != reparacion['selectedDate']) {
      reparacion['selectedDate'] = picked;
      reparacionesNotifier.notifyListeners();
    }
  }

  Future<void> _pickImage(BuildContext context, Map<String, dynamic> reparacion,
      String tipo) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      if (tipo == 'solicitud') {
        reparacion['imagenSolicitud'] = pickedFile.path;
      } else if (tipo == 'presupuesto') {
        reparacion['imagenPresupuesto'] = pickedFile.path;
      } else if (tipo == 'reparacion') {
        reparacion['imagenReparacion'] = pickedFile.path;
      }
      reparacionesNotifier.notifyListeners();
    }
  }

  void _agregarNuevaReparacion() {
    final newReparacion = {
      'selectedDate': null,
      'selectedServicios': <String>[],
      'necesitaRepuesto': false,
      'selectedRepuestos': <String>[],
      'observaciones': '',
      'repuestoSolicitado': false,
      'presupuestoRepuesto': '',
      'comentarios': '',
      'estado': 'Reparación',
      'comentariosGenerales': '',
    };
    reparacionesNotifier.value = List.from(reparacionesNotifier.value)
      ..add(newReparacion);
  }

  void _guardarReparacion(
      BuildContext context, Map<String, dynamic> reparacion) {
    // Implementación para guardar la reparación
    // Aquí puedes agregar la lógica para guardar la reparación en la base de datos o enviarla a un servidor
    print('Reparación guardada: $reparacion');

    // Mostrar un toast al guardar la reparación
    Fluttertoast.showToast(
      msg: "Reparación guardada",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  Color _getChipColor(String estado) {
    switch (estado) {
      case 'Solicitud de Repuesto':
        return Colors.orange;
      case 'No hay stock':
        return Colors.red;
      case 'Presupuesto de compra de repuesto':
        return Colors.blue;
      default:
        return Colors.green;
    }
  }
}
