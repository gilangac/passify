// ignore_for_file: must_be_immutable, prefer_const_constructors, prefer_const_constructors_in_immutables, file_names, unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:passify/constant/color_constant.dart';
import 'package:passify/controllers/auth/firebase_auth_controller.dart';
import 'package:passify/controllers/profile/profile_controller.dart';
import 'package:passify/helpers/dialog_helper.dart';
import 'package:passify/routes/pages.dart';
import 'package:passify/services/service_preference.dart';

FirebaseAuthController firebaseAuthController =
    Get.put(FirebaseAuthController());

class ProfileActionMenuWidget extends StatelessWidget {
  ProfileActionMenuWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: Icon(Feather.menu, size: 24)),
      onTap: () {
        _bottomSheetContentProfile();
      },
    );
  }
}

void _bottomSheetContentProfile() {
  Get.bottomSheet(
      SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(color: AppColors.lightGrey, width: 35, height: 4),
              SizedBox(height: 30),
              Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey.shade100),
                  child: Column(
                    children: [
                      _listAction2(
                          icon: Feather.edit,
                          title: "Edit Profil",
                          path: AppPages.EDIT_PROFILE,
                          type: "report"),
                      Divider(
                        height: 1,
                        color: Colors.grey.shade300,
                      ),
                      if (PreferenceService.getStatusUser() != "verified" &&
                          PreferenceService.getStatusUser() != "waiting")
                        _listAction2(
                            icon: Feather.check_circle,
                            title: "Verifikasi Akun",
                            path: AppPages.EDIT_PROFILE,
                            type: "verif"),
                      if (PreferenceService.getStatusUser() != "verified" &&
                          PreferenceService.getStatusUser() != "waiting")
                        Divider(
                          height: 1,
                          color: Colors.grey.shade300,
                        ),
                      _listAction2(
                          icon: Feather.info,
                          title: "Tentang Aplikasi",
                          path: AppPages.HOME,
                          type: "about"),
                    ],
                  )),
              SizedBox(height: 13),
              _logoutAction()
            ],
          ),
        ),
      ),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      isDismissible: true,
      enableDrag: true,
      isScrollControlled: true);
}

Widget _listAction2({
  IconData? icon,
  required String title,
  required String path,
  String? type,
}) {
  return Container(
    width: Get.width,
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () {
          Get.back();
          type == "about"
              ? DialogHelper.showInfo()
              : type == "verif"
                  ? DialogHelper.showConfirm(
                      title: "Ajukan Verifikasi Akun",
                      description:
                          "Akun yang telah terverifikasi dapat memiliki hak untuk mengelola komunitas dan event. \n\nApa anda yakin akan mengajukan permintaan verifikasi akun?",
                      titleSecondary: "Batal",
                      titlePrimary: "Ajukan",
                      action: () {
                        ProfileController profileC = Get.find();
                        profileC.onRequestVerifAccount();
                      })
                  : Get.toNamed(path);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: ListTile(
            minLeadingWidth: 0,
            leading: Icon(icon),
            title: Text(
              title,
              style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textColor),
            ),
            trailing: Icon(Feather.chevron_right),
          ),
        ),
      ),
    ),
  );
}

Widget _logoutAction() {
  return Container(
    width: Get.width,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10), color: Colors.grey.shade100),
    child: Material(
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () {
          Get.back();
          DialogHelper.showConfirm(
              title: "Logout",
              description: "Anda yakin akan keluar aplikasi?",
              titlePrimary: "Logout",
              titleSecondary: "Batal",
              action: () => firebaseAuthController.logout());
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: ListTile(
            minLeadingWidth: 0,
            leading: Icon(Feather.log_out, color: Colors.red.shade400),
            title: Text(
              "Keluar",
              style: GoogleFonts.poppins(color: Colors.red.shade400),
            ),
          ),
        ),
      ),
      color: Colors.transparent,
    ),
  );
}
