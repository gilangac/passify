// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, unused_import, must_be_immutable, prefer_const_constructors_in_immutables

import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:passify/constant/color_constant.dart';
import 'package:passify/controllers/auth/firebase_auth_controller.dart';
import 'package:passify/controllers/auth/onboard_controller.dart';
import 'package:passify/helpers/bottomsheet_helper.dart';
import 'package:passify/helpers/dialog_helper.dart';
import 'package:passify/routes/pages.dart';
import 'package:passify/services/service_preference.dart';
import 'package:passify/views/login/privacypolicy_page.dart';
import 'package:passify/views/login/termofuse_page.dart';
import 'package:url_launcher/url_launcher.dart';

class OnboardingPage extends StatelessWidget {
  OnboardingPage({Key? key}) : super(key: key);
  onboardController controller = Get.put(onboardController());

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark));
    return Obx(() => Scaffold(backgroundColor: Colors.white, body: _body()));
  }

  Widget _body() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
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
                _welcome(),
                _illustration(),
                _logo(),
                _textContent(),
                _btnStart(),
                SizedBox()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _illustration() {
    return FadeInDown(
      child: Align(
        alignment: Alignment.center,
        child: Image.asset(
          "assets/images/welcome.png",
          width: Get.width * 0.65,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _logo() {
    return FadeInDown(
      child: Align(
        alignment: Alignment.center,
        child: Image.asset(
          "assets/images/passify_tittle.png",
          width: Get.width * 0.40,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _welcome() {
    return Text(
      "Selamat Datang!",
      style: GoogleFonts.poppins(
        fontSize: 24,
        color: Colors.black,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _textContent() {
    return FadeInDown(
      child: RichText(
        textAlign: TextAlign.center,
        // ignore: prefer_const_literals_to_create_immutables
        text: TextSpan(children: <TextSpan>[
          TextSpan(
            text:
                "Aplikasi jejaring sosial yang dapat mempermudah kamu untuk menemukan teman yang memiliki kesamaan hobi denganmu!",
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Colors.grey.shade800,
              fontWeight: FontWeight.w500,
            ),
          ),
        ]),
      ),
    );
  }

  Widget _textAgree() {
    return FadeInDown(
      child: Padding(
        padding: const EdgeInsets.only(top: 20, bottom: 0),
        child: Obx(() => Row(
              children: [
                Checkbox(
                  value: controller.checkbox.value,
                  activeColor: AppColors.primaryColor,
                  checkColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7),
                  ),
                  onChanged: (value) {
                    controller.checkbox.value = value!;
                  },
                ), //Checkbox
                Expanded(
                  child: RichText(
                    textAlign: TextAlign.left,
                    // ignore: prefer_const_literals_to_create_immutables
                    text: TextSpan(children: <TextSpan>[
                      TextSpan(
                        text:
                            "Dengan melanjutkan berarti anda telah menyetujui ",
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          color: Colors.grey.shade500,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      TextSpan(
                        text: "syarat ketentuan ",
                        recognizer: new TapGestureRecognizer()
                          ..onTap = () {
                            // launch('https://pages.flycricket.io/passify-0/privacy.html');
                            Get.to(TermofusePage());
                          },
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          color: Colors.blue.shade300,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextSpan(
                        text: "dan ",
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          color: Colors.grey.shade500,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      TextSpan(
                        text: "kebijakan privasi ",
                        recognizer: new TapGestureRecognizer()
                          ..onTap = () {
                            // launch('https://pages.flycricket.io/passify-0/privacy.html');
                            Get.to(PrivacipolicyPage());
                          },
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          color: Colors.blue.shade300,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextSpan(
                        text: " yang berlaku.",
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          color: Colors.grey.shade500,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ]),
                  ),
                ),
              ],
            )),
      ),
    );
  }

  static showPrivacyPolicy() async {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Kebijakan Privasi',
                style: Get.textTheme.headline6,
              ),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Image.asset("assets/images/logo.png", height: 150),
              ),
              Text(
                'App Version : v',
                style: GoogleFonts.poppins(fontSize: 14),
              ),
              Text(
                'App Name : ',
                style: GoogleFonts.poppins(
                    fontSize: 12, color: Colors.grey.shade400),
              ),
              Text(
                'Package Name : ',
                style: GoogleFonts.poppins(
                    fontSize: 12, color: Colors.grey.shade400),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.only(left: 30, right: 30),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100))),
                  onPressed: () {
                    if (Get.isDialogOpen ?? false) Get.back();
                  },
                  child: Text('Okay'))
            ],
          ),
        ),
      ),
    );
  }

  Widget _btnStart() {
    return FadeInDown(
      child: Column(
        children: [
          _textAgree(),
          SizedBox(
            height: 10,
          ),
          Container(
            width: Get.width / 1,
            height: 50,
            child: GetPlatform.isIOS
                ? CupertinoButton.filled(
                    borderRadius: BorderRadius.circular(12),
                    onPressed: () {
                      PreferenceService.setBoard("notfirst");
                      Get.offNamed(AppPages.LOGIN);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Setuju & Lanjutkan',
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
                        primary: AppColors.primaryColor, elevation: 0.1),
                    onPressed: !controller.checkbox.value
                        ? null
                        : () {
                            PreferenceService.setBoard("notfirst");
                            Get.offNamed(AppPages.LOGIN);
                          },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Setuju & Lanjutkan',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
