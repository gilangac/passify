import 'package:get/get.dart';
import 'package:passify/controllers/notification/notification_controller.dart';

class NotificationBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => NotificationController());
  }
}
