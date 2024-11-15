import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';


class RepairLogFormTest extends StatefulWidget {
  @override
  _RepairLogFormTestState createState() => _RepairLogFormTestState();
}

class _RepairLogFormTestState extends State<RepairLogFormTest> {
  List<RepairEntry> _repairEntries = [];

  @override
  void initState() {
    super.initState();
    _addRepairEntry();
  }

  void _addRepairEntry() {
    setState(() {
      _repairEntries.add(RepairEntry());
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _repairEntries.length + 1,
      itemBuilder: (context, index) {
        if (index == _repairEntries.length) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: _addRepairEntry,
              child: const Text('Añadir nueva entrada'),
            ),
          );
        }
        return _repairEntries[index];
      },
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
    );
  }
}

class RepairEntry extends StatefulWidget {
  @override
  _RepairEntryState createState() => _RepairEntryState();
}

class _RepairEntryState extends State<RepairEntry> {
  DateTime? _selectedDate;
  final List<String> _services = ['Servicio 1', 'Servicio 2', 'Servicio 3'];
  final List<String> _parts = ['Insumo 1', 'Insumo 2', 'Insumo 3'];
  final List<String> _selectedServices = [];
  final List<String> _selectedParts = [];
  bool _needsReplacement = false;
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _replacementController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  List<XFile>? _images;

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}";
      });
    }
  }

  Future<void> _pickImages() async {
    final List<XFile>? pickedImages = await _picker.pickMultiImage();
    if (pickedImages != null && pickedImages.length <= 3) {
      setState(() {
        _images = pickedImages;
      });
    } else {
      // Manejo del caso en que se seleccionen más de 3 imágenes
    }
  }

  void _saveEntry() {
    // Lógica para guardar la información del formulario
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Información guardada')));
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
                const SizedBox(height: 10,),
                MultiSelectDialogField(
                  items: _services.map((service) => MultiSelectItem(service, service)).toList(),
                  title: const Text("Servicios realizados"),
                  selectedColor: const Color(0xff051937),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: const Color(0xff051937), width: 1),
                    borderRadius: BorderRadius.circular(10),
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
                    setState(() {
                      _selectedServices.clear();
                      _selectedServices.addAll(List<String>.from(results));
                    });
                  },
                ),
                const SizedBox(height: 10),
                MultiSelectDialogField(
                  items: _parts.map((part) => MultiSelectItem(part, part)).toList(),
                  title: const Text("Insumos utilizados"),
                  selectedColor: const Color(0xff051937),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: const Color(0xff051937), width: 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  buttonIcon: const Icon(
                    Icons.arrow_drop_down,
                    color: const Color(0xff051937),
                  ),
                  buttonText: const Text(
                    "Seleccionar Insumos",
                    style: TextStyle(
                      color: Color(0xff051937),
                      fontSize: 16,
                    ),
                  ),
                  onConfirm: (results) {
                    setState(() {
                      _selectedParts.clear();
                      _selectedParts.addAll(List<String>.from(results));
                    });
                  },
                ),
                const SizedBox(height: 10),
                CheckboxListTile(
                  title: const Text('¿Necesita repuesto?'),
                  value: _needsReplacement,
                  onChanged: (bool? value) {
                    setState(() {
                      _needsReplacement = value!;
                    });
                  },
                ),
                if (_needsReplacement)
                  TextField(
                    controller: _replacementController,
                    decoration: const InputDecoration(labelText: 'Detalle del repuesto'),
                  ),
                if (_needsReplacement)
                  ElevatedButton(
                    onPressed: _pickImages,
                    child: const Text('Cargar imágenes'),
                  ),
                if (_needsReplacement && _images != null)
                  Column(
                    children: _images!.map((image) {
                      return Image.file(File(image.path), width: 100, height: 100);
                    }).toList(),
                  ),
                ElevatedButton(
                  onPressed: _saveEntry,
                  child: const Text('Guardar Información'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
