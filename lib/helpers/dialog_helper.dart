// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:passify/constant/color_constant.dart';

class DialogHelper {
  static showLoading() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: EdgeInsets.fromLTRB(0, 40, 0, 25),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GetPlatform.isIOS
                  ? CupertinoActivityIndicator(radius: 20)
                  : SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation(AppColors.primaryColor),
                      ),
                    ),
              SizedBox(height: 30),
              Text(
                'Mohon Tunggu...',
                style:
                    GoogleFonts.poppins(fontSize: 14, color: AppColors.black),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  static showError({String? title, String? description}) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(title ?? 'Terdapat Gangguan',
                  style: Get.textTheme.headline6),
              SizedBox(
                height: 10,
              ),
              Text(
                description ?? 'Sorry, something went wrong',
                style: Get.textTheme.bodyText1,
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

  static showSuccess({String? title, String? description}) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title ?? 'Pemberitahuan',
                style: Get.textTheme.headline6,
              ),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Image.asset("assets/images/login_illustration.png"),
              ),
              Text(
                description ?? 'COOMING SOON',
                style: Get.textTheme.headline5,
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

  static showInfo({String? title, String? description}) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    String code = packageInfo.buildNumber;
    String appName = packageInfo.appName;
    String packageName = packageInfo.packageName;
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title ?? 'Informasi Aplikasi',
                style: Get.textTheme.headline6,
              ),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Image.asset("assets/images/logo.png", height: 150),
              ),
              Text(
                description ?? 'App Version : v$version',
                style: GoogleFonts.poppins(fontSize: 14),
              ),
              Text(
                description ?? 'App Name : $appName',
                style: GoogleFonts.poppins(
                    fontSize: 12, color: Colors.grey.shade400),
              ),
              Text(
                description ?? 'Package Name : $packageName',
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

  static showConfirm(
      {required String title,
      required String description,
      String? titlePrimary,
      String? titleSecondary,
      String? dialogType,
      VoidCallback? action}) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: Get.textTheme.headline6,
              ),
              SizedBox(height: 10),
              Text(
                description,
                style: Get.textTheme.bodyText1,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40),
              dialogType == "DialogType.alert"
                  ? Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.white,
                              padding: EdgeInsets.symmetric(
                                vertical: 10,
                              ),
                              shape: RoundedRectangleBorder(
                                side: BorderSide(color: Colors.red.shade400),
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: action,
                            child: Text(
                              titlePrimary ?? 'Ya',
                              style: TextStyle(
                                  color: Colors.red.shade400, fontSize: 14),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Color(0xFF5BBFFA),
                                padding: EdgeInsets.symmetric(
                                  vertical: 10,
                                ),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12))),
                            onPressed: () {
                              if (Get.isDialogOpen ?? false) Get.back();
                            },
                            child: Text(
                              titleSecondary ?? 'Tidak',
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                        )
                      ],
                    )
                  : Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Colors.white,
                                padding: EdgeInsets.only(top: 10, bottom: 10),
                                shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                        color: AppColors.primaryColor),
                                    borderRadius: BorderRadius.circular(12))),
                            onPressed: () {
                              if (Get.isDialogOpen ?? false) Get.back();
                            },
                            child: Text(
                              titleSecondary ?? 'Tidak',
                              style: TextStyle(
                                  fontSize: 14, color: AppColors.primaryColor),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: AppColors.primaryColor,
                                padding: EdgeInsets.only(top: 10, bottom: 10),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12))),
                            onPressed: action,
                            child: Text(
                              titlePrimary ?? 'Ya',
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                        )
                      ],
                    )
            ],
          ),
        ),
      ),
    );
  }
}
