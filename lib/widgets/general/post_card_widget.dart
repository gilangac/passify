// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:passify/constant/color_constant.dart';
import 'package:passify/controllers/forum/detail_community_controller.dart';
import 'package:passify/helpers/dialog_helper.dart';
import 'package:passify/routes/pages.dart';
import 'package:passify/services/service_timeago.dart';
import 'package:share_plus/share_plus.dart';
import 'circle_avatar.dart';
import 'package:intl/intl.dart';
import 'package:hashtagable/hashtagable.dart';

DetailCommunityController controller = Get.find();

Widget postCard(
    {String? idPost,
    String? title,
    String? price,
    String? status,
    String? name,
    String? idUser,
    required String idCommunity,
    String? username,
    String? caption,
    String? photo,
    String? photoUser,
    String? category,
    String? number,
    DateTime? date,
    bool isFromForum = false,
    int? comment}) {
  NumberFormat currencyFormatter = NumberFormat.currency(
    locale: 'id',
    symbol: "Rp ",
    decimalDigits: 0,
  );
  return Container(
      margin: EdgeInsets.only(bottom: 20),
      width: Get.width,
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 2,
              offset: Offset(0, 0), // changes position of shadow
            ),
          ],
          borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // StreamBuilder<DocumentSnapshot>(
            //     stream: FirebaseFirestore.instance
            //         .collection('communities')
            //         .doc(idCommunity)
            //         .snapshots(),
            //     builder: (context, snapshot) {
            //       return Column(
            //           mainAxisAlignment: MainAxisAlignment.start,
            //           crossAxisAlignment: CrossAxisAlignment.start,
            //           children: [
            //             Text(
            //               snapshot.data!.get("name").toString(),
            //               maxLines: 2,
            //               overflow: TextOverflow.ellipsis,
            //               style: GoogleFonts.poppins(
            //                   height: 1,
            //                   fontSize: 14,
            //                   fontWeight: FontWeight.w600),
            //             ),
            //             Divider(
            //               height: 15,
            //               thickness: 2,
            //               color: Colors.grey.shade300,
            //             )
            //           ]);
            //     }),
            isFromForum
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        Text(
                          idCommunity,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                              height: 1,
                              fontSize: 14,
                              color: Colors.grey.shade400,
                              fontWeight: FontWeight.w400),
                        ),
                        Divider(
                          height: 15,
                          thickness: 2,
                          color: Colors.grey.shade200,
                        )
                      ])
                : SizedBox(),
            GestureDetector(
              onTap: () => Get.toNamed(
                  AppPages.PROFILE_PERSON + idUser.toString(),
                  arguments: idUser.toString()),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  circleAvatar(
                      imageData: photoUser ?? "",
                      nameData: name ?? "Gilang",
                      size: 17),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    width: Get.width * 0.55,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name ?? "",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                              height: 1,
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                        ),
                        Row(
                          children: [
                            Text(
                              username ?? "",
                              overflow: TextOverflow.clip,
                              style: GoogleFonts.poppins(
                                  color: Colors.grey.shade600,
                                  height: 1.5,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w400),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 5),
                              height: 3,
                              width: 3,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.grey),
                            ),
                            Text(
                                TimeAgo2.timeAgoSinceDate(
                                    DateFormat("dd-MM-yyyy h:mma")
                                        .format(date!)),
                                overflow: TextOverflow.clip,
                                style: GoogleFonts.poppins(
                                    color: Colors.grey.shade600,
                                    height: 1.5,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w400)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  isFromForum
                      ? SizedBox()
                      : Container(
                          alignment: Alignment.topRight,
                          child: GestureDetector(
                              onTap: () => _bottomSheetContent(idUser, idPost!),
                              child: Icon(Feather.more_horizontal)))
                ],
              ),
            ),
            category == 'fjb'
                ? Row(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 8,
                          ),
                          Row(
                            // mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                title ?? "",
                                style: GoogleFonts.poppins(
                                    color: AppColors.tittleColor,
                                    height: 1.5,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600),
                                textAlign: TextAlign.justify,
                                maxLines: photo == "" ? 5 : 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 5),
                                alignment: Alignment.center,
                                width: 3,
                                height: 3,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              Text(
                                status == "available" ? "Tersedia" : "Terjual",
                                style: GoogleFonts.poppins(
                                    color: Colors.grey.shade600,
                                    height: 1.5,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400),
                                textAlign: TextAlign.justify,
                                maxLines: photo == "" ? 5 : 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                          Text(
                            currencyFormatter.format(int.parse(price!)),
                            style: GoogleFonts.poppins(
                                color: Colors.grey.shade600,
                                height: 1.5,
                                fontSize: 11,
                                fontWeight: FontWeight.w400),
                            textAlign: TextAlign.justify,
                            maxLines: photo == "" ? 5 : 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      Spacer(),
                      number == ""
                          ? Container()
                          : GestureDetector(
                              onTap: () => controller.onLaunchUrl(number!),
                              child: Container(
                                height: 27,
                                width: 27,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(9),
                                  color: AppColors.green,
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.green.shade100,
                                        blurRadius: 4,
                                        spreadRadius: 2)
                                  ],
                                ),
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Icon(FontAwesome.whatsapp,
                                        color: Colors.white, size: 15),
                                  ),
                                ),
                              ),
                            )
                    ],
                  )
                : Container(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          title ?? "",
                          style: GoogleFonts.poppins(
                              color: AppColors.tittleColor,
                              height: 1.5,
                              fontSize: 12,
                              fontWeight: FontWeight.w600),
                          textAlign: TextAlign.justify,
                          maxLines: photo == "" ? 5 : 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
            SizedBox(
              height: 8,
            ),
            HashTagText(
              text: caption ?? "",
              decoratedStyle: GoogleFonts.poppins(
                  color: Colors.blue.shade700,
                  height: 1.5,
                  fontSize: 11,
                  fontWeight: FontWeight.w400),
              basicStyle: GoogleFonts.poppins(
                  color: Colors.grey.shade600,
                  height: 1.5,
                  fontSize: 11,
                  fontWeight: FontWeight.w400),
              onTap: (text) {
                print(text);
              },
              softWrap: true,
              maxLines: photo == "" ? 5 : 3,
              overflow: TextOverflow.ellipsis,
            ),
            // Text(
            //   caption ?? "",
            //   style: GoogleFonts.poppins(
            //       color: Colors.grey.shade600,
            //       height: 1.5,
            //       fontSize: 11,
            //       fontWeight: FontWeight.w400),
            //   textAlign: TextAlign.justify,
            //   maxLines: photo == "" ? 5 : 3,
            //   overflow: TextOverflow.ellipsis,
            // ),
            SizedBox(
              height: 10,
            ),
            photo == ""
                ? SizedBox(
                    height: 0,
                  )
                : Column(
                    children: [
                      Container(
                        height: Get.height * 0.2,
                        width: Get.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: CachedNetworkImage(
                            imageUrl: photo.toString(),
                            width: Get.width,
                            fit: BoxFit.cover,
                            errorWidget: (context, url, error) =>
                                Center(child: Icon(Icons.error)),
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
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                    ],
                  ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey.shade100),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Get.toNamed(AppPages.DETAIL_POST + idPost.toString(),
                              arguments: idPost);
                        },
                        child: Container(
                          child: Center(
                              child: SvgPicture.asset(
                            "assets/svg/icon_comment.svg",
                            height: 19,
                            color: Colors.grey.shade400,
                          )),
                        ),
                      ),
                      SizedBox(
                        width: 3,
                      ),
                      Text(
                        '$comment',
                        style: GoogleFonts.poppins(
                            color: Colors.grey.shade400,
                            fontSize: 12,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                GestureDetector(
                  onTap: () async {
                    String url = await AppUtils.buildDynamicLink(
                        idPost!, title!, caption!, photo!, "post");
                    Share.share('${url}');
                  },
                  child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey.shade100),
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      child: SvgPicture.asset("assets/svg/icon_share.svg",
                          color: Colors.grey.shade400, height: 19)),
                ),
                Spacer(),
                GestureDetector(
                  onTap: () {
                    Get.toNamed(AppPages.DETAIL_POST + idPost.toString(),
                        arguments: idPost);
                  },
                  child: Container(
                    child: Text(
                      'Lihat Detail',
                      style: GoogleFonts.poppins(
                          fontSize: 11, fontWeight: FontWeight.w600),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ));
}

void _bottomSheetContent(var idUser, String idPost) {
  String myId = controller.myAccountId.value;
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
                      _listAction(
                          title: "Laporkan",
                          idPost: idPost,
                          type: "report",
                          path: AppPages.EDIT_PROFILE),
                      myId == idUser
                          ? Column(
                              children: [
                                Divider(
                                  height: 1,
                                  color: Colors.grey.shade300,
                                ),
                                _listAction(
                                    title: "Edit Postingan",
                                    idPost: idPost,
                                    path: AppPages.HOME,
                                    type: "edit"),
                                Divider(
                                  height: 1,
                                  color: Colors.grey.shade300,
                                ),
                                _deleteAction(
                                    title: "Edit Postingan",
                                    path: AppPages.HOME,
                                    idPost: idPost),
                              ],
                            )
                          : SizedBox(
                              height: 0,
                            ),
                    ],
                  )),
              SizedBox(height: 13),
              _cancelAction()
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
    required String path,
    required String idPost,
    String? type}) {
  return Container(
    width: Get.width,
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () {
          Get.back();
          if (type == 'edit') {
            Get.toNamed(AppPages.EDIT_POST + Get.arguments.toString(),
                arguments: [idPost, "community"]);
          } else if (type == 'report') {
            DialogHelper.showConfirm(
                title: "Laporkan Postingan",
                description: "Apakah anda yakin akan melaporkan postingan ini?",
                action: () => controller.onReportPost(idPost),
                titlePrimary: "Laporkan",
                titleSecondary: "Batal");
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          child: Text(
            title,
            style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: AppColors.textColor),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    ),
  );
}

Widget _deleteAction({String? title, String? path, required idPost}) {
  return Container(
    width: Get.width,
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () {
          controller.onConfirmDelete(idPost);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          child: Text(
            "Hapus Postingan",
            style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Colors.red.shade500),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    ),
  );
}

Widget _cancelAction() {
  return Container(
    width: Get.width,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10), color: Colors.grey.shade100),
    child: Material(
      child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () => Get.back(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            child: Text(
              'Batal',
              style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textColor),
              textAlign: TextAlign.center,
            ),
          )),
      color: Colors.transparent,
    ),
  );
}
