import 'package:flutter/material.dart';
import 'package:tsmobile/src/core/theme/app.styles.dart';
import 'package:tsmobile/src/features/main/screens/detail_ticket_accept_decline_view.dart';


import 'package:tsmobile/src/interfaces/ticket.dart';

class TicketAcceptedProgressDetailPage extends StatefulWidget {
  final Ticket ticket;
  static const String route = 'ticket-accepted-decline-ticket-route';
  TicketAcceptedProgressDetailPage({required this.ticket});

  @override
  _TicketDetailPageState createState() => _TicketDetailPageState();
}

class _TicketDetailPageState extends State<TicketAcceptedProgressDetailPage> {
  bool _needsReplacement = false;
  DateTime? _selectedDate;
  final _inputController1 = TextEditingController();
  final _inputController2 = TextEditingController();
  final _replacementCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles del Ticket'),
      ),
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
                Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Text(
                                'ID del Ticket: ',
                                style: AppStyle.txtPoppinsBold18Black,
                              ),
                              Text(
                                '#12345',
                                style: AppStyle.txtPoppinsRegular14BlueDaka,
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          getStatusChip('in_progress'),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            'Fecha: ',
                            style:   AppStyle.txtPoppinsBold18Black,
                          ),
                            Text(
                            '11/10/2024',
                            style:  AppStyle.txtPoppinsRegular18Black,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('Tipo: ', style: AppStyle.txtPoppinsBold18Black),
                        const SizedBox(height: 10),
                        Text('Reparación',
                            style: AppStyle.txtPoppinsRegular18Black),
                      ]),
                  const SizedBox(height: 10),
                  Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('Título:  ', style: AppStyle.txtPoppinsBold18Black),
                        const SizedBox(height: 10),
                        Text('Problema con el software.',
                            style: AppStyle.txtPoppinsRegular18Black),
                      ]),
                  const SizedBox(height: 10),
                  Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('Producto:  ',
                            style: AppStyle.txtPoppinsBold18Black),
                        const SizedBox(height: 10),
                        Text('REFRIGERADOR 19 PIE TF  ...',
                            style: AppStyle.txtPoppinsRegular18Black),
                      ]),
                  const SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('Descripción:  ',
                          style: AppStyle.txtPoppinsBold18Black),
                      const SizedBox(height: 10),
                      Text('Problema con el software.',
                          style: AppStyle.txtPoppinsRegular18Black),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    
                    children: [
                                  const SizedBox(height: 10),
                      Row(
                        children: [
                          
                          const Icon(Icons.location_on_outlined),
                          const SizedBox(width: 4),
                          Text('Vía Av. Caracas y Av. P.º Caroni',
                              style: AppStyle.txtPoppinsRegular18Black)
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.account_circle),
                      const SizedBox(width: 4),
                      Text(
                        'Andrea Suarez',
                        style: AppStyle.txtPoppinsRegular18Black,
                      )
                    ],
                  ),
                  const SizedBox(height: 30),
                  
                  const SizedBox(height: 20),
           
                ],
              ),
             /* Text(
                widget.ticket.title,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              Text(widget.ticket.description),*/
              const SizedBox(height: 16.0),
              ExpansionTile(
                title: Text('Diagnóstico', style: AppStyle.txtPoppinsRegular18Black),
                children: [
                  _buildDatePicker(),
                  TextField(
                    controller: _inputController1,
                    decoration: const InputDecoration(labelText: 'Origen' ),
                  ),
                  TextField(
                    controller: _inputController2,
                    decoration: const InputDecoration(labelText: 'Observaciones'),
                  ),
                ],
              ),
              ExpansionTile(
                title: Text('Reparación',style: AppStyle.txtPoppinsRegular18Black),
                children: [
                  SizedBox(height: 10,),
                  _buildDropdown('Seleccione Fallo', ['Fallo 1', 'Fallo 2', 'Fallo 3']),
                        SizedBox(height: 15),
                  _buildDropdown('Servicios Aplicados', ['Servicio 1', 'Servicio 2', 'Servicio 3']),
                  CheckboxListTile(
                    title: const Text('¿Necesita Repuesto?'),
                    value: _needsReplacement,
                    onChanged: (bool? value) {
                      setState(() {
                        _needsReplacement = value ?? false;
                      });
                    },
                  ),
                  if (_needsReplacement)
                    TextField(
                      controller: _replacementCodeController,
                      decoration: const InputDecoration(labelText: 'Código del Repuesto'),
                    ),
                  ElevatedButton(
                    onPressed: () {
                      // Lógica para seleccionar imágenes
                    },
                    child: const Text('Seleccionar Imágenes'),
                  ),
                ],
              ),
              // Más apartados como Prueba y Cierre pueden ser añadidos aquí...
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDatePicker() {
    return ListTile(
      title: Text(_selectedDate == null
          ? 'Seleccionar Fecha'
          : 'Fecha: ${_selectedDate!.toLocal()}'.split(' ')[0]),
      trailing: const Icon(Icons.calendar_today),
      onTap: () async {
        DateTime? picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2101),
        );
        if (picked != null && picked != _selectedDate) {
          setState(() {
            _selectedDate = picked;
          });
        }
      },
    );
  }

  Widget _buildDropdown(String hint, List<String> options) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: hint,
        border: const OutlineInputBorder(),
      ),
      items: options.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (newValue) {
        // Lógica para manejar el cambio
      },
    );
  }
}
