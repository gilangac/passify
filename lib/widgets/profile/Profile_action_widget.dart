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
        _bottomSheetContent();
      },
    );
  }
}

void _bottomSheetContent() {
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
              _listAction(
                  icon: Feather.edit,
                  title: "Edit Profil",
                  path: AppPages.EDIT_PROFILE),
              _listAction(
                  icon: Feather.info,
                  title: "Tentang Aplikasi",
                  type: "about",
                  path: AppPages.HOME),
              SizedBox(height: 10),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 12),
                color: AppColors.lightGrey,
                height: 0.5,
                width: Get.width,
              ),
              SizedBox(height: 10),
              _logoutAction(
                icon: Feather.log_out,
                title: "Keluar",
              ),
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

Widget _listAction(
    {IconData? icon,
    required String title,
    String? type,
    required String path}) {
  return InkWell(
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        minLeadingWidth: 0,
        leading: Icon(icon),
        title: Text(title),
        trailing: Icon(Feather.chevron_right),
      ),
    ),
    onTap: () {
      Get.back();
      type == "about" ? DialogHelper.showInfo() : Get.toNamed(path);
    },
  );
}

Widget _logoutAction({IconData? icon, required String title}) {
  final ProfileController controller = Get.find();

  return InkWell(
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        minLeadingWidth: 0,
        leading: Icon(icon, color: Colors.red.shade400),
        title: Text(
          title,
          style: GoogleFonts.poppins(color: Colors.red.shade400),
        ),
      ),
    ),
    onTap: () => DialogHelper.showConfirm(
        title: "Logout",
        description: "Anda yakin akan keluar aplikasi?",
        action: () => firebaseAuthController.logout()),
  );
}
