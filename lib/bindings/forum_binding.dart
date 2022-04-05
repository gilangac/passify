import 'package:get/get.dart';
import 'package:passify/controllers/forum/forum_controller.dart';

class ForumBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ForumController(), fenix: true);
  }
}
