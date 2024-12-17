import 'package:flutter/material.dart';

class VisitDetail extends StatelessWidget {
  final Map<String, dynamic> visitData;

  VisitDetail({required this.visitData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles de la Visita'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Título: ${visitData['titulo']}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Estado: ${visitData['estado']}', style: TextStyle(fontSize: 18)),
            // Añade más campos según los datos que quieras mostrar
          ],
        ),
      ),
    );
  }
}
