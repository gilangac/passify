// ignore_for_file: prefer_const_constructors, must_be_immutable, unrelated_type_equality_checks

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:passify/constant/color_constant.dart';
import 'package:passify/controllers/profile/edit_profile_controller.dart';
import 'package:passify/widgets/general/bottomsheet_widget.dart';
import 'package:passify/widgets/general/circle_avatar.dart';
import 'package:passify/widgets/general/form_input.dart';

class EditProfilePage extends StatelessWidget {
  EditProfilePage({Key? key}) : super(key: key);
  EditProfileController editProfileC = Get.put(EditProfileController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _body(context),
        backgroundColor: Colors.white,
      ),
    );
  }

  Widget _body(BuildContext context) {
    return SafeArea(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [_actionBar(), _content(context)],
    ));
  }

  Widget _actionBar() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      alignment: Alignment.center,
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Container(
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.shade50,
                        blurRadius: 4,
                        spreadRadius: 6)
                  ],
                ),
                child: Icon(Feather.x, size: 24)),
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
              editProfileC.selectedImagePath != ''
                  ? editProfileC.uploadImage()
                  : editProfileC.onEditData();
            },
            child: Container(
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.shade50,
                        blurRadius: 4,
                        spreadRadius: 6)
                  ],
                ),
                child: Icon(Feather.check, size: 24)),
          ),
        ],
      ),
    );
  }

  Widget _content(BuildContext context) {
    return Obx(() => Expanded(
        child: editProfileC.isLoading
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: EdgeInsets.fromLTRB(30, 50, 30, 30),
                child: Form(
                  key: editProfileC.formKeyEditProfile,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _photoProfile(),
                      SizedBox(
                        height: 50,
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
                    ],
                  ),
                ),
              )));
  }

  Widget _photoProfile() {
    return GestureDetector(
      onTap: () {
        _showBottomSheet(editProfileC);
      },
      child: Stack(
        children: [
          editProfileC.selectedImagePath.value == ''
              ? circleAvatar(
                  imageData: editProfileC.dataUser[0].photo,
                  nameData:
                      (editProfileC.dataUser[0].name.toString()).toString(),
                  size: 50)
              : CircleAvatar(
                  backgroundImage:
                      FileImage(File(editProfileC.selectedImagePath.value)),
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
      ),
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
      controller: editProfileC.usernameFC
        ..text = editProfileC.dataUser[0].username.toString(),
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
      controller: editProfileC.nameFC
        ..text = editProfileC.dataUser[0].name.toString(),
    );
  }

  Widget _provinceInput() {
    return GestureDetector(
      child: formInput(
        suffix: true,
        enabled: false,
        title: 'Provinsi Tempat Tinggal',
        placeholder: 'Provinsi Tempat Tinggal',
        inputType: TextInputType.name,
        inputAction: TextInputAction.next,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Masukkan provinsi tempat tinggal terlebih dahulu';
          }
          return null;
        },
        controller: editProfileC.provinsiFC
          ..text = editProfileC.dataUser[0].provinsi.toString(),
      ),
      onTap: () {
        editProfileC.dataProvinsi.isNotEmpty
            ? BottomSheetList(
                ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: editProfileC.dataProvinsi.length,
                    padding: EdgeInsets.all(15),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          editProfileC.provinsiFC.text =
                              editProfileC.dataProvinsi[index].nama.toString();
                          editProfileC.cityFC.text = '';
                          editProfileC.cityFC.clear();
                          editProfileC.dataCity.clear();
                          editProfileC.onGetCity(
                              editProfileC.dataProvinsi[index].id.toString());
                          Get.back();
                        },
                        child: Container(
                          margin: EdgeInsets.only(bottom: 15),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                editProfileC.dataProvinsi[index].nama
                                    .toString(),
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
            : editProfileC.onGetProvince();
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
        controller: editProfileC.cityFC
          ..text = editProfileC.dataUser[0].city.toString(),
      ),
      onTap: () {
        editProfileC.dataCity.isNotEmpty
            ? BottomSheetList(
                ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: editProfileC.dataCity.length,
                    padding: EdgeInsets.all(15),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          editProfileC.cityFC.text =
                              editProfileC.dataCity[index].nama.toString();
                          Get.back();
                        },
                        child: Container(
                          margin: EdgeInsets.only(bottom: 15),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                editProfileC.dataCity[index].nama.toString(),
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
            placeholder: editProfileC.selectedHoby.isNotEmpty
                ? 'Tambah Hobi (maksimal 3)'
                : 'Pilih Hobi',
            inputType: TextInputType.name,
            inputAction: TextInputAction.next,
            validator: (value) {
              if (editProfileC.selectedHoby.isEmpty) {
                return 'Masukkan hobi terlebih dahulu';
              }
              return null;
            },
            controller: editProfileC.hobbyFC,
          ),
          onTap: () {
            editProfileC.dataHobies.isNotEmpty
                ? editProfileC.selectedHoby.length < 3
                    ? BottomSheetList(
                        ListView.builder(
                            physics: BouncingScrollPhysics(),
                            itemCount: editProfileC.dataHobies.length,
                            padding: EdgeInsets.symmetric(vertical: 15),
                            itemBuilder: (context, index) {
                              return InkWell(
                                borderRadius: BorderRadius.circular(15),
                                highlightColor: Colors.grey.shade200,
                                splashColor: Colors.grey.shade200,
                                onTap: () => editProfileC.onSelectHoby(index),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Text(
                                        editProfileC.dataHobies[index]['name']
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
                : editProfileC.onReadJson();
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

  List<Widget> _selectedHoby() => editProfileC.selectedHoby
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
                  editProfileC.selectedHoby
                      .removeWhere((hoby) => hoby == element);
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
      controller: editProfileC.instagramFC
        ..text = editProfileC.dataUser[0].instagram.toString(),
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
      controller: editProfileC.twitterFC
        ..text = editProfileC.dataUser[0].twitter.toString(),
    );
  }

  void _showBottomSheet(EditProfileController controller) {
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
                controller.dataUser[0].photo != ""
                    ? _listAction(
                        controller: controller,
                        title: "Hapus Foto Profil",
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
      required EditProfileController controller,
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
