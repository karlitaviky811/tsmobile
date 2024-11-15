import 'package:flutter/material.dart';

class DiagnosticForm extends StatelessWidget {
  final Function(DateTime?, String, String) onSave;

  DiagnosticForm({required this.onSave});

  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _observationsController = TextEditingController();
  final TextEditingController _commentsController = TextEditingController();

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      _dateController.text = "${picked.day}/${picked.month}/${picked.year}";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextField(
                controller: _dateController,
                decoration: InputDecoration(
                  labelText: 'Fecha',
                  prefixIcon: IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () => _pickDate(context),
                  ),
                ),
                readOnly: true,
              ),
              TextField(
                controller: _observationsController,
                decoration: InputDecoration(labelText: 'Observaciones'),
              ),
              TextField(
                controller: _commentsController,
                decoration: InputDecoration(labelText: 'Comentarios'),
              ),
            ],
          ),
        ),
        SizedBox(height: 30,),
      
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xff051937),
              
                // Cambia este color al que desees onPrimary: Colors.white, // Color del texto del botón
              ),
          icon: Icon(Icons.save ,size: 18, color: Colors.white),
          onPressed: () {
            final DateTime? selectedDate = DateTime.tryParse(_dateController.text);
            onSave(selectedDate, _observationsController.text, _commentsController.text);
          },
          label: Text('Guardar Información', style: TextStyle(color: Colors.white),),
        ),
        SizedBox(height: 20,)
      ],
    );
  }
}
