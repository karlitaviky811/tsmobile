import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CollapsibleList(),
    );
  }
}

class CollapsibleList extends StatefulWidget {
  @override
  _CollapsibleListState createState() => _CollapsibleListState();
}

class _CollapsibleListState extends State<CollapsibleList> {
  List<Item> _data = generateItems(3);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista Colapsable'),
      ),
      body: SingleChildScrollView(
        child: ExpansionPanelList(
          expandedHeaderPadding: EdgeInsets.all(10),
          expansionCallback: (int index, bool isExpanded) {
            setState(() {
              _data[index].isExpanded = !isExpanded;
            });
          },
          children: _data.map<ExpansionPanel>((Item item) {
            return ExpansionPanel(
              headerBuilder: (BuildContext context, bool isExpanded) {
                return ListTile(
                  title: Text(item.headerValue),
                );
              },
              body: item.body,
              isExpanded: item.isExpanded,
            );
          }).toList(),
        ),
      ),
    );
  }
}

class Item {
  Item({
    required this.headerValue,
    required this.body,
    this.isExpanded = false,
  });

  String headerValue;
  Widget body;
  bool isExpanded;
}

List<Item> generateItems(int numberOfItems) {
  return [
    Item(
      headerValue: 'Diagnóstico',
      body: DiagnosticForm(),
    ),
    Item(
      headerValue: 'Fecha de Reparación',
      body: RepairDateForm(),
    ),
  ];
}

class DiagnosticForm extends StatefulWidget {
  @override
  _DiagnosticFormState createState() => _DiagnosticFormState();
}

class _DiagnosticFormState extends State<DiagnosticForm> {
  DateTime? _selectedDate;
  String _selectedArticle = 'Artículo 1';
  final TextEditingController _observationsController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate)
      setState(() {
        _selectedDate = picked;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () => _selectDate(context),
          child: Text(_selectedDate == null
              ? 'Seleccionar fecha'
              : 'Fecha: ${_selectedDate?.toLocal()}'.split(' ')[0]),
        ),
        TextField(
          controller: _observationsController,
          decoration: InputDecoration(labelText: 'Observaciones'),
        ),
        DropdownButton<String>(
          value: _selectedArticle,
          onChanged: (String? newValue) {
            setState(() {
              _selectedArticle = newValue!;
            });
          },
          items: <String>['Artículo 1', 'Artículo 2', 'Artículo 3']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class RepairDateForm extends StatefulWidget {
  @override
  _RepairDateFormState createState() => _RepairDateFormState();
}

class _RepairDateFormState extends State<RepairDateForm> {
  List<Widget> _repairForms = [];
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _addRepairForm();
  }

  void _addRepairForm() {
    setState(() {
      _repairForms.add(_buildRepairForm());
    });
  }

  Future<void> _pickImages() async {
    final List<XFile>? images = await _picker.pickMultiImage();
    // Manejar las imágenes seleccionadas
  }

  Widget _buildRepairForm() {
    return Column(
      children: [
        ElevatedButton(
          onPressed: _addRepairForm,
          child: Text('Añadir Fecha de Reparación'),
        ),
        TextField(
          decoration: InputDecoration(labelText: 'Servicios realizados'),
        ),
        TextField(
          decoration: InputDecoration(labelText: 'Repuestos implementados'),
        ),
        DropdownButton<String>(
          value: 'Repuesto 1',
          onChanged: (String? newValue) {
            // Manejar el cambio de valor
          },
          items: <String>['Repuesto 1', 'Repuesto 2', 'Repuesto 3']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
        TextField(
          decoration: InputDecoration(labelText: 'Otros repuestos'),
        ),
        ElevatedButton(
          onPressed: _pickImages,
          child: Text('Subir Fotos'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: _repairForms,
    );
  }
}
