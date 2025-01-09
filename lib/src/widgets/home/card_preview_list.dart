import 'package:flutter/material.dart';
import '../../core/theme/app.styles.dart';

class CardPreview extends StatelessWidget {
  final String name;
  final String image;
  final String type;
  final String rainyPercentage;
  final Function onTap;
  final List<Color> gradientColors;
  final String imageUrl;

  const CardPreview({
    super.key,
    required this.name,
    required this.type,
    required this.rainyPercentage,
    required this.image,
    required this.onTap,
    required this.gradientColors,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        width: 260,
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xffEEEFF1)),
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _CardPrevieCourtImage(image: imageUrl),
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
                        children: [
                          const Icon(Icons.work, size: 20),
                          const SizedBox(width: 4),
                          Text(rainyPercentage),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    type,
                    style: AppStyle.txtPoppinsRegular12Black,
                  ),
                  const SizedBox(height: 14),
                  
                                       
                
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CardPreviewCourtToday extends StatelessWidget {
  const _CardPreviewCourtToday();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Icon(
          Icons.calendar_today,
          size: 13,
        ),
        SizedBox(width: 8),
       
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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: double.infinity,
        height: 100,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
          image: DecorationImage(image: AssetImage(image), fit: BoxFit.contain),
        ),
      ),
    );
  }
}
