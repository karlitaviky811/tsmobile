import 'package:tsmobile/src/core/constants/color.constant.dart';
import 'package:tsmobile/src/features/main/screens/card_detail_ticket.dart';
import 'package:tsmobile/src/features/main/widgets/carousel_images.dart';
import 'package:tsmobile/src/widgets/CustomElevatedButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app.styles.dart';

class AcceptDeclineTicket extends StatelessWidget {
  static const String route = 'accept-decline-ticket-route';

  final dynamic ticketId;

  const AcceptDeclineTicket({super.key, required this.ticketId});

  @override
  Widget build(BuildContext context) {
    List<String> carouselImagesPath = [
      'court1_carousel.png',
      'court2_carousel.png',
      'court3_carousel.png'
    ];
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [_CourtDetail(), _FormReservation()],
      ),
    );
  }
}

class _FormReservation extends StatelessWidget {
  const _FormReservation({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.only(left: 32, right: 32, top: 26.5, bottom: 41),
      width: double.infinity,
      height: 300,
      color: ColorConstant.blueF4,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Establecer fecha y hora',
              style: AppStyle.txtPoppinsMedium18Black,
            ),
            const SizedBox(height: 20),
            _getDatePickerEnabled(context),
            const SizedBox(height: 20),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              _getTimePickerEnabled(context),
              _getTimePickerEnabled(context),
            ]),
            const SizedBox(height: 24),
            Text(
              'Agregar un comentario',
              style: AppStyle.txtPoppinsMedium18Black,
            ),
            const SizedBox(height: 15.5),
            Card(
              color: Colors.white,
              child: TextFormField(
                minLines:
                    6, // any number you need (It works as the rows for the textarea)
                keyboardType: TextInputType.multiline,
                maxLines: null,
              ),
            ),
            const SizedBox(
              height: 45,
            ),
            CustomElevatedButton(
                color: ColorConstant.green82,
                child: Text(
                  'Reservar',
                  style: AppStyle.txtPoppinsSemiBold18White,
                ))
          ],
        ),
      ),
    );
  }

  Widget _getTimePickerEnabled(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 147.7),
      child: Material(
        color: ColorConstant.whiteFF,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(color: ColorConstant.whiteEE, width: 1.0)),
        child: InkWell(
          onTap: () {
            DatePicker.showTime12hPicker(
              context,
            );
          },
          child: InputDecorator(
            decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(
                    left: 20, right: 6.7, top: 6, bottom: 8),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                enabled: true),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hora de inicio',
                        style: AppStyle.txtRobotoRegular12Black,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '00:00',
                            style: AppStyle.txtRobotoRegular14Gray,
                          ),
                          Icon(Icons.keyboard_arrow_down_outlined,
                              color: ColorConstant.gray3D),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _getDatePickerEnabled(BuildContext context) {
    return Material(
      color: ColorConstant.whiteFF,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: ColorConstant.whiteEE, width: 1.0)),
      child: InkWell(
        onTap: () {
          _selectDate(context);
        },
        child: InputDecorator(
          decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.only(left: 20, right: 20, top: 6, bottom: 8),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              enabled: true),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Fecha',
                    style: AppStyle.txtRobotoRegular12Black,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat.yMMMd().format(DateTime.now()),
                    style: AppStyle.txtRobotoRegular14Gray,
                  ),
                ],
              ),
              Icon(Icons.keyboard_arrow_down_outlined,
                  color: ColorConstant.gray3D),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime.now());
  }
}

class _CourtDetail extends StatelessWidget {
  const _CourtDetail({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
          padding:
              const EdgeInsets.only(left: 32, right: 31, top: 24, bottom: 22),
          width: double.infinity,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SizedBox(height: 4),
            Row(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Creación',
                      style: AppStyle.txtPoppinsRegular12Black,
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                          color: const Color(0xff346BC3),
                          borderRadius: BorderRadius.circular(50)),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Fecha',
                      style: AppStyle.txtPoppinsRegular12Black,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '13 -11-2024',
                      style: AppStyle.txtPoppinsRegular12Black,
                    ),
                    const Icon(Icons.schedule_outlined, size: 12),
                    Text(
                      '7:00 am a 4:00 pm',
                      style: AppStyle.txtPoppinsRegular12Black,
                    )
                  ],
                )
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.location_on_outlined),
                const SizedBox(width: 4),
                Text(
                  'Vía Av. Caracas y Av. P.º Caroni',
                  style: AppStyle.txtPoppinsRegular12Black,
                )
              ],
            ),
            Row(
              children: [
                const Icon(Icons.location_on_outlined),
                const SizedBox(width: 4),
                Text(
                  'Vía Av. Caracas y Av. P.º Caroni',
                  style: AppStyle.txtPoppinsRegular12Black,
                )
              ],
            ),
            const SizedBox(height: 24),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 166, maxHeight: 55),
              child: DropdownButtonFormField(
                  value: 1.0,
                  icon: const Icon(Icons.keyboard_arrow_down_outlined),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: ColorConstant.black3D, width: 1.0),
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                  ),
                  style: AppStyle.txtPoppinsRegular14Black,
                  items: const [
                    DropdownMenuItem(
                      value: 1.0,
                      child: Text('Item 1'),
                    ),
                    DropdownMenuItem(value: 2.0, child: Text('Item 1')),
                  ],
                  onChanged: (value) {}),
            ),
            const SizedBox(height: 22),
            TicketDetailPage()
          ])),
    );
  }
}

class _CarouselCourt extends StatelessWidget {
  const _CarouselCourt({
    required this.carouselImagesPath,
  });

  final List<String> carouselImagesPath;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        CarouselImages(imagesPath: carouselImagesPath),
        Positioned(
          top: 30,
          left: 32,
          child: Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
                color: ColorConstant.green82,
                borderRadius: BorderRadius.circular(10)),
            child: Icon(
              Icons.arrow_back,
              color: ColorConstant.whiteFC,
            ),
          ),
        ),
        Positioned(
            top: 24,
            right: 22,
            child: Icon(
              size: 30.0,
              Icons.favorite_border_outlined,
              color: ColorConstant.whiteFC,
            )),
      ],
    );
  }
}

Widget getStatusChip(String status) {
  Color color;
  String text;
  switch (status) {
    case 'pending':
      color = Colors.orange;
      text = 'Pendiente';
      break;
    case 'new':
      color = const Color.fromARGB(255, 167, 126, 245);
      text = 'En Proceso';
      break;
    case 'in_progress':
      color = Colors.blue;
      text = 'En Proceso';
      break;
    case 'completed':
      color = Colors.green;
      text = 'Completado';
      break;
    case 'canceled':
      color = Colors.red;
      text = 'Cancelado';
      break;
    default:
      color = Colors.grey;
      text = 'Desconocido';
  }
  return Chip(
    label: Text(
      text,
      style: const TextStyle(fontStyle: FontStyle.normal, color: Colors.white),
    ),
    shadowColor: Colors.grey[350],
    backgroundColor: color,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.0),
      side: BorderSide.none, // Quitar el borde
    ),
  );
}

class TicketDetailPage extends StatefulWidget {
  @override
  _TicketDetailPageState createState() => _TicketDetailPageState();
}

class _TicketDetailPageState extends State<TicketDetailPage> {
  String _status = 'pending';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
                backgroundColor: Color(0xffF3F5FD),
        title: Text('Detalle del Ticket',  style: AppStyle.txtPoppinsRegular18Black,),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
              TicketDetails(
                      status: 'in_progress',
                      title: 'Reparación de Aire Acondicionado',
                      description:
                          'El aire acondicionado no enfría adecuadamente.',
                      ticketType: 'Reparación',
                      product: 'Aire Acondicionado',
                      scheduledDate: '2024-11-15',
                      customerLocation: 'Caracas, Venezuela',
                      customerName: 'Juan Pérez',
                    ),
             Row(
              children: <Widget>[
                ElevatedButton(
                style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                textStyle: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold)),
                  onPressed: () {
                    setState(() {
                      _status = 'accepted';
                    });
                    
                  },
                  child: const Text('Aceptar'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _status = 'rejected';
                    });
                  },
                  child: const Text('Rechazar'),
                ),
              ],
            ),
            const Text('ID del Ticket: 12345', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            const Text('Descripción: Problema con el software.',
                style: TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            Row(
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _status = 'accepted';
                    });
                  },
                  style: ElevatedButton.styleFrom( backgroundColor: Colors.red, // Cambia este color al que desees onPrimary: Colors.white, // Color del texto del botón 
                  ),
                  child: const Text('Aceptar'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _status = 'rejected';
                    });
                  },
                  child: const Text('Rechazar'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (_status == 'accepted') buildAcceptedForm(),
            if (_status == 'rejected') buildRejectedForm(),
          ],
        ),
      ),
    );
  }

  Widget buildAcceptedForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text('Información adicional para tickets aceptados:',
            style: TextStyle(fontSize: 16)),
        TextFormField(
          decoration: const InputDecoration(labelText: 'Fecha de inicio'),
        ),
        TextFormField(
          decoration: const InputDecoration(labelText: 'Notas adicionales'),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            // Lógica para guardar los detalles del ticket aceptado
          },
          child: const Text('Guardar'),
        ),
      ],
    );
  }

  Widget buildRejectedForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[

        TextFormField(
          decoration: const InputDecoration(labelText: 'Razón del rechazo'),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            // Lógica para guardar el motivo del rechazo
          },
          child: const Text('Guardar'),
        ),
      ],
    );
  }
}
