import 'package:get/get.dart';
import 'package:passify/controllers/auth/firebase_auth_controller.dart';
import 'package:passify/controllers/forum/forum_controller.dart';

class FirebaseBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FirebaseAuthController(), fenix: true);
  }
}
