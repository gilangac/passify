// ignore_for_file: unnecessary_this, non_constant_identifier_names, prefer_final_fields, avoid_function_literals_in_foreach_calls, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math';
import 'package:intl/intl.dart';
import 'package:passify/controllers/home/home_controller.dart';
import 'package:passify/controllers/profile/profile_controller.dart';
import 'package:passify/helpers/dialog_helper.dart';
import 'package:passify/models/event.dart';
import 'package:passify/models/event_comment.dart';
import 'package:passify/models/user.dart';

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

  String dateee = DateFormat("yyyy").format(DateTime.now());
  late final commentText = ''.obs;
  var isFollow = false.obs;
  final _isLoadingDetail = true.obs;
  var detailEvent = <EventModel>[].obs;
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
    super.onInit();
  }

  Future<void> OnRefresh() async {
    await onGetDetailEvent();
  }

  onGetDetailEvent() async {
    myAccountId.value = (auth.currentUser?.uid).toString();
    // memberEvent.clear();
    memberEvent.isNotEmpty ? memberEvent.clear() : null;
    await event
        .where("idEvent", isEqualTo: idEvent)
        .get()
        .then((QuerySnapshot snapshot) {
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
      });
      onGetDetailEvent();
      homeController.onRefreshData();
      profileController.onRefresh();
    } catch (e) {
      isFollow.value = false;
    }
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

  onPostComment() {
    Timestamp dateNow = Timestamp.fromDate(DateTime.now());
    String idComment = getRandomString(15).toString();

    if (commentText.isNotEmpty || commentText.value != '') {
      try {
        eventComment.doc(idComment).set({
          "idComment": idComment,
          "idEvent": Get.arguments,
          "idUser": auth.currentUser?.uid,
          "comment": commentFC.text,
          "date": dateNow,
        });
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
