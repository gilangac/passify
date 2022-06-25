// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:passify/constant/color_constant.dart';

class BottomSheetHelper {
  static successReport() {
    Get.bottomSheet(
      SafeArea(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Container(
            height: 500,
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      LottieBuilder.asset("assets/json/lottie_success.json",
                          height: 300),
                      Text(
                        "Laporan berhasil terkirim",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                            color: AppColors.tittleColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                      ),
                      Text(
                        "Terimakasih telah membantu kami untuk melaporkan aktivitas pelanggaran, laporkan kembali jika terdapat aktivitas pelanggaran lainnya!",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                            color: Colors.grey.shade400,
                            fontSize: 12,
                            fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: AppColors.primaryColor, elevation: 0.5),
                        onPressed: () {
                          Get.back();
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 70),
                          child: Text(
                            "Kembali",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      isDismissible: true,
      enableDrag: true,
      isScrollControlled: true,
    );
  }

  static successDissable() {
    Get.bottomSheet(
      SafeArea(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Container(
            height: 280,
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Pemberitahuan",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                            color: AppColors.tittleColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Text(
                        "Maaf, akun anda dinonaktifkan sementara karena terjadi penyalahgunaan dalam aplikasi.",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                            color: Colors.grey.shade400,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: 80,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: AppColors.primaryColor, elevation: 0.5),
                        onPressed: () {
                          Get.back();
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 70),
                          child: Text(
                            "Kembali",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      isDismissible: true,
      enableDrag: true,
      isScrollControlled: true,
    );
  }
}

class BottomsheetEvent extends StatelessWidget {
  const BottomsheetEvent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => bottomsheetEvent(),
      child: FloatingActionButton(
        onPressed: () => bottomsheetEvent(),
        child: Icon(
          Icons.add,
          color: AppColors.primaryColor,
          size: 29,
        ),
        backgroundColor: Colors.white,
        elevation: 2,
        splashColor: Colors.grey,
      ),
    );
  }
}

void bottomsheetEvent() {
  Get.bottomSheet(
    SafeArea(
      child: Padding(
        padding: EdgeInsets.all(10),
        child: SizedBox(
          height: Get.height * 0.92,
          child: Column(
            children: [
              _actionBar(),
              Expanded(
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 20),
                      _formNameEvent(),
                      _formEventLocation(),
                      _formEventDate(),
                      _formEventTime(),
                      _formEventDesc(),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20))),
    isDismissible: false,
    enableDrag: false,
    isScrollControlled: true,
  );
}

Widget _formNameEvent() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    child: TextFormField(
      onChanged: (text) => {},
      keyboardType: TextInputType.name,
      textInputAction: TextInputAction.next,
      enabled: true,
      decoration: InputDecoration(hintText: "Nama Event"),
      autovalidateMode: AutovalidateMode.onUserInteraction,
    ),
  );
}

Widget _formEventLocation() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    child: TextFormField(
      onChanged: (text) => {},
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      enabled: true,
      decoration: InputDecoration(hintText: "Lokasi"),
      autovalidateMode: AutovalidateMode.onUserInteraction,
    ),
  );
}

Widget _formEventDate() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    child: TextFormField(
      onChanged: (text) => {},
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      enabled: true,
      decoration: InputDecoration(hintText: "Tanggal"),
      autovalidateMode: AutovalidateMode.onUserInteraction,
    ),
  );
}

Widget _formEventTime() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    child: TextFormField(
      onChanged: (text) => {},
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      enabled: true,
      decoration: InputDecoration(hintText: "Waktu"),
      autovalidateMode: AutovalidateMode.onUserInteraction,
    ),
  );
}

Widget _formEventDesc() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    child: TextFormField(
      onChanged: (text) => {},
      keyboardType: TextInputType.text,
      maxLines: 6,
      minLines: 5,
      textInputAction: TextInputAction.done,
      enabled: true,
      decoration: InputDecoration(hintText: "Deskripsi"),
      autovalidateMode: AutovalidateMode.onUserInteraction,
    ),
  );
}

Widget _actionBar() {
  return Container(
    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
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
                      color: Colors.grey.shade100,
                      blurRadius: 4,
                      spreadRadius: 6)
                ],
              ),
              child: Icon(Feather.x, size: 24)),
        ),
        Spacer(),
        Text(
          "Tambah Event",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Spacer(),
        GestureDetector(
          onTap: () {},
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
