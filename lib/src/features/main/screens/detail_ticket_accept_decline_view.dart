import 'package:flutter/material.dart';
import 'package:tsmobile/src/core/constants/color.constant.dart';
import 'package:tsmobile/src/core/theme/app.styles.dart';

class TicketDetailPageView extends StatefulWidget {
  static const String route = 'detail-view-ticket-route';

  @override
  _TicketDetailPageState createState() => _TicketDetailPageState();
}

class _TicketDetailPageState extends State<TicketDetailPageView> {
  String _status = 'pending';
  String _selectedReason = 'No especificado';

  final List<String> _rejectionReasons = [
    'Cliente no disponible',
    'Información insuficiente',
    'Problema fuera de alcance',
    'Solicitud cancelada',
    'Equipo no se puede reparar',
    'No especificado'
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Detalle del Ticket',
          style: AppStyle.txtPoppinsRegular18Black,
        ),
      ),
      body: Container(
        width: double.infinity,
        color: Colors.white,
        child: Stack(children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
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
                        getStatusChip('new'),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    ElevatedButton.icon(
                      icon: const Icon(Icons.check_box,
                          size: 18, color: Colors.white),
                      onPressed: () {
                        setState(() {
                          _status = 'accepted';
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff051937),
                        // Cambia este color al que desees onPrimary: Colors.white, // Color del texto del botón
                      ),
                      label: Text('Aceptar',
                          style: AppStyle.txtPoppinsMedium14White),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.report_problem,
                          size: 18, color: Colors.white),
                      onPressed: () {
                        setState(() {
                          _status = 'rejected';
                        });
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xff051937)),
                      label: Text('Rechazar',
                          style: AppStyle.txtPoppinsMedium14White),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                if (_status == 'accepted') buildAcceptedForm(),
                if (_status == 'rejected') buildRejectedForm(),
              ],
            ),
          ),
        ]),
      ),
    );
  }

  Widget buildAcceptedForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('Programar visita ticket aceptado:',
            style: AppStyle.txtPoppinsRegular18Black),
        TextFormField(
            decoration: const InputDecoration(
              labelText: 'Fecha de inicio',
            ),
            style: AppStyle.txtPoppinsRegular14Black),
        TextFormField(
            decoration: const InputDecoration(labelText: 'Notas adicionales'),
            style: AppStyle.txtPoppinsRegular14Black),
        const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: Icon(Icons.save ,size: 18, color: Colors.white),
          onPressed: () {
            // Lógica para guardar los detalles del ticket aceptado
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xff051937),
            // Cambia este color al que desees onPrimary: Colors.white, // Color del texto del botón
          ),
          label: Text('Guardar', style: AppStyle.txtPoppinsMedium14White),
        ),
      ],
    );
  }

  Widget buildRejectedForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('Motivo del rechazo:', style: AppStyle.txtPoppinsRegular18Black),
        DropdownButton<String>(
          value: _selectedReason,
          onChanged: (String? newValue) {
            setState(() {
              _selectedReason = newValue!;
            });
          },
          items:
              _rejectionReasons.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
        TextFormField(
          decoration: const InputDecoration(labelText: 'Razón del rechazo'),
        ),
        const SizedBox(
          height: 20,
        ),
        ElevatedButton.icon(
              icon: Icon(Icons.save ,size: 18, color: Colors.white),
          onPressed: () {
            // Lógica para guardar los detalles del ticket aceptado
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xff051937),
            // Cambia este color al que desees onPrimary: Colors.white, // Color del texto del botón
          ),
          label: Text('Guardar', style: AppStyle.txtPoppinsMedium14White),
        )
      ],
    );
  }
}

Widget getStatusChip(String status) {
  Color color;
  String text;
  Color colorIcon;

  switch (status) {
    case 'pending':
      color = Colors.orange;
      text = 'Pendiente';
      break;
    case 'new':
      color = Color(0xffE0FFFF);
      text = 'Nuevo';
      break;
    case 'in_progress':
      color = Color(0xffb0c2f2);
      text = 'En Proceso';
      break;
    case 'completed':
      color = Color(0xffa07a);
      text = 'Completado';
      break;
    case 'canceled':
      color = Color(0xffa07a);
      text = 'Cancelado';
      break;
    default:
      color = Colors.grey;
      text = 'Desconocido';
  }
  return Chip(
    label: Text(
      text,
      style: const TextStyle(
          fontStyle: FontStyle.normal,
          color: Colors.black,
          fontFamily: 'Poppins'),
    ),
    avatar: const Icon(
           Icons.sell, color: Colors.black, // Color del ícono
    ),
    shadowColor: Colors.grey[350],
    backgroundColor: color,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(100.0),
      side: BorderSide(
        color: color, // Cambiar el color del borde aquí
        width: 2.0, // Ancho del borde
      ),
    ),
  );
}
