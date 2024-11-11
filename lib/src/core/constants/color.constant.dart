import 'package:flutter/material.dart';

class ColorConstant {
  static Color black3D = fromHex('#3D3D3D');
  static Color black00 = fromHex('#000000');
  static Color whiteFB = fromHex('#FBFBFB');
  static Color white00 = fromHex('#00000000');
  static Color whiteFF = fromHex('#FFFFFF');
  static Color whiteFC = fromHex('#FCFCFC');
  static Color whiteF4 = fromHex('#F4F7FC');
  static Color whiteEE = fromHex('#EEEFF1');
  static Color whiteAA = fromHex('#AAF72400');
  static Color whiteEC = fromHex('#ECEFF4');
  static Color gray9B = fromHex('#9B9C9D');
  static Color gray00 = fromHex('#00000029');
  static Color gray3D = fromHex('#3D3D3D');
  static Color blue34 = fromHex('#346BC3');
  static Color blueF4 = fromHex('#F4F7FC');
  static Color greenAA = fromHex('#AAF724');
  static Color green82 = fromHex('#82BC00');
  static Color blue48 = fromHex('#1c2648');

  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
