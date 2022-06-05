// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, must_be_immutable, sized_box_for_whitespace, unrelated_type_equality_checks

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:passify/constant/color_constant.dart';
import 'package:passify/controllers/forum/detail_community_controller.dart';
import 'package:passify/widgets/general/app_bar.dart';
import 'package:passify/widgets/general/bottomsheet_widget.dart';
import 'package:passify/widgets/general/circle_avatar.dart';
import 'package:passify/widgets/general/dotted_separator.dart';
import 'package:passify/widgets/general/post_card_widget.dart';

class CommunityPage extends StatelessWidget {
  CommunityPage({Key? key}) : super(key: key);
  DetailCommunityController detailCommunityC =
      Get.put(DetailCommunityController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          backgroundColor: Colors.white,
          appBar: detailCommunityC.isLoadingDetail.value ? _appBar() : null,
          body: _body(),
        ));
  }

  PreferredSizeWidget _appBar() {
    return appBar(title: "");
  }

  void handleClick(int value) {
    switch (value) {
      case 0:
        _communityMembers(
            detailCommunityC.memberWaiting, "Permintaan Bergabung");
        break;
      case 1:
        break;
      case 2:
        detailCommunityC.onLeaveCommunity("leave");
        break;
      case 3:
        _formEditCommunity();
        break;
    }
  }

  Widget _body() {
    return Obx(() => !detailCommunityC.isLoadingDetail.value
        ? NestedScrollView(
            controller: detailCommunityC.controller,
            physics: BouncingScrollPhysics(),
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              SliverAppBar(
                leadingWidth: 60,
                actions: [
                  PopupMenuButton<int>(
                    child: Container(
                      height: 32,
                      width: 40,
                      margin: EdgeInsets.only(right: 10, top: 14, bottom: 14),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Feather.more_horizontal,
                        color: Colors.black,
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    onSelected: (item) => handleClick(item),
                    itemBuilder: (context) => [
                      PopupMenuItem<int>(value: 1, child: Text('Laporkan')),
                      detailCommunityC.isCreator.value
                          ? PopupMenuItem<int>(
                              value: 0, child: Text('Permintaan Gabung'))
                          : detailCommunityC.isMember.value
                              ? PopupMenuItem<int>(
                                  value: 2, child: Text('Keluar Komunitas'))
                              : PopupMenuItem<int>(value: 4, child: Text('')),
                      detailCommunityC.isCreator.value
                          ? PopupMenuItem<int>(
                              value: 3, child: Text('Edit Komunitas'))
                          : PopupMenuItem<int>(value: 4, child: Text('')),
                    ],
                  ),
                ],
                leading: AnimatedOpacity(
                  duration: Duration(milliseconds: 100),
                  opacity: 1,
                  child: GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: Container(
                      margin: EdgeInsets.only(
                          left: 10, top: 14, bottom: 14, right: 10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Feather.arrow_left,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: ShaderMask(
                      blendMode: BlendMode.dstIn,
                      shaderCallback: (Rect bounds) {
                        return LinearGradient(
                          begin: Alignment.center,
                          end: Alignment.bottomCenter,
                          colors: [Colors.black, Colors.transparent],
                        ).createShader(
                            Rect.fromLTRB(0, 0, bounds.width, bounds.height));
                      },
                      child: Obx(
                        () => detailCommunityC.detailCommunity[0].photo == ""
                            ? Container(
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                        begin: Alignment.bottomLeft,
                                        end: Alignment.topRight,
                                        colors: [
                                      AppColors.primaryColor,
                                      AppColors.accentColor.withOpacity(0.8)
                                    ])),
                                child: Center(
                                  child: Image(
                                      image: AssetImage(
                                          "assets/images/logo_icon.png")),
                                ),
                              )
                            : CachedNetworkImage(
                                imageUrl: detailCommunityC
                                    .detailCommunity[0].photo
                                    .toString(),
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
                              ),
                      )),
                  centerTitle: true,
                  collapseMode: CollapseMode.parallax,
                  title: Obx(() => AnimatedContainer(
                        duration: Duration(milliseconds: 100),
                        child: Padding(
                          padding: detailCommunityC.isExtends.value
                              ? EdgeInsets.symmetric(horizontal: 0)
                              : EdgeInsets.symmetric(horizontal: 50),
                          child: Text(
                            detailCommunityC.detailCommunity[0].name.toString(),
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      )),
                ),
                automaticallyImplyLeading: true,
                toolbarHeight: 70,
                elevation: 1,
                expandedHeight: 230,
                backgroundColor: Colors.white,
                pinned: true,
              ),
            ],
            body: Obx(() => RefreshIndicator(
                  onRefresh: () {
                    HapticFeedback.vibrate();
                    return detailCommunityC.onGetData();
                  },
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics()),
                    child: Container(
                        alignment: Alignment.topLeft,
                        child: Column(
                          children: [
                            _infoCommunity(),
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
                            _content(),
                          ],
                        )),
                  ),
                )),
          )
        : Center(child: CircularProgressIndicator()));
  }

  Widget _infoCommunity() {
    var data = detailCommunityC.detailCommunity[0];
    var member = detailCommunityC.memberCommunity;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Feather.map_pin,
                color: AppColors.primaryColor,
                size: 13,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                data.city.toString() + ", " + data.province.toString(),
                style: GoogleFonts.poppins(
                    fontSize: 12, fontWeight: FontWeight.w400),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Feather.user,
                color: AppColors.primaryColor,
                size: 13,
              ),
              SizedBox(
                width: 5,
              ),
              Row(
                children: [
                  Text(
                    "Ketua Komunitas : ",
                    style: GoogleFonts.poppins(
                        fontSize: 12, fontWeight: FontWeight.w400),
                  ),
                  Text(
                    detailCommunityC.nameUser.toString(),
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                        fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Feather.users,
                color: AppColors.primaryColor,
                size: 13,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                detailCommunityC.memberCommunity.length.toString() + " Anggota",
                style: GoogleFonts.poppins(
                    fontSize: 12, fontWeight: FontWeight.w400),
              ),
              Spacer(),
              GestureDetector(
                onTap: () => _communityMembers(
                    detailCommunityC.memberCommunity, "Anggota Komunitas"),
                child: Text(
                  "Lihat Semua",
                  style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primaryColor),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: 30,
            child: Row(
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: member.length > 7 ? 7 : member.length,
                  itemBuilder: (context, index) {
                    return Align(
                      widthFactor: 0.7,
                      child: CircleAvatar(
                        radius: 18,
                        backgroundColor: AppColors.inputBoxColor,
                        child: circleAvatar(
                            imageData: member[index].photo.toString(),
                            nameData: member[index].name.toString(),
                            size: 15),
                      ),
                    );
                  },
                ),
                if (member.length > 7)
                  Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: Text(
                      '+${member.length - 7}',
                      style: GoogleFonts.poppins(
                          color: Colors.black45,
                          fontWeight: FontWeight.w600,
                          fontSize: 16),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
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
            detailCommunityC.detailCommunity[0].description.toString(),
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

  Widget _content() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: !detailCommunityC.isMember.value
          ? detailCommunityC.isRequestJoin.value
              ? Container(
                  height: 200,
                  child: Column(
                    children: [
                      Container(
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: AppColors.lightGrey, elevation: 0.5),
                          onPressed: () =>
                              detailCommunityC.onLeaveCommunity("cancel"),
                          child: Center(
                            child: Text(
                              'Batal Bergabung',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.black54,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(child: Container())
                    ],
                  ),
                )
              : Container(
                  height: 200,
                  child: Column(
                    children: [
                      Container(
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: AppColors.primaryColor, elevation: 0.5),
                          onPressed: () => detailCommunityC.onJoinCommunity(),
                          child: Center(
                            child: Text(
                              'Gabung Komunitas',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(child: Container())
                    ],
                  ),
                )
          : Column(
              children: [
                Row(
                  children: [
                    Material(
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        splashColor: Colors.red,
                        onTap: () => detailCommunityC.isDiscusion.value = true,
                        child: Ink(
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: detailCommunityC.isDiscusion.value
                                    ? Colors.grey.shade700
                                    : Colors.grey.shade200),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 7, horizontal: 20),
                              child: Center(
                                child: Text(
                                  "Diskusi",
                                  style: GoogleFonts.poppins(
                                      color: detailCommunityC.isDiscusion.value
                                          ? Colors.white
                                          : AppColors.textColor,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500),
                                  textAlign: TextAlign.justify,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () => detailCommunityC.isDiscusion.value = false,
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: detailCommunityC.isDiscusion.value
                                ? Colors.grey.shade200
                                : Colors.grey.shade700),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 7, horizontal: 20),
                          child: Center(
                            child: Text(
                              "Jual - beli",
                              style: GoogleFonts.poppins(
                                  color: detailCommunityC.isDiscusion.value
                                      ? AppColors.textColor
                                      : Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500),
                              textAlign: TextAlign.justify,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                detailCommunityC.isDiscusion.value ? _disccusion() : _fjb()
              ],
            ),
    );
  }

  List post = [
    {'foto': "", 'name': 'Taesei Marukawa'},
    {'foto': "ada", 'name': 'Gilang Ahmad Chaeral'},
    {'foto': "", 'name': 'Leonel Messi'},
    {'foto': "ada", 'name': 'Adama Traore'},
    {'foto': "", 'name': 'Mark Marques'},
    {'foto': "ada", 'name': 'Valentino Jebret'}
  ];

  Widget _disccusion() {
    return Column(
      children: [
        SizedBox(
          height: 15,
        ),
        InkWell(
          onTap: () => _formCreatePost(),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            alignment: Alignment.centerLeft,
            width: Get.width,
            height: 45,
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 2,
                    offset: Offset(0, 0), // changes position of shadow
                  )
                ],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade50, width: 2)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                "Apa yang ingin anda diskusikan ?",
                style: GoogleFonts.poppins(
                    color: Colors.grey.shade500,
                    fontSize: 12,
                    fontWeight: FontWeight.w500),
                textAlign: TextAlign.justify,
              ),
            ),
          ),
        ),
        detailCommunityC.dataDisccusion.isEmpty
            ? Center(
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Belum ada postingan",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                          color: AppColors.tittleColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                    Text(
                      "Silahkan refresh halaman atau buat postingan anda",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                          color: Colors.grey.shade400,
                          fontSize: 12,
                          fontWeight: FontWeight.w500),
                    ),
                    Container(height: 400)
                  ],
                ),
              )
            : ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(vertical: 15),
                itemCount: detailCommunityC.dataDisccusion.length,
                itemBuilder: (context, index) {
                  var data = detailCommunityC.dataDisccusion[index];
                  return postCard(
                      idPost: data.idPost,
                      idUser: data.idUser,
                      title: data.title,
                      price: data.price,
                      status: data.status,
                      name: data.name,
                      username: data.username,
                      photoUser: data.photoUser,
                      caption: data.caption,
                      photo: data.photo,
                      category: data.category,
                      comment: data.comment);
                }),
      ],
    );
  }

  Widget _fjb() {
    return Column(
      children: [
        SizedBox(
          height: 15,
        ),
        InkWell(
          onTap: () => _formCreatePost(),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            alignment: Alignment.centerLeft,
            width: Get.width,
            height: 45,
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 2,
                    offset: Offset(0, 0), // changes position of shadow
                  )
                ],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade50, width: 2)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                "Apa yang ingin anda jual ?",
                style: GoogleFonts.poppins(
                    color: Colors.grey.shade500,
                    fontSize: 12,
                    fontWeight: FontWeight.w500),
                textAlign: TextAlign.justify,
              ),
            ),
          ),
        ),
        detailCommunityC.dataFjb.isEmpty
            ? Center(
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Belum ada postingan",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                          color: AppColors.tittleColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                    Text(
                      "Silahkan refresh halaman atau buat postingan anda",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                          color: Colors.grey.shade400,
                          fontSize: 12,
                          fontWeight: FontWeight.w500),
                    ),
                    Container(height: 400)
                  ],
                ),
              )
            : ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(vertical: 15),
                itemCount: detailCommunityC.dataFjb.length,
                itemBuilder: (context, index) {
                  var data = detailCommunityC.dataFjb[index];
                  var number = "";
                  if (data.noHp.toString() != "" &&
                      data.noHp.toString()[0] == "0") {
                    number = (data.noHp)!.substring(1);
                  } else {
                    number = data.noHp.toString();
                  }
                  return postCard(
                      idPost: data.idPost,
                      idUser: data.idUser,
                      title: data.title,
                      price: data.price,
                      status: data.status,
                      name: data.name,
                      username: data.username,
                      photoUser: data.photoUser,
                      caption: data.caption,
                      category: data.category,
                      photo: data.photo,
                      number: number,
                      comment: data.comment);
                }),
      ],
    );
  }

  void _communityMembers(var dataMember, var title) {
    var member = dataMember;
    Get.bottomSheet(
      SafeArea(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Container(
            height: Get.height * 0.92,
            child: Column(
              children: [
                _actionBar(title),
                Expanded(
                  child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      itemCount: member.length,
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
                                      imageData: member[index].photo,
                                      nameData: member[index].name.toString(),
                                      size: 20),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Container(
                                    width: Get.width - 160,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          member[index].name.toString(),
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.poppins(
                                              color: AppColors.tittleColor,
                                              height: 1.2,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        Text(
                                          member[index].username.toString(),
                                          overflow: TextOverflow.ellipsis,
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
                                  Obx(() => detailCommunityC
                                              .detailCommunity[0].idUser ==
                                          member[index].idUser
                                      ? Text(
                                          "Pembuat",
                                          style: GoogleFonts.poppins(
                                              height: 1.2,
                                              color: Colors.grey.shade500,
                                              fontStyle: FontStyle.normal,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400),
                                        )
                                      : SizedBox()),
                                  title == "Permintaan Bergabung"
                                      ? Container(
                                          width: 60,
                                          color: Colors.transparent,
                                          child: Row(
                                            children: [
                                              InkWell(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                child: Icon(Feather.check),
                                                onTap: () => detailCommunityC
                                                    .onAccMember(
                                                        member[index].idUser),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              InkWell(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                child: Icon(Feather.x),
                                                onTap: () => detailCommunityC
                                                    .onRejectMember(
                                                        member[index].idUser),
                                              )
                                            ],
                                          ),
                                        )
                                      : SizedBox()
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

  Widget _actionBar(var title) {
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
            title,
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

  // BOTTOMSHEET CREATE COMMUNITY
  void _formCreatePost() {
    Get.bottomSheet(
      SafeArea(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Container(
            height: Get.height * 0.92,
            child: Column(
              children: [
                _actionBar2("Postingan"),
                Expanded(
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics()),
                    child: Form(
                      key: detailCommunityC.formKeyPost,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(height: 20),
                          _bannerImage(),
                          _formTitle(),
                          _formPrice(),
                          _formNoHp(),
                          _formCaption(),
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
          onTap: (() => detailCommunityC.pickImage()),
          child: Container(
            height: Get.height * 0.25,
            width: Get.width,
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12)),
            child: detailCommunityC.selectedImagePath.value == ''
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
                              File(detailCommunityC.selectedImagePath.value)),
                          fit: BoxFit.cover,
                          height: Get.height * 0.25,
                          width: Get.width,
                        ),
                        Positioned(
                            top: 5,
                            right: 5,
                            child: GestureDetector(
                              onTap: () {
                                detailCommunityC.selectedImagePath.value = '';
                                detailCommunityC.urlImage.value = '';
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

  Widget _formTitle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: TextFormField(
        onChanged: (text) => {},
        keyboardType: TextInputType.name,
        textInputAction: TextInputAction.next,
        enabled: true,
        decoration:
            InputDecoration(hintText: "Judul", fillColor: Colors.grey.shade100),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Masukkan judul dahulu';
          }
          return null;
        },
        controller: detailCommunityC.titleFC,
      ),
    );
  }

  Widget _formCaption() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: TextFormField(
        onChanged: (text) => {},
        keyboardType: TextInputType.name,
        textInputAction: TextInputAction.newline,
        enabled: true,
        maxLines: 6,
        minLines: 5,
        decoration: InputDecoration(
            hintText: "Masukkan caption...", fillColor: Colors.grey.shade100),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Masukkan caption dahulu';
          }
          return null;
        },
        controller: detailCommunityC.captionFC,
      ),
    );
  }

  Widget _formPrice() {
    return detailCommunityC.isDiscusion.value
        ? SizedBox()
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: TextFormField(
                onChanged: (text) => {},
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                enabled: true,
                decoration: InputDecoration(
                    hintText: "Harga", fillColor: Colors.grey.shade100),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan harga terlebih dahulu';
                  }
                  return null;
                },
                controller: detailCommunityC.priceFC),
          );
  }

  Widget _formNoHp() {
    return detailCommunityC.isDiscusion.value
        ? SizedBox()
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: TextFormField(
                onChanged: (text) => {},
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                enabled: true,
                decoration: InputDecoration(
                    hintText: "Nomor Whatsapp (Opsional)",
                    fillColor: Colors.grey.shade100),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: detailCommunityC.noHpFC),
          );
  }

  Widget _actionBar2(String tab) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      alignment: Alignment.center,
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              tab == "Postingan"
                  ? detailCommunityC.onClearFC()
                  : detailCommunityC.onClearFC();
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
              detailCommunityC.onPrepareCreatePost();
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

  void _formEditCommunity() {
    detailCommunityC.onGetProvince();
    Get.bottomSheet(
      SafeArea(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Container(
            height: Get.height * 0.92,
            child: Column(
              children: [
                _actionBar("Edit Komunitas"),
                Expanded(
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics()),
                    child: Form(
                      key: detailCommunityC.formKeyEdit,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(height: 20),
                          _bannerImage2(),
                          _formCommunityName(),
                          _formProvinsiCommunity(),
                          _formCityCommunity(),
                          _formCommunityDesc(),
                          SizedBox(height: 15),
                          _btnSaveEdit()
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

  Widget _bannerImage2() {
    return Obx(() => Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: (() => detailCommunityC.pickImageEdit()),
              child: Container(
                height: Get.height * 0.25,
                width: Get.width,
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12)),
                child: detailCommunityC.selectedImagePathEdit.value == ''
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: CachedNetworkImage(
                          imageUrl: detailCommunityC.detailCommunity[0].photo
                              .toString(),
                          width: Get.width,
                          fit: BoxFit.cover,
                          errorWidget: (context, url, error) => Center(
                              child: Icon(
                            Feather.camera,
                            color: Colors.grey.shade400,
                            size: 28,
                          )),
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
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Stack(
                          children: [
                            Image(
                              image: FileImage(File(detailCommunityC
                                  .selectedImagePathEdit.value)),
                              fit: BoxFit.cover,
                              height: Get.height * 0.25,
                              width: Get.width,
                            ),
                            Positioned(
                                top: 5,
                                right: 5,
                                child: GestureDetector(
                                  onTap: () {
                                    detailCommunityC
                                        .selectedImagePathEdit.value = '';
                                    detailCommunityC.urlImageEdit.value = '';
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
            ),
            detailCommunityC.detailCommunity[0].photo != ""
                ? GestureDetector(
                    onTap: () => detailCommunityC.onDeleteImage(),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Hapus Foto Komunitas",
                        style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.primaryColor),
                      ),
                    ),
                  )
                : SizedBox(
                    height: 0,
                  ),
          ],
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
        controller: detailCommunityC.nameFC
          ..text = detailCommunityC.detailCommunity[0].name.toString(),
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
              controller: detailCommunityC.provinsiFC
                ..text =
                    detailCommunityC.detailCommunity[0].province.toString()),
          onTap: () {
            detailCommunityC.dataProvinsi.isNotEmpty
                ? BottomSheetList(
                    ListView.builder(
                        physics: BouncingScrollPhysics(),
                        itemCount: detailCommunityC.dataProvinsi.length,
                        padding: EdgeInsets.all(15),
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              detailCommunityC.provinsiFC.text =
                                  detailCommunityC.dataProvinsi[index].nama
                                      .toString();
                              detailCommunityC.cityFC.text = '';
                              detailCommunityC.cityFC.clear();
                              detailCommunityC.dataCity.clear();
                              detailCommunityC.onGetCity(detailCommunityC
                                  .dataProvinsi[index].id
                                  .toString());
                              Get.back();
                            },
                            child: Container(
                              margin: EdgeInsets.only(bottom: 15),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    detailCommunityC.dataProvinsi[index].nama
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
                : detailCommunityC.onGetProvince();
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
              controller: detailCommunityC.cityFC
                ..text = detailCommunityC.detailCommunity[0].city.toString()),
          onTap: () {
            detailCommunityC.dataCity.isNotEmpty
                ? BottomSheetList(
                    ListView.builder(
                        physics: BouncingScrollPhysics(),
                        itemCount: detailCommunityC.dataCity.length,
                        padding: EdgeInsets.all(15),
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              detailCommunityC.cityFC.text = detailCommunityC
                                  .dataCity[index].nama
                                  .toString();
                              Get.back();
                            },
                            child: Container(
                              margin: EdgeInsets.only(bottom: 15),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    detailCommunityC.dataCity[index].nama
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
          keyboardType: TextInputType.text,
          maxLines: 6,
          minLines: 5,
          textInputAction: TextInputAction.done,
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
          controller: detailCommunityC.descriptionFC
            ..text =
                detailCommunityC.detailCommunity[0].description.toString()),
    );
  }

  Widget _btnSaveEdit() {
    return Container(
      width: Get.width * 0.6,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            primary: AppColors.primaryColor, elevation: 0.5),
        onPressed: () => detailCommunityC.onPrepareEditCommunity(),
        child: Center(
          child: Text(
            'Simpan',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
