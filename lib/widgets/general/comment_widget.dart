// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:passify/constant/color_constant.dart';
import 'package:passify/routes/pages.dart';
import 'package:passify/services/service_additional.dart';
import 'package:passify/widgets/general/circle_avatar.dart';
import 'package:passify/widgets/general/dotted_separator.dart';
import 'package:intl/intl.dart';

Widget commentWidget(
    {String? nama,
    String? photo,
    String? username,
    String? idUser,
    String? comment,
    int? sort,
    Timestamp? date}) {
  return Container(
    width: Get.width,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(5),
      color: sort == 0
          ? Colors.grey.shade400.withOpacity(0.5)
          : Colors.transparent,
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => Get.toNamed(AppPages.PROFILE_PERSON + idUser.toString(),
              arguments: idUser.toString()),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              circleAvatar(
                  imageData: photo ?? "", nameData: nama ?? "G", size: 20),
              SizedBox(
                width: 10,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    nama ?? 'Taesei Marukawa',
                    style: GoogleFonts.poppins(
                        color: AppColors.tittleColor,
                        height: 1.2,
                        fontSize: 14,
                        fontWeight: FontWeight.w600),
                  ),
                  Row(
                    children: [
                      Text(
                        username ?? 'marukawa',
                        style: GoogleFonts.poppins(
                            height: 1.2,
                            color: Colors.grey.shade500,
                            fontStyle: FontStyle.normal,
                            fontSize: 12,
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
                        TimeAgo.timeAgoSinceDate(DateFormat("dd-MM-yyyy h:mma")
                            .format(date!.toDate())),
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Text(
          comment ??
              "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer",
          style: GoogleFonts.poppins(
              color: AppColors.tittleColor,
              fontSize: 12,
              fontWeight: FontWeight.w400),
          textAlign: TextAlign.justify,
        ),
        dotSeparator(
          color: Colors.grey.shade400,
        ),
      ],
    ),
  );
}
