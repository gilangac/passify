import 'package:get/get.dart';
import 'package:passify/controllers/base/navigator_controller.dart';

class NavigatorBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => NavigatorController());
  }
}
