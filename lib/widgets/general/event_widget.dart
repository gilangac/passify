// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:passify/constant/color_constant.dart';
import 'package:passify/controllers/forum/event_controller.dart';
import 'package:passify/routes/pages.dart';
import 'package:passify/services/service_additional.dart';
import 'package:share_plus/share_plus.dart';

EventController eventC = Get.find();
Widget eventCard(
    {String? idEvent,
    String? name,
    String? location,
    String? date,
    String? time,
    String? category,
    String? description,
    String? membersCount,
    String? commentCount}) {
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
    child: Stack(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      name ?? "Fun Football Madiun",
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                          fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Container(
                    color: Colors.transparent,
                    width: 75,
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 80,
                child: Row(
                  children: [
                    Stack(
                      children: [
                        Container(
                          height: 80,
                          width: 70,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  width: 1, color: AppColors.primaryColor)),
                        ),
                        Positioned(
                            top: 0,
                            left: 0,
                            right: 0,
                            child: ClipRRect(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10)),
                              child: Container(
                                color: AppColors.primaryColor,
                                width: 70,
                                height: 25,
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: Text(
                                      ((date?.split(" ")[2]).toString())
                                          .substring(0, 3)
                                          .toUpperCase(),
                                      style: GoogleFonts.poppins(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            )),
                        Positioned(
                            bottom: 2,
                            left: 0,
                            right: 0,
                            child: Container(
                              height: 50,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    (date?.split(" ")[1]).toString(),
                                    style: GoogleFonts.poppins(
                                        fontSize: 32,
                                        height: 1,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.primaryColor),
                                  ),
                                  Text(
                                    (date?.split(" ")[3]).toString(),
                                    style: GoogleFonts.poppins(
                                        fontSize: 13,
                                        height: 0.8,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.primaryColor),
                                  ),
                                ],
                              ),
                            ))
                      ],
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Feather.map_pin,
                                color: AppColors.primaryColor,
                                size: 13,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Container(
                                width: Get.width * 0.5,
                                child: Text(
                                  location ?? "GOR Wilis Madiun",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Feather.calendar,
                                color: AppColors.primaryColor,
                                size: 13,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Container(
                                width: Get.width * 0.5,
                                child: Text(
                                  date ?? "18 Februari 2022",
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Feather.clock,
                                color: AppColors.primaryColor,
                                size: 13,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Container(
                                width: Get.width * 0.5,
                                child: Text(
                                  time ?? " 12.00 WIB - 14.00 WIB",
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Feather.users,
                                color: AppColors.primaryColor,
                                size: 13,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Row(
                                children: [
                                  Text(
                                    membersCount ?? "0",
                                    style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  Container(
                                    width: Get.width * 0.4,
                                    child: Text(
                                      " Partisipan",
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 15,
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
                            Get.toNamed(
                                AppPages.DETAIL_EVENT + idEvent.toString(),
                                arguments: idEvent);
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
                          '$commentCount',
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
                          idEvent!, name!, description!, "", "event");
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
                      Get.toNamed(AppPages.DETAIL_EVENT + idEvent.toString(),
                          arguments: idEvent);
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
        ),
        Positioned(
            top: 0,
            right: 0,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10)),
              child: Container(
                width: 90,
                color: AppColors.primaryColor,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                  child: Center(
                    child: Text(
                      category ?? 'Sepakbola',
                      style: GoogleFonts.poppins(
                          fontSize: 11,
                          color: Colors.white,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
            ))
      ],
    ),
  );
}
