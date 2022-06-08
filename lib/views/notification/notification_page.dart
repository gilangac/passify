// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:passify/constant/color_constant.dart';
import 'package:passify/controllers/notification/notification_controller.dart';
import 'package:passify/widgets/general/app_bar.dart';
import 'package:get/get.dart';
import 'package:passify/widgets/general/circle_avatar.dart';

class NotificationPage extends StatelessWidget {
  NotificationPage({Key? key}) : super(key: key);
  NotificationController notificationController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          appBar: _appBar(),
          body: _body(),
          backgroundColor: Colors.white,
        ));
  }

  PreferredSizeWidget _appBar() {
    return appBar(title: "Notifikasi", canBack: false);
  }

  Widget _body() {
    return notificationController.isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : notificationController.dataNotif.isEmpty
            ? RefreshIndicator(
                onRefresh: () {
                  HapticFeedback.lightImpact();
                  return notificationController.onGetData();
                },
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  child: Center(
                    child: Container(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 150,
                          ),
                          LottieBuilder.asset("assets/json/empty_data.json",
                              height: 180),
                          SizedBox(
                            height: 0,
                          ),
                          Text(
                            "Tidak ada data notifikasi",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                                color: AppColors.tittleColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w600),
                          ),
                          Container(height: 300)
                        ],
                      ),
                    ),
                  ),
                ),
              )
            : RefreshIndicator(
                onRefresh: () {
                  HapticFeedback.lightImpact();
                  return notificationController.onGetData();
                },
                child: ListView.builder(
                    physics: BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics()),
                    padding: EdgeInsets.all(25),
                    itemCount: notificationController.dataNotif.length,
                    itemBuilder: (context, index) {
                      var data = notificationController.dataNotif[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Container(
                          width: Get.width,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              circleAvatar(
                                  imageData: "", nameData: "A", size: 25),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: Text(
                                  "Ahmad Menyetujui permintaan anda bergabung ke komunitas “Madiun Bal-balan",
                                  maxLines: 5,
                                  style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400),
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
                    }),
              );
  }
}
