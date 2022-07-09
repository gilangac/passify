// ignore_for_file: prefer_const_constructors, must_be_immutable, avoid_unnecessary_containers, sized_box_for_whitespace, avoid_print

import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:passify/constant/color_constant.dart';
import 'package:passify/controllers/forum/community_controller.dart';
import 'package:passify/controllers/forum/event_controller.dart';
import 'package:intl/intl.dart';
import 'package:passify/models/community.dart';
import 'package:passify/models/event.dart';
import 'package:passify/widgets/general/app_bar.dart';
import 'package:passify/widgets/general/bottomsheet_widget.dart';
import 'package:passify/widgets/general/community_widget.dart';
import 'package:passify/widgets/general/event_widget.dart';
import 'package:passify/widgets/shimmer/search_community_shimmer.dart';
import 'package:passify/widgets/shimmer/search_event_shimmer.dart';

class HobbyPage extends StatelessWidget {
  HobbyPage({Key? key}) : super(key: key);
  String label = Get.arguments;
  EventController eventC = Get.put(EventController());
  CommunityController communityC = Get.put(CommunityController());

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: _appBar(),
        body: _body(),
        backgroundColor: Colors.white,
      ),
    );
  }

  PreferredSizeWidget _appBar() {
    return appBar(
      title: label,
      bottom: PreferredSize(
        preferredSize: Size(Get.width, 40.0),
        child: Theme(
          data: ThemeData(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: TabBar(
              overlayColor: MaterialStateProperty.all(
                  AppColors.primaryColor.withOpacity(0.5)),
              isScrollable: true,
              unselectedLabelColor: AppColors.primaryColor,
              indicatorSize: TabBarIndicatorSize.label,
              labelPadding: EdgeInsets.symmetric(horizontal: 5),
              indicatorWeight: 0,
              indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: AppColors.primaryColor),
              tabs: [
                tabBar(
                  "Komunitas",
                ),
                tabBar("Event"),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static Widget tabBar(String verified) {
    return Container(
      width: 100,
      height: 32,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.primaryColor, width: 1)),
      child: Tab(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Text(verified,
              style: GoogleFonts.poppins(
                  fontSize: 12, fontWeight: FontWeight.w600)),
        ),
      ),
    );
  }

  Widget _body() {
    return Obx(() => Column(
          children: [
            Expanded(
              child: TabBarView(
                children: [_community(), _event()],
              ),
            ),
          ],
        ));
  }

  Widget _event() {
    return eventC.isLoading
        ? Center(
            child: SearchEventShimmer(),
          )
        : Stack(
            children: [
              eventC.dataEvent.isNotEmpty
                  ? RefreshIndicator(
                      onRefresh: () => eventC.onGetDataEvent(),
                      child: ListView.builder(
                          itemCount: eventC.dataEvent.length,
                          physics: BouncingScrollPhysics(
                              parent: AlwaysScrollableScrollPhysics()),
                          padding: EdgeInsets.all(25),
                          itemBuilder: (context, index) {
                            EventModel data = eventC.dataEvent[index];
                            return FadeInDown(
                              delay: Duration(milliseconds: 10 * index),
                              duration: Duration(milliseconds: 400),
                              child: eventCard(
                                  idEvent: data.idEvent,
                                  name: data.name,
                                  description: data.description,
                                  date: DateFormat("EEEE, dd MMMM yyyy", "id")
                                      .format(data.dateEvent!.toDate())
                                      .toString(),
                                  location: data.location,
                                  time: data.time,
                                  category: data.category,
                                  commentCount: data.comment.toString(),
                                  membersCount: data.member?.toString()),
                            );
                          }),
                    )
                  : RefreshIndicator(
                      onRefresh: () => eventC.onGetDataEvent(),
                      child: SingleChildScrollView(
                        physics: BouncingScrollPhysics(
                            parent: AlwaysScrollableScrollPhysics()),
                        child: Container(
                          margin: EdgeInsets.all(20),
                          height: 500,
                          width: Get.width,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Belum Ada Data Event',
                                  style: GoogleFonts.poppins(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.black),
                                ),
                                Text(
                                  'Silahkan refresh halaman atau anda dapat membuat agenda event baru',
                                  style: GoogleFonts.poppins(
                                      fontSize: 12, color: Colors.black45),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
              Positioned(
                right: 20,
                bottom: 20,
                child: FloatingActionButton(
                  onPressed: () => _formCreateEvent(),
                  child: Icon(
                    Icons.add,
                    color: AppColors.primaryColor,
                    size: 29,
                  ),
                  backgroundColor: Colors.white,
                  elevation: 2,
                  splashColor: Colors.grey,
                ),
              )
            ],
          );
  }

  Widget _community() {
    return communityC.isLoading
        ? Center(child: SearchCommunityShimmer())
        : Stack(
            children: [
              communityC.dataCommunity.isNotEmpty
                  ? RefreshIndicator(
                      onRefresh: () => communityC.onGetDataCommunity(),
                      child: ListView.builder(
                          physics: BouncingScrollPhysics(
                              parent: AlwaysScrollableScrollPhysics()),
                          itemCount: communityC.dataCommunity.length,
                          padding: EdgeInsets.all(25),
                          itemBuilder: (context, index) {
                            CommunityModel data =
                                communityC.dataCommunity[index];
                            return FadeInDown(
                              delay: Duration(milliseconds: 10 * index),
                              duration: Duration(milliseconds: 400),
                              child: communityCard(
                                  idCommunity: data.idCommunity,
                                  category: data.category,
                                  city: data.city,
                                  name: data.name,
                                  photo: data.photo,
                                  membere: data.member),
                            );
                          }),
                    )
                  : RefreshIndicator(
                      onRefresh: () => communityC.onGetDataCommunity(),
                      child: SingleChildScrollView(
                        physics: BouncingScrollPhysics(
                            parent: AlwaysScrollableScrollPhysics()),
                        child: Container(
                          margin: EdgeInsets.all(20),
                          height: 500,
                          width: Get.width,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Belum Ada Data Komunitas',
                                  style: GoogleFonts.poppins(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.black),
                                ),
                                Text(
                                  'Silahkan refresh halaman atau anda dapat membuat komunitas baru',
                                  style: GoogleFonts.poppins(
                                      fontSize: 12, color: Colors.black45),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
              Positioned(
                right: 20,
                bottom: 20,
                child: FloatingActionButton(
                  onPressed: () => _formCreateCommunity(),
                  child: Icon(
                    Icons.add,
                    color: AppColors.primaryColor,
                    size: 29,
                  ),
                  backgroundColor: Colors.white,
                  elevation: 2,
                  splashColor: Colors.grey,
                ),
              )
            ],
          );
  }

  void _formCreateEvent() {
    Get.bottomSheet(
      SafeArea(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Container(
            height: Get.height * 0.92,
            child: Column(
              children: [
                _actionBar("Event"),
                Expanded(
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Form(
                      key: eventC.formKeyEvent,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(height: 20),
                          _formEventName(),
                          _formEventDate(),
                          _formEventTime(),
                          _formEventLocation(),
                          _formEventDesc(),
                          SizedBox(height: 50),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      isDismissible: false,
      enableDrag: false,
      isScrollControlled: true,
    );
  }

  Widget _formEventName() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: TextFormField(
        onChanged: (text) => {},
        keyboardType: TextInputType.name,
        textInputAction: TextInputAction.next,
        enabled: true,
        decoration: InputDecoration(hintText: "Nama Event"),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Masukkan Nama Event terlebih dahulu';
          }
          return null;
        },
        controller: eventC.nameFC,
      ),
    );
  }

  Widget _formEventLocation() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: TextFormField(
          onChanged: (text) => {},
          keyboardType: TextInputType.name,
          textInputAction: TextInputAction.newline,
          enabled: true,
          maxLines: 4,
          minLines: 2,
          decoration: InputDecoration(hintText: "Lokasi"),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Masukkan Lokasi terlebih dahulu';
            }
            return null;
          },
          controller: eventC.locationFC),
    );
  }

  Widget _formEventDate() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: GestureDetector(
        onTap: () {
          Get.bottomSheet(
              SafeArea(
                child: Container(
                  height: 250,
                  width: Get.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        alignment: Alignment.bottomRight,
                        width: Get.width,
                        color: Colors.white,
                        child: GestureDetector(
                          onTap: () => Get.back(),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 7),
                            child: Text("Selesai",
                                style: GoogleFonts.poppins(
                                    color: Colors.blue.shade700,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400)),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 15),
                        height: 200,
                        child: CupertinoDatePicker(
                          mode: CupertinoDatePickerMode.date,
                          // initialDateTime: DateTime.now(),
                          use24hFormat: true,
                          dateOrder: DatePickerDateOrder.dmy,
                          minimumDate: DateTime.now(),
                          onDateTimeChanged: (DateTime newDateTime) {
                            eventC.dateEvent = newDateTime;
                            eventC.dateFC.text =
                                DateFormat("EEEE, dd MMMM yyyy", "id")
                                    .format(newDateTime)
                                    .toString();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              backgroundColor: Colors.grey.shade200,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
              isDismissible: true,
              enableDrag: false,
              isScrollControlled: true);
        },
        child: TextFormField(
            onChanged: (text) => {},
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            enabled: false,
            decoration: InputDecoration(
                hintText: "Tanggal",
                suffixIcon: Icon(
                  Feather.calendar,
                  color: Colors.grey.shade300,
                )),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Masukkan Tanggal terlebih dahulu';
              }
              return null;
            },
            controller: eventC.dateFC),
      ),
    );
  }

  Widget _formEventTime() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: GestureDetector(
        onTap: () {
          Get.bottomSheet(
              SafeArea(
                child: Container(
                  height: 250,
                  width: Get.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        alignment: Alignment.bottomRight,
                        width: Get.width,
                        color: Colors.white,
                        child: GestureDetector(
                          onTap: () => Get.back(),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 7),
                            child: Text("Selesai",
                                style: GoogleFonts.poppins(
                                    color: Colors.blue.shade700,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400)),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 15),
                        height: 200,
                        child: Row(
                          children: [
                            Container(
                              width: Get.width * 0.7,
                              child: CupertinoDatePicker(
                                mode: CupertinoDatePickerMode.time,
                                initialDateTime: DateTime.now(),
                                use24hFormat: true,
                                dateOrder: DatePickerDateOrder.dmy,
                                minimumDate: DateTime(2022),
                                onDateTimeChanged: (DateTime newDateTime) {
                                  eventC.selectedTime.value =
                                      DateFormat("HH.mm ", "id")
                                          .format(newDateTime)
                                          .toString();
                                  eventC.timeFC.text =
                                      DateFormat("HH.mm ", "id")
                                              .format(newDateTime)
                                              .toString() +
                                          eventC.selectedDropdown.value;
                                },
                              ),
                            ),
                            Spacer(),
                            Obx(() => Container(
                                  child: DropdownButton<String>(
                                    elevation: 0,
                                    hint: Text(eventC.selectedDropdown.value,
                                        style: GoogleFonts.poppins(
                                            color: AppColors.textColor,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400)),
                                    items: <String>['WIB', 'WITA', 'WIT']
                                        .map((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      eventC.selectedDropdown.value =
                                          value.toString();
                                      eventC.timeFC.text =
                                          eventC.selectedTime.value +
                                              eventC.selectedDropdown.value;
                                    },
                                  ),
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              backgroundColor: Colors.grey.shade200,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
              isDismissible: true,
              enableDrag: false,
              isScrollControlled: true);
        },
        child: TextFormField(
            onChanged: (text) => {},
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            enabled: false,
            decoration: InputDecoration(
                hintText: "Waktu",
                suffixIcon: Icon(
                  Feather.clock,
                  color: Colors.grey.shade300,
                )),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Masukkan Waktu terlebih dahulu';
              }
              return null;
            },
            controller: eventC.timeFC),
      ),
    );
  }

  Widget _formEventDesc() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: TextFormField(
          onChanged: (text) => {},
          keyboardType: TextInputType.name,
          maxLines: 6,
          minLines: 5,
          textInputAction: TextInputAction.newline,
          enabled: true,
          decoration: InputDecoration(hintText: "Deskripsi"),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Masukkan Deskripsi terlebih dahulu';
            }
            return null;
          },
          controller: eventC.descriptionFC),
    );
  }

  Widget _actionBar(String tab) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      alignment: Alignment.center,
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              tab == "Event" ? eventC.onClearFC() : communityC.onClearFC();
              Get.back();
            },
            child: Container(
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.shade100,
                        blurRadius: 4,
                        spreadRadius: 6)
                  ],
                ),
                child: Icon(Feather.x, size: 24)),
          ),
          Spacer(),
          Text(
            "Buat " + tab,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
              tab == "Event"
                  ? eventC.onCreateEvent()
                  : communityC.onPrepareCreateCommunity();
            },
            child: Container(
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.shade100,
                        blurRadius: 4,
                        spreadRadius: 6)
                  ],
                ),
                child: Icon(Feather.check, size: 24)),
          ),
        ],
      ),
    );
  }

  // BOTTOMSHEET CREATE COMMUNITY
  void _formCreateCommunity() {
    Get.bottomSheet(
      SafeArea(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Container(
            height: Get.height * 0.92,
            child: Column(
              children: [
                _actionBar("Komunitas"),
                Expanded(
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics()),
                    child: Form(
                      key: communityC.formKeyCommunity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(height: 20),
                          _bannerImage(),
                          _formCommunityName(),
                          _formProvinsiCommunity(),
                          _formCityCommunity(),
                          _formCommunityDesc(),
                          SizedBox(height: 50),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      isDismissible: false,
      enableDrag: false,
      isScrollControlled: true,
    );
  }

  Widget _bannerImage() {
    return Obx(() => GestureDetector(
          onTap: (() => communityC.pickImage()),
          child: Container(
            height: Get.height * 0.25,
            width: Get.width,
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12)),
            child: communityC.selectedImagePath.value == ''
                ? Center(
                    child: Icon(
                    Feather.camera,
                    color: Colors.grey.shade400,
                    size: 28,
                  ))
                : ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Stack(
                      children: [
                        Image(
                          image: FileImage(
                              File(communityC.selectedImagePath.value)),
                          fit: BoxFit.cover,
                          height: Get.height * 0.25,
                          width: Get.width,
                        ),
                        Positioned(
                            top: 5,
                            right: 5,
                            child: GestureDetector(
                              onTap: () {
                                communityC.selectedImagePath.value = '';
                                communityC.urlImage.value = '';
                              },
                              child: Container(
                                width: 30,
                                height: 30,
                                margin: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8)),
                                child: Icon(
                                  Feather.trash,
                                  size: 20,
                                  color: Colors.black38,
                                ),
                              ),
                            ))
                      ],
                    ),
                  ),
          ),
        ));
  }

  Widget _formCommunityName() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: TextFormField(
        onChanged: (text) => {},
        keyboardType: TextInputType.name,
        textInputAction: TextInputAction.next,
        enabled: true,
        decoration: InputDecoration(
            hintText: "Nama Komunitas", fillColor: Colors.grey.shade100),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Masukkan Nama Komunitas terlebih dahulu';
          }
          return null;
        },
        controller: communityC.nameFC,
      ),
    );
  }

  Widget _formProvinsiCommunity() {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: GestureDetector(
          child: TextFormField(
              onChanged: (text) => {},
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              enabled: false,
              decoration: InputDecoration(
                  hintText: "Provinsi",
                  fillColor: Colors.grey.shade100,
                  suffixIcon: Icon(Feather.chevron_down)),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Masukkan provinsi terlebih dahulu';
                }
                return null;
              },
              controller: communityC.provinsiFC),
          onTap: () {
            communityC.dataProvinsi.isNotEmpty
                ? BottomSheetList(
                    ListView.builder(
                        physics: BouncingScrollPhysics(),
                        itemCount: communityC.dataProvinsi.length,
                        padding: EdgeInsets.all(15),
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              communityC.provinsiFC.text = communityC
                                  .dataProvinsi[index].nama
                                  .toString();
                              communityC.cityFC.text = '';
                              communityC.cityFC.clear();
                              communityC.dataCity.clear();
                              communityC.onGetCity(
                                  communityC.dataProvinsi[index].id.toString());
                              Get.back();
                            },
                            child: Container(
                              margin: EdgeInsets.only(bottom: 15),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    communityC.dataProvinsi[index].nama
                                        .toString(),
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      color: AppColors.textColor,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Container(
                                    height: 1,
                                    width: Get.width,
                                    color: Colors.grey.shade200,
                                  )
                                ],
                              ),
                            ),
                          );
                        }),
                    "Provinsi")
                : communityC.onGetProvince();
          },
        ));
  }

  Widget _formCityCommunity() {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: GestureDetector(
          child: TextFormField(
              onChanged: (text) => {},
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              enabled: false,
              decoration: InputDecoration(
                  hintText: "Kota",
                  fillColor: Colors.grey.shade100,
                  suffixIcon: Icon(Feather.chevron_down)),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Masukkan kota terlebih dahulu';
                }
                return null;
              },
              controller: communityC.cityFC),
          onTap: () {
            communityC.dataCity.isNotEmpty
                ? BottomSheetList(
                    ListView.builder(
                        physics: BouncingScrollPhysics(),
                        itemCount: communityC.dataCity.length,
                        padding: EdgeInsets.all(15),
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              communityC.cityFC.text =
                                  communityC.dataCity[index].nama.toString();
                              Get.back();
                            },
                            child: Container(
                              margin: EdgeInsets.only(bottom: 15),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    communityC.dataCity[index].nama.toString(),
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      color: AppColors.textColor,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Container(
                                    height: 1,
                                    width: Get.width,
                                    color: Colors.grey.shade200,
                                  )
                                ],
                              ),
                            ),
                          );
                        }),
                    "Kota")
                : null;
          },
        ));
  }

  Widget _formCommunityDesc() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: TextFormField(
          onChanged: (text) => {},
          keyboardType: TextInputType.name,
          maxLines: 6,
          minLines: 5,
          textInputAction: TextInputAction.newline,
          enabled: true,
          decoration: InputDecoration(
              hintText: "Deskripsi", fillColor: Colors.grey.shade100),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Masukkan Deskripsi terlebih dahulu';
            }
            return null;
          },
          controller: communityC.descriptionFC),
    );
  }
}
