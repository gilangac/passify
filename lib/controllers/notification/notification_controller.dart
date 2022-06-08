// ignore: unused_import
// ignore_for_file: unnecessary_this, unnecessary_overrides, curly_braces_in_flow_control_structures

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:passify/controllers/base/navigator_controller.dart';
import 'package:passify/models/notification.dart';

class NotificationController extends GetxController {
  final NavigatorController navigatorController = Get.find();
  FirebaseAuth auth = FirebaseAuth.instance;
  CollectionReference notification =
      FirebaseFirestore.instance.collection('notifications');

  var dataNotif = <NotificationModel>[].obs;
  var dataNotifUnread = <NotificationModel>[].obs;
  final _isLoading = true.obs;
  final _hasUnread = false.obs;

  @override
  void onInit() {
    onGetData();
    super.onInit();
  }

  onGetData() async {
    await notification
        .where("idUser", isEqualTo: auth.currentUser!.uid)
        .get()
        .then((QuerySnapshot snapshot) {
      dataNotif.isNotEmpty ? dataNotif.clear() : null;
      snapshot.docs.forEach((notif) {
        DateTime a = notif['date'].toDate();
        String sort = DateFormat("yyyyMMddHHmmss").format(a);
        dataNotif.add(NotificationModel(
          idNotification: notif['idNotification'],
          idUser: notif['idUser'],
          code: notif['code'],
          category: notif['category'],
          idFromUser: notif['idFromUser'],
          readAt: notif['readAt'],
          date: notif['date'],
          sort: int.parse(sort),
        ));
        dataNotif.sort((a, b) => b.sort!.compareTo(a.sort!));
        dataNotifUnread.value =
            dataNotif.where((data) => data.readAt == null).toList();
        final _hasUnreadTemp =
            dataNotif.where((element) => element.readAt == null).isNotEmpty;

        _hasUnread.value = _hasUnreadTemp;

        navigatorController.hasNotification.value = _hasUnreadTemp;
        if (_hasUnreadTemp)
          navigatorController.countBadge.value =
              dataNotif.where((element) => element.readAt == null).length;

        update();
      });
    }).then((_) {
      _isLoading.value = false;
    });
  }

  get isLoading => this._isLoading.value;
  get hasUnread => this._hasUnread.value;
}
