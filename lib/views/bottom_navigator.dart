// ignore_for_file: sized_box_for_whitespace, prefer_const_constructors, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:passify/constant/color_constant.dart';
import 'package:passify/controllers/base/navigator_controller.dart';
import 'package:passify/views/forum/forum_page.dart';
import 'package:passify/views/notification/notification_page.dart';
import 'package:passify/views/search/search_page.dart';
import 'package:badges/badges.dart';
import 'home/home_page.dart';
import 'profile/profile_page.dart';

class BottomNavigator extends StatelessWidget {
  final NavigatorController navigatorController = Get.find();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NavigatorController>(
      builder: (controller) => Scaffold(
        body: SafeArea(
          child: IndexedStack(
            index: controller.tabIndex,
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              HomePage(),
              SearchPage(),
              ForumPage(),
              NotificationPage(),
              ProfilePage(),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.white,
          unselectedItemColor: Colors.grey.shade500,
          selectedItemColor: AppColors.primaryColor,
          onTap: controller.onChangeTab,
          currentIndex: controller.tabIndex,
          enableFeedback: false,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          type: BottomNavigationBarType.fixed,
          items: [
            _bottomNavigationBarItem(
                'home_filled.svg', 'home_icon.svg', 'Home'),
            _bottomNavigationBarItem(
                'search_filled.svg', 'search_icon.svg', 'Pencarian'),
            _bottomNavigationBarItem(
                'forum_filled.svg', 'forum_icon.svg', 'Forum'),
            _bottomNavigationBarItemNotif('notification_filled.svg',
                'notification_icon.svg', 'Notifikasi'),
            _bottomNavigationBarItem(
                'profile_filled.svg', 'profile_icon.svg', 'Profile'),
          ],
        ),
      ),
    );
  }

  _bottomNavigationBarItem(String activeIcon, String icon, String labelMenu) {
    return BottomNavigationBarItem(
        activeIcon: Container(
          height: 22,
          child: SvgPicture.asset(
            "assets/svg/icon/" + activeIcon,
            color: AppColors.primaryColor,
          ),
        ),
        icon: Container(
          height: 22,
          child: SvgPicture.asset("assets/svg/icon/" + icon),
        ),
        label: labelMenu);
  }

  _bottomNavigationBarItemNotif(
      String activeIcon, String icon, String labelMenu) {
    return BottomNavigationBarItem(
        activeIcon: Container(
          height: 22,
          child: Obx(
            () => Badge(
              showBadge: navigatorController.hasNotification.value,
              position: BadgePosition.topEnd(top: -10, end: -6),
              badgeContent: Text(
                  navigatorController.countBadge.value.toString(),
                  style: TextStyle(color: Colors.white, fontSize: 10)),
              child: SvgPicture.asset(
                "assets/svg/icon/" + activeIcon,
                color: AppColors.primaryColor,
              ),
              animationType: BadgeAnimationType.scale,
              animationDuration: Duration(milliseconds: 300),
            ),
          ),
        ),
        icon: Container(
          height: 22,
          child: Obx(
            () => Badge(
              showBadge: navigatorController.hasNotification.value,
              position: BadgePosition.topEnd(top: -10, end: -6),
              badgeContent: Text(
                  navigatorController.countBadge.value.toString(),
                  style: TextStyle(color: Colors.white, fontSize: 10)),
              child: SvgPicture.asset("assets/svg/icon/" + icon),
              animationType: BadgeAnimationType.scale,
              animationDuration: Duration(milliseconds: 300),
            ),
          ),
        ),
        label: labelMenu);
  }
}
