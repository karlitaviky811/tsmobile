import 'package:flutter/material.dart';

import '../core/theme/app.styles.dart';

class CardScheduledReservation extends StatelessWidget {
  const CardScheduledReservation({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 13, left: 19),
      width: double.infinity,
      height: 120,
      color: const Color(0xffF4F7FC),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const _CardScheduledReservationtImage(
            image: 'assets/images/court2.png',
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Epic Box',
                style: AppStyle.txtPoppinsSemiBold16Black,
              ),
              const SizedBox(height: 6),
              const _CardScheduledReservationToday(),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text('Reservado por: ',
                      style: AppStyle.txtPoppinsRegular12Black),
                  Text('Andrea Gómez', style: AppStyle.txtPoppinsRegular12Black)
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(
                    Icons.schedule_outlined,
                    size: 12,
                  ),
                  Text('2 horas', style: AppStyle.txtPoppinsRegular12Black),
                  const Text(' | '),
                  Text('50', style: AppStyle.txtPoppinsRegular12Black),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}

class _CardScheduledReservationToday extends StatelessWidget {
  const _CardScheduledReservationToday();

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
          '9 de julio 2024',
          style: AppStyle.txtPoppinsRegular12Black,
        ),
      ],
    );
  }
}

class _CardScheduledReservationtImage extends StatelessWidget {
  const _CardScheduledReservationtImage({
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
          border: Border.all(color: const Color(0xffEEEFF1)),
          image: DecorationImage(image: AssetImage(image), fit: BoxFit.cover)),
    );
  }
}
