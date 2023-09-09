import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:supabase_auth/core/app_export.dart';
import 'package:supabase_auth/supabase_state/auth_state.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../theme/app_style.dart';
import 'package:http/http.dart' as http;

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends AuthState<SignInScreen> {
  var authRedirectUri = 'io.supabase.flutterdemo://login-callback';
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        body: Container(
          width: size.width,
          height: size.height,
          decoration: BoxDecoration(
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
          ),
          child: Container(
            width: double.maxFinite,
            padding: getPadding(
              left: 20,
              top: 40,
              right: 20,
            ),
            child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        Container(
                          height: getVerticalSize(
                            10,
                          ),
                          width: getHorizontalSize(
                            29,
                          ),
                          decoration: BoxDecoration(
                            color: ColorConstant.gray300,
                            borderRadius: BorderRadius.circular(
                              getHorizontalSize(
                                5,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: getVerticalSize(
                            10,
                          ),
                          width: getHorizontalSize(
                            48,
                          ),
                          margin: getMargin(
                            left: 9,
                          ),
                          decoration: BoxDecoration(
                            color: ColorConstant.gray300,
                            borderRadius: BorderRadius.circular(
                              getHorizontalSize(
                                5,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: getVerticalSize(
                            10,
                          ),
                          width: getHorizontalSize(
                            106,
                          ),
                          margin: getMargin(
                            left: 9,
                          ),
                          decoration: BoxDecoration(
                            color: ColorConstant.pink300,
                            borderRadius: BorderRadius.circular(
                              getHorizontalSize(
                                5,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: getPadding(
                      top: 40,
                    ),
                    child: Text(
                      "Challista Beauty Salon".tr,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                      style: AppStyle.txtPoppinsMedium22.copyWith(
                        letterSpacing: getHorizontalSize(
                          1.0,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: getHorizontalSize(
                      400,
                    ),
                    margin: getMargin(
                      left: 49,
                      right: 43,
                    ),
                    child: Text(
                      "Booking perawatan kamu sekarang!".tr,
                      maxLines: null,
                      textAlign: TextAlign.center,
                      style: AppStyle.txtPoppinsRegular14.copyWith(
                        letterSpacing: getHorizontalSize(
                          1.0,
                        ),
                      ),
                    ),
                  ),
                  CustomImageView(
                    imagePath: ImageConstant.imgGirllo11,
                    height: getSize(
                      280,
                    ),
                    width: getSize(
                      250,
                    ),
                    margin: getMargin(
                      top: 15,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      onTapBtnGoogleSignin();
                    },
                    child: Container(
                      width: 375,
                      height: 57,
                      margin:
                          const EdgeInsets.only(top: 10, left: 20, right: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          30,
                        ),
                        border: Border.all(
                          color: const Color.fromARGB(255, 241, 118, 138),
                          width: 1,
                        ),
                      ),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 23,
                              ),
                              child: SvgPicture.asset(
                                  'assets/images/img_googleicon.svg',
                                  height: 57,
                                  width: 24,
                                  fit: BoxFit.cover),
                            ),
                            Expanded(
                              child: Container(
                                height: 48,
                                width: 148,
                                margin: const EdgeInsets.only(
                                  left: 50,
                                  top: 16,
                                  right: 66,
                                  bottom: 16,
                                ),
                                child: const Text(
                                  "Login dengan Google",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            )
                          ]),
                    ),
                  ),
                ]),
          ),
        ),
      ),
    );
  }

  void onTapBtnGoogleSignin() async {
    try {
      // Get the current Supabase instance
      final supabaseInstance = Supabase.instance;

      // Check if the Supabase instance is initialized
      if (supabaseInstance != null) {
        // Get the Google authentication URL
        final authUrl = await supabaseInstance.client.auth.signInWithProvider(
          Provider.google,
          options: AuthOptions(redirectTo: authRedirectUri),
        );

        // Open the authentication URL in a WebView or use other methods to redirect the user to the URL
        // ...

        // After the user signs in with Google and is redirected back to the app, obtain the access token
        final queryParams = Uri.parse(authRedirectUri).queryParameters;
        final googleToken = queryParams['access_token'];

        // Get the currwent user's information from Supabase
        final user = supabaseInstance.client.auth.user();

        if (user != null) {
          final userId =
              user.id; // This is the user_id from the auth.users table
          // Call your custom API route in your Laravel backend to link the Google provider
          final apiUrl = Uri.parse(
              'https://ffff-202-80-216-225.ngrok-free.app/link-google-provider');
          final headers = {'Content-Type': 'application/json'};
          final body = {
            'access_token': googleToken,
            'user_id': userId,
          };

          final apiResponse =
              await http.post(apiUrl, headers: headers, body: jsonEncode(body));

          if (apiResponse.statusCode == 200) {
            // Provider linking successful
            print('Google provider linked successfully');
          } else {
            // Provider linking failed
            print('Failed to link Google provider');
          }
        } else {
          // Handle case when user information is not available
          print('User information not available');
        }
      } else {
        // Handle case when Supabase instance is not initialized
        print(
            'Supabase instance is not initialized. Call Supabase.initialize() to initialize it.');
      }
    } catch (e) {
      // Handle any errors that occur during sign-in
      print('Error signing in with Google: $e');
    }
  }
}
