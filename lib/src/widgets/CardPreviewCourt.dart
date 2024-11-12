
import 'package:flutter/material.dart';
import 'package:tsmobile/src/widgets/CustomElevatedButton.dart';

import '../core/theme/app.styles.dart';

class CardPreviewCourt extends StatelessWidget {
  final String name;
  final String image;
  final String type;
  final String rainyPercentage;
  final Function onTap;

  const CardPreviewCourt({
    super.key,
    required this.name,
    required this.type,
    required this.rainyPercentage,
    required this.image,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xffEEEFF1)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.25, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    name,
                    style: AppStyle.txtPoppinsRegular18Black,
                  ),
                  Row(
                    //Icons.thunderstorm_rounded
                    children: [
                      const Icon(Icons.work, size: 16),
                      const SizedBox(
                        width: 4,
                      ),
                      Text(rainyPercentage)
                    ],
                  )
                ],
              ),
              const SizedBox(height: 4),
              Text(
                type,
                style: AppStyle.txtPoppinsRegular12Black,
              ),
              const SizedBox(height: 14),
              const _CardPreviewCourtToday(),
              const SizedBox(height: 14),
              Row(children: [
                Text(
                  'Disponible',
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
                const Icon(Icons.schedule_outlined, size: 12),
                const SizedBox(width: 4),
                Text(
                  '7:00 am a 4:00 pm',
                  style: AppStyle.txtPoppinsRegular12Black,
                )
              ]),
              const SizedBox(height: 40),
              CustomElevatedButton(
                  height: 32,
                  onChange: onTap,
                  color: const Color(0xffe4c404),
                  child: Text(
                    'Detalle',
                    style: AppStyle.txtPoppinsRegular14White,
                  ))
            ],
          ),
        )
      ]),
    );
  }
}

class _CardPreviewCourtToday extends StatelessWidget {
  const _CardPreviewCourtToday();

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

class _CardPrevieCourtImage extends StatelessWidget {
  const _CardPrevieCourtImage({
    required this.image,
  });

  final String image;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xffEEEFF1)),
          image: DecorationImage(image: AssetImage(image), fit: BoxFit.cover)),
    );
  }
}
