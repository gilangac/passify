// ignore_for_file: prefer_const_constructors, must_be_immutable, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:passify/constant/color_constant.dart';
import 'package:passify/controllers/forum/event_controller.dart';
import 'package:passify/helpers/bottomsheet_helper.dart';
import 'package:passify/models/event.dart';
import 'package:passify/widgets/general/app_bar.dart';
import 'package:passify/widgets/general/community_widget.dart';
import 'package:passify/widgets/general/event_widget.dart';

class HobbyPage extends StatelessWidget {
  HobbyPage({Key? key}) : super(key: key);
  String label = Get.arguments;
  EventController eventC = Get.put(EventController());

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
        child: Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: TabBar(
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
    return Obx(() => TabBarView(
          children: [_community(), _event()],
        ));
  }

  Widget _event() {
    return eventC.isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Stack(
            children: [
              eventC.dataEvent.isNotEmpty
                  ? ListView.builder(
                      itemCount: eventC.dataEvent.length,
                      physics: BouncingScrollPhysics(),
                      padding: EdgeInsets.all(25),
                      itemBuilder: (context, index) {
                        EventModel data = eventC.dataEvent[index];
                        return eventCard(
                            idEvent: data.idEvent,
                            name: data.name,
                            date: data.dateEvent,
                            location: data.location,
                            time: data.time,
                            category: data.category,
                            membersCount: data.member?.length.toString());
                      })
                  : Container(
                      child: Center(
                        child: Text(
                          "Belum Ada Event",
                          style: TextStyle(fontWeight: FontWeight.bold),
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
    return Stack(
      children: [
        ListView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: 4,
            padding: EdgeInsets.all(25),
            itemBuilder: (context, index) {
              return communityCard();
            }),
        Positioned(
          right: 20,
          bottom: 20,
          child: FloatingActionButton(
            onPressed: () {},
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
                _actionBar(),
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
                          _formNameEvent(),
                          _formEventLocation(),
                          _formEventDate(),
                          _formEventTime(),
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

  Widget _formNameEvent() {
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
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          enabled: true,
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
      child: TextFormField(
          onChanged: (text) => {},
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          enabled: true,
          decoration: InputDecoration(hintText: "Tanggal"),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Masukkan Tanggal terlebih dahulu';
            }
            return null;
          },
          controller: eventC.dateFC),
    );
  }

  Widget _formEventTime() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: TextFormField(
          onChanged: (text) => {},
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          enabled: true,
          decoration: InputDecoration(hintText: "Waktu"),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Masukkan Waktu terlebih dahulu';
            }
            return null;
          },
          controller: eventC.timeFC),
    );
  }

  Widget _formEventDesc() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: TextFormField(
          onChanged: (text) => {},
          keyboardType: TextInputType.text,
          maxLines: 6,
          minLines: 5,
          textInputAction: TextInputAction.done,
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

  Widget _actionBar() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      alignment: Alignment.center,
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              eventC.onClearFC();
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
            "Tambah Event",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
              eventC.onCreateEvent(label);
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
}
