import 'dart:ui';
import 'package:flutter/material.dart';

class ColorConstant {
  static Color gray700 = fromHex('#606060');

  static Color gray400 = fromHex('#b3b3b3');

  static Color gray500 = fromHex('#a7a2a3');

  static Color blueGray50 = fromHex('#f1f1f1');

  static Color blue800 = fromHex('#1170af');

  static Color gray800 = fromHex('#403839');

  static Color blue500 = fromHex('#16a0f9');

  static Color gray80003 = fromHex('#40393a');

  static Color gray80002 = fromHex('#4a4a4a');

  static Color gray80001 = fromHex('#414141');

  static Color gray200 = fromHex('#eaeaea');

  static Color black900 = fromHex('#000000');

  static Color bluegray400 = fromHex('#888888');

  static Color gray50001 = fromHex('#928e8f');

  static Color gray50033 = fromHex('#33a5a5a5');

  static Color gray50002 = fromHex('#918d8e');

  static Color blueGray900 = fromHex('#333333');

  static Color pink300 = fromHex('#f1768a');

  static Color black90014 = fromHex('#14000000');

  static Color whiteA700 = fromHex('#ffffff');

  static Color gray8007f = fromHex('#7f4a4a4a');

  static Color gray300 = fromHex('#dfe0eb');

  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
