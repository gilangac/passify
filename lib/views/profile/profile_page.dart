// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:passify/constant/color_constant.dart';
import 'package:passify/controllers/auth/firebase_auth_controller.dart';
import 'package:passify/controllers/home/home_controller.dart';
import 'package:passify/controllers/profile/profile_controller.dart';
import 'package:passify/widgets/general/circle_avatar.dart';
import 'package:passify/widgets/general/community_widget.dart';
import 'package:passify/widgets/general/event_widget.dart';
import 'package:passify/widgets/profile/Profile_action_widget.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({Key? key}) : super(key: key);
  FirebaseAuthController firebaseAuthController = Get.find();
  ProfileController profileC = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(body: _body(), backgroundColor: Colors.white));
  }

  List<Widget> _action() {
    return [ProfileActionMenuWidget()];
  }

  Widget _body() {
    final dataUser = profileC.dataUser[0];
    return DefaultTabController(
      length: 2,
      child: NestedScrollView(
          physics: BouncingScrollPhysics(),
          headerSliverBuilder: (context, index) {
            return <Widget>[
              SliverAppBar(
                title: Text("Profile",
                    style: GoogleFonts.poppins(
                        color: AppColors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w600)),
                actions: _action(),
                centerTitle: true,
                backgroundColor: Colors.white,
                pinned: true,
                elevation: 1,
                forceElevated: true,
                primary: true,
                expandedHeight: 325,
                flexibleSpace: FlexibleSpaceBar(background: _profileInfo()),
                bottom: TabBar(
                  isScrollable: false,
                  indicatorColor: AppColors.primaryColor,
                  indicatorWeight: 2.0,
                  indicatorPadding: EdgeInsets.symmetric(horizontal: 25),
                  labelColor: AppColors.primaryColor,
                  unselectedLabelColor: AppColors.textColor,
                  tabs: [
                    Tab(
                      height: 50,
                      child: Column(
                        children: [
                          Text("12",
                              style: GoogleFonts.poppins(
                                  color: AppColors.tittleColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600)),
                          Text("Komunitas",
                              style: GoogleFonts.poppins(
                                  color: Colors.grey,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                    Tab(
                      height: 50,
                      child: Column(
                        children: [
                          Text("0",
                              style: GoogleFonts.poppins(
                                  color: AppColors.tittleColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600)),
                          Text("Event",
                              style: GoogleFonts.poppins(
                                  color: Colors.grey,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ];
          },
          body: _content()),
    );
  }

  Widget _profileInfo() {
    final dataUser = profileC.dataUser[0];
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 20,
        ),
        circleAvatar(
            imageData: dataUser.photo.toString(),
            nameData: dataUser.name.toString(),
            size: 45),
        SizedBox(
          height: 10,
        ),
        Text(
          profileC.name.toString(),
          style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.tittleColor),
        ),
        Text(
          dataUser.hobby.toString(),
          style: GoogleFonts.poppins(
              fontSize: 12, fontWeight: FontWeight.w500, color: Colors.grey),
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(0.8),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: Icon(
                    Feather.instagram,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(0.8),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Icon(
                  Feather.twitter,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(0.8),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: Icon(
                    Feather.instagram,
                    color: Colors.white,
                  ),
                ),
              ),
            )
          ],
        ),
        SizedBox(
          height: 5,
        ),
      ],
    );
  }

  Widget _content() {
    return Container(
      height: 4,
      width: Get.width,
      color: Colors.white,
      child: TabBarView(children: [_community(), _event()]),
    );
  }

  Widget _event() {
    return ListView.builder(
        itemCount: 4,
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.all(25),
        itemBuilder: (context, index) {
          return eventCard();
        });
  }

  Widget _community() {
    return ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: 4,
        padding: EdgeInsets.all(25),
        itemBuilder: (context, index) {
          return communityCard();
        });
  }
}
