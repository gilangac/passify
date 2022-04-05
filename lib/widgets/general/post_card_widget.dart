// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'circle_avatar.dart';

Widget postCard(Map data) {
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
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                circleAvatar(
                    imageData: "", nameData: data['name'].toString(), size: 18),
                SizedBox(
                  width: 10,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data['name'].toString(),
                      style: GoogleFonts.poppins(
                          height: 1, fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      '@gilang.ac',
                      style: GoogleFonts.poppins(
                          color: Colors.grey.shade600,
                          height: 1.5,
                          fontSize: 11,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letra.",
              style: GoogleFonts.poppins(
                  color: Colors.grey.shade600,
                  height: 1.5,
                  fontSize: 11,
                  fontWeight: FontWeight.w400),
              textAlign: TextAlign.justify,
              maxLines: data['foto'] == "" ? 5 : 3,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(
              height: 10,
            ),
            data['foto'] == ""
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
                          child: Image(
                              fit: BoxFit.cover,
                              image: NetworkImage(
                                  'https://firebasestorage.googleapis.com/v0/b/passify-app-347b7.appspot.com/o/UTSSport_Hero_TEST_Landscape-1536x1143.jpg?alt=media&token=dd016e59-98cd-41b5-8fd8-2182a2862573')),
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
                  child: Text(
                    'Lihat Detail',
                    style: GoogleFonts.poppins(
                        fontStyle: FontStyle.italic,
                        fontSize: 12,
                        fontWeight: FontWeight.w400),
                  ),
                )
              ],
            )
          ],
        ),
      ));
}
