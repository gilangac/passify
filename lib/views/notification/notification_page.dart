// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, prefer_const_constructors_in_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:passify/constant/color_constant.dart';
import 'package:passify/controllers/notification/notification_controller.dart';
import 'package:passify/helpers/dialog_helper.dart';
import 'package:passify/services/service_timeago.dart';
import 'package:passify/widgets/general/app_bar.dart';
import 'package:get/get.dart';
import 'package:passify/widgets/general/circle_avatar.dart';
import 'package:intl/intl.dart';
import 'package:passify/widgets/general/slideable_panel.dart';

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
          // floatingActionButton: _fab(),
          // floatingActionButtonLocation:
          //     FloatingActionButtonLocation.miniCenterFloat,
        ));
  }

  PreferredSizeWidget _appBar() {
    return appBar(title: "Notifikasi", canBack: false);
  }

  Widget _fab() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 3,
              blurRadius: 3,
              offset: Offset(0, 1), // changes position of shadow
            ),
          ],
          borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          "Tandai telah terbaca",
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
              color: AppColors.tittleColor,
              fontSize: 10,
              fontWeight: FontWeight.w600),
        ),
      ),
    );
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
                              height: 150),
                          SizedBox(
                            height: 0,
                          ),
                          Text(
                            "Tidak ada data notifikasi",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                                color: AppColors.tittleColor,
                                fontSize: 14,
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
                    padding: EdgeInsets.only(bottom: 30),
                    physics: BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics()),
                    itemCount: notificationController.dataNotif.length,
                    itemBuilder: (context, index) {
                      var data = notificationController.dataNotif[index];
                      return Slidable(
                        enabled: true,
                        closeOnScroll: true,
                        endActionPane: ActionPane(
                          motion: ScrollMotion(),
                          children: [
                            SlidableActionCustom(
                              flex: 2,
                              spacing: 1,
                              onPressed: (context) {
                                DialogHelper.showConfirm(
                                    title: "Hapus Notifikasi",
                                    description:
                                        "Anda yakin akan menghapus notifikasi?",
                                    titlePrimary: "Hapus",
                                    titleSecondary: "Batal",
                                    action: () => notificationController
                                        .onDeleteNotif(data.idNotification));
                              },
                              autoClose: true,
                              backgroundColor: Color(0xFFFE4A49),
                              foregroundColor: Colors.white,
                              icon: Feather.trash,
                              label: 'Hapus',
                            ),
                            // SlidableActionCustom(
                            //   flex: 2,
                            //   spacing: 1,
                            //   onPressed: (context) {
                            //     data.readAt =
                            //         Timestamp.fromDate(DateTime.now());
                            //     notificationController
                            //         .onReadNotif(data.idNotification);
                            //   },
                            //   autoClose: true,
                            //   backgroundColor: Colors.grey,
                            //   foregroundColor: Colors.white,
                            //   icon: Feather.check,
                            //   label: 'Terbaca',
                            // ),
                          ],
                        ),
                        child: GestureDetector(
                          onTap: () => notificationController.onClickNotif(
                              data.idNotification.toString(),
                              data.code.toString(),
                              data.category!),
                          child: Container(
                            color: data.readAt == null
                                ? Colors.blue.shade50.withOpacity(0.6)
                                : Colors.transparent,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(right: 20, left: 20),
                              child: Column(
                                children: [
                                  Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: 10, top: 10),
                                      child: Container(
                                          width: Get.width,
                                          child:
                                              StreamBuilder<DocumentSnapshot>(
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
                                                        ConnectionState
                                                            .waiting) {
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
                                                                      .hasData
                                                                  ? snapshot
                                                                          .data!
                                                                          .get(
                                                                              "photoUser") ??
                                                                      ""
                                                                  : "",
                                                              nameData: snapshot
                                                                      .hasData
                                                                  ? snapshot
                                                                          .data!
                                                                          .get(
                                                                              "name") ??
                                                                      ""
                                                                  : "",
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
                                                                        text: snapshot.hasData
                                                                            ? snapshot.data!.get("name")
                                                                            : "",
                                                                        style: GoogleFonts.poppins(
                                                                            fontSize:
                                                                                12,
                                                                            color:
                                                                                Colors.black,
                                                                            fontWeight: FontWeight.w600),
                                                                      ),
                                                                      TextSpan(
                                                                        text:
                                                                            " ${messageNotif[data.category!]} ",
                                                                        style: GoogleFonts
                                                                            .poppins(
                                                                          fontSize:
                                                                              12,
                                                                          color:
                                                                              Colors.black,
                                                                        ),
                                                                      ),
                                                                      TextSpan(
                                                                        text: typeSnapshot.hasData
                                                                            ? typeSnapshot.data!.get(typeName[data.category!])
                                                                            : "",
                                                                        style: GoogleFonts.poppins(
                                                                            fontSize:
                                                                                12,
                                                                            color:
                                                                                Colors.black,
                                                                            fontWeight: FontWeight.w600),
                                                                      ),
                                                                    ]),
                                                              ),
                                                              Text(
                                                                TimeAgo.timeAgoSinceDate(DateFormat(
                                                                        "dd-MM-yyyy h:mma")
                                                                    .format(data
                                                                        .date!
                                                                        .toDate())),
                                                                style:
                                                                    GoogleFonts
                                                                        .poppins(
                                                                  fontSize: 10,
                                                                  color: Colors
                                                                      .grey
                                                                      .shade600,
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
                        ),
                      );
                    }),
              );
  }
}
