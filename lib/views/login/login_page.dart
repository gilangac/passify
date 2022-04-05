// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, unused_import, must_be_immutable

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:passify/constant/color_constant.dart';
import 'package:passify/controllers/auth/firebase_auth_controller.dart';
import 'package:passify/routes/pages.dart';
import 'package:passify/services/service_preference.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);
  FirebaseAuthController firebaseAuthController = Get.find();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark));
    return Scaffold(backgroundColor: Colors.white, body: _body());
  }

  Widget _body() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
        child: Container(
          height: Get.height,
          constraints: BoxConstraints(
            maxHeight: Get.height,
            maxWidth: Get.width,
          ),
          decoration: const BoxDecoration(color: Colors.white),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _illustration(),
              _logo(),
              _textContent(),
              _btnStart(),
              SizedBox()
            ],
          ),
        ),
      ),
    );
  }

  Widget _illustration() {
    return Align(
      alignment: Alignment.center,
      child: Image.asset(
        "assets/images/login_ilustration.png",
        width: Get.width * 0.8,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _logo() {
    return Align(
      alignment: Alignment.center,
      child: Image.asset(
        "assets/images/passify_tittle.png",
        width: Get.width * 0.40,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _textContent() {
    return RichText(
      textAlign: TextAlign.center,
      // ignore: prefer_const_literals_to_create_immutables
      text: TextSpan(children: <TextSpan>[
        TextSpan(
          text:
              "Jangan biarkan hobi dan passionmu tidak berjalan hanya karena kamu tidak mempunyai teman sehobi. Temukan teman sehobimu di ",
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: Colors.grey.shade500,
            fontWeight: FontWeight.w400,
          ),
        ),
        TextSpan(
          text: "Passify",
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: AppColors.primaryColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        TextSpan(
          text: " !",
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: Colors.grey.shade500,
            fontWeight: FontWeight.w400,
          ),
        ),
      ]),
    );

    // return const Text(
    //   "Jangan biarkan hobi dan passionmu tidak berjalan hanya karena kamu tidak mempunyai teman sehobi. Temukan teman se-hobimu di passify!",
    //   textAlign: TextAlign.center,
    // );
  }

  Widget _btnStart() {
    return Container(
      width: Get.width / 1,
      height: 50,
      child: GetPlatform.isIOS
          ? CupertinoButton.filled(
              borderRadius: BorderRadius.circular(12),
              onPressed: () {
                PreferenceService.setC1(0);
                PreferenceService.setC2(1);
                PreferenceService.setC3(2);
                PreferenceService.setC4(3);
                Get.offNamed(AppPages.NAVIGATOR);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset("assets/svg/google_icon.svg"),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Masuk dengan Google',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey.shade500,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            )
          : ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: Color(0xFFF5F5F5), elevation: 0.5),
              onPressed: () {
                PreferenceService.setC1(0);
                PreferenceService.setC2(1);
                PreferenceService.setC3(2);
                PreferenceService.setC4(3);
                firebaseAuthController.signInWithGoogle().then((_) {
                  Get.back();
                  firebaseAuthController.onGetUser();
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset("assets/svg/google_icon.svg"),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Masuk dengan Google',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey.shade500,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
