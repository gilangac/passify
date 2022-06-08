import 'package:get/get.dart';
import 'package:passify/controllers/notification/notification_controller.dart';

class NavigatorController extends GetxController {
  var tabIndex = 0;
  final hasNotification = false.obs;
  final countBadge = 0.obs;

  void onChangeTab(int index) {
  final NotificationController notificationController = Get.find();
    tabIndex = index;
    update();
  }
}
