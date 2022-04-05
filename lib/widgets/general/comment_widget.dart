// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:passify/constant/color_constant.dart';
import 'package:passify/widgets/general/circle_avatar.dart';
import 'package:passify/widgets/general/dotted_separator.dart';

Widget commentWidget(
    {String? nama, String? photo, String? username, String? comment}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          circleAvatar(imageData: photo ?? "", nameData: nama ?? "G", size: 20),
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
              Text(
                username ?? 'marukawa',
                style: GoogleFonts.poppins(
                    height: 1.2,
                    color: Colors.grey.shade500,
                    fontStyle: FontStyle.normal,
                    fontSize: 12,
                    fontWeight: FontWeight.w400),
              ),
            ],
          ),
        ],
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
      )
    ],
  );
}
