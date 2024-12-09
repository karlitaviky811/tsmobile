import 'package:flutter/material.dart';
import 'package:tsmobile/src/features/main/screens/detail_ticket_accept_decline_view.dart';
import '../core/theme/app.styles.dart';
import 'package:tsmobile/src/services/Item.model.dart';

class ReservationItemElement extends StatelessWidget {
  final Item item;

  const ReservationItemElement({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print('item----- $item');
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => TicketDetailPageView(item: item)));
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const _CardScheduledReservationtImage(
             image: 'assets/images/wrench.png',
          ),
          const SizedBox(width: 8),
          Expanded( // Envuelve la columna en un widget Expanded para evitar desbordamientos
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title, // Mostrar el título del item
                  style: AppStyle.txtPoppinsSemiBold16Black,
                  overflow: TextOverflow.ellipsis, // Agregar esta línea
                  maxLines: 1, // Limitar el número de líneas
                ),
                const SizedBox(height: 6),
                _CardScheduledReservationToday(date: item.diagnosisDate ?? DateTime.now()), // Pasar la fecha de diagnóstico
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text('Cliente: ',
                        style: AppStyle.txtPoppinsRegular12Black),
                    Expanded(
                      child: Text(
                        item.customerName, 
                        style: AppStyle.txtPoppinsRegular12Black,
                        overflow: TextOverflow.ellipsis, // Agregar esta línea
                        maxLines: 1, // Limitar el número de líneas
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(
                      Icons.schedule_outlined,
                      size: 12,
                    ),
                    Text('${item.totalCost} USD', style: AppStyle.txtPoppinsRegular12Black), // Mostrar el costo total
                    const Text(' | '),
                    Text('50', style: AppStyle.txtPoppinsRegular12Black),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 12,
                    ),
                    Expanded(
                      child: Text(
                        'Vía Av. Caracas y Av. P.º Caroni', 
                        style: AppStyle.txtPoppinsRegular12Black,
                        overflow: TextOverflow.ellipsis, // Agregar esta línea
                        maxLines: 1, // Limitar el número de líneas
                      ),
                    ),
                    const Text(' | '),
                    Text('50', style: AppStyle.txtPoppinsRegular12Black),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CardScheduledReservationToday extends StatelessWidget {
  final DateTime date;

  const _CardScheduledReservationToday({
    super.key,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.calendar_today,
          size: 13,
        ),
        const SizedBox(width: 8),
        Text(
          '${date.day} de ${_getMonthName(date.month)} ${date.year}', // Formatear la fecha
          style: AppStyle.txtPoppinsRegular12Black,
        ),
      ],
    );
  }

  String _getMonthName(int month) {
    const months = [
      'enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio',
      'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre'
    ];
    return months[month - 1];
  }
}

class _CardScheduledReservationtImage extends StatelessWidget {
  const _CardScheduledReservationtImage({
    super.key,
    required this.image,
  });

  final String image;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.transparent),
          image: DecorationImage(image: AssetImage(image), fit: BoxFit.contain)),
    );
  }
}
