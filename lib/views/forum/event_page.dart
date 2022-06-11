// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:passify/constant/color_constant.dart';
import 'package:passify/controllers/forum/detail_event_controller.dart';
import 'package:intl/intl.dart';
import 'package:passify/helpers/dialog_helper.dart';
import 'package:passify/routes/pages.dart';
import 'package:passify/services/service_timeago.dart';
import 'package:passify/widgets/general/app_bar.dart';
import 'package:passify/widgets/general/circle_avatar.dart';
import 'package:passify/widgets/general/comment_widget.dart';
import 'package:passify/widgets/general/dotted_separator.dart';
import 'package:passify/widgets/post/form_edit_post.dart';
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
        ? Center(child: CircularProgressIndicator())
        : Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () => detailEventController.OnRefresh(),
                  child: SingleChildScrollView(
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
                      detailEventController.detailEvent[0].idEvent!, detailEventController.detailEvent[0].name!,detailEventController.detailEvent[0].description!, "", "event");
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
                            title: "Laporkan",
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
              formCreateEvent();
            } else if (type == 'report') {
              DialogHelper.showConfirm(
                  title: "Laporkan Event",
                  description: "Apakah anda yakin akan melaporkan event ini?",
                  action: () => detailEventController.onReportEvent(),
                  titlePrimary: "Laporkan",
                  titleSecondary: "Batal");
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
