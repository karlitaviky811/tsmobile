import 'package:flutter/material.dart';
import 'package:tsmobile/src/models/visit_model.dart';

class EditVisitPage extends StatefulWidget {
  final Visit visit;

  EditVisitPage({required this.visit});

  @override
  _EditVisitPageState createState() => _EditVisitPageState();
}

class _EditVisitPageState extends State<EditVisitPage> {
  late TextEditingController _titleController;
  late TextEditingController _dateController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.visit.title);
    _dateController = TextEditingController(text: widget.visit.visitDate.toLocal().toString().split(' ')[0]);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: widget.visit.visitDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != widget.visit.visitDate) {
      setState(() {
        widget.visit.visitDate = picked;
        _dateController.text = picked.toLocal().toString().split(' ')[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return  Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Título de la Visita'),
              onChanged: (value) {
                setState(() {
                  widget.visit.title = value;
                });
              },
            ),
            TextField(
              controller: _dateController,
              decoration: InputDecoration(
                labelText: 'Fecha de la Visita',
                suffixIcon: IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () => _selectDate(context),
                ),
              ),
              readOnly: true,
            ),
            // Añade más campos según sea necesario
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, widget.visit);
              },
              child: Text('Guardar'),
            ),
          ],
        ),
      );
  }
}
