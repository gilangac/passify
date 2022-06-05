// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_local_variable, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:passify/constant/color_constant.dart';
import 'package:passify/controllers/profile/profile_person_controller.dart';
import 'package:passify/widgets/general/circle_avatar.dart';
import 'package:passify/widgets/general/community_widget.dart';
import 'package:passify/widgets/general/event_widget.dart';
import 'package:passify/widgets/profile/Profile_action_widget.dart';
import 'package:intl/intl.dart';

class ProfilePersonPage extends StatelessWidget {
  ProfilePersonPage({Key? key}) : super(key: key);
  ProfilePersonController profileC = Get.put(ProfilePersonController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(body: _body(), backgroundColor: Colors.white));
  }

  List<Widget> _action() {
    return [ProfileActionMenuWidget()];
  }

  Widget _body() {
    return profileC.isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : DefaultTabController(
            length: 2,
            child: NestedScrollView(
                physics: BouncingScrollPhysics(),
                headerSliverBuilder: (context, index) {
                  return <Widget>[
                    SliverAppBar(
                      title: Text(
                          '@${profileC.dataUser[0].username.toString()}',
                          style: GoogleFonts.poppins(
                              color: AppColors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w600)),
                      centerTitle: true,
                      backgroundColor: Colors.white,
                      pinned: true,
                      elevation: 1,
                      forceElevated: true,
                      primary: true,
                      expandedHeight: 325,
                      flexibleSpace:
                          FlexibleSpaceBar(background: _profileInfo()),
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
                                Text(profileC.dataCommunity.length.toString(),
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
                                Text(profileC.dataEvent.length.toString(),
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
        GestureDetector(
          onTap: () => profileC.onRefresh(),
          child: circleAvatar(
              imageData: dataUser.photo.toString(),
              nameData: dataUser.name.toString(),
              size: 45),
        ),
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
          dataUser.hobby!.length == 1
              ? dataUser.hobby![0].toString()
              : dataUser.hobby!.length == 2
                  ? dataUser.hobby![0].toString() +
                      " | " +
                      dataUser.hobby![1].toString()
                  : dataUser.hobby![0].toString() +
                      " | " +
                      dataUser.hobby![1].toString() +
                      " | " +
                      dataUser.hobby![2].toString(),
          style: GoogleFonts.poppins(
              fontSize: 12, fontWeight: FontWeight.w500, color: Colors.grey),
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            profileC.dataUser[0].instagram == ''
                ? SizedBox(
                    height: 0,
                  )
                : GestureDetector(
                    onTap: () => profileC.onLaunchUrl(
                        'instagram', profileC.dataUser[0].instagram.toString()),
                    child: Container(
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
                  ),
            SizedBox(
              width: 10,
            ),
            profileC.dataUser[0].twitter == ''
                ? SizedBox(
                    height: 0,
                  )
                : GestureDetector(
                    onTap: () => profileC.onLaunchUrl(
                        'twitter', profileC.dataUser[0].twitter.toString()),
                    child: Container(
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
                  ),
          ],
        ),
        SizedBox(
          height: 5,
        ),
      ],
    );
  }

  Widget _content() {
    return RefreshIndicator(
      onRefresh: () {
        HapticFeedback.lightImpact();
        return profileC.onRefresh();
      },
      child: TabBarView(
          physics:
              BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          children: [_community(), _event()]),
    );
  }

  Widget _event() {
    return RefreshIndicator(
      onRefresh: () {
        HapticFeedback.lightImpact();
        return profileC.onRefresh();
      },
      child: profileC.dataEvent.isEmpty
          ? SingleChildScrollView(
              physics: BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              child: Center(
                child: Column(
                  children: [
                    SizedBox(
                      height: 50,
                    ),
                    LottieBuilder.asset("assets/json/empty_data.json",
                        height: 180),
                    Text(
                      "Belum ada event yang diikuti",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                          color: AppColors.tittleColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                    Container(height: 100)
                  ],
                ),
              ),
            )
          : ListView.builder(
              itemCount: profileC.dataEvent.length,
              physics: BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              padding: EdgeInsets.all(25),
              itemBuilder: (context, index) {
                var data = profileC.dataEvent[index];
                return eventCard(
                    idEvent: data.idEvent,
                    name: data.name,
                    date: DateFormat("EEEE, dd MMMM yyyy", "id")
                        .format(data.dateEvent!.toDate())
                        .toString(),
                    location: data.location,
                    time: data.time,
                    category: data.category,
                    commentCount: data.comment.toString(),
                    membersCount: data.member?.toString());
              }),
    );
  }

  Widget _community() {
    return RefreshIndicator(
      onRefresh: () {
        HapticFeedback.lightImpact();
        return profileC.onRefresh();
      },
      child: profileC.dataCommunity.isEmpty
          ? SingleChildScrollView(
              physics: BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              child: Center(
                child: Column(
                  children: [
                    SizedBox(
                      height: 50,
                    ),
                    LottieBuilder.asset("assets/json/empty_data.json",
                        height: 180),
                    Text(
                      "Belum ada komunitas yang diikuti",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                          color: AppColors.tittleColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                    Container(height: 100)
                  ],
                ),
              ),
            )
          : ListView.builder(
              itemCount: profileC.dataCommunity.length,
              physics: BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              shrinkWrap: true,
              padding: EdgeInsets.all(25),
              itemBuilder: (context, index) {
                var data = profileC.dataCommunity[index];
                return communityCard(
                    idCommunity: data.idCommunity,
                    category: data.category,
                    city: data.city,
                    name: data.name,
                    photo: data.photo,
                    membere: data.member);
              }),
    );
  }
}
