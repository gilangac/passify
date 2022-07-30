// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:passify/constant/color_constant.dart';
import 'package:passify/controllers/forum/detail_event_controller.dart';
import 'package:intl/intl.dart';
import 'package:passify/helpers/dialog_helper.dart';
import 'package:passify/routes/pages.dart';
import 'package:passify/services/service_additional.dart';
import 'package:passify/views/forum/maps_new_event_page.dart';
import 'package:passify/widgets/general/app_bar.dart';
import 'package:passify/widgets/general/circle_avatar.dart';
import 'package:passify/widgets/general/comment_widget.dart';
import 'package:passify/widgets/general/dotted_separator.dart';
import 'package:passify/widgets/post/form_edit_post.dart';
import 'package:passify/widgets/shimmer/detail_event_shimmer.dart';
import 'package:share_plus/share_plus.dart';

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
    return appBar(title: "Detail Event", actions: [
      Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 14, 0),
        child: Container(
            alignment: Alignment.center,
            child: GestureDetector(
                onTap: () => _bottomSheetContent(
                    detailEventController.detailEvent[0].idUser),
                child: Icon(Feather.more_horizontal))),
      )
    ]);
  }

  Widget _body() {
    return Obx(() => detailEventController.isLoadingDetail
        ? Center(child: DetailEventShimmer())
        : Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () => detailEventController.OnRefresh(),
                  child: SingleChildScrollView(
                    controller: detailEventController.scrollController,
                    physics: BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics()),
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
                        _buttonFollow(),
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
          GestureDetector(
            onTap: () => Get.toNamed(
                AppPages.PROFILE_PERSON +
                    detailEventController.userEvent[0].idUser.toString(),
                arguments:
                    detailEventController.userEvent[0].idUser.toString()),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                circleAvatar(
                    imageData: detailEventController.userEvent[0].photo,
                    nameData:
                        detailEventController.userEvent[0].name.toString(),
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

  Widget _buttonFollow() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Center(
        child: Container(
          width: Get.width * 0.8,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: detailEventController.isFollow.value
                  ? Colors.transparent
                  : AppColors.primaryColor,
              border: Border.all(color: AppColors.primaryColor, width: 1)),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              splashColor: detailEventController.isFollow.value
                  ? AppColors.primaryColor.withOpacity(0.5)
                  : Colors.grey.shade200.withOpacity(0.5),
              highlightColor: detailEventController.isFollow.value
                  ? AppColors.primaryColor.withOpacity(0.5)
                  : Colors.grey.shade200.withOpacity(0.5),
              onTap: () {
                if (detailEventController.isFollow.value) {
                  detailEventController.onUnfollowEvent();
                } else {
                  detailEventController.onFollowEvent();
                }
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Center(
                  child: Text(
                    detailEventController.isFollow.value
                        ? 'Mengikuti Event'
                        : 'Ikuti Event',
                    style: GoogleFonts.poppins(
                        color: detailEventController.isFollow.value
                            ? AppColors.primaryColor
                            : Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
          ),
        ),
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
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Feather.map_pin,
                    size: 15,
                    color: AppColors.primaryColor,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    width: Get.width * 0.825,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          detailEventController.detailEvent[0].location
                              .toString(),
                          maxLines: 5,
                          style: GoogleFonts.poppins(
                              color: AppColors.tittleColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w500),
                        ),
                        Row(
                          children: [
                            Container(
                              width: Get.width * 0.6,
                              child: Text(
                                "(${detailEventController.detailEvent[0].locationDesc.toString()})",
                                maxLines: 5,
                                style: GoogleFonts.poppins(
                                    color: AppColors.tittleColor,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            Spacer(),
                            GestureDetector(
                              onTap: () => MapsLauncher.launchCoordinates(
                                  double.parse(detailEventController
                                      .detailEvent[0].latitude
                                      .toString()),
                                  double.parse(detailEventController
                                      .detailEvent[0].longitude
                                      .toString()),
                                  detailEventController
                                      .detailEvent[0].locationDesc),
                              child: Text(
                                "Lihat di maps",
                                maxLines: 5,
                                style: GoogleFonts.poppins(
                                    color: AppColors.primaryColor,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
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
                    DateFormat("EEEE, dd MMMM yyyy", "id")
                        .format(detailEventController.detailEvent[0].dateEvent!
                            .toDate())
                        .toString(),
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
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
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
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
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
                          detailEventController.detailEvent[0].member!
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
          Row(
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
              Spacer(),
              GestureDetector(
                onTap: () async {
                  String url = await AppUtils.buildDynamicLink(
                      detailEventController.detailEvent[0].idEvent!,
                      detailEventController.detailEvent[0].name!,
                      detailEventController.detailEvent[0].description!,
                      "",
                      "event");
                  Share.share('${url}');
                },
                child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey.shade100),
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    child: SvgPicture.asset("assets/svg/icon_share.svg",
                        color: Colors.grey.shade400, height: 19)),
              ),
            ],
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
                        idUser:
                            detailEventController.commentEvent[index].idUser,
                        date: detailEventController.commentEvent[index].date,
                        nama: detailEventController.commentEvent[index].name,
                        photo: detailEventController.commentEvent[index].photo,
                        sort: detailEventController.commentEvent[index].sort,
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
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                            color: AppColors.tittleColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                      ),
                      Text(
                        "Jadilah yang pertama mengomentari event ini",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                            color: Colors.grey.shade400,
                            fontSize: 12,
                            fontWeight: FontWeight.w500),
                      ),
                      Container(height: 400)
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
                      onFieldSubmitted: (value) {
                        detailEventController.onPostComment();
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
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
                      itemCount: detailEventController.memberEvent.length,
                      padding: EdgeInsets.all(15),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () => Get.toNamed(
                              AppPages.PROFILE_PERSON +
                                  detailEventController
                                      .memberEvent[index].idUser
                                      .toString(),
                              arguments: detailEventController
                                  .memberEvent[index].idUser
                                  .toString()),
                          child: Container(
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
                                    Container(
                                      width: Get.width * 0.55,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                                    ),
                                    Spacer(),
                                    Obx(() => detailEventController
                                                .memberEvent[index].idUser ==
                                            detailEventController
                                                .detailEvent[0].idUser
                                        ? Text(
                                            "Pembuat",
                                            style: GoogleFonts.poppins(
                                                height: 1.2,
                                                color: Colors.grey.shade500,
                                                fontStyle: FontStyle.normal,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400),
                                          )
                                        : SizedBox(height: 0)),
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

  void _bottomSheetReport() {
    detailEventController.valueRadio.value = 10;
    Get.bottomSheet(
        SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(color: Colors.grey.shade300, width: 35, height: 4),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  child: Text(
                    "Mengapa anda melaporkan event ini?",
                    style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textColor),
                    textAlign: TextAlign.left,
                  ),
                ),
                SizedBox(height: 20),
                _listReport(0),
                _listReport(1),
                _listReport(2),
                _listReport(3),
                Divider(height: 1.5, color: Colors.grey.shade400),
                SizedBox(height: 10),
                SizedBox(height: 13),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  child: _submitReport(),
                )
              ],
            ),
          ),
        ),
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        isDismissible: true,
        enableDrag: true,
        isScrollControlled: true);
  }

  Widget _listReport(
    int index,
  ) {
    var report = [
      "Kekerasan, pelecehan, ancaman, pembakaran atau intimidasi terhadap orang atau organisasi",
      "Terlibat dalam atau berkontribusi pada aktivitas ilegal apa pun yang melanggar hak orang lain",
      "Penggunaan bahasa yang menghina, diskriminatif, atau terlalu vulgar",
      "Memberikan informasi yang salah, menyesatkan atau tidak akurat"
    ];
    return InkWell(
      onTap: () {
        detailEventController.valueRadio.value = index;
        // Get.back();
        // DialogHelper.showConfirm(
        //     title: "Laporkan Event",
        //     description: "Apakah anda yakin akan melaporkan event ini?",
        //     action: () => detailEventController.onReportEvent(index),
        //     titlePrimary: "Laporkan",
        //     titleSecondary: "Batal");
      },
      child: Obx(() => Container(
            width: Get.width,
            child: Column(
              children: [
                Divider(height: 1.5, color: Colors.grey.shade400),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          report[index].toString(),
                          style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: AppColors.textColor),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      // Container(
                      //   width: 18,
                      //   child: Icon(Feather.chevron_right,
                      //       color: Colors.grey.shade400),
                      // )
                      Padding(
                        padding: const EdgeInsets.fromLTRB(12, 0, 0, 0),
                        child: Container(
                          height: 18,
                          width: 18,
                          decoration: BoxDecoration(
                              color: detailEventController.valueRadio.value ==
                                      index
                                  ? AppColors.primaryColor
                                  : Colors.transparent,
                              border: Border.all(
                                  color:
                                      detailEventController.valueRadio.value ==
                                              index
                                          ? AppColors.accentColor
                                          : Colors.grey.shade600,
                                  width: 2),
                              borderRadius: BorderRadius.circular(15)),
                        ),
                      ),
                      // Radio(
                      //   value: index,
                      //   groupValue: detailEventController.valueRadio,
                      //   onChanged: (value) {
                      //     detailEventController.valueRadio.value = value as int;
                      //     print(detailEventController.valueRadio.value);
                      //   },
                      // )
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }

  Widget _submitReport() {
    return Obx(() => Container(
          width: Get.width,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: detailEventController.valueRadio.value == 10
                  ? Colors.grey.shade300
                  : AppColors.primaryColor),
          child: Material(
            child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: detailEventController.valueRadio.value == 10
                    ? null
                    : () {
                        // DialogHelper.showConfirm(
                        //     title: "Laporkan Event",
                        //     description:
                        //         "Apakah anda yakin akan melaporkan event ini?",
                        //     action: () =>
                        detailEventController.onReportEvent(
                            detailEventController.valueRadio.value);
                        // titlePrimary: "Laporkan",
                        // titleSecondary: "Batal");
                      },
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  child: Text(
                    'Laporkan',
                    style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                )),
            color: Colors.transparent,
          ),
        ));
  }

  void _bottomSheetContent(var idUser) {
    String myId = detailEventController.myAccountId.value;
    Get.bottomSheet(
        SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(color: AppColors.lightGrey, width: 35, height: 4),
                SizedBox(height: 30),
                Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey.shade100),
                    child: Column(
                      children: [
                        _listAction(
                            title: "Laporkan Event",
                            path: AppPages.EDIT_PROFILE,
                            type: "report"),
                        myId == idUser
                            ? Column(
                                children: [
                                  Divider(
                                    height: 1,
                                    color: Colors.grey.shade300,
                                  ),
                                  _listAction(
                                      title: "Edit Event",
                                      path: AppPages.HOME,
                                      type: "edit"),
                                  Divider(
                                    height: 1,
                                    color: Colors.grey.shade300,
                                  ),
                                  _deleteAction(),
                                ],
                              )
                            : SizedBox(
                                height: 0,
                              ),
                      ],
                    )),
                SizedBox(height: 13),
                _cancelAction()
              ],
            ),
          ),
        ),
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        isDismissible: true,
        enableDrag: true,
        isScrollControlled: true);
  }

  Widget _listAction({
    required String title,
    required String path,
    String? type,
  }) {
    return Container(
      width: Get.width,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () {
            Get.back();
            if (type == "edit") {
              formEditEvent();
            } else if (type == 'report') {
              detailEventController.valueRadio.value = 10;
              _bottomSheetReport();
              // DialogHelper.showConfirm(
              //     title: "Laporkan Event",
              //     description: "Apakah anda yakin akan melaporkan event ini?",
              //     action: () => detailEventController.onReportEvent(),
              //     titlePrimary: "Laporkan",
              //     titleSecondary: "Batal");
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            child: Text(
              title,
              style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textColor),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  Widget _deleteAction({String? title, String? path}) {
    return Container(
      width: Get.width,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () {
            DialogHelper.showConfirm(
                title: "Hapus Event",
                description: "Apa anda yakin menghapus event ini?",
                titlePrimary: "Hapus",
                titleSecondary: "Batal",
                action: () => detailEventController.onDeleteEvent());
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            child: Text(
              "Hapus Event",
              style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.red.shade500),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  Widget _cancelAction() {
    return Container(
      width: Get.width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: Colors.grey.shade100),
      child: Material(
        child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () => Get.back(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              child: Text(
                'Batal',
                style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textColor),
                textAlign: TextAlign.center,
              ),
            )),
        color: Colors.transparent,
      ),
    );
  }
}

void formEditEvent() {
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
                    key: controller.formKeyEditEvent,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: 20),
                        _formEventName(),
                        _formEventDate(),
                        _formEventTime(),
                        _formEventPickLocation(),
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
      controller: controller.nameFC
        ..text = controller.detailEvent[0].name.toString(),
    ),
  );
}

Widget _formEventPickLocation() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    child: GestureDetector(
      onTap: () {
        Get.to(() => MapsPageNewEvent(), arguments: "edit");
      },
      child: TextFormField(
        onChanged: (text) => {},
        keyboardType: TextInputType.name,
        textInputAction: TextInputAction.next,
        enabled: false,
        onTap: () {
          Get.to(() => MapsPageNewEvent(), arguments: "edit");
        },
        decoration: InputDecoration(
            hintText: "Lokasi",
            suffixIcon: Icon(
              Feather.map_pin,
              color: Colors.grey.shade300,
            )),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Masukkan Nama Event terlebih dahulu';
          }
          return null;
        },
        controller: controller.addressFC
          ..text = controller.detailEvent[0].location.toString(),
      ),
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
        decoration: InputDecoration(hintText: "Deskripsi Lokasi"),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Masukkan Lokasi terlebih dahulu';
          }
          return null;
        },
        controller: controller.locationFC
          ..text = controller.detailEvent[0].locationDesc.toString()),
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
                        use24hFormat: true,
                        dateOrder: DatePickerDateOrder.dmy,
                        minimumDate: DateTime.now(),
                        onDateTimeChanged: (DateTime newDateTime) {
                          controller.dateEvent = newDateTime;
                          controller.dateFC.text =
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
          controller: controller.dateFC
            ..text = DateFormat("EEEE, dd MMMM yyyy", "id")
                .format(controller.detailEvent[0].dateEvent!.toDate())
                .toString()),
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
                                controller.selectedTime.value =
                                    DateFormat("HH.mm ", "id")
                                        .format(newDateTime)
                                        .toString();
                                controller.timeFC.text =
                                    DateFormat("HH.mm ", "id")
                                            .format(newDateTime)
                                            .toString() +
                                        controller.selectedDropdown.value;
                              },
                            ),
                          ),
                          Spacer(),
                          Obx(() => Container(
                                child: DropdownButton<String>(
                                  elevation: 0,
                                  hint: Text(controller.selectedDropdown.value,
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
                                    controller.selectedDropdown.value =
                                        value.toString();
                                    controller.timeFC.text =
                                        controller.selectedTime.value +
                                            controller.selectedDropdown.value;
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
          controller: controller.timeFC
            ..text = controller.detailEvent[0].time.toString()),
    ),
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
        controller: controller.descriptionFC
          ..text = controller.detailEvent[0].description.toString()),
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
          "Edit Event",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Spacer(),
        GestureDetector(
          onTap: () {
            //  controller.onCreateEvent(label)
            controller.onEditEvent();
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
