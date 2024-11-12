import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../core/constants/color.constant.dart';

class CarouselImages extends StatefulWidget {
  final List<String> imagesPath;

  const CarouselImages({super.key, required this.imagesPath});

  @override
  State<CarouselImages> createState() => _CarouselImagesState();
}

class _CarouselImagesState extends State<CarouselImages> {
  final CarouselSliderController controller = CarouselSliderController();
  double kPosition = 0.0;

  void handleChangeDotIndicator(int index) {
    controller.jumpToPage(index.toInt());
    kPosition = index.toDouble();
    setState(() {});
  }

  void handlePageChange(int index, CarouselPageChangedReason reason) {
    kPosition = index.toDouble();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        CarouselSlider(
          carouselController: controller,
          options: CarouselOptions(
            height: 269.0,
            viewportFraction: 1.0,
            onPageChanged: handlePageChange,
          ),
          items: widget.imagesPath.map((imagePath) {
            return Builder(
              builder: (BuildContext context) {
                return Image.asset(
                  'assets/images/$imagePath',
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.cover,
                  // opacity: const AlwaysStoppedAnimation(.7),
                );
              },
            );
          }).toList(),
        ),
        Positioned(
          bottom: 19,
          child: DotsIndicator(
            dotsCount: widget.imagesPath.length,
            position: kPosition.toInt() ,
            onTap: handleChangeDotIndicator,
            decorator: DotsDecorator(
              activeColor: ColorConstant.greenAA,
              size: const Size.square(16.0),
              activeSize: const Size.square(16.0),
              activeShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0)),
            ),
          ),
        )
      ],
    );
  }
}
