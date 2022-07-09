// ignore_for_file: unnecessary_overrides

import 'package:get/get.dart';
import 'package:passify/helpers/dialog_helper.dart';

class onboardController extends GetxController {
  var checkbox = false.obs;
  var privacy = false.obs;
  @override
  void onInit() {
    super.onInit();
    DialogHelper.showPrivacyPolicy();
  }
}
