import 'package:flutter/material.dart';
import 'package:tsmobile/src/core/theme/app.styles.dart';

class TicketDetails extends StatelessWidget {
  final String status;
  final String title;
  final String description;
  final String ticketType;
  final String product;
  final String scheduledDate;
  final String customerLocation;
  final String customerName;

  TicketDetails({
    required this.status,
    required this.title,
    required this.description,
    required this.ticketType,
    required this.product,
    required this.scheduledDate,
    required this.customerLocation,
    required this.customerName,
  });

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

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text('Ticket: #35941 ',
                      style: AppStyle.txtPoppinsBold14Black),
                ),
                getStatusChip(status),
              ],
            ),
            const SizedBox(height: 10),
             Text(
              'Titulo:',
                     style: AppStyle.txtPoppinsBold14Black,
            ),
            Text(title, style: AppStyle.txtPoppinsSemiBold14Black),
            const SizedBox(height: 10),
             Text(
              'Descripción:',
                  style:  AppStyle.txtPoppinsBold14Black,
            ),
            Text(description,   style: AppStyle.txtPoppinsSemiBold14Black),
            const SizedBox(height: 10),
             Text(
              'Tipo de Ticket:',
                   style:  AppStyle.txtPoppinsBold14Black
            ),
            Text(ticketType, style: AppStyle.txtPoppinsSemiBold14Black),
            const SizedBox(height: 10),
             Text(
              'Producto:',
                     style:  AppStyle.txtPoppinsBold14Black,
            ),
            Text(product,  style: AppStyle.txtPoppinsSemiBold14Black),
            const SizedBox(height: 10),
             Text(
              'Fecha Programada:',
                    style: AppStyle.txtPoppinsBold14Black,
            ),
            Text(scheduledDate, style: AppStyle.txtPoppinsSemiBold14Black),
            const SizedBox(height: 10),
             Text(
              'Ubicación del Cliente:',
                      style: AppStyle.txtPoppinsBold14Black
            ),
            Text(customerLocation,style: AppStyle.txtPoppinsSemiBold14Black),
            const SizedBox(height: 10),
             Text(
              'Nombre del Cliente:',
                      style: AppStyle.txtPoppinsBold14Black,
            ),
            Text(customerName, style: AppStyle.txtPoppinsSemiBold14Black),
          ],
        ),
      ),
    );
  }
}
