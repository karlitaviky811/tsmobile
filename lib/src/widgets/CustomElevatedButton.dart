import 'package:flutter/material.dart';

import '../core/theme/app.styles.dart';

class CustomElevatedButton extends StatelessWidget {
  final Color color;
  final Function? onChange;
  final double? height;
  final Widget child;

  const CustomElevatedButton({
    super.key,
    required this.color,
    this.onChange,
    this.height,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height ?? 53,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            backgroundColor: color,
          ),
          onPressed: () {
            onChange!();
          },
          child: child),
    );
  }
}
