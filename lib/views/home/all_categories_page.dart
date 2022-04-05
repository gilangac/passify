// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, unrelated_type_equality_checks, sized_box_for_whitespace
import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:passify/constant/color_constant.dart';
import 'package:passify/controllers/home/categories_controller.dart';
import 'package:passify/controllers/home/home_controller.dart';
import 'package:passify/routes/pages.dart';
import 'package:passify/services/service_preference.dart';
import 'package:passify/widgets/general/app_bar.dart';
import 'package:get/get.dart';

class AllCategoriesPage extends StatelessWidget {
  final HomeController homeController = Get.find();
  final categoriesController = Get.put(CategoriesController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: _body(),
    );
  }

  PreferredSizeWidget _appBar() {
    return appBar(title: "Semua Kategori");
  }

  Widget _body() {
    return Obx(() => categoriesController.change == 0
        ? SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [_favoriteCategories(), _otherCategories()],
            ),
          )
        : SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _favoriteCategories2(),
                _otherCategories2(),
                SizedBox(
                  height: 15,
                ),
                _btnSaveChange(),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ));
  }

  Widget _favoriteCategories() {
    final c1 = homeController.c1.value;
    final c2 = homeController.c2.value;
    final c3 = homeController.c3.value;
    final c4 = homeController.c4.value;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Favorit Kategori Hobi',
                    style: GoogleFonts.poppins(
                        fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    '4 Menu favorit yang ada di dashboard Anda',
                    style: GoogleFonts.poppins(
                        fontSize: 10, fontWeight: FontWeight.w400),
                  ),
                ],
              ),
              Spacer(),
              GestureDetector(
                onTap: () => categoriesController.change.value = 1,
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border:
                          Border.all(color: AppColors.primaryColor, width: 1)),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      'Ubah',
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
                  _iconCategories(homeController.items[c1]["icon"],
                      homeController.items[c1]["name"]),
                  Spacer(),
                  _iconCategories(homeController.items[c2]["icon"],
                      homeController.items[c2]["name"]),
                  Spacer(),
                  _iconCategories(homeController.items[c3]["icon"],
                      homeController.items[c3]["name"]),
                  Spacer(),
                  _iconCategories(homeController.items[c4]["icon"],
                      homeController.items[c4]["name"]),
                ],
              ),
              SizedBox(
                height: 20,
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _otherCategories() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Kategori Lainnya',
            style:
                GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          SizedBox(
            height: 15,
          ),
          Container(
            height: 500,
            child: GridView.builder(
                itemCount: homeController.otherItems.length,
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 60,
                    mainAxisExtent: 100,
                    crossAxisSpacing: 24,
                    childAspectRatio: 1 / 6,
                    mainAxisSpacing: 5),
                itemBuilder: (BuildContext ctx, index) {
                  return _iconCategories(
                      homeController.otherItems[index]["icon"],
                      homeController.otherItems[index]["name"]);
                }),
          ),
        ],
      ),
    );
  }

  Widget _iconCategories(String icon, String label) {
    return GestureDetector(
      onTap: () {},
      child: FadeInDown(
        child: Container(
          width: 65,
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
                        'assets/images/categories/' + icon,
                        alignment: Alignment.center,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Text(label,
                  style: GoogleFonts.poppins(
                      fontSize: 12, fontWeight: FontWeight.w400))
            ],
          ),
        ),
      ),
    );
  }

  Widget _favoriteCategories2() {
    final c1 = homeController.c1.value;
    final c2 = homeController.c2.value;
    final c3 = homeController.c3.value;
    final c4 = homeController.c4.value;

    CategoriesController cC = categoriesController;

    cC.changeC1.value = c1;
    cC.changeC2.value = c2;
    cC.changeC3.value = c3;
    cC.changeC4.value = c4;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Favorit Kategori Hobi',
                    style: GoogleFonts.poppins(
                        fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    '4 Menu favorit yang ada di dashboard Anda',
                    style: GoogleFonts.poppins(
                        fontSize: 10, fontWeight: FontWeight.w400),
                  ),
                ],
              ),
              Spacer(),
              GestureDetector(
                onTap: () => categoriesController.onCancle(),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border:
                          Border.all(color: AppColors.primaryColor, width: 1)),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      'Batal',
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
                  Obx(() => cC.changeC1.value != 300
                      ? GestureDetector(
                          onTap: () {
                            categoriesController.onMinFav(
                                homeController.items[cC.changeC1.value]["id"]);
                          },
                          child: Stack(
                            children: [
                              _iconCategories2(
                                  homeController.items[cC.changeC1.value]
                                      ["icon"],
                                  homeController.items[cC.changeC1.value]
                                      ["name"]),
                              Positioned(
                                  top: 1,
                                  right: 1,
                                  child: SvgPicture.asset(
                                    'assets/svg/min.svg',
                                    height: 15,
                                    width: 15,
                                  )),
                              Container(height: 65, width: 65)
                            ],
                          ),
                        )
                      : Column(
                          children: [
                            Container(
                              width: 65,
                              child: Column(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(360.0),
                                    child: Container(
                                      height: 60,
                                      width: 60,
                                      color: AppColors.accentBoxColor,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 7),
                                        child: Container(
                                          height: 65,
                                          child: Center(
                                            child: Icon(
                                              Feather.plus,
                                              color: Colors.white,
                                              size: 20,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text("",
                                style: GoogleFonts.poppins(
                                    fontSize: 12, fontWeight: FontWeight.w400))
                          ],
                        )),
                  Spacer(),
                  Obx(() => cC.changeC2.value != 300
                      ? GestureDetector(
                          onTap: () => cC.changeC2.value = 300,
                          child: Stack(
                            children: [
                              _iconCategories2(
                                  homeController.items[cC.changeC2.value]
                                      ["icon"],
                                  homeController.items[cC.changeC2.value]
                                      ["name"]),
                              Positioned(
                                  top: 1,
                                  right: 1,
                                  child: SvgPicture.asset(
                                    'assets/svg/min.svg',
                                    height: 15,
                                    width: 15,
                                  )),
                              Container(height: 65, width: 65)
                            ],
                          ),
                        )
                      : Column(
                          children: [
                            Container(
                              width: 65,
                              child: Column(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(360.0),
                                    child: Container(
                                      height: 60,
                                      width: 60,
                                      color: AppColors.accentBoxColor,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 7),
                                        child: Container(
                                          height: 65,
                                          child: Center(
                                            child: Icon(
                                              Feather.plus,
                                              color: Colors.white,
                                              size: 20,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text("",
                                style: GoogleFonts.poppins(
                                    fontSize: 12, fontWeight: FontWeight.w400))
                          ],
                        )),
                  Spacer(),
                  Obx(() => cC.changeC3.value != 300
                      ? GestureDetector(
                          onTap: () => cC.changeC3.value = 300,
                          child: Stack(
                            children: [
                              _iconCategories2(
                                  homeController.items[cC.changeC3.value]
                                      ["icon"],
                                  homeController.items[cC.changeC3.value]
                                      ["name"]),
                              Positioned(
                                  top: 1,
                                  right: 1,
                                  child: SvgPicture.asset(
                                    'assets/svg/min.svg',
                                    height: 15,
                                    width: 15,
                                  )),
                              Container(height: 65, width: 65)
                            ],
                          ),
                        )
                      : Column(
                          children: [
                            Container(
                              width: 65,
                              child: Column(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(360.0),
                                    child: Container(
                                      height: 60,
                                      width: 60,
                                      color: AppColors.accentBoxColor,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 7),
                                        child: Container(
                                          height: 65,
                                          child: Center(
                                            child: Icon(
                                              Feather.plus,
                                              color: Colors.white,
                                              size: 20,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text("",
                                style: GoogleFonts.poppins(
                                    fontSize: 12, fontWeight: FontWeight.w400))
                          ],
                        )),
                  Spacer(),
                  _changeFav(),
                ],
              ),
              SizedBox(
                height: 20,
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _changeFav() {
    CategoriesController cC = categoriesController;
    return Obx(() => cC.changeC4.value != 300
        ? GestureDetector(
            onTap: () => cC.changeC4.value = 300,
            child: Stack(
              children: [
                _iconCategories2(
                    homeController.items[cC.changeC4.value]["icon"],
                    homeController.items[cC.changeC4.value]["name"]),
                Positioned(
                    top: 1,
                    right: 1,
                    child: SvgPicture.asset(
                      'assets/svg/min.svg',
                      height: 15,
                      width: 15,
                    )),
                Container(height: 65, width: 65)
              ],
            ),
          )
        : Column(
            children: [
              Container(
                width: 65,
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
                            child: Center(
                              child: Icon(
                                Feather.plus,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Text("",
                  style: GoogleFonts.poppins(
                      fontSize: 12, fontWeight: FontWeight.w400))
            ],
          ));
  }

  Widget _otherCategories2() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Kategori Lainnya',
            style:
                GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          SizedBox(
            height: 15,
          ),
          Column(
            children: [
              Row(
                children: [
                  Stack(
                    children: [
                      _iconCategories2("sepakbola_icon.png", "Sepakbola"),
                      Positioned(
                        child: Positioned(
                            top: 1,
                            right: 1,
                            child: SvgPicture.asset(
                              'assets/svg/plus.svg',
                              height: 15,
                              width: 15,
                            )),
                      )
                    ],
                  ),
                  Spacer(),
                  Stack(
                    children: [
                      _iconCategories2("sepakbola_icon.png", "Sepakbola"),
                      Positioned(
                        child: Positioned(
                            top: 1,
                            right: 1,
                            child: SvgPicture.asset(
                              'assets/svg/plus.svg',
                              height: 15,
                              width: 15,
                            )),
                      )
                    ],
                  ),
                  Spacer(),
                  Stack(
                    children: [
                      _iconCategories2("sepakbola_icon.png", "Sepakbola"),
                      Positioned(
                        child: Positioned(
                            top: 1,
                            right: 1,
                            child: SvgPicture.asset(
                              'assets/svg/plus.svg',
                              height: 15,
                              width: 15,
                            )),
                      )
                    ],
                  ),
                  Spacer(),
                  Stack(
                    children: [
                      _iconCategories2("sepakbola_icon.png", "Sepakbola"),
                      Positioned(
                        child: Positioned(
                            top: 1,
                            right: 1,
                            child: SvgPicture.asset(
                              'assets/svg/plus.svg',
                              height: 15,
                              width: 15,
                            )),
                      )
                    ],
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _iconCategories2(String icon, String label) {
    return Container(
      width: 65,
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
                    'assets/images/categories/' + icon,
                    alignment: Alignment.center,
                    height: 65,
                    width: 65,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Text(label,
              style: GoogleFonts.poppins(
                  fontSize: 12, fontWeight: FontWeight.w400))
        ],
      ),
    );
  }

  Widget _btnSaveChange() {
    return Center(
      child: Container(
        width: Get.width / 1.4,
        child: GetPlatform.isIOS
            ? CupertinoButton.filled(
                borderRadius: BorderRadius.circular(12),
                onPressed: () {
                  PreferenceService.setC1(0);
                  PreferenceService.setC2(1);
                  PreferenceService.setC3(2);
                  PreferenceService.setC4(3);
                  Get.offNamed(AppPages.NAVIGATOR);
                },
                child: Text('Simpan'),
              )
            : ElevatedButton(
                onPressed: () {
                  PreferenceService.setC1(0);
                  PreferenceService.setC2(1);
                  PreferenceService.setC3(2);
                  PreferenceService.setC4(3);
                  Get.offNamed(AppPages.NAVIGATOR);
                },
                child: Text('Simpan'),
              ),
      ),
    );
  }
}
