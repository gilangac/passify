// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:passify/constant/color_constant.dart';
import 'package:passify/controllers/home/categories_controller.dart';
import 'package:passify/controllers/home/home_controller.dart';
import 'package:passify/routes/pages.dart';
import 'package:passify/widgets/general/app_bar.dart';

class CategoriesPage extends StatelessWidget {
  CategoriesPage({Key? key}) : super(key: key);
  final HomeController homeController = Get.find();
  final categoriesController = Get.put(CategoriesController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: _body(),
      backgroundColor: Colors.white,
    );
  }

  PreferredSizeWidget _appBar() {
    return appBar(title: "Semua Kategori");
  }

  Widget _body() {
    return Obx(() => categoriesController.isLoading ? Center(child: CircularProgressIndicator(),) : Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Obx(() => categoriesController.change.value == 0
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _favCategories(),
                        Expanded(child: _otherCategories())
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _favCategories2(),
                        Expanded(child: _otherCategories2()),
                        _btnSaveChange()
                      ],
                    )),
            ),
          ],
        ));
  }

  Widget _favCategories() {
    final c1 = homeController.c1.value;
    final c2 = homeController.c2.value;
    final c3 = homeController.c3.value;
    final c4 = homeController.c4.value;
    return Padding(
      padding: const EdgeInsets.fromLTRB(25, 25, 25, 0),
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
                onTap: () {
                  categoriesController.change.value = 1;
                },
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
                  GestureDetector(
                    onTap: () => Get.toNamed(
                        AppPages.HOBBY +
                            homeController.items[c1]["path"]
                                .toString()
                                .toLowerCase(),
                        arguments: homeController.items[c1]["name"]),
                    child: Stack(
                      children: [
                        _iconCategories(homeController.items[c1]["icon"],
                            homeController.items[c1]["name"]),
                        Container(
                          height: 65,
                          width: 65,
                          color: Colors.transparent,
                        )
                      ],
                    ),
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: () => Get.toNamed(
                        AppPages.HOBBY +
                            homeController.items[c2]["path"]
                                .toString()
                                .toLowerCase(),
                        arguments: homeController.items[c2]["name"]),
                    child: Stack(
                      children: [
                        _iconCategories(homeController.items[c2]["icon"],
                            homeController.items[c2]["name"]),
                        Container(
                            height: 65, width: 65, color: Colors.transparent),
                      ],
                    ),
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: () => Get.toNamed(
                        AppPages.HOBBY +
                            homeController.items[c3]["path"]
                                .toString()
                                .toLowerCase(),
                        arguments: homeController.items[c3]["name"]),
                    child: Stack(
                      children: [
                        _iconCategories(homeController.items[c3]["icon"],
                            homeController.items[c3]["name"]),
                        Container(
                            height: 65, width: 65, color: Colors.transparent),
                      ],
                    ),
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: () => Get.toNamed(
                        AppPages.HOBBY +
                            homeController.items[c4]["path"]
                                .toString()
                                .toLowerCase(),
                        arguments: homeController.items[c4]["name"]),
                    child: Stack(
                      children: [
                        _iconCategories(homeController.items[c4]["icon"],
                            homeController.items[c4]["name"]),
                        Container(
                            height: 65, width: 65, color: Colors.transparent),
                      ],
                    ),
                  ),
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
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
            child: Text(
              'Kategori Lainnya',
              style: GoogleFonts.poppins(
                  fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Expanded(
            child: GridView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: homeController.otherItems.length,
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                dragStartBehavior: DragStartBehavior.start,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  mainAxisSpacing: 10,
                  crossAxisCount: 4,
                ),
                itemBuilder: (BuildContext ctx, index) {
                  return GestureDetector(
                    onTap: () => Get.toNamed(
                        AppPages.HOBBY +
                            homeController.otherItems[index]["path"]
                                .toString()
                                .toLowerCase(),
                        arguments: homeController.otherItems[index]["name"]),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 0),
                      child: Center(
                        child: Stack(
                          children: [
                            _iconCategories(
                                homeController.otherItems[index]["icon"],
                                homeController.otherItems[index]["name"]),
                            Container(
                                height: 65,
                                width: 65,
                                color: Colors.transparent)
                          ],
                        ),
                      ),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }

  Widget _iconCategories(String icon, String label) {
    return GestureDetector(
      onTap: () {},
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
            AutoSizeText(label,
                maxLines: 1,
                style: GoogleFonts.poppins(
                    fontSize: 12, fontWeight: FontWeight.w400))
          ],
        ),
      ),
    );
  }

// ON CHANGE FAVORITE CATEGORIES

  Widget _favCategories2() {
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
      padding: const EdgeInsets.fromLTRB(25, 25, 25, 0),
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
                          onTap: () => categoriesController.onMinFav(
                              homeController.items[cC.changeC1.value]["id"]),
                          child: Stack(
                            children: [
                              _iconCategories(
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
                              Container(
                                height: 65,
                                width: 65,
                                color: Colors.transparent,
                              )
                            ],
                          ),
                        )
                      : _addCategories()),
                  Spacer(),
                  Obx(() => cC.changeC2.value != 300
                      ? GestureDetector(
                          onTap: () => categoriesController.onMinFav(
                              homeController.items[cC.changeC2.value]["id"]),
                          child: Stack(
                            children: [
                              _iconCategories(
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
                              Container(
                                  height: 65,
                                  width: 65,
                                  color: Colors.transparent)
                            ],
                          ),
                        )
                      : _addCategories()),
                  Spacer(),
                  Obx(() => cC.changeC3.value != 300
                      ? GestureDetector(
                          onTap: () => categoriesController.onMinFav(
                              homeController.items[cC.changeC3.value]["id"]),
                          child: Stack(
                            children: [
                              _iconCategories(
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
                              Container(
                                  height: 65,
                                  width: 65,
                                  color: Colors.transparent)
                            ],
                          ),
                        )
                      : _addCategories()),
                  Spacer(),
                  Obx(() => cC.changeC4.value != 300
                      ? GestureDetector(
                          onTap: () => categoriesController.onMinFav(
                              homeController.items[cC.changeC4.value]["id"]),
                          child: Stack(
                            children: [
                              _iconCategories(
                                  homeController.items[cC.changeC4.value]
                                      ["icon"],
                                  homeController.items[cC.changeC4.value]
                                      ["name"]),
                              Positioned(
                                  top: 1,
                                  right: 1,
                                  child: SvgPicture.asset(
                                    'assets/svg/min.svg',
                                    height: 15,
                                    width: 15,
                                  )),
                              Container(
                                  height: 65,
                                  width: 65,
                                  color: Colors.transparent)
                            ],
                          ),
                        )
                      : _addCategories()),
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

  Widget _addCategories() {
    return Column(children: [
      Container(
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
          style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w400))
    ]);
  }

  Widget _otherCategories2() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
          child: Text(
            'Kategori Lainnya',
            style:
                GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
        SizedBox(
          height: 15,
        ),
        Expanded(
          child: Obx(() => GridView.builder(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              itemCount: categoriesController.otherItemsChange.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4, mainAxisSpacing: 10),
              itemBuilder: (BuildContext ctx, index) {
                return Obx(() => (categoriesController.changeC1.value == 300 ||
                        categoriesController.changeC2.value == 300 ||
                        categoriesController.changeC3.value == 300 ||
                        categoriesController.changeC4.value == 300)
                    ? GestureDetector(
                        onTap: () => categoriesController.onAddFav(
                            categoriesController.otherItemsChange[index]["id"]),
                        child: Center(
                          child: Stack(
                            children: [
                              _iconCategories(
                                  categoriesController.otherItemsChange[index]
                                      ["icon"],
                                  categoriesController.otherItemsChange[index]
                                      ["name"]),
                              Positioned(
                                top: 1,
                                right: 1,
                                child: SvgPicture.asset(
                                  'assets/svg/plus.svg',
                                  height: 15,
                                  width: 15,
                                ),
                              ),
                              Container(
                                height: 65,
                                width: 65,
                                color: Colors.transparent,
                              )
                            ],
                          ),
                        ),
                      )
                    : _iconCategories(
                        categoriesController.otherItemsChange[index]["icon"],
                        categoriesController.otherItemsChange[index]["name"]));
              })),
        ),
      ],
    );
  }

  Widget _btnSaveChange() {
    return Center(
      child: Container(
        margin: EdgeInsets.fromLTRB(0, 10, 0, 20),
        width: Get.width / 1.4,
        child: GetPlatform.isIOS
            ? CupertinoButton.filled(
                borderRadius: BorderRadius.circular(12),
                onPressed: () => (categoriesController.changeC1.value == 300 ||
                        categoriesController.changeC2.value == 300 ||
                        categoriesController.changeC3.value == 300 ||
                        categoriesController.changeC4.value == 300)
                    ? null
                    : categoriesController.onSaveChange(),
                child: Text('Simpan'),
              )
            : Obx(() => ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: (categoriesController.changeC1.value == 300 ||
                              categoriesController.changeC2.value == 300 ||
                              categoriesController.changeC3.value == 300 ||
                              categoriesController.changeC4.value == 300)
                          ? Colors.grey.shade400
                          : AppColors.primaryColor),
                  onPressed: () =>
                      (categoriesController.changeC1.value == 300 ||
                              categoriesController.changeC2.value == 300 ||
                              categoriesController.changeC3.value == 300 ||
                              categoriesController.changeC4.value == 300)
                          ? null
                          : categoriesController.onSaveChange(),
                  child: Text('Simpan'),
                )),
      ),
    );
  }
}
