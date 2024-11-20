

import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'dart:io';
import 'package:tsmobile/src/widgets/repair_log_thumbnails.dart';

Color _getChipColor(String estado) {
  switch (estado) {
    case 'Solicitud de Repuesto':
      return Colors.yellow;
    case 'En Proceso':
      return Colors.orange;
    case 'Completado':
      return Colors.green;
    case 'Enviada':
      return Colors.blue;
    case 'Aprobada':
      return Colors.green;
    case 'Rechazada':
      return Colors.red;
    default:
      return Colors.grey;
  }
}

IconData _getChipIcon(String estado) {
  switch (estado) {
    case 'Solicitud de Repuesto':
      return Icons.assignment;
    case 'En Proceso':
      return Icons.hourglass_empty;
    case 'Completado':
      return Icons.check_circle;
    case 'Enviada':
      return Icons.send;
    case 'Aprobada':
      return Icons.thumb_up;
    case 'Rechazada':
      return Icons.thumb_down;
    default:
      return Icons.info;
  }
}

class RepairLogCard extends StatefulWidget {
  final Map<String, dynamic> reparacion;
  final Future<void> Function(BuildContext, Map<String, dynamic>) selectDate;
  final Future<void> Function(BuildContext, Map<String, dynamic>, String) pickImage;
  final VoidCallback onSave;

  RepairLogCard({
    required this.reparacion,
    required this.selectDate,
    required this.pickImage,
    required this.onSave,
  });

  @override
  _RepairLogCardState createState() => _RepairLogCardState();
}

class _RepairLogCardState extends State<RepairLogCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
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
                widget.reparacion['titulo'] = value;
              },
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Estado:'),
                Chip(
                  label: Text(widget.reparacion['estado']),
                  backgroundColor: _getChipColor(widget.reparacion['estado']),
                  avatar: Icon(
                    _getChipIcon(widget.reparacion['estado']),
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
              subtitle: Text(widget.reparacion['selectedDate'] == null
                  ? 'Seleccione una fecha'
                  : widget.reparacion['selectedDate'].toLocal().toString()),
              trailing: const Icon(Icons.calendar_today),
              onTap: () => widget.selectDate(context, widget.reparacion),
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
              initialValue: widget.reparacion['selectedServicios'].cast<String>(),
              onConfirm: (values) {
                widget.reparacion['selectedServicios'] = values.cast<String>();
              },
            ),
            CheckboxListTile(
              title: const Text('¿Necesita repuesto?'),
              value: widget.reparacion['necesitaRepuesto'],
              onChanged: (bool? value) {
                setState(() {
                  widget.reparacion['necesitaRepuesto'] = value ?? false;
                  if (value == true) {
                    widget.reparacion['estado'] = 'Solicitud de Repuesto';
                  } else {
                    widget.reparacion['estado'] = 'Reparación';
                  }
                });
              },
            ),
            if (widget.reparacion['necesitaRepuesto'])
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
                    initialValue: widget.reparacion['selectedRepuestos'].cast<String>(),
                    onConfirm: (values) {
                      widget.reparacion['selectedRepuestos'] = values.cast<String>();
                    },
                  ),
                  TextField(
                    decoration: const InputDecoration(labelText: 'Observaciones'),
                    onChanged: (value) {
                      widget.reparacion['observaciones'] = value;
                    },
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      await widget.pickImage(context, widget.reparacion, 'solicitud');
                    },
                    child: const Text('Adjuntar imagen de solicitud'),
                  ),
                ],
              ),
            if (widget.reparacion['necesitaRepuesto'])
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    decoration: const InputDecoration(labelText: 'Presupuesto del repuesto'),
                    onChanged: (value) {
                      setState(() {
                        widget.reparacion['presupuestoRepuesto'] = value;
                        widget.reparacion['estadoCompraRepuesto'] = 'Enviada';
                      });
                    },
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      await widget.pickImage(context, widget.reparacion, 'presupuesto');
                    },
                    child: const Text('Adjuntar imagen de presupuesto'),
                  ),
                  if (widget.reparacion['imagenPresupuesto'] != '')
                    Image.file(
                      File(widget.reparacion['imagenPresupuesto']),
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  TextField(
                    decoration: const InputDecoration(labelText: 'Comentarios'),
                    onChanged: (value) {
                      widget.reparacion['comentarios'] = value;
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            widget.reparacion['estadoCompraRepuesto'] = 'Aprobada';
                          });
                        },
                        child: const Text('Aprobar'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            widget.reparacion['estadoCompraRepuesto'] = 'Rechazada';
                          });
                        },
                        child: const Text('Rechazar'),
                      ),
                    ],
                  ),
                  Chip(
                    label: Text(widget.reparacion['estadoCompraRepuesto']),
                    backgroundColor: _getChipColor(widget.reparacion['estadoCompraRepuesto']),
                    avatar: Icon(
                      _getChipIcon(widget.reparacion['estadoCompraRepuesto']),
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            if (widget.reparacion['estado'] == 'Sin Repuesto')
              ExpansionTile(
                title: Text('Detalles del Repuesto'),
                children: [
                  TextField(
                    decoration: const InputDecoration(labelText: 'Nombre del repuesto'),
                    onChanged: (value) {
                      setState(() {
                        widget.reparacion['nombreRepuesto'] = value;
                      });
                    },
                  ),
                  TextField(
                    decoration: const InputDecoration(labelText: 'Monto del repuesto'),
                    onChanged: (value) {
                      setState(() {
                        widget.reparacion['montoRepuesto'] = value;
                      });
                    },
                  ),
                  TextField(
                    decoration: const InputDecoration(labelText: 'Presupuesto del repuesto'),
                    onChanged: (value) {
                      setState(() {
                        widget.reparacion['presupuestoRepuesto'] = value;
                      });
                    },
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      await widget.pickImage(context, widget.reparacion, 'presupuestoRepuesto');
                    },
                    child: const Text('Adjuntar imagen de presupuesto'),
                  ),
                  if (widget.reparacion['imagenPresupuestoRepuesto'] != '')
                    Image.file(
                      File(widget.reparacion['imagenPresupuestoRepuesto']),
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                ],
              ),
            ElevatedButton(
              onPressed: () async {
                await widget.pickImage(context, widget.reparacion, 'reparacion');
              },
              child: const Text('Adjuntar imagen de reparación'),
            ),
            buildImageThumbnails(widget.reparacion),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(labelText: 'Comentarios generales'),
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
              onPressed: widget.onSave,
              icon: Icon(Icons.save, color: Colors.white),
              label: Text('Guardar', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
