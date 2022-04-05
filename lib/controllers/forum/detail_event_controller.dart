// ignore_for_file: unnecessary_this, non_constant_identifier_names, prefer_final_fields

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import 'package:passify/models/event.dart';
import 'package:passify/models/event_comment.dart';
import 'package:passify/models/user.dart';

class DetailEventController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference event = FirebaseFirestore.instance.collection('events');
  CollectionReference user = FirebaseFirestore.instance.collection('users');
  CollectionReference eventMember =
      FirebaseFirestore.instance.collection('eventMembers');
  CollectionReference eventComment =
      FirebaseFirestore.instance.collection('eventComments');

  final dateNow = DateFormat("dd-MM-yyyy h:mma").format(DateTime.now());
  late final commentText = ''.obs;
  final _isLoadingDetail = true.obs;
  var detailEvent = <EventModel>[].obs;
  var userEvent = <UserModel>[].obs;
  var memberEvent = <UserModel>[].obs;
  var commentEvent = <EventCommentModel>[].obs;
  final commentFC = TextEditingController();

  @override
  void onInit() async {
    OnGetComment(Get.arguments);
    OnGetDetailEvent(Get.arguments);
    super.onInit();
  }

  OnRefresh() {
    OnGetComment(Get.arguments);
    OnGetDetailEvent(Get.arguments);
  }

  OnGetDetailEvent(String idEvent) {
    // memberEvent.clear();
    memberEvent.isNotEmpty ? memberEvent.clear() : null;
    event
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
                member: member["members"]));

            for (int i = 0; i < member["members"].length; i++) {
              user
                  .where("idUser", isEqualTo: member["members"][i])
                  .get()
                  .then((value) {
                value.docs.forEach((u) {
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
            }
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

            _isLoadingDetail.value = false;
          });
        });
      });
    });
  }

  OnGetComment(String idEvent) {
    // commentEvent.clear();
    commentEvent.isNotEmpty ? commentEvent.clear() : null;
    // userComment.clear();
    eventComment
        .where("idEvent", isEqualTo: idEvent)
        .orderBy("date", descending: true)
        .get()
        .then((value) {
      value.docs.forEach((u) {
        user.where("idUser", isEqualTo: u["idUser"]).get().then((value) {
          value.docs.forEach((user) {
            commentEvent.add(EventCommentModel(
              date: u["date"],
              idUser: u["idUser"],
              idEvent: u["idEvent"],
              comment: u["comment"],
              name: user["name"],
              username: user["username"],
              photo: user["photoUser"],
            ));
          });
          commentEvent.sort((a, b) => a.date!.compareTo(b.date!));
        });
      });
    });
  }

  onPostComment() {
    String idComment = getRandomString(15).toString();

    try {
      eventComment.doc(idComment).set({
        "idComment": idComment,
        "idEvent": Get.arguments,
        "idUser": auth.currentUser?.uid,
        "comment": commentFC.text,
        "date": dateNow,
      });
      OnRefresh();
    } catch (e) {
      print(e);
    }
  }

  final _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();
  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  get isLoadingDetail => this._isLoadingDetail.value;
}
