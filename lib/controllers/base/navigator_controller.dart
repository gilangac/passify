import 'package:get/get.dart';

class NavigatorController extends GetxController {
  var tabIndex = 0;
  final hasNotification = false.obs;
  final countBadge = 0.obs;

  void onChangeTab(int index) {
    tabIndex = index;
    update();
  }
}
