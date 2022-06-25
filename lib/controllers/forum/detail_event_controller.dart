// ignore_for_file: unnecessary_this, non_constant_identifier_names, prefer_final_fields, avoid_function_literals_in_foreach_calls, avoid_print, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:passify/constant/color_constant.dart';
import 'package:passify/controllers/auth/firebase_auth_controller.dart';
import 'package:passify/controllers/forum/event_controller.dart';
import 'package:passify/controllers/home/home_controller.dart';
import 'package:passify/controllers/notification/notification_controller.dart';
import 'package:passify/controllers/profile/profile_controller.dart';
import 'package:passify/helpers/bottomsheet_helper.dart';
import 'package:passify/helpers/dialog_helper.dart';
import 'package:passify/models/event.dart';
import 'package:passify/models/event_comment.dart';
import 'package:passify/models/user.dart';
import 'package:passify/routes/pages.dart';
import 'package:passify/services/service_notification.dart';

class DetailEventController extends GetxController {
  HomeController homeController = Get.find();
  ProfileController profileController = Get.find();
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference event = FirebaseFirestore.instance.collection('events');
  CollectionReference user = FirebaseFirestore.instance.collection('users');
  CollectionReference eventMember =
      FirebaseFirestore.instance.collection('eventMembers');
  CollectionReference eventComment =
      FirebaseFirestore.instance.collection('eventComments');
  CollectionReference notification =
      FirebaseFirestore.instance.collection('notifications');
  CollectionReference report = FirebaseFirestore.instance.collection('reports');

  String dateee = DateFormat("yyyy").format(DateTime.now());
  late final commentText = ''.obs;
  var isFollow = false.obs;
  final _isLoadingDetail = true.obs;
  var detailEvent = <EventModel>[].obs;
  var myProfile = <UserModel>[].obs;
  var userEvent = <UserModel>[].obs;
  var memberEvent = <UserModel>[].obs;
  var commentEvent = <EventCommentModel>[].obs;
  var dataComment = <EventCommentModel>[].obs;
  final commentFC = TextEditingController();
  var idEvent = Get.arguments;
  var myAccountId = ''.obs;
  var selectedDropdown = 'WIB'.obs;
  var selectedTime = '00.00 '.obs;
  final formKeyEditEvent = GlobalKey<FormState>();
  DateTime dateEvent = DateTime.now();

  final nameFC = TextEditingController();
  final descriptionFC = TextEditingController();
  final locationFC = TextEditingController();
  final dateFC = TextEditingController();
  final timeFC = TextEditingController();

  @override
  void onInit() async {
    onGetDetailEvent();
    onGetMyProfile();
    super.onInit();
  }

  Future<void> OnRefresh() async {
    await onGetDetailEvent();
  }

  Future<void> onGetMyProfile() async {
    await user.doc(auth.currentUser!.uid).get().then((value) {
      myProfile.assign(UserModel(
          name: value["name"],
          username: value["username"],
          fcmToken: value["fcmToken"],
          date: value["date"],
          idUser: value["idUser"],
          email: value["email"],
          photo: value["photoUser"],
          twitter: value["twitter"],
          hobby: value["hobby"],
          city: value["city"],
          instagram: value["instagram"]));
      if (value["status"] == 0) {
        FirebaseAuthController firebaseAuthController =
            Get.put(FirebaseAuthController());
        firebaseAuthController.logout();
      }
    });
  }

  onGetDetailEvent() async {
    myAccountId.value = (auth.currentUser?.uid).toString();
    // memberEvent.clear();
    memberEvent.isNotEmpty ? memberEvent.clear() : null;
    await event
        .where("idEvent", isEqualTo: idEvent)
        .get()
        .then((QuerySnapshot snapshot) {
      if (snapshot.size == 0) Get.offAndToNamed(AppPages.NOT_FOUND);
      // detailEvent.clear();
      snapshot.docs.forEach((d) {
        eventMember
            .where("idEvent", isEqualTo: d["idEvent"])
            .get()
            .then((QuerySnapshot snapshotMember) {
          snapshotMember.docs.forEach((member) {
            detailEvent.isNotEmpty ? detailEvent.clear() : null;
            detailEvent.add(EventModel(
                name: d["name"],
                category: d["category"],
                date: d["date"],
                idUser: d["idUser"],
                idEvent: d["idEvent"],
                description: d["description"],
                location: d["location"],
                time: d["time"],
                dateEvent: d["dateEvent"],
                member: snapshotMember.size));

            user
                .where("idUser", isEqualTo: member["idUser"])
                .get()
                .then((value) {
              value.docs.forEach((u) {
                u['idUser'] == auth.currentUser?.uid
                    ? isFollow.value = true
                    : null;
                memberEvent.add(UserModel(
                    name: u["name"],
                    username: u["username"],
                    fcmToken: u["fcmToken"],
                    date: u["date"],
                    idUser: u["idUser"],
                    email: u["email"],
                    photo: u["photoUser"],
                    twitter: u["twitter"],
                    hobby: u["hobby"],
                    city: u["city"],
                    instagram: u["instagram"]));
              });
            });
          });
        });

        user.where("idUser", isEqualTo: d["idUser"]).get().then((value) {
          value.docs.forEach((u) {
            userEvent.assign(UserModel(
                name: u["name"],
                username: u["username"],
                date: u["date"],
                idUser: u["idUser"],
                email: u["email"],
                photo: u["photoUser"],
                twitter: u["twitter"],
                hobby: u["hobby"],
                city: u["city"],
                instagram: u["instagram"]));

            OnGetComment(Get.arguments);
          });
        });
      });
    });
  }

  OnGetComment(String idEvent) {
    dataComment.isNotEmpty ? dataComment.clear() : null;
    // userComment.clear();

    eventComment
        .where("idEvent", isEqualTo: idEvent)
        .orderBy("date", descending: true)
        .get()
        .then((value) {
      value.size > 0
          ? value.docs.forEach((u) {
              user.where("idUser", isEqualTo: u["idUser"]).get().then((value) {
                value.docs.forEach((user) {
                  DateTime a = u['date'].toDate();
                  String sort = DateFormat("yyyyMMddHHmmss").format(a);
                  dataComment.add(EventCommentModel(
                      date: u["date"],
                      idUser: u["idUser"],
                      idEvent: u["idEvent"],
                      comment: u["comment"],
                      name: user["name"],
                      username: user["username"],
                      photo: user["photoUser"],
                      sort: int.parse(sort)));
                });
                commentEvent.assignAll(dataComment);
                commentEvent.sort((a, b) => a.sort!.compareTo(b.sort!));
                dataComment.length == value.size
                    ? _isLoadingDetail.value = false
                    : null;
              });
            })
          : _isLoadingDetail.value = false;
    });
  }

  onEditEvent() async {
    if (this.formKeyEditEvent.currentState!.validate()) {
      DialogHelper.showLoading();
      try {
        await event.doc(idEvent).update({
          "name": nameFC.text,
          "description": descriptionFC.text,
          "location": locationFC.text,
          "dateEvent": dateEvent,
          "time": timeFC.text,
        });

        // eventC.onGetDataEvent();
        onGetDetailEvent();
        homeController.onRefreshData();
        profileController.onRefresh();
        Get.back();
        Get.back();
      } catch (e) {
        print(e);
      }
    }
  }

  onFollowEvent() async {
    var idMember = DateFormat("yyyyMMddHHmmss").format(DateTime.now()) +
        getRandomString(8);
    isFollow.value = true;
    try {
      await eventMember.doc(idMember).set({
        "idMember": idMember,
        "idUser": auth.currentUser?.uid,
        "idEvent": idEvent,
        "date": DateTime.now(),
      }).then((_) {
        pushNotifNewParticipant("follow");
      });
      onGetDetailEvent();
      homeController.onRefreshData();
      profileController.onRefresh();
    } catch (e) {
      isFollow.value = false;
    }
  }

  void pushNotifNewParticipant(String action) {
    List listFcmToken = [];
    List listFcmTokenComment = [];
    int i = 0;

    var member = <UserModel>[];
    member = memberEvent
        .where((data) => data.idUser != auth.currentUser!.uid)
        .toList();
    member.forEach((element) async {
      i++;
      listFcmToken.addAll(element.fcmToken!.toList());
      if (i == member.length) {
        print(listFcmToken);
        if (action == "follow") {
          NotificationService.pushNotif(
              code: Get.arguments,
              registrationId: listFcmToken,
              type: 6,
              username: myProfile[0].name,
              object: detailEvent[0].name);
        } else if (action == "comment") {
          int j = 0;
          int k = 0;
          List tokenUser = [];
          List listAllTokenComment = [];
          List idUserComment = [];
          List idUserCommentFilter = [];
          await eventComment
              .where("idEvent", isEqualTo: Get.arguments)
              .get()
              .then((QuerySnapshot snapshot) {
            snapshot.docs.forEach((userComment) async {
              k++;
              idUserComment.add(userComment['idUser']);
              if (snapshot.size == k) {
                idUserCommentFilter = idUserComment.toSet().toList();
                idUserCommentFilter.removeWhere(
                    (idUserFilter) => idUserFilter == auth.currentUser!.uid);
                // print(idUserCommentFilter);
                await Future.forEach(idUserCommentFilter, (idUser) async {
                  await user
                      .doc(idUser.toString())
                      .get()
                      .then((datauser) async {
                    tokenUser.addAll(datauser['fcmToken']);
                    if (idUserCommentFilter.length == tokenUser.length) {
                      await Future.forEach(tokenUser, (token) async {
                        j++;
                        listAllTokenComment.add(token);
                        if (tokenUser.length == j) {
                          listFcmToken.addAll(listAllTokenComment);
                          listFcmTokenComment = listFcmToken.toSet().toList();
                          print(listFcmTokenComment);
                          NotificationService.pushNotif(
                              code: Get.arguments,
                              registrationId: listFcmToken,
                              type: 5,
                              username: myProfile[0].name,
                              object: detailEvent[0].name);
                        }
                      });
                    }
                  });
                });
              }
            });
          });
        }
      }
      if (action == "follow") {
        String idNotif = DateFormat("yyyyMMddHHmmss").format(DateTime.now()) +
            getRandomString(8).toString();
        await notification.doc(idNotif).set({
          "idNotification": idNotif,
          "idUser": element.idUser,
          "code": Get.arguments,
          "idFromUser": auth.currentUser?.uid,
          "category": 6,
          "readAt": null,
          "date": DateTime.now(),
        });
      } else if (action == "comment") {
        String idNotif = DateFormat("yyyyMMddHHmmss").format(DateTime.now()) +
            getRandomString(8).toString();
        await notification.doc(idNotif).set({
          "idNotification": idNotif,
          "idUser": element.idUser,
          "code": Get.arguments,
          "idFromUser": auth.currentUser?.uid,
          "category": 5,
          "readAt": null,
          "date": DateTime.now(),
        });
      }
    });
  }

  onUnfollowEvent() {
    void _action() async {
      Get.back();
      DialogHelper.showLoading();
      isFollow.value = false;
      final User? users = auth.currentUser;
      final String? myId = users!.uid;
      try {
        await eventMember
            .where("idEvent", isEqualTo: idEvent)
            .where("idUser", isEqualTo: myId)
            .get()
            .then((snapshot) {
          snapshot.docs.forEach((element) {
            eventMember.doc(element['idMember']).delete();
            Get.back();
            onGetDetailEvent();
            homeController.onRefreshData();
            profileController.onRefresh();
          });
        });
      } catch (e) {
        isFollow.value = true;
        print(e);
      }
    }

    DialogHelper.showConfirm(
        title: "Batal Mengikuti Event",
        description: "Apa anda yakin batal mengikuti event ini?",
        action: _action);
  }

  onDeleteEvent() async {
    Get.back();
    DialogHelper.showLoading();
    event.doc(idEvent).delete().then((_) {
      eventMember
          .where("idEvent", isEqualTo: idEvent)
          .get()
          .then((QuerySnapshot snapshotMember) {
        snapshotMember.docs.forEach((element) {
          eventMember.doc(element['idMember']).delete();
        });
      });
      eventComment
          .where("idEvent", isEqualTo: idEvent)
          .get()
          .then((QuerySnapshot snapshotComment) {
        snapshotComment.docs.forEach((element) {
          eventComment.doc(element['idComment']).delete();
        });
      });
      notification
          .where("code", isEqualTo: idEvent)
          .get()
          .then((snapshotNotif) {
        snapshotNotif.docs.forEach((element) {
          notification.doc(element['idNotification']).delete();
        });
      });
      report.where("code", isEqualTo: idEvent).get().then((snapshotReport) {
        snapshotReport.docs.forEach((element) {
          report.doc(element['idReport']).delete();
        });
      });
      NotificationController notifC = Get.find();
      notifC.onGetData();
      EventController eventController = Get.put(EventController());
      eventController.onGetDataEvent();
      homeController.onRefreshData();
      profileController.onRefresh();
      Get.back();
      Get.back();
      Get.back();
    });
  }

  onReportEvent() async {
    Get.back();
    DialogHelper.showLoading();
    String idReport = DateFormat("yyyyMMddHHmmss").format(DateTime.now()) +
        getRandomString(8).toString();
    await report.doc(idReport).set({
      "idReport": idReport,
      "idFromUser": auth.currentUser?.uid,
      "category": 0,
      "code": idEvent,
      "readAt": null,
      "date": DateTime.now(),
    }).then((_) {
      NotificationService.pushNotifAdmin(
          code: idEvent,
          type: 0,
          username: myProfile[0].name,
          object: detailEvent[0].name);
      Get.back();
      BottomSheetHelper.successReport();
    });
  }

  onPostComment() {
    Timestamp dateNow = Timestamp.fromDate(DateTime.now());
    String idComment = DateFormat("yyyyMMddHHmmss").format(DateTime.now()) +
        getRandomString(8).toString();

    if (commentText.isNotEmpty || commentText.value != '') {
      commentEvent.add(EventCommentModel(
          date: Timestamp.fromDate(DateTime.now()),
          idUser: auth.currentUser?.uid,
          idEvent: Get.arguments,
          comment: commentFC.text,
          name: myProfile[0].name,
          username: myProfile[0].username,
          photo: myProfile[0].photo,
          sort: 0));
      try {
        eventComment.doc(idComment).set({
          "idComment": idComment,
          "idEvent": Get.arguments,
          "idUser": auth.currentUser?.uid,
          "comment": commentFC.text,
          "date": DateTime.now(),
        });
        pushNotifNewParticipant("comment");
        commentFC.clear();
        commentText.value = '';
        OnRefresh();
      } catch (e) {
        print(e);
      }
    }
  }

  final _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();
  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  get isLoadingDetail => this._isLoadingDetail.value;
}
