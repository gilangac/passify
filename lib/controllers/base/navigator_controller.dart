import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:passify/controllers/notification/notification_controller.dart';
import 'package:passify/routes/pages.dart';

class NavigatorController extends GetxController {
  var tabIndex = 0;
  final hasNotification = false.obs;
  final countBadge = 0.obs;

  void onChangeTab(int index) {
    final NotificationController notificationController = Get.find();
    tabIndex = index;
    update();
  }

  void initDynamicLinks() async {
    final PendingDynamicLinkData? data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri? deepLink = data?.link;

    if (deepLink != null) {
      handleDynamicLink(deepLink);
    }

    FirebaseDynamicLinks.instance.onLink.listen((dynamicLinkData) {
      final Uri? deepLink = dynamicLinkData.link;

      if (deepLink != null) {
        handleDynamicLink(deepLink);
      }
    }).onError((error) {
      print('onLink error');
      print(error.message);
    });
  }

  handleDynamicLink(Uri url) {
    List<String> separatedString = [];
    separatedString.addAll(url.path.split('/'));
    if (separatedString[1] == "post") {
      Get.toNamed(AppPages.DETAIL_POST + separatedString[2],
          arguments: separatedString[2]);
    } else if (separatedString[1] == "community") {
      Get.toNamed(AppPages.COMMUNITY + separatedString[2],
          arguments: separatedString[2]);
    } else if (separatedString[1] == "event") {
      Get.toNamed(AppPages.DETAIL_EVENT + separatedString[2],
          arguments: separatedString[2]);
    }
  }

  @override
  Future<void> onInit() async {
    initDynamicLinks();
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage?.data != null) {
      final jsonPayload = initialMessage!.data["code"];
      final type = initialMessage.data["path"];
      if (type == "post") {
        Get.toNamed(AppPages.DETAIL_POST + jsonPayload, arguments: jsonPayload);
      } else if (type == "community") {
        Get.toNamed(AppPages.COMMUNITY + jsonPayload, arguments: jsonPayload);
      } else if (type == "event") {
        Get.toNamed(AppPages.DETAIL_EVENT + jsonPayload,
            arguments: jsonPayload);
      }
    }
    super.onInit();
  }
}
