// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, prefer_const_constructors_in_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:passify/constant/color_constant.dart';
import 'package:passify/controllers/notification/notification_controller.dart';
import 'package:passify/services/service_timeago.dart';
import 'package:passify/widgets/general/app_bar.dart';
import 'package:get/get.dart';
import 'package:passify/widgets/general/circle_avatar.dart';
import 'package:intl/intl.dart';

class NotificationPage extends StatelessWidget {
  NotificationPage({Key? key}) : super(key: key);
  NotificationController notificationController = Get.find();

  List messageNotif = [
    "meminta bergabung dengan komunitas ",
    "menyetujui permintaan anda bergabung dengan komunitas ",
    "mengomentari postingan anda",
    "juga mengomentari postingan ",
    "membuat postingan baru di komunitas ",
    "mengomentari event ",
    "juga mengikuti event "
  ];
  List typeCode = [
    "communities",
    "communities",
    "post",
    "post",
    "post",
    "events",
    "events"
  ];
  List typeName = [
    "name",
    "name",
    "title",
    "title",
    "title",
    "name",
    "name",
  ];

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
                    itemCount: notificationController.dataNotif.length,
                    itemBuilder: (context, index) {
                      var data = notificationController.dataNotif[index];
                      return GestureDetector(
                        onTap: () => notificationController.onClickNotif(
                            data.idNotification.toString(),
                            data.code.toString(),
                            data.category!),
                        child: Container(
                          color: data.readAt == null
                              ? Colors.blue.shade50.withOpacity(0.6)
                              : Colors.transparent,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 20, left: 20),
                            child: Column(
                              children: [
                                Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 10, top: 10),
                                    child: Container(
                                        width: Get.width,
                                        child: StreamBuilder<DocumentSnapshot>(
                                          stream: FirebaseFirestore.instance
                                              .collection('users')
                                              .doc(data.idFromUser)
                                              .snapshots(),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return SizedBox();
                                            } else {
                                              return StreamBuilder<
                                                  DocumentSnapshot>(
                                                stream: FirebaseFirestore
                                                    .instance
                                                    .collection(typeCode[
                                                        data.category!])
                                                    .doc(data.code)
                                                    .snapshots(),
                                                builder:
                                                    (context, typeSnapshot) {
                                                  if (typeSnapshot
                                                          .connectionState ==
                                                      ConnectionState.waiting) {
                                                    return SizedBox();
                                                  } else {
                                                    return Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        circleAvatar(
                                                            imageData: snapshot
                                                                    .data!
                                                                    .get(
                                                                        "photoUser") ??
                                                                "",
                                                            nameData: snapshot
                                                                    .data!
                                                                    .get(
                                                                        "name") ??
                                                                "",
                                                            size: 28),
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                        Expanded(
                                                            child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            RichText(
                                                              text: TextSpan(
                                                                  children: [
                                                                    TextSpan(
                                                                      text: snapshot
                                                                          .data!
                                                                          .get(
                                                                              "name"),
                                                                      style: GoogleFonts.poppins(
                                                                          fontSize:
                                                                              12,
                                                                          color: Colors
                                                                              .black,
                                                                          fontWeight:
                                                                              FontWeight.w600),
                                                                    ),
                                                                    TextSpan(
                                                                      text:
                                                                          " ${messageNotif[data.category!]} ",
                                                                      style: GoogleFonts
                                                                          .poppins(
                                                                        fontSize:
                                                                            12,
                                                                        color: Colors
                                                                            .black,
                                                                      ),
                                                                    ),
                                                                    TextSpan(
                                                                      text: typeSnapshot
                                                                          .data!
                                                                          .get(typeName[
                                                                              data.category!]),
                                                                      style: GoogleFonts.poppins(
                                                                          fontSize:
                                                                              12,
                                                                          color: Colors
                                                                              .black,
                                                                          fontWeight:
                                                                              FontWeight.w600),
                                                                    ),
                                                                  ]),
                                                            ),
                                                            Text(
                                                              TimeAgo.timeAgoSinceDate(
                                                                  DateFormat(
                                                                          "dd-MM-yyyy h:mma")
                                                                      .format(data
                                                                          .date!
                                                                          .toDate())),
                                                              style: GoogleFonts
                                                                  .poppins(
                                                                fontSize: 10,
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                            ),
                                                          ],
                                                        )),
                                                        // Expanded(
                                                        //   child: Text(
                                                        //     "Ahmad Menyetujui permintaan anda bergabung ke komunitas “Madiun Bal-balan",
                                                        //     maxLines: 5,
                                                        //     style: GoogleFonts.poppins(
                                                        //         fontSize: 12,
                                                        //         fontWeight: FontWeight.w400),
                                                        //   ),
                                                        // ),
                                                        // SizedBox(
                                                        //   width: 10,
                                                        // ),
                                                        // Text(
                                                        //   "19 Des 22",
                                                        //   style: GoogleFonts.poppins(
                                                        //       fontSize: 10,
                                                        //       fontWeight: FontWeight.w500,
                                                        //       color: Colors.grey),
                                                        // )
                                                      ],
                                                    );
                                                  }
                                                },
                                              );
                                            }
                                          },
                                        ))),
                                Divider(
                                  height: 0.5,
                                  color: Colors.grey.shade200,
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
              );
  }
}
