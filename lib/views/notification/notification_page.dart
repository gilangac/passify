// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:passify/widgets/general/app_bar.dart';
import 'package:get/get.dart';
import 'package:passify/widgets/general/circle_avatar.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: _body(),
      backgroundColor: Colors.white,
    );
  }

  PreferredSizeWidget _appBar() {
    return appBar(title: "Notifikasi", canBack: false);
  }

  Widget _body() {
    return ListView.builder(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.all(25),
        itemCount: 20,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Container(
              width: Get.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  circleAvatar(imageData: "", nameData: "A", size: 25),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Text(
                      "Ahmad Menyetujui permintaan anda bergabung ke komunitas “Madiun Bal-balan",
                      maxLines: 5,
                      style: GoogleFonts.poppins(
                          fontSize: 12, fontWeight: FontWeight.w400),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "19 Des 22",
                    style: GoogleFonts.poppins(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey),
                  )
                ],
              ),
            ),
          );
        });
  }
}
