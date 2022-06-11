import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:passify/constant/color_constant.dart';
import 'package:passify/controllers/search/search_controller.dart';
import 'package:passify/models/post.dart';
import 'package:passify/widgets/general/app_bar.dart';
import 'package:passify/widgets/general/post_card_widget.dart';

class DetailTrend extends StatelessWidget {
  SearchController searchController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          appBar: _appBar(),
          body: _body(),
          backgroundColor: Colors.white,
        ));
  }

  PreferredSizeWidget _appBar() {
    return appBar(title: Get.arguments.toString(), canBack: false);
  }

  Widget _body() {
    var dataTrend = <PostModel>[].obs;
    dataTrend.value = searchController.dataPost
        .where((data) => data.caption!
            .toString()
            .toLowerCase()
            .contains(Get.arguments.toString().toLowerCase()))
        .toList();
    return RefreshIndicator(
      onRefresh: () {
        HapticFeedback.lightImpact();
        return searchController.onGetCommunityMember();
      },
      child: searchController.dataPost.isEmpty
          ? SingleChildScrollView(
              physics: BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              child: Center(
                child: Column(
                  children: [
                    SizedBox(
                      height: 200,
                    ),
                    LottieBuilder.asset("assets/json/empty_data.json",
                        height: 180),
                    Text(
                      "Belum ada data postingan",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                          color: AppColors.tittleColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 200,
                    ),
                  ],
                ),
              ),
            )
          : ListView.builder(
              physics: BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              padding: EdgeInsets.all(25),
              itemCount: dataTrend.length,
              itemBuilder: (context, index) {
                var data = dataTrend[index];
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
                    idCommunity: data.idCommunity.toString(),
                    category: data.category,
                    date: data.date!.toDate(),
                    comment: data.comment);
              }),
    );
  }
}
