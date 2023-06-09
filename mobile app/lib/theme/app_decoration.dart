import 'package:flutter/material.dart';
import 'package:supabase_auth/core/app_export.dart';

class AppDecoration {
  static BoxDecoration get text => BoxDecoration(
        border: Border.all(
          color: ColorConstant.black900,
          width: getHorizontalSize(
            1,
          ),
        ),
        gradient: LinearGradient(
          begin: const Alignment(
            0.5,
            0,
          ),
          end: const Alignment(
            0.5,
            1,
          ),
          colors: [
            ColorConstant.whiteA700,
            ColorConstant.whiteA700,
            ColorConstant.whiteA700,
          ],
        ),
      );
  static BoxDecoration get fillWhiteA700 => BoxDecoration(
        color: ColorConstant.whiteA700,
      );

  static BoxDecoration get txtFillBluegray50 => BoxDecoration(
        color: ColorConstant.blueGray50,
      );
  static BoxDecoration get txtFillBluegray900 => BoxDecoration(
        color: ColorConstant.blueGray900,
      );
  static BoxDecoration get txtFillPink300 => BoxDecoration(
        color: ColorConstant.pink300,
      );
  static BoxDecoration get txtFillWhiteA700 => BoxDecoration(
        color: ColorConstant.whiteA700,
      );
  static BoxDecoration get outlineGray50033 => BoxDecoration(
        color: ColorConstant.whiteA700,
        boxShadow: [
          BoxShadow(
            color: ColorConstant.gray50033,
            spreadRadius: getHorizontalSize(
              2,
            ),
            blurRadius: getHorizontalSize(
              2,
            ),
            offset: const Offset(
              0,
              0,
            ),
          ),
        ],
      );
}

class BorderRadiusStyle {
  double get strokeAlignInside => BorderSide.strokeAlignInside;
  double get strokeAlignCenter => BorderSide.strokeAlignCenter;
  double get strokeAlignOutside => BorderSide.strokeAlignOutside;
  static BorderRadius roundedBorder6 = BorderRadius.circular(
    getHorizontalSize(
      6,
    ),
  );

  static BorderRadius txtRoundedBorder5 = BorderRadius.circular(
    getHorizontalSize(
      5,
    ),
  );

  static BorderRadius txtRoundedBorder12 = BorderRadius.circular(
    getHorizontalSize(
      12,
    ),
  );

  static BorderRadius circleBorder50 = BorderRadius.circular(
    getHorizontalSize(
      50,
    ),
  );
}
