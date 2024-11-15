import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'dart:io';

import 'package:multi_select_flutter/util/multi_select_item.dart';
class RepairLogFormTest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _repairEntries.length + 1,
      itemBuilder: (context, index) {
        if (index == _repairEntries.length) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton.icon(
              onPressed: () {
                _addRepairEntry(context);
              },
              label: const Text('Añadir nueva reparación',
                  style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff051937),
              ),
              icon: const Icon(Icons.construction, size: 18, color: Colors.white),
            ),
          );
        }
        return _repairEntries[index];
      },
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
    );
  }

  static List<RepairEntry> _repairEntries = [];

  static void _addRepairEntry(BuildContext context) {
    _repairEntries.add(RepairEntry());
    (context as Element).markNeedsBuild();
  }
}

class RepairEntry extends StatelessWidget {
  RepairEntry({Key? key}) : super(key: key);

  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _replacementController = TextEditingController();
  final TextEditingController _costController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  List<XFile>? _images;
  XFile? _invoiceImage;
  DateTime? _selectedDate;
  String? _selectedRepuesto;
  bool _needsReplacement = false;
  final List<String> _services = ['Servicio 1', 'Servicio 2', 'Servicio 3'];
  final List<String> _parts = ['Insumo 1', 'Insumo 2', 'Insumo 3'];
  final List<String> _repuestos = ['Repuesto 1', 'Repuesto 2', 'Repuesto 3'];
  final List<String> _selectedServices = [];
  final List<String> _selectedParts = [];

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      _selectedDate = picked;
      _dateController.text =
          "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}";
      (context as Element).markNeedsBuild();
    }
  }

  Future<void> _pickImages(BuildContext context) async {
    final List<XFile>? pickedImages = await _picker.pickMultiImage();
    if (pickedImages != null && pickedImages.length <= 3) {
      _images = pickedImages;
      (context as Element).markNeedsBuild();
    } else {
      // Manejo del caso en que se seleccionen más de 3 imágenes
    }
  }

  Future<void> _pickInvoiceImage(BuildContext context) async {
    final XFile? pickedImage = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      _invoiceImage = pickedImage;
      (context as Element).markNeedsBuild();
    }
  }

  void _saveEntry(BuildContext context) {
    // Lógica para guardar la información del formulario
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Información guardada')));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.all(8.0),
      child: ExpansionTile(
        backgroundColor: Colors.white,
        title: const Text('Formulario de Reparación'),
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _dateController,
                  decoration: InputDecoration(
                    labelText: 'Fecha',
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: () => _pickDate(context),
                    ),
                  ),
                  readOnly: true,
                ),
                const SizedBox(height: 10),
                MultiSelectDialogField(
                  items: _services
                      .map((service) => MultiSelectItem(service, service))
                      .toList(),
                  title: const Text("Servicios realizados"),
                  selectedColor: const Color(0xff051937),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    border: Border(bottom: BorderSide(color: Colors.grey)),
                  ),
                  buttonIcon: const Icon(
                    Icons.arrow_drop_down,
                    color: Color(0xff051937),
                  ),
                  buttonText: const Text(
                    "Seleccionar Servicios",
                    style: TextStyle(
                      color: Color(0xff051937),
                      fontSize: 16,
                    ),
                  ),
                  onConfirm: (results) {
                    _selectedServices.clear();
                    _selectedServices.addAll(List<String>.from(results));
                    (context as Element).markNeedsBuild();
                  },
                ),
                const SizedBox(height: 10),
                MultiSelectDialogField(
                  items: _parts
                      .map((part) => MultiSelectItem(part, part))
                      .toList(),
                  title: const Text("Insumos utilizados"),
                  selectedColor: const Color(0xff051937),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    border: Border(bottom: BorderSide(color: Colors.grey)),
                  ),
                  buttonIcon: const Icon(
                    Icons.arrow_drop_down,
                    color: Color(0xff051937),
                  ),
                  buttonText: const Text(
                    "Seleccionar Insumos",
                    style: TextStyle(
                      color: Color(0xff051937),
                      fontSize: 16,
                    ),
                  ),
                  onConfirm: (results) {
                    _selectedParts.clear();
                    _selectedParts.addAll(List<String>.from(results));
                    (context as Element).markNeedsBuild();
                  },
                ),
                const SizedBox(height: 10),
                CheckboxListTile(
                  title: const Text('¿Necesita repuesto?'),
                  value: _needsReplacement,
                  onChanged: (bool? value) {
                    _needsReplacement = value!;
                    (context as Element).markNeedsBuild();
                  },
                ),
                if (_needsReplacement) ...[
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Seleccionar Repuesto',
                      border: OutlineInputBorder(),
                    ),
                    items: _repuestos
                        .map((repuesto) => DropdownMenuItem<String>(
                              value: repuesto,
                              child: Text(repuesto),
                            ))
                        .toList(),
                    onChanged: (String? newValue) {
                      _selectedRepuesto = newValue;
                      (context as Element).markNeedsBuild();
                    },
                    value: _selectedRepuesto,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Estado del Repuesto: Solicitado',
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: () => _pickInvoiceImage(context),
                    label: const Text('Subir Factura',
                        style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff051937),
                    ),
                    icon: const Icon(Icons.attach_file,
                        size: 18, color: Colors.white),
                  ),
                  if (_invoiceImage != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Image.file(File(_invoiceImage!.path), height: 100),
                    ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _costController,
                    decoration: const InputDecoration(
                      labelText: 'Monto de Costo del Repuesto',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ],
                const SizedBox(height: 10),
                ElevatedButton.icon(
                  onPressed: () => _pickImages(context),
                  label: const Text('Cargar imágenes',
                      style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff051937),
                  ),
                  icon: const Icon(Icons.camera_alt_rounded,
                      size: 18, color: Colors.white),
                ),
                if (_images != null)
                  Column(
                    children: _images!.map((image) {
                      return Image.file(File(image.path),
                          width: 100, height: 100);
                    }).toList(),
                  ),
                ElevatedButton.icon(
                  onPressed: () => _saveEntry(context),
                  label: const Text('Guardar',
                      style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff051937),
                  ),
                  icon: const Icon(Icons.check, size: 18, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
