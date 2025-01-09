import 'package:flutter/material.dart';
import 'package:tsmobile/src/features/main/screens/detail_ticket_accept_decline_view.dart';
import 'package:tsmobile/src/features/main/screens/ticket_accepted_progress.dart';
import 'package:tsmobile/src/models/tickets_model.dart';
import '../core/theme/app.styles.dart';

class TicketItem extends StatelessWidget {
  final ServiceTicket ticket;
  final VoidCallback onTap;

  const TicketItem({super.key, required this.ticket, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap();
        print('ticket----- ${ticket}');

        if (ticket.status == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TicketDetailPageView(
                  ticketId: ticket.id.toString()), // Cambiar item a ticket
            ),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TicketAcceptedProgressDetailPage(
                  ticketId: ticket.id.toString()), // Cambiar item a ticket
            ),
          );
        }
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.transparent,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const _CardScheduledReservationtImage(
              image: 'assets/images/wrench.png',
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ticket.title,
                    style: AppStyle.txtPoppinsSemiBold16Black,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  const SizedBox(height: 6),
                  _CardScheduledReservationToday(
                      date: ticket.diagnosisDate ?? DateTime.now()),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text('Cliente: ', style: AppStyle.txtPoppinsRegular12Black),
                      Expanded(
                        child: Text(
                          ticket.customerName ?? 'Customer name',
                          style: AppStyle.txtPoppinsRegular12Black,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                    Row(
                    children: [
                      Text('# ', style: AppStyle.txtPoppinsRegular12Black),
                      Expanded(
                        child: Text(
                          ticket.id.toString() ?? '-',
                          style: AppStyle.txtPoppinsRegular12Black,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
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
                           ticket.serviceCallDetail['REFERENCE_DIRECTORY'],
                          style: AppStyle.txtPoppinsRegular12Black,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      const Text(' | '),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
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
          '${date.day} de ${_getMonthName(date.month)} ${date.year}',
          style: AppStyle.txtPoppinsRegular12Black,
        ),
      ],
    );
  }

  String _getMonthName(int month) {
    const months = [
      'enero',
      'febrero',
      'marzo',
      'abril',
      'mayo',
      'junio',
      'julio',
      'agosto',
      'septiembre',
      'octubre',
      'noviembre',
      'diciembre'
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
        image: DecorationImage(image: AssetImage(image), fit: BoxFit.contain),
      ),
    );
  }
}