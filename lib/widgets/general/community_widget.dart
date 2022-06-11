// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, avoid_unnecessary_containers

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:passify/constant/color_constant.dart';
import 'package:passify/models/community_member.dart';
import 'package:passify/routes/pages.dart';
import 'package:passify/widgets/general/circle_avatar.dart';

List membere = [
  {
    "name": "Gilang",
    "image": "",
  },
  {
    "name": "Marukawa",
    "image": "",
  },
  {
    "name": "Bruno",
    "image": "",
  },
  {
    "name": "Bruno",
    "image": "",
  },
  {
    "name": "Bruno",
    "image": "",
  },
];

Widget communityCard(
    {String? idCommunity,
    String? name,
    String? city,
    String? category,
    String? membersCount,
    String? photo,
    List? membera,
    List<CommunityMemberModel>? membere}) {
  // List member = membera ?? [];
  List<CommunityMemberModel> member = membere ?? [];

  return GestureDetector(
    onTap: () => Get.toNamed(AppPages.COMMUNITY + idCommunity.toString(),
        arguments: idCommunity),
    child: Stack(
      children: [
        Container(
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
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10)),
                        height: Get.height * 0.2,
                        width: Get.width,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: photo != ""
                              ? CachedNetworkImage(
                                  imageUrl: photo.toString(),
                                  width: Get.width,
                                  fit: BoxFit.cover,
                                  errorWidget: (context, url, error) =>
                                      Center(child: Icon(Icons.error)),
                                  progressIndicatorBuilder:
                                      (context, url, downloadProgress) =>
                                          Container(
                                    color: Colors.white,
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        value: downloadProgress.progress,
                                        color: AppColors.primaryColor,
                                        strokeWidth: 2,
                                      ),
                                    ),
                                  ),
                                )
                              : Container(
                                  decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                          begin: Alignment.bottomLeft,
                                          end: Alignment.topRight,
                                          colors: [
                                        AppColors.primaryColor,
                                        AppColors.accentColor.withOpacity(0.7)
                                      ])),
                                  child: Center(
                                    child: Image(
                                        image: AssetImage(
                                            "assets/images/logo_icon.png")),
                                  ),
                                ),
                        ),
                      ),
                      Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.black.withOpacity(0.6)),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 8),
                              child: Text(category ?? "Sepakbola",
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                  )),
                            ),
                          ))
                    ],
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(name ?? "Fun Football Madiun",
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              )),
                          Row(
                            children: [
                              Icon(
                                Feather.map_pin,
                                color: Colors.grey.shade500,
                                size: 13,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(city ?? "Madiun",
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    color: Colors.grey.shade500,
                                    fontWeight: FontWeight.w400,
                                  )),
                            ],
                          ),
                        ],
                      ),
                      Spacer(),
                      // Container(height: 45, child: _members())
                      GestureDetector(
                        onTap: () => Get.toNamed(
                            AppPages.COMMUNITY + idCommunity.toString(),
                            arguments: idCommunity),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(500),
                          child: Container(
                              height: 30,
                              width: 30,
                              child: SvgPicture.asset('assets/svg/visit.svg')),
                        ),
                      )
                    ],
                  )
                ],
              ),
            )),
        Positioned(
            top: Get.height * 0.2 - 15,
            left: 20,
            child: Container(
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 1,
                        offset: Offset(0, 1), // changes position of shadow
                      ),
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                height: 45,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Center(
                      child: Row(
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: member.length > 3 ? 3 : member.length,
                        itemBuilder: (context, index) {
                          return Align(
                            widthFactor: 0.7,
                            child: CircleAvatar(
                              radius: 18,
                              backgroundColor: AppColors.inputBoxColor,
                              child: StreamBuilder<DocumentSnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(member[index].idUser)
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return SizedBox();
                                  } else {
                                    return circleAvatar(
                                        imageData: snapshot.hasData
                                            ? snapshot.data!.get("photoUser") ??
                                                ""
                                            : "",
                                        nameData: snapshot.hasData
                                            ? snapshot.data!.get("name") ?? ""
                                            : "",
                                        size: 15);
                                  }
                                },
                              ),
                            ),
                          );
                        },
                      ),
                      if (member.length > 3)
                        Padding(
                          padding: EdgeInsets.only(left: 8),
                          child: Text(
                            '+${member.length - 3}',
                            style: GoogleFonts.poppins(
                                color: Colors.black45,
                                fontWeight: FontWeight.w600,
                                fontSize: 16),
                          ),
                        ),
                    ],
                  )),
                )))
      ],
    ),
  );
}

// Widget _members() {
//   int _memberCount = member.length;

//   return Row(
//     children: [
//       ListView.builder(
//         shrinkWrap: true,
//         scrollDirection: Axis.horizontal,
//         physics: NeverScrollableScrollPhysics(),
//         itemCount: _memberCount > 3 ? 3 : _memberCount,
//         itemBuilder: (context, index) {
//           return Align(
//             widthFactor: 0.7,
//             child: CircleAvatar(
//               radius: 18,
//               backgroundColor: AppColors.inputBoxColor,
//               child: circleAvatar(
//                   imageData: member[index]['image'],
//                   nameData: member[index]['name'],
//                   size: 15),
//             ),
//           );
//         },
//       ),
//       if (_memberCount > 3)
//         Padding(
//           padding: EdgeInsets.only(left: 8),
//           child: Text(
//             '+${_memberCount - 3}',
//             style: GoogleFonts.poppins(
//                 color: Colors.black45,
//                 fontWeight: FontWeight.w600,
//                 fontSize: 16),
//           ),
//         ),
//     ],
//   );
// }
