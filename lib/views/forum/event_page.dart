// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:passify/constant/color_constant.dart';
import 'package:passify/controllers/forum/detail_event_controller.dart';
import 'package:passify/controllers/forum/event_controller.dart';
import 'package:passify/widgets/general/app_bar.dart';
import 'package:passify/widgets/general/circle_avatar.dart';
import 'package:passify/widgets/general/comment_widget.dart';
import 'package:passify/widgets/general/dotted_separator.dart';

class EventPage extends StatelessWidget {
  EventPage({Key? key}) : super(key: key);
  // final EventController eventController = Get.find();
  final DetailEventController detailEventController =
      Get.put(DetailEventController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: _appBar(),
      body: _body(),
      backgroundColor: Colors.white,
    ));
  }

  PreferredSizeWidget _appBar() {
    return appBar(title: "Detail Event");
  }

  Widget _body() {
    return Obx(() => detailEventController.isLoadingDetail
        ? Center(child: CircularProgressIndicator())
        : Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _profile(),
                      Divider(
                        height: 5,
                        thickness: 5,
                        color: Colors.grey.shade200,
                      ),
                      _aboutEvent(),
                      Divider(
                        height: 5,
                        thickness: 5,
                        color: Colors.grey.shade200,
                      ),
                      _description(),
                      Divider(
                        height: 5,
                        thickness: 5,
                        color: Colors.grey.shade200,
                      ),
                      _comment()
                    ],
                  ),
                ),
              ),
              Container(
                width: Get.width,
                color: Colors.white,
                child: _commentInput(),
              )
            ],
          ));
  }

  Widget _profile() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              circleAvatar(
                  imageData: detailEventController.userEvent[0].photo,
                  nameData: detailEventController.userEvent[0].name.toString(),
                  size: 22),
              SizedBox(
                width: 10,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    detailEventController.userEvent[0].name.toString(),
                    style: GoogleFonts.poppins(
                        height: 1.2,
                        color: AppColors.tittleColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600),
                  ),
                  Text(
                    detailEventController.userEvent[0].username.toString(),
                    style: GoogleFonts.poppins(
                        height: 1.2,
                        color: Colors.grey.shade500,
                        fontSize: 12,
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
            detailEventController.detailEvent[0].name.toString(),
            style:
                GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _aboutEvent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tentang Event',
                style: GoogleFonts.poppins(
                    color: AppColors.tittleColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
              dotSeparator(
                color: Colors.grey.shade400,
              ),
              Row(
                children: [
                  Icon(
                    Feather.map_pin,
                    size: 15,
                    color: AppColors.primaryColor,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    detailEventController.detailEvent[0].location.toString(),
                    style: GoogleFonts.poppins(
                        color: AppColors.tittleColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  Icon(
                    Feather.calendar,
                    size: 15,
                    color: AppColors.primaryColor,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    detailEventController.detailEvent[0].dateEvent.toString(),
                    style: GoogleFonts.poppins(
                        color: AppColors.tittleColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  Icon(
                    Feather.clock,
                    size: 15,
                    color: AppColors.primaryColor,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    detailEventController.detailEvent[0].time.toString(),
                    style: GoogleFonts.poppins(
                        color: AppColors.tittleColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  Icon(
                    Feather.users,
                    size: 15,
                    color: AppColors.primaryColor,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    width: Get.width - 65,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          detailEventController.detailEvent[0].member!.length
                                  .toString() +
                              " Partisipan",
                          style: GoogleFonts.poppins(
                              color: AppColors.tittleColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w500),
                        ),
                        GestureDetector(
                          onTap: () => _participantEvent(),
                          child: Text(
                            'Lihat Partisipan',
                            style: GoogleFonts.poppins(
                                color: AppColors.primaryColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _description() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Deskripsi',
            style: GoogleFonts.poppins(
                color: AppColors.tittleColor,
                fontSize: 16,
                fontWeight: FontWeight.w600),
          ),
          dotSeparator(
            color: Colors.grey.shade400,
          ),
          Text(
            detailEventController.detailEvent[0].description.toString(),
            style: GoogleFonts.poppins(
                color: AppColors.tittleColor,
                fontSize: 12,
                fontWeight: FontWeight.w400),
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }

  Widget _comment() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Komentar (' +
                detailEventController.commentEvent.length.toString() +
                ')',
            style: GoogleFonts.poppins(
                color: AppColors.tittleColor,
                fontSize: 16,
                fontWeight: FontWeight.w600),
          ),
          dotSeparator(
            color: Colors.grey.shade400,
          ),
          detailEventController.commentEvent.isNotEmpty
              ? ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  itemCount: detailEventController.commentEvent.length,
                  itemBuilder: ((context, index) {
                    return commentWidget(
                        comment: detailEventController
                            .commentEvent[index].comment
                            .toString(),
                        nama: detailEventController.commentEvent[index].name,
                        photo: detailEventController.commentEvent[index].photo,
                        username:
                            detailEventController.commentEvent[index].username);
                  }))
              : Center(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Belum ada komentar",
                        style: GoogleFonts.poppins(
                            color: AppColors.tittleColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                      ),
                      Text(
                        "Jadilah yang pertama mengomentari event ini",
                        style: GoogleFonts.poppins(
                            color: Colors.grey.shade400,
                            fontSize: 12,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
        ],
      ),
    );
  }

  Widget _commentInput() {
    return BottomAppBar(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Center(
          child: Obx(() => Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      textAlign: TextAlign.start,
                      controller: detailEventController.commentFC,
                      onChanged: (value) {
                        detailEventController.commentText.value = value;
                      },
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.send,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(10),
                        fillColor: AppColors.lightGrey,
                        labelStyle: GoogleFonts.poppins(
                            fontSize: 12, fontWeight: FontWeight.w500),
                        hintText: 'Tuliskan komentar kamu',
                      ),
                      // validator: validator,
                    ),
                  ),
                  SizedBox(
                    width:
                        detailEventController.commentText.value != '' ? 10 : 0,
                  ),
                  detailEventController.commentText.value != ''
                      ? GestureDetector(
                          onTap: () {
                            detailEventController.onPostComment();
                            detailEventController.commentFC.clear();
                            detailEventController.commentText.value = '';
                            FocusManager.instance.primaryFocus?.unfocus();
                          },
                          child: Container(
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                  color: AppColors.inputBoxColor,
                                  borderRadius: BorderRadius.circular(15)),
                              child: Icon(Feather.send, color: Colors.grey)),
                        )
                      : SizedBox(
                          width: 0,
                        ),
                ],
              )),
        ),
      ),
    );
  }

  void _participantEvent() {
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
                  child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      itemCount:
                          detailEventController.detailEvent[0].member!.length,
                      padding: EdgeInsets.all(15),
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.only(bottom: 15),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  circleAvatar(
                                      imageData: detailEventController
                                          .memberEvent[index].photo
                                          .toString(),
                                      nameData: detailEventController
                                          .memberEvent[index].name
                                          .toString(),
                                      size: 20),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        detailEventController
                                            .memberEvent[index].name
                                            .toString(),
                                        style: GoogleFonts.poppins(
                                            color: AppColors.tittleColor,
                                            height: 1.2,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      Text(
                                        detailEventController
                                            .memberEvent[index].username
                                            .toString(),
                                        style: GoogleFonts.poppins(
                                            height: 1.2,
                                            color: Colors.grey.shade500,
                                            fontStyle: FontStyle.normal,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ],
                                  ),
                                  Spacer(),
                                  Obx(() => detailEventController
                                              .memberEvent[index].idUser ==
                                          detailEventController
                                              .detailEvent[0].member![0]
                                      ? Text(
                                          "Pembuat Event",
                                          style: GoogleFonts.poppins(
                                              height: 1.2,
                                              color: Colors.grey.shade500,
                                              fontStyle: FontStyle.normal,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400),
                                        )
                                      : SizedBox()),
                                ],
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
                        );
                      }),
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
      isDismissible: true,
      enableDrag: true,
      isScrollControlled: true,
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
              // eventC.onClearFC();
              Get.back();
            },
            child: Container(
                width: 35,
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
            "Partisipan Event",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Spacer(),
          Container(
            width: 35,
          ),
        ],
      ),
    );
  }
}
