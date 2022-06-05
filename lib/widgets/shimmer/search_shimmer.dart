// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:passify/controllers/search/search_controller.dart';
import 'package:shimmer/shimmer.dart';

class SearchShimmer extends StatelessWidget {
  final SearchController controller = Get.find();

  SearchShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () {
        HapticFeedback.lightImpact();
        return controller.onGetCommunityMember();
      },
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(25, 20, 20, 0),
                child: Container(
                  height: 20,
                  width: Get.width * 0.45,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7),
                    color: Colors.grey.shade300,
                  ),
                ),
              ),
            ),
            SizedBox(height: 7),
            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 22),
              itemCount: 5,
              itemBuilder: (conext, index) {
                return Container(
                  padding: EdgeInsets.symmetric(vertical: 2.5),
                  color: Colors.white,
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(25),
                                    bottomRight: Radius.circular(25),
                                    topRight: Radius.circular(10),
                                    bottomLeft: Radius.circular(10)),
                                child: Container(
                                  width: 60,
                                  height: 60,
                                  color: Colors.grey.shade300,
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 16,
                                  width: Get.width * 0.45,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(7),
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  height: 13,
                                  width: Get.width * 0.25,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(7),
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            Container(
              height: Get.width,
              width: 200,
              color: Colors.transparent,
            ),
          ],
        ),
      ),
    );
  }
}
