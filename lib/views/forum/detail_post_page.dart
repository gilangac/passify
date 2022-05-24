// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, avoid_unnecessary_containers, must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:passify/constant/color_constant.dart';
import 'package:passify/controllers/forum/detail_post_controller.dart';
import 'package:passify/routes/pages.dart';
import 'package:passify/widgets/general/app_bar.dart';
import 'package:passify/widgets/general/circle_avatar.dart';
import 'package:passify/widgets/general/comment_widget.dart';
import 'package:passify/widgets/general/dotted_separator.dart';
import 'package:intl/intl.dart';
import 'package:passify/widgets/post/form_edit_post.dart';

class DetailPostPage extends StatelessWidget {
  DetailPostPage({Key? key}) : super(key: key);
  final DetailPostController detailPostC = Get.put(DetailPostController());

  NumberFormat currencyFormatter = NumberFormat.currency(
    locale: 'id',
    symbol: "Rp ",
    decimalDigits: 0,
  );

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
    return appBar(title: "Detail Postingan", actions: [
      Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 14, 0),
        child: Container(
            alignment: Alignment.center,
            child: GestureDetector(
                onTap: () =>
                    _bottomSheetContent(detailPostC.detailPost[0].idUser),
                child: Icon(Feather.more_horizontal))),
      )
    ]);
  }

  Widget _body() {
    return Obx(() => detailPostC.isLoadingDetail
        ? Center(child: CircularProgressIndicator())
        : Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () => detailPostC.OnRefresh(),
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
                        _comment(),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              circleAvatar(
                  imageData: detailPostC.userPost[0].photo,
                  nameData: detailPostC.userPost[0].name.toString(),
                  size: 22),
              SizedBox(
                width: 10,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    detailPostC.userPost[0].name.toString(),
                    style: GoogleFonts.poppins(
                        height: 1.2,
                        color: AppColors.tittleColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600),
                  ),
                  Text(
                    detailPostC.userPost[0].username.toString(),
                    style: GoogleFonts.poppins(
                        height: 1.2,
                        color: Colors.grey.shade500,
                        fontSize: 12,
                        fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ],
          ),
          detailPostC.detailPost[0].category == 'fjb'
              ? Row(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 12,
                        ),
                        Row(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              detailPostC.detailPost[0].title.toString(),
                              style: GoogleFonts.poppins(
                                  color: AppColors.tittleColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600),
                              textAlign: TextAlign.justify,
                              maxLines:
                                  detailPostC.detailPost[0].photo == "" ? 5 : 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 5),
                              alignment: Alignment.center,
                              width: 3,
                              height: 3,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: Colors.grey.shade600,
                              ),
                            ),
                            detailPostC.myAccountId.value ==
                                    detailPostC.detailPost[0].idUser
                                ? GestureDetector(
                                    onTap: () {
                                      Get.defaultDialog(
                                        title: "Status",
                                        content: Container(
                                          child: Column(
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  detailPostC.onChangeStatus(
                                                      "available");
                                                },
                                                child: Text(
                                                  "Tersedia",
                                                  style: GoogleFonts.poppins(
                                                      color:
                                                          AppColors.tittleColor,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                  textAlign: TextAlign.justify,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Divider(
                                                color: Colors.grey,
                                                height: 1,
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  detailPostC
                                                      .onChangeStatus("sold");
                                                },
                                                child: Text(
                                                  "Terjual",
                                                  style: GoogleFonts.poppins(
                                                      color:
                                                          AppColors.tittleColor,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                  textAlign: TextAlign.justify,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                    child: Row(
                                      children: [
                                        Text(
                                          detailPostC.isAvailable
                                              ? "Tersedia"
                                              : "Terjual",
                                          style: GoogleFonts.poppins(
                                              color: Colors.grey.shade600,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400),
                                          textAlign: TextAlign.justify,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Icon(
                                          Feather.chevron_down,
                                          color: Colors.grey.shade600,
                                          size: 20,
                                        )
                                      ],
                                    ),
                                  )
                                : Text(
                                    detailPostC.isAvailable
                                        ? "Tersedia"
                                        : "Terjual",
                                    style: GoogleFonts.poppins(
                                        color: Colors.grey.shade600,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400),
                                    textAlign: TextAlign.justify,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                          ],
                        ),
                        Text(
                          currencyFormatter.format(
                              int.parse(detailPostC.detailPost[0].price!)),
                          style: GoogleFonts.poppins(
                              color: Colors.grey.shade600,
                              height: 1.5,
                              fontSize: 11,
                              fontWeight: FontWeight.w400),
                          textAlign: TextAlign.justify,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    Spacer(),
                    detailPostC.detailPost[0].noHp != ""
                        ? GestureDetector(
                            onTap: () {
                              var number = "";
                              if (detailPostC.detailPost[0].noHp.toString() !=
                                      "" &&
                                  detailPostC.detailPost[0].noHp
                                          .toString()[0] ==
                                      "0") {
                                number = detailPostC.detailPost[0].noHp
                                    .toString()
                                    .substring(1);
                              } else {
                                number =
                                    detailPostC.detailPost[0].noHp.toString();
                              }
                              detailPostC.onLaunchUrl(number);
                            },
                            child: Container(
                              height: 27,
                              width: 27,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(9),
                                color: AppColors.green,
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.green.shade100,
                                      blurRadius: 4,
                                      spreadRadius: 2)
                                ],
                              ),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Icon(FontAwesome.whatsapp,
                                      color: Colors.white, size: 15),
                                ),
                              ),
                            ),
                          )
                        : Container()
                  ],
                )
              : Container(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        detailPostC.detailPost[0].title ?? "",
                        style: GoogleFonts.poppins(
                            color: AppColors.tittleColor,
                            height: 1.5,
                            fontSize: 12,
                            fontWeight: FontWeight.w600),
                        textAlign: TextAlign.justify,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
          SizedBox(
            height: 12,
          ),
          Text(
            detailPostC.detailPost[0].caption.toString(),
            style: GoogleFonts.poppins(
                color: Colors.grey.shade600,
                height: 1.5,
                fontSize: 11,
                fontWeight: FontWeight.w400),
            textAlign: TextAlign.justify,
          ),
          SizedBox(
            height: 12,
          ),
          detailPostC.detailPost[0].photo == ""
              ? SizedBox(
                  height: 0,
                )
              : Column(
                  children: [
                    Container(
                      width: Get.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: CachedNetworkImage(
                          imageUrl: detailPostC.detailPost[0].photo.toString(),
                          width: Get.width,
                          fit: BoxFit.cover,
                          errorWidget: (context, url, error) =>
                              Center(child: Icon(Icons.error)),
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) => Container(
                            color: Colors.white,
                            child: Center(
                              child: CircularProgressIndicator(
                                value: downloadProgress.progress,
                                color: AppColors.primaryColor,
                                strokeWidth: 2,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                  ],
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
            'Komentar (' + detailPostC.commentPost.length.toString() + ')',
            style: GoogleFonts.poppins(
                color: AppColors.tittleColor,
                fontSize: 16,
                fontWeight: FontWeight.w600),
          ),
          dotSeparator(
            color: Colors.grey.shade400,
          ),
          detailPostC.commentPost.isNotEmpty
              ? Column(
                  children: [
                    ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemCount: detailPostC.commentPost.length,
                        itemBuilder: ((context, index) {
                          return commentWidget(
                              comment: detailPostC.commentPost[index].comment
                                  .toString(),
                              nama: detailPostC.commentPost[index].name,
                              photo: detailPostC.commentPost[index].photo,
                              username:
                                  detailPostC.commentPost[index].username);
                        })),
                    Container(height: 400)
                  ],
                )
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
                        "Jadilah yang pertama mengomentari postingan ini",
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
                      controller: detailPostC.commentFC,
                      onChanged: (value) {
                        detailPostC.commentText.value = value;
                      },
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.send,
                      onFieldSubmitted: (value) {
                        detailPostC.onPostComment();
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
                    width: detailPostC.commentText.value != '' ? 10 : 0,
                  ),
                  detailPostC.commentText.value != ''
                      ? GestureDetector(
                          onTap: () {
                            detailPostC.onPostComment();
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

  void _bottomSheetContent(var idUser) {
    String myId = detailPostC.myAccountId.value;
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
                                      title: "Edit Postingan",
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
            type == "edit"
                ? Get.toNamed(AppPages.EDIT_POST + Get.arguments.toString(),
                    arguments: [Get.arguments, "detail"])
                : null;
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
            detailPostC.onConfirmDelete();
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            child: Text(
              "Hapus Postingan",
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
