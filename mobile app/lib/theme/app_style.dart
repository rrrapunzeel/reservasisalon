import 'package:flutter/material.dart';
import 'package:supabase_auth/core/app_export.dart';

class AppStyle {
  static TextStyle txtPoppinsMedium22 = TextStyle(
    color: ColorConstant.gray800,
    fontSize: getFontSize(
      22,
    ),
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w500,
  );

  static TextStyle txtRobotoRegular16 = TextStyle(
    color: ColorConstant.bluegray400,
    fontSize: getFontSize(
      16,
    ),
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w400,
  );

  static TextStyle txtPoppinsRegular14 = TextStyle(
    color: ColorConstant.gray500,
    fontSize: getFontSize(
      14,
    ),
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w400,
  );

  static TextStyle txtRobotoRegular20 = TextStyle(
    color: ColorConstant.black900,
    fontSize: getFontSize(
      20,
    ),
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w400,
  );
}
