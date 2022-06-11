// ignore_for_file: prefer_const_constructors, must_be_immutable, unrelated_type_equality_checks, sized_box_for_whitespace

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:passify/constant/color_constant.dart';
import 'package:passify/controllers/auth/register_controller.dart';
import 'package:passify/routes/pages.dart';
import 'package:passify/widgets/general/app_bar.dart';
import 'package:passify/widgets/general/bottomsheet_widget.dart';
import 'package:passify/widgets/general/circle_avatar.dart';
import 'package:passify/widgets/general/form_input.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({Key? key}) : super(key: key);
  RegisterController registerC = Get.put(RegisterController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(
          title: "LENGKAPI DATA DIRIMU", canBack: false, enableLeading: false),
      body: _body(),
      backgroundColor: Colors.white,
    );
  }

  Widget _body() {
    return Obx(
      () => SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            margin: EdgeInsets.all(35),
            width: Get.width,
            child: Form(
              key: registerC.formKeReg,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  _photoProfile(),
                  SizedBox(
                    height: 40,
                  ),
                  _usernameInput(),
                  SizedBox(
                    height: 30,
                  ),
                  _nameInput(),
                  SizedBox(
                    height: 30,
                  ),
                  _provinceInput(),
                  SizedBox(
                    height: 30,
                  ),
                  _cityInput(),
                  SizedBox(
                    height: 30,
                  ),
                  _hobbyInput(),
                  SizedBox(
                    height: 30,
                  ),
                  _accountIgInput(),
                  SizedBox(
                    height: 30,
                  ),
                  _accountTwitterInput(),
                  SizedBox(
                    height: 70,
                  ),
                  _btnNext()
                ],
              ),
            ),
          )),
    );
  }

  Widget _photoProfile() {
    return GestureDetector(
      onTap: () => _showBottomSheet(registerC),
      child: Obx(() => Stack(
            children: [
              registerC.selectedImagePath.value == ""
                  ? circleAvatar(
                      imageData: registerC.auth.currentUser?.photoURL,
                      nameData: "G",
                      size: 50)
                  : CircleAvatar(
                      backgroundImage:
                          FileImage(File(registerC.selectedImagePath.value)),
                      radius: 50,
                    ),
              Positioned(
                  bottom: 3,
                  right: 3,
                  child: Container(
                    height: 25,
                    width: 25,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.shade300,
                            blurRadius: 3,
                            spreadRadius: 3)
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Icon(Feather.camera, size: 13),
                    ),
                  ))
            ],
          )),
    );
  }

  Widget _usernameInput() {
    return formInput(
      title: 'Username',
      placeholder: 'Username',
      inputType: TextInputType.name,
      inputAction: TextInputAction.next,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Masukkan username terlebih dahulu';
        }
        if (value.split(' ').length > 1) {
          return 'Username tidak boleh terdapat spasi';
        }
        if (value.length > 32) {
          return 'Username tidak boleh lebih dari 32 karakter';
        }
        return null;
      },
      controller: registerC.usernameFC,
    );
  }

  Widget _nameInput() {
    return formInput(
      title: 'Nama',
      placeholder: 'Nama',
      inputType: TextInputType.name,
      inputAction: TextInputAction.next,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Masukkan nama terlebih dahulu';
        }
        return null;
      },
      controller: registerC.nameFC,
    );
  }

  Widget _provinceInput() {
    return GestureDetector(
      child: formInput(
        suffix: true,
        enabled: false,
        title: 'Provinsi Tempat Tinggal',
        placeholder: 'Kota Tempat Tinggal',
        inputType: TextInputType.name,
        inputAction: TextInputAction.next,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Masukkan provinsi tempat tinggal terlebih dahulu';
          }
          return null;
        },
        controller: registerC.provinceFC,
      ),
      onTap: () {
        registerC.dataProvinsi.isNotEmpty
            ? BottomSheetList(
                ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: registerC.dataProvinsi.length,
                    padding: EdgeInsets.all(15),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          registerC.provinceFC.text =
                              registerC.dataProvinsi[index].nama.toString();
                          registerC.cityFC.text = '';
                          registerC.cityFC.clear();
                          registerC.dataCity.clear();
                          registerC.onGetCity(
                              registerC.dataProvinsi[index].id.toString());
                          Get.back();
                        },
                        child: Container(
                          margin: EdgeInsets.only(bottom: 15),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                registerC.dataProvinsi[index].nama.toString(),
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: AppColors.textColor,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Container(
                                height: 1,
                                width: Get.width,
                                color: Colors.grey.shade200,
                              )
                            ],
                          ),
                        ),
                      );
                    }),
                "Provinsi")
            : registerC.onGetProvince();
      },
    );
  }

  Widget _cityInput() {
    return GestureDetector(
      child: formInput(
        suffix: true,
        enabled: false,
        title: 'Kota Tempat Tinggal',
        placeholder: 'Kota Tempat Tinggal',
        inputType: TextInputType.name,
        inputAction: TextInputAction.next,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Masukkan kota tempat tinggal terlebih dahulu';
          }
          return null;
        },
        controller: registerC.cityFC,
      ),
      onTap: () {
        registerC.dataCity.isNotEmpty
            ? BottomSheetList(
                ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: registerC.dataCity.length,
                    padding: EdgeInsets.all(15),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          registerC.cityFC.text =
                              registerC.dataCity[index].nama.toString();
                          Get.back();
                        },
                        child: Container(
                          margin: EdgeInsets.only(bottom: 15),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                registerC.dataCity[index].nama.toString(),
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: AppColors.textColor,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Container(
                                height: 1,
                                width: Get.width,
                                color: Colors.grey.shade200,
                              )
                            ],
                          ),
                        ),
                      );
                    }),
                "Kota")
            : null;
      },
    );
  }

  Widget _hobbyInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          child: formInput(
            enabled: false,
            suffix: true,
            title: 'Hobi',
            placeholder: registerC.selectedHoby.isNotEmpty
                ? 'Tambah Hobi (maksimal 3)'
                : 'Pilih Hobi',
            inputType: TextInputType.name,
            inputAction: TextInputAction.next,
            validator: (value) {
              if (registerC.selectedHoby.isEmpty) {
                return 'Masukkan hobi terlebih dahulu';
              }
              return null;
            },
            controller: registerC.hobbyFC,
          ),
          onTap: () {
            registerC.dataHobies.isNotEmpty
                ? registerC.selectedHoby.length < 3
                    ? BottomSheetList(
                        ListView.builder(
                            physics: BouncingScrollPhysics(),
                            itemCount: registerC.dataHobies.length,
                            padding: EdgeInsets.symmetric(vertical: 15),
                            itemBuilder: (context, index) {
                              return InkWell(
                                borderRadius: BorderRadius.circular(15),
                                highlightColor: Colors.grey.shade200,
                                splashColor: Colors.grey.shade200,
                                onTap: () => registerC.onSelectHoby(index),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Text(
                                        registerC.dataHobies[index]['name']
                                            .toString(),
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          color: AppColors.textColor,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15),
                                      child: Container(
                                        height: 1,
                                        width: Get.width,
                                        color: Colors.grey.shade200,
                                      ),
                                    )
                                  ],
                                ),
                              );
                            }),
                        "Hobi")
                    : null
                : registerC.onReadJson();
          },
        ),
        SizedBox(
          height: 10,
        ),
        Wrap(
            direction: Axis.horizontal,
            alignment: WrapAlignment.start,
            children: _selectedHoby())
      ],
    );
  }

  List<Widget> _selectedHoby() => registerC.selectedHoby
      .map(
        (element) => Container(
          margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
          decoration: BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.circular(5),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.shade200, blurRadius: 4, spreadRadius: 2)
              ]),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                // member.detail.fullName ?? '',
                element,
                style: GoogleFonts.poppins(color: Colors.white),
              ),
              SizedBox(width: 8),
              GestureDetector(
                onTap: () {
                  registerC.selectedHoby.removeWhere((hoby) => hoby == element);
                },
                child: Icon(
                  Feather.x,
                  color: Colors.white54,
                  size: 16,
                ),
              ),
            ],
          ),
        ),
      )
      .toList();

  Widget _accountIgInput() {
    return formInput(
      title: 'Akun Instagram',
      placeholder: 'Akun Instagram (opsional)',
      inputType: TextInputType.name,
      inputAction: TextInputAction.next,
      validator: (value) {
        if (value.split(' ').length > 1) {
          return 'Tidak boleh terdapat spasi';
        }
        return null;
      },
      controller: registerC.instagramFC,
    );
  }

  Widget _accountTwitterInput() {
    return formInput(
      title: 'Akun Twitter',
      placeholder: 'Akun Twitter (opsional)',
      inputType: TextInputType.name,
      inputAction: TextInputAction.next,
      validator: (value) {
        if (value.split(' ').length > 1) {
          return 'Tidak boleh terdapat spasi';
        }
        return null;
      },
      controller: registerC.twitterFC,
    );
  }

  Widget _btnNext() {
    return Container(
      width: Get.width / 1,
      height: 55,
      child: GetPlatform.isIOS
          ? CupertinoButton.filled(
              borderRadius: BorderRadius.circular(12),
              onPressed: () {
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
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            )
          : ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: AppColors.primaryColor, elevation: 0.1),
              onPressed: () => registerC.selectedImagePath.value == ""
                  ? registerC.onRegister()
                  : registerC.uploadImage(),
              child: Text(
                'Lanjutkan',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
    );
  }

  void _showBottomSheet(RegisterController controller) {
    Get.bottomSheet(
        SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(color: AppColors.lightGrey, width: 35, height: 4),
                SizedBox(height: 15),
                Text(
                  "Ganti Foto Profil",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                _listAction(
                    controller: controller, title: "Kamera", source: 'camera'),
                _listAction(
                    controller: controller, title: "Galeri", source: 'gallery'),
                controller.selectedImagePath.value != ""
                    ? _listAction(
                        controller: controller,
                        title: "Gunakan Foto Akun Google",
                        type: "delete")
                    : SizedBox(
                        height: 0,
                      ),
                SizedBox(height: 10),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 12),
                  color: AppColors.lightGrey,
                  height: 0.5,
                  width: Get.width,
                ),
                SizedBox(height: 10),
                _cancelAction(
                  icon: Feather.x,
                  title: "Batal",
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
      {required String title,
      required RegisterController controller,
      String? source,
      String? type}) {
    return InkWell(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
          minLeadingWidth: 0,
          title: Text(title),
        ),
      ),
      onTap: () {
        Get.back();
        type == "delete"
            ? controller.onDeleteImage()
            : controller.pickImage(source!);
      },
    );
  }

  Widget _cancelAction({IconData? icon, required String title}) {
    return InkWell(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
          minLeadingWidth: 0,
          title: Text(
            title,
            style: GoogleFonts.poppins(color: Colors.red.shade400),
          ),
        ),
      ),
      onTap: () {
        Get.back();
      },
    );
  }
}
