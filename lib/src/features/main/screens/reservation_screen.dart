import 'package:tsmobile/src/core/constants/color.constant.dart';
import 'package:tsmobile/src/features/main/widgets/carousel_images.dart';
import 'package:tsmobile/src/widgets/CustomElevatedButton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app.styles.dart';

class ReservationScreen extends StatelessWidget {
  static const String route = 'reservation-route';

  const ReservationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> carouselImagesPath = [
      'court1_carousel.png',
      'court2_carousel.png',
      'court3_carousel.png'
    ];
    return Scaffold(
      body: Column(
        children: [
          _CarouselCourt(carouselImagesPath: carouselImagesPath),
          const _CourtDetail(),
          const _FormReservation()
        ],
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
    return Container(
        padding:
            const EdgeInsets.only(left: 32, right: 31, top: 24, bottom: 22),
        width: double.infinity,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Epic Box',
                style: AppStyle.txtPoppinsSemiBold20Black,
              ),
              Text(
                '\$25',
                style: AppStyle.txtPoppinsSemiBold20Blue,
              )
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Cancha Tipo A',
                style: AppStyle.txtPoppinsRegular12Black,
              ),
              Text(
                'Por hora',
                style: AppStyle.txtPoppinsRegular12Gray,
              )
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                'Disponible',
                style: AppStyle.txtPoppinsRegular12Black,
              ),
              const SizedBox(width: 8),
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                    color: Color(0xff346BC3),
                    borderRadius: BorderRadius.circular(50)),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.schedule_outlined, size: 12),
              const SizedBox(width: 4),
              Text(
                '7:00 am a 4:00 pm',
                style: AppStyle.txtPoppinsRegular12Black,
              )
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.location_on_outlined),
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
                    child: Text('Item 1'),
                    value: 1.0,
                  ),
                  DropdownMenuItem(child: Text('Item 1'), value: 2.0),
                ],
                onChanged: (value) {}),
          ),
          const SizedBox(height: 22),
        ]));
  }
}

class _CarouselCourt extends StatelessWidget {
  const _CarouselCourt({
    super.key,
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
