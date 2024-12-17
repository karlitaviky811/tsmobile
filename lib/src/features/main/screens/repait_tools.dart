import 'package:flutter/material.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';

class SolicitudRepuestoScreen extends StatefulWidget {
  @override
  _SolicitudRepuestoScreenState createState() => _SolicitudRepuestoScreenState();
}

class _SolicitudRepuestoScreenState extends State<SolicitudRepuestoScreen> {
  List<String> selectedRepuestos = [];
  String observations = '';
  List<String> imagePaths = [];
  String requestStatus = 'Pendiente';

  final TextEditingController _repuestosController = TextEditingController();
  final TextEditingController _comentariosGeneralesController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  Future<void> _pickImage(BuildContext context, String imagePath) async {
    // Implementa la lógica para seleccionar una imagen y agregarla a imagePaths
  }

  void _showToast(BuildContext context, String message) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(message),
        action: SnackBarAction(label: 'OK', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }

  void _submitForm() {
    setState(() {
      requestStatus = 'Enviada';
    });
    Navigator.pop(context);
    print('Solicitud enviada con los siguientes datos:');
    print('Repuestos seleccionados: $selectedRepuestos');
    print('Observaciones: ${_comentariosGeneralesController.text}');
    print('Imágenes adjuntas: $imagePaths');
  }

  void _showSolicitudRepuestoForm() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Solicitud de repuesto'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: _repuestosController,
                  decoration: const InputDecoration(
                    labelText: 'Repuestos necesarios',
                    labelStyle: TextStyle(color: Colors.black54, fontSize: 16),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 1),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xff051937), width: 1),
                    ),
                    suffixIcon: Icon(Icons.arrow_drop_down, color: Color(0xff051937)),
                  ),
                  readOnly: true,
                  onTap: _showMultiSelectDialog,
                ),
                const SizedBox(height: 10),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Observaciones',
                    labelStyle: TextStyle(color: Colors.black54, fontSize: 16),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 1),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xff051937), width: 1),
                    ),
                  ),
                  controller: _comentariosGeneralesController,
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () async {
                    if (imagePaths.length < 5) {
                      await _pickImage(context, 'imagenPresupuestoRepuesto${imagePaths.length}');
                    } else {
                      _showToast(context, 'Solo se pueden cargar hasta 5 imágenes');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff051937),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Adjuntar imágenes de presupuesto', style: TextStyle(color: Colors.white)),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff051937),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Enviar solicitud', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }

  void _showMultiSelectDialog() async {
    final List<String> items = ['Repuesto 1', 'Repuesto 2']; // Lista de repuestos
    final List<String>? result = await showDialog<List<String>>(
      context: context,
      builder: (BuildContext context) {
        return MultiSelectDialog(
          items: items,
          initialSelectedItems: selectedRepuestos,
        );
      },
    );
    if (result != null) {
      setState(() {
        selectedRepuestos.clear();
        selectedRepuestos.addAll(result);
        _repuestosController.text = selectedRepuestos.join(', ');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Solicitud de Repuesto'),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _showSolicitudRepuestoForm,
              child: const Text('Abrir Formulario de Solicitud'),
            ),
            const SizedBox(height: 20),
            Card(
              margin: const EdgeInsets.all(10),
              child: ListTile(
                title: const Text('Repuesto Solicitado'),
                subtitle: Text(selectedRepuestos.join(', ')),
                trailing: Text(requestStatus),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MultiSelectDialog extends StatefulWidget {
  final List<String> items;
  final List<String> initialSelectedItems;

  MultiSelectDialog({required this.items, required this.initialSelectedItems});

  @override
  _MultiSelectDialogState createState() => _MultiSelectDialogState();
}

class _MultiSelectDialogState extends State<MultiSelectDialog> {
  List<String> _selectedItems = [];

  @override
  void initState() {
    super.initState();
    _selectedItems = List.from(widget.initialSelectedItems);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Seleccione uno o más repuestos'),
      content: SingleChildScrollView(
        child: ListBody(
          children: widget.items.map((item) {
            return CheckboxListTile(
              value: _selectedItems.contains(item),
              title: Text(item),
              controlAffinity: ListTileControlAffinity.leading,
              onChanged: (isChecked) {
                setState(() {
                  isChecked! ? _selectedItems.add(item) : _selectedItems.remove(item);
                });
              },
            );
          }).toList(),
        ),
      ),
      actions: [
        TextButton(
          child: const Text('CANCELAR'),
          onPressed: () {
            Navigator.pop(context, null);
          },
        ),
        TextButton(
          child: const Text('ACEPTAR'),
          onPressed: () {
            Navigator.pop(context, _selectedItems);
          },
        ),
      ],
    );
  }
}
