// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:passify/constant/color_constant.dart';
import 'package:passify/controllers/forum/forum_controller.dart';
import 'package:passify/widgets/general/app_bar.dart';
import 'package:passify/widgets/general/post_card_widget.dart';
import 'package:get/get.dart';

List post = [
  {'foto': "", 'name': 'Taesei Marukawa'},
  {'foto': "ada", 'name': 'Gilang Ahmad Chaeral'},
  {'foto': "", 'name': 'Leonel Messi'},
  {'foto': "ada", 'name': 'Adama Traore'},
  {'foto': "", 'name': 'Mark Marques'},
  {'foto': "ada", 'name': 'Valentino Jebret'}
];

class ForumPage extends StatelessWidget {
  ForumPage({Key? key}) : super(key: key);
  ForumController forumController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          appBar: _appBar(),
          body: _body(),
          backgroundColor: Colors.white,
        ));
  }

  PreferredSizeWidget _appBar() {
    return appBar(title: "Forum Komunitas", canBack: false);
  }

  Widget _body() {
    return forumController.isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : RefreshIndicator(
            onRefresh: () {
              HapticFeedback.lightImpact();
              return forumController.onGetCommunityMember();
            },
            child: forumController.dataPost.isEmpty
                ? SingleChildScrollView(
                    physics: BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics()),
                    child: Center(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 150,
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
                    itemCount: forumController.dataPost.length,
                    itemBuilder: (context, index) {
                      var data = forumController.dataPost[index];
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
          );
  }
}
