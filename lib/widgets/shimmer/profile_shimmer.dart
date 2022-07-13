import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:passify/controllers/profile/profile_person_controller.dart';
import 'package:shimmer/shimmer.dart';

class ProfileShimmer extends StatelessWidget {
  final ProfilePersonController controller = Get.find();

  ProfileShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () {
        HapticFeedback.lightImpact();
        return controller.onRefresh();
      },
      child: ListView.builder(
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
        itemCount: 1,
        itemBuilder: (conext, index) {
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 0),
            color: Colors.white,
            child: Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      Center(
                        child: Container(
                            height: 16,
                            width: Get.width * 0.3,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.grey.shade300)),
                      ),
                      const SizedBox(height: 30),
                      Center(
                        child: CircleAvatar(
                          radius: 45,
                          backgroundColor: Colors.grey.shade300,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Center(
                        child: Container(
                            height: 16,
                            width: Get.width * 0.35,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.grey.shade300)),
                      ),
                      const SizedBox(height: 5),
                      Center(
                        child: Container(
                            height: 12,
                            width: Get.width * 0.55,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.grey.shade300)),
                      ),
                      const SizedBox(height: 10),
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                            const SizedBox(width: 5),
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Container(
                                  height: 28,
                                  width: Get.width * 0.05,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: Colors.grey.shade300)),
                              const SizedBox(height: 10),
                              Container(
                                  height: 14,
                                  width: Get.width * 0.2,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: Colors.grey.shade300)),
                            ],
                          ),
                          SizedBox(width: Get.width * 0.3),
                          Column(
                            children: [
                              Container(
                                  height: 28,
                                  width: Get.width * 0.05,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: Colors.grey.shade300)),
                              const SizedBox(height: 10),
                              Container(
                                  height: 14,
                                  width: Get.width * 0.2,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: Colors.grey.shade300)),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      Container(
                          height: 11,
                          width: Get.width * 0.4,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.grey.shade300)),
                      _event()
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  _event() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: Get.height,
          width: Get.width,
          child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemCount: 3,
              shrinkWrap: true,
              itemBuilder: ((context, index) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  width: Get.width - 40,
                  height: Get.height * 0.22,
                  decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(12)),
                );
              })),
        )
      ],
    );
  }
}
