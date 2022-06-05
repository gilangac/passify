// ignore_for_file: must_be_immutable, prefer_const_constructors, sized_box_for_whitespace

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:passify/constant/color_constant.dart';
import 'package:passify/controllers/forum/edit_post_controller.dart';
import 'package:passify/widgets/general/app_bar.dart';

class EditPostPage extends StatelessWidget {
  EditPostPage({Key? key}) : super(key: key);
  EditPostController editPostC = Get.put(EditPostController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: _body(),
      backgroundColor: Colors.white,
    );
  }

  PreferredSizeWidget _appBar() {
    return appBar(title: "Edit Postingan");
  }

  Widget _body() {
    return Obx(() => editPostC.isLoading.value
        ? Center(
            child: CircularProgressIndicator(),
          )
        : SingleChildScrollView(
            physics:
                BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            child: Form(
              key: editPostC.formKeyEdit,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 20),
                  _bannerImage(),
                  _formTitle(),
                  _formPrice(),
                  _formNoHp(),
                  _formCaption(),
                  SizedBox(height: 15),
                  _btnSaveEdit(),
                  SizedBox(height: 200),
                ],
              ),
            ),
          ));
  }

  Widget _bannerImage() {
    return Obx(() => Column(
          children: [
            GestureDetector(
              onTap: (() => editPostC.pickImage()),
              child: Container(
                height: Get.height * 0.25,
                width: Get.width,
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12)),
                child: editPostC.selectedImagePath.value == ''
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: CachedNetworkImage(
                          imageUrl: editPostC.dataPost[0].photo.toString(),
                          width: Get.width,
                          fit: BoxFit.cover,
                          errorWidget: (context, url, error) => Center(
                              child: Icon(
                            Feather.camera,
                            color: Colors.grey.shade400,
                            size: 28,
                          )),
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) => Container(
                            color: Colors.white,
                            child: Center(
                              child: CircularProgressIndicator(
                                value: downloadProgress.progress,
                                color: AppColors.primaryColor,
                                strokeWidth: 2,
                              ),
                            ),
                          ),
                        ),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Stack(
                          children: [
                            Image(
                              image: FileImage(
                                  File(editPostC.selectedImagePath.value)),
                              fit: BoxFit.cover,
                              height: Get.height * 0.25,
                              width: Get.width,
                            ),
                            Positioned(
                                top: 5,
                                right: 5,
                                child: GestureDetector(
                                  onTap: () {
                                    editPostC.selectedImagePath.value = '';
                                    editPostC.urlImage.value = '';
                                  },
                                  child: Container(
                                    width: 30,
                                    height: 30,
                                    margin: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(8)),
                                    child: Icon(
                                      Feather.trash,
                                      size: 20,
                                      color: Colors.black38,
                                    ),
                                  ),
                                ))
                          ],
                        ),
                      ),
              ),
            ),
            editPostC.dataPost[0].photo != ""
                ? GestureDetector(
                    onTap: () => editPostC.onDeleteImage(),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Hapus Foto",
                        style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.primaryColor),
                      ),
                    ),
                  )
                : SizedBox(
                    height: 0,
                  ),
          ],
        ));
  }

  Widget _formTitle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: TextFormField(
        onChanged: (text) => {},
        keyboardType: TextInputType.name,
        textInputAction: TextInputAction.next,
        enabled: true,
        decoration:
            InputDecoration(hintText: "Judul", fillColor: Colors.grey.shade100),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Masukkan judul dahulu';
          }
          return null;
        },
        controller: editPostC.titleFC
          ..text = editPostC.dataPost[0].title.toString(),
      ),
    );
  }

  Widget _formCaption() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: TextFormField(
        onChanged: (text) => {},
        keyboardType: TextInputType.name,
        textInputAction: TextInputAction.newline,
        enabled: true,
        maxLines: 6,
        minLines: 5,
        decoration: InputDecoration(
            hintText: "Masukkan caption...", fillColor: Colors.grey.shade100),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Masukkan caption dahulu';
          }
          return null;
        },
        controller: editPostC.captionFC
          ..text = editPostC.dataPost[0].caption.toString(),
      ),
    );
  }

  Widget _formPrice() {
    return editPostC.isDiscusion.value
        ? SizedBox()
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: TextFormField(
                onChanged: (text) => {},
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                enabled: true,
                decoration: InputDecoration(
                    hintText: "Harga", fillColor: Colors.grey.shade100),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan harga terlebih dahulu';
                  }
                  return null;
                },
                controller: editPostC.priceFC
                  ..text = editPostC.dataPost[0].price.toString()),
          );
  }

  Widget _formNoHp() {
    return editPostC.isDiscusion.value
        ? SizedBox()
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: TextFormField(
                onChanged: (text) => {},
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                enabled: true,
                decoration: InputDecoration(
                    hintText: "Nomor Whatsapp (Opsional)",
                    fillColor: Colors.grey.shade100),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: editPostC.noHpFC
                  ..text = editPostC.dataPost[0].noHp.toString()),
          );
  }

  Widget _btnSaveEdit() {
    return Container(
      width: Get.width * 0.6,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            primary: AppColors.primaryColor, elevation: 0.5),
        onPressed: () => editPostC.onPrepareEditePost(),
        child: Center(
          child: Text(
            'Simpan',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
