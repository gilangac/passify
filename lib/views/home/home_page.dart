// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, unrelated_type_equality_checks, sized_box_for_whitespace, prefer_const_literals_to_create_immutables

import 'package:animate_do/animate_do.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:passify/constant/color_constant.dart';
import 'package:passify/controllers/home/home_controller.dart';
import 'package:passify/routes/pages.dart';
import 'package:passify/widgets/general/circle_avatar.dart';
import 'package:passify/widgets/general/event_widget.dart';

final List<String> imgList = [
  'https://firebasestorage.googleapis.com/v0/b/passify-app-347b7.appspot.com/o/UTSSport_Hero_TEST_Landscape-1536x1143.jpg?alt=media&token=dd016e59-98cd-41b5-8fd8-2182a2862573',
  'https://firebasestorage.googleapis.com/v0/b/passify-app-347b7.appspot.com/o/Youth-soccer-indiana.jpg?alt=media&token=889db024-72e3-4a51-ba1c-a1d9eab1e5d6',
  'https://firebasestorage.googleapis.com/v0/b/passify-app-347b7.appspot.com/o/csm_22095_fussball_92c034a746.jpg?alt=media&token=1d6cf0f6-0111-4cb1-9876-a7cf200cab1d',
  'https://firebasestorage.googleapis.com/v0/b/passify-app-347b7.appspot.com/o/Untitled.png?alt=media&token=0b7bd39d-30ac-4e48-987f-c5e6292c5069',
];

final List<Widget> imageSliders = imgList
    .map((item) => Container(
          child: Container(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  child: Stack(
                    children: [
                      Image.network(item, fit: BoxFit.cover, width: 1000.0),
                      Container(
                        width: Get.width,
                        height: Get.height * 0.18,
                        color: AppColors.primaryColor.withOpacity(0.3),
                        child: Padding(
                          padding: const EdgeInsets.all(25.0),
                          child: Center(
                            child: Text(
                                "Komunitas Hobi, Tempat Diskusi Tentang Hobi Bersama Temanmu",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                )),
                          ),
                        ),
                      ),
                    ],
                  )),
            ),
          ),
        ))
    .toList();

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);
  final HomeController homeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [_body()],
      ),
    );
  }

  Widget _header() {
    final dataUser = homeController.dataUser[0];
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(dataUser.name.toString(),
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    height: 1,
                    fontWeight: FontWeight.w600,
                  )),
              Text(dataUser.username.toString(),
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    height: 1.5,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w400,
                  )),
            ],
          ),
          circleAvatar(
              imageData: dataUser.photo.toString(),
              nameData: dataUser.name.toString(),
              size: 25)
        ],
      ),
    );
  }

  Widget _body() {
    return Expanded(
      child: Obx(() => !homeController.isLoading
          ? RefreshIndicator(
              onRefresh: homeController.onRefreshData,
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: [
                    _header(),
                    _carousel(),
                    SizedBox(height: 10),
                    _categories(),
                    SizedBox(height: 25),
                    _recomendedCommunity(),
                    SizedBox(height: 25),
                    _eventSchedule()
                  ],
                ),
              ),
            )
          : Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )),
    );
  }

  Widget _carousel() {
    return FadeInDown(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Container(
                child: CarouselSlider(
                    carouselController: homeController.carouselController,
                    options: CarouselOptions(
                        height: Get.height * 0.17,
                        autoPlay: true,
                        viewportFraction: 1.0,
                        enlargeCenterPage: true,
                        autoPlayInterval: Duration(seconds: 7),
                        autoPlayAnimationDuration: Duration(milliseconds: 800),
                        onPageChanged: (index, reason) {
                          homeController.currentCarousel.value = index;
                        }),
                    items: imageSliders),
              ),
            ),
            Obx(() => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: imgList.asMap().entries.map((entry) {
                    return GestureDetector(
                      onTap: () => homeController.carouselController
                          .animateToPage(entry.key),
                      child: Container(
                        width: 8.0,
                        height: 8.0,
                        margin: EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 4.0),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: homeController.currentCarousel == entry.key
                                ? AppColors.primaryColor
                                : AppColors.grey),
                      ),
                    );
                  }).toList(),
                )),
          ],
        ),
      ),
    );
  }

  Widget _categories() {
    final c1 = homeController.c1.value;
    final c2 = homeController.c2.value;
    final c3 = homeController.c3.value;
    final c4 = homeController.c4.value;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Kategori',
                style: GoogleFonts.poppins(
                    color: AppColors.tittleColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
              Spacer(),
              GestureDetector(
                onTap: () => Get.toNamed(AppPages.CATEGORIES),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border:
                          Border.all(color: AppColors.primaryColor, width: 1)),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      'Lihat Semua',
                      style: GoogleFonts.poppins(
                          color: AppColors.primaryColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Column(
            children: [
              Row(
                children: [
                  _iconCategories(c1),
                  Spacer(),
                  _iconCategories(c2),
                  Spacer(),
                  _iconCategories(c3),
                  Spacer(),
                  _iconCategories(c4),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _iconCategories(int index) {
    return GestureDetector(
      onTap: () => Get.toNamed(
          AppPages.HOBBY +
              homeController.items[index]["path"].toString().toLowerCase(),
          arguments: homeController.items[index]["name"]),
      child: FadeInDown(
        child: Container(
          width: 70,
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(360.0),
                child: Container(
                  height: 60,
                  width: 60,
                  color: AppColors.accentBoxColor,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 7),
                    child: Container(
                      height: 65,
                      child: Image.asset(
                        'assets/images/categories/' +
                            homeController.items[index]["icon"],
                        alignment: Alignment.center,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              AutoSizeText(homeController.items[index]["name"],
                  maxLines: 1,
                  minFontSize: 12,
                  style: GoogleFonts.poppins(
                      fontSize: 12, fontWeight: FontWeight.w400))
            ],
          ),
        ),
      ),
    );
  }

  Widget _recomendedCommunity() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Text(
            'Rekomendasi Komunitas',
            style: GoogleFonts.poppins(
                color: AppColors.tittleColor,
                fontSize: 16,
                fontWeight: FontWeight.w600),
          ),
        ),
        SizedBox(
          height: 15,
        ),
        FadeInRight(
          child: Container(
              height: 135,
              child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: imgList.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Stack(
                          children: [
                            Container(
                              color: Colors.grey.shade200,
                              width: 200,
                              height: 135,
                              child: Image.network(
                                imgList[index].toString(),
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                                top: 7,
                                right: 7,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Container(
                                    height: Get.height * 0.03,
                                    color: Colors.black.withOpacity(0.6),
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8),
                                        child: Text(
                                          'Futsal',
                                          style: GoogleFonts.poppins(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                )),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                color: Colors.black.withOpacity(0.7),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(8, 5, 8, 8),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Komunitas Futsal Madiun',
                                        style: GoogleFonts.poppins(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white),
                                      ),
                                      Text(
                                        'Madiun',
                                        style: GoogleFonts.poppins(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white),
                                      ),
                                      Text(
                                        '25 Anggota',
                                        style: GoogleFonts.poppins(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  })),
        ),
      ],
    );
  }

  Widget _eventSchedule() {
    return Container(
      width: Get.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Text(
              'Jadwal Event',
              style: GoogleFonts.poppins(
                  color: AppColors.tittleColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w600),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          FadeInRight(
            child: ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(horizontal: 25),
                physics: NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemCount: imgList.length,
                itemBuilder: (context, index) {
                  return eventCard();
                }),
          ),
        ],
      ),
    );
  }
}
