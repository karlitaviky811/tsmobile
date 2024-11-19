import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:image_picker/image_picker.dart';

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
            child: ElevatedButton(
              onPressed: _agregarNuevaReparacion,
              child: Text('Añadir nueva reparación'),
            ),
          );
        }

        final reparacion = reparaciones[index];

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ExpansionTile(
            title: Text(reparacion['titulo'] == '' ? 'Nueva reparación' : reparacion['titulo']),
            children: [
              Card(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
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
                      SizedBox(height: 10),
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
                                side: BorderSide(color: Colors.transparent)),
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
                          setState(() {
                            reparacion['selectedServicios'] = values.cast<String>();
                          });
                        },
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
                        Column(
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
                                await _pickImage(context, reparacion, 'solicitud');
                              },
                              child: const Text('Adjuntar imagen de solicitud'),
                            ),
                          ],
                        ),
                      if (reparacion['necesitaRepuesto'])
                        ExpansionTile(
                          title: Text('Compra de Repuesto'),
                          initiallyExpanded: false,
                          children: [
                            TextField(
                              decoration: const InputDecoration(labelText: 'Presupuesto del repuesto'),
                              onChanged: (value) {
                                setState(() {
                                  reparacion['presupuestoRepuesto'] = value;
                                  reparacion['estadoCompraRepuesto'] = 'Enviada';
                                });
                              },
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                await _pickImage(context, reparacion, 'presupuesto');
                              },
                              child: const Text('Adjuntar imagen de presupuesto'),
                            ),
                            TextField(
                              decoration: const InputDecoration(labelText: 'Comentarios'),
                              onChanged: (value) {
                                setState(() {
                                  reparacion['comentarios'] = value;
                                });
                              },
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      reparacion['estadoCompraRepuesto'] = 'Aprobada';
                                    });
                                  },
                                  child: const Text('Aprobar'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      reparacion['estadoCompraRepuesto'] = 'Rechazada';
                                    });
                                  },
                                  child: const Text('Rechazar'),
                                ),
                              ],
                            ),
                            Chip(
                              label: Text(reparacion['estadoCompraRepuesto']),
                              backgroundColor: _getChipColor(reparacion['estadoCompraRepuesto']),
                              avatar: Icon(
                                _getChipIcon(reparacion['estadoCompraRepuesto']),
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ExpansionTile(
                        title: Text('Imágenes de Reparación'),
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              await _pickImage(context, reparacion, 'reparacion');
                            },
                            child: const Text('Adjuntar imagen de reparación'),
                          ),
                        ],
                      ),
                      ExpansionTile(
                        title: Text('Comentarios Generales'),
                        children: [
                          TextField(
                            decoration: const InputDecoration(labelText: 'Comentarios generales'),
                            onChanged: (value) {
                              setState(() {
                                reparacion['comentariosGenerales'] = value;
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

Color _getChipColor(String estado) {
    switch (estado) {
      case 'Reparación':
        return Colors.lightBlueAccent;
      case 'Solicitud de Repuesto':
        return Colors.lightGreenAccent;
      case 'Sin Stock':
        return Colors.deepOrangeAccent;
      case 'Presupuesto Enviado':
        return Colors.purpleAccent;
      case 'Cerrado':
        return Colors.pinkAccent;
      default:
        return Colors.grey.shade300;
    }
  }

  IconData _getChipIcon(String estado) {
    switch (estado) {
      case 'Solicitud de Repuesto':
        return Icons.assignment;
      case 'Sin Stock':
        return Icons.error;
      case 'Presupuesto Enviado':
        return Icons.mail;
      case 'Cerrado':
        return Icons.close;
      default:
        return Icons.info;
    }
  }
  
 }
  