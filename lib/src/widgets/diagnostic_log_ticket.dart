import 'package:flutter/material.dart';
import 'package:tsmobile/src/core/theme/app.styles.dart';

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
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                'Diagnóstico',
                textAlign: TextAlign.left,
              style: AppStyle.txtPoppinsMedium18Black,
              ),
              TextField(
                controller: _dateController,
                decoration: InputDecoration(
                  labelText: 'Fecha',
                  prefixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () => _pickDate(context),
                  ),
                ),
                readOnly: true,
              ),
              TextField(
                controller: _observationsController,
                decoration: const InputDecoration(labelText: 'Observaciones'),
              ),
              TextField(
                controller: _commentsController,
                decoration: const InputDecoration(labelText: 'Comentarios'),
              ),


               const SizedBox(
          height: 30,
        ),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xff051937),
          ),
          icon: const Icon(Icons.save, size: 18, color: Colors.white),
          onPressed: () {
            final DateTime? selectedDate =
                DateTime.tryParse(_dateController.text);
            onSave(selectedDate, _observationsController.text,
                _commentsController.text);
          },
          label: const Text(
            'Guardar Información',
            style: TextStyle(color: Colors.white),
          ),
        ),
        const SizedBox(
          height: 20,
        )
            ],
          ),
        ),
       
      ],
    );
  }
}
