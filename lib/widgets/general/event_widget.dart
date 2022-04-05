// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:passify/constant/color_constant.dart';
import 'package:passify/controllers/forum/event_controller.dart';
import 'package:passify/routes/pages.dart';
import 'package:passify/widgets/general/community_widget.dart';

EventController eventC = Get.find();
Widget eventCard(
    {String? idEvent,
    String? name,
    String? location,
    String? date,
    String? time,
    String? category,
    String? membersCount}) {
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
                                      'JAN',
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
                                    '22',
                                    style: GoogleFonts.poppins(
                                        fontSize: 36,
                                        height: 1,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.primaryColor),
                                  ),
                                  Text(
                                    '2022',
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
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Feather.map_pin,
                              color: AppColors.primaryColor,
                              size: 13,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              location ?? "GOR Wilis Madiun",
                              style: GoogleFonts.poppins(
                                  fontSize: 12, fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Feather.calendar,
                              color: AppColors.primaryColor,
                              size: 13,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              date ?? "18 Februari 2022",
                              style: GoogleFonts.poppins(
                                  fontSize: 12, fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Feather.clock,
                              color: AppColors.primaryColor,
                              size: 13,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              time ?? " 12.00 WIB - 14.00 WIB",
                              style: GoogleFonts.poppins(
                                  fontSize: 12, fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
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
                                Text(
                                  " Partisipan",
                                  style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400),
                                ),
                              ],
                            ),
                          ],
                        )
                      ],
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
                  Icon(
                    Feather.message_circle,
                    size: 18,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    '10 Komentar',
                    style: GoogleFonts.poppins(
                        fontSize: 12, fontWeight: FontWeight.w400),
                  ),
                  Spacer(),
                  Container(
                    child: GestureDetector(
                      onTap: () {
                        Get.toNamed(AppPages.DETAIL_EVENT + idEvent.toString(),
                            arguments: idEvent);
                      },
                      child: Text(
                        'Lihat Detail',
                        style: GoogleFonts.poppins(
                            fontStyle: FontStyle.italic,
                            fontSize: 12,
                            fontWeight: FontWeight.w400),
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
