// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors, prefer_is_empty, sized_box_for_whitespace, unrelated_type_equality_checks

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:passify/constant/color_constant.dart';
import 'package:passify/controllers/search/search_controller.dart';
import 'package:passify/widgets/general/circle_avatar.dart';
import 'package:passify/widgets/general/community_widget.dart';
import 'package:passify/widgets/general/event_widget.dart';

class SearchPage extends StatelessWidget {
  SearchPage({Key? key}) : super(key: key);
  final SearchController searchController = Get.find();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.dark,
        statusBarColor: Colors.white));
    return Obx(() => DefaultTabController(
          length: searchController.searchView == true ? 4 : 1,
          child: Scaffold(
            appBar: _appBar(),
            body: _body(),
            backgroundColor: Colors.white,
          ),
        ));
  }

  PreferredSizeWidget _appBar() {
    return AppBar(
        title: _searchBar(),
        elevation: 0.4,
        bottom: searchController.searchView == true
            ? PreferredSize(
                preferredSize: Size(Get.width, 35.0),
                child: TabBar(
                  physics: BouncingScrollPhysics(),
                  isScrollable: false,
                  indicatorColor: AppColors.primaryColor,
                  indicatorWeight: 2.0,
                  labelPadding: EdgeInsets.only(top: 0),
                  labelColor: AppColors.primaryColor,
                  unselectedLabelColor: AppColors.textColor,
                  // ignore: prefer_const_literals_to_create_immutables
                  tabs: [
                    _tabBar("Orang"),
                    _tabBar("Event"),
                    _tabBar("Komunitas"),
                    _tabBar("Tagar"),
                  ],
                ),
              )
            : null);
  }

  Widget _searchBar() {
    return Padding(
      padding: EdgeInsets.fromLTRB(
          0,
          searchController.searchView == true ? 7 : 0,
          searchController.searchView == true ? 0 : 2,
          0),
      child: Container(
        width: Get.width,
        child: Container(
          height: 40,
          alignment: Alignment.centerLeft,
          child: Center(
            child: Obx(() => Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        textAlign: TextAlign.start,
                        onTap: () {
                          searchController.searchView.value = true;

                          FocusManager.instance.primaryFocus;
                        },
                        controller: searchController.searchFC,
                        onChanged: (value) {
                          searchController.searchText.value = value;
                        },
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 10),
                          fillColor: AppColors.lightGrey,
                          labelStyle: GoogleFonts.poppins(
                              fontSize: 12, fontWeight: FontWeight.w500),
                          hintText: 'Cari',
                          prefixIcon:
                              Icon(Feather.search, color: Colors.grey.shade400),
                          suffixIcon: searchController.searchFC.text.length >
                                      0 ||
                                  searchController.searchText.value != ''
                              ? GestureDetector(
                                  onTap: () {
                                    searchController.searchFC.clear();
                                    searchController.searchText.value = '';
                                  },
                                  child: Icon(Feather.x, color: Colors.black54),
                                )
                              : null,
                        ),
                        // validator: validator,
                      ),
                    ),
                    SizedBox(
                      width: searchController.searchView == true ? 10 : 0,
                    ),
                    searchController.searchView == true
                        ? GestureDetector(
                            onTap: () {
                              searchController.searchFC.clear();
                              searchController.searchText.value = '';
                              FocusManager.instance.primaryFocus?.unfocus();
                              searchController.searchView.value = false;
                            },
                            child: Text("Batal",
                                style: GoogleFonts.poppins(
                                    fontSize: 14, fontWeight: FontWeight.w400)),
                          )
                        : SizedBox(
                            width: 0,
                          ),
                  ],
                )),
          ),
        ),
      ),
    );
  }

  Widget _tabBar(String label) {
    return Tab(
      height: 40,
      child: Text(label,
          style:
              GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w500)),
    );
  }

  Widget _body() {
    return searchController.searchView.value == true
        ? TabBarView(
            // ignore: prefer_const_literals_to_create_immutables
            physics: BouncingScrollPhysics(),
            children: [
              _searchPerson(),
              _searchEvent(),
              _searchCommunity(),
              _searchTag()
            ],
          )
        : TabBarView(
            // ignore: prefer_const_literals_to_create_immutables
            physics: BouncingScrollPhysics(),
            children: [_trendTag()]);
  }

  Widget _trendTag() {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tren tagar untukmu',
              style: GoogleFonts.poppins(
                  fontSize: 18, fontWeight: FontWeight.w700),
            ),
            SizedBox(
              height: 15,
            ),
            ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: 5,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(25),
                              bottomRight: Radius.circular(25),
                              topRight: Radius.circular(10),
                              bottomLeft: Radius.circular(10)),
                          child: Container(
                            height: 60,
                            width: 60,
                            color: Colors.grey.shade100,
                            child: Center(
                              child: Icon(Feather.hash),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          '#sparingfutsalmadiun',
                          style: GoogleFonts.poppins(
                              fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  );
                })
          ],
        ),
      ),
    );
  }

  Widget _searchPerson() {
    return ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: 5,
        padding: EdgeInsets.all(25),
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: Row(
              children: [
                circleAvatar(imageData: "", nameData: "T", size: 25),
                SizedBox(
                  width: 10,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Taesei Marukawa',
                      style: GoogleFonts.poppins(
                          fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                    Text(
                      'marukawa',
                      style: GoogleFonts.poppins(
                          color: Colors.grey.shade500,
                          fontStyle: FontStyle.normal,
                          fontSize: 12,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }

  Widget _searchEvent() {
    return ListView.builder(
        itemCount: 4,
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.all(25),
        itemBuilder: (context, index) {
          return eventCard();
        });
  }

  Widget _searchCommunity() {
    return ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: 4,
        padding: EdgeInsets.all(25),
        itemBuilder: (context, index) {
          return communityCard();
        });
  }

  Widget _searchTag() {
    return ListView.builder(
        itemCount: 4,
        padding: EdgeInsets.all(25),
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25),
                        bottomRight: Radius.circular(25),
                        topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10)),
                    color: Colors.grey.shade100,
                  ),
                  child: Center(
                    child: Icon(Feather.hash),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  '#sparingfutsalmadiun',
                  style: GoogleFonts.poppins(
                      fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          );
        });
  }
}
