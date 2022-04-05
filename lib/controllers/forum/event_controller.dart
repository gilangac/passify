// ignore: unused_import
// ignore_for_file: non_constant_identifier_names, prefer_final_fields, unused_local_variable, unnecessary_this, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math';
import 'package:intl/intl.dart';
import 'package:passify/helpers/dialog_helper.dart';
import 'package:passify/models/event.dart';
import 'package:passify/models/user.dart';

class EventController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference event = FirebaseFirestore.instance.collection('events');
  CollectionReference user = FirebaseFirestore.instance.collection('users');
  CollectionReference eventMember =
      FirebaseFirestore.instance.collection('eventMembers');

  final dateNow = DateFormat("dd-MM-yyyy h:mma").format(DateTime.now());
  final formKeyEvent = GlobalKey<FormState>();
  var dataEvent = <EventModel>[].obs;
  var userEvent = <UserModel>[].obs;
  var dataEventMembers = [].obs;
  final _isLoading = true.obs;
  // var dataEvents = [].obs;

  final nameFC = TextEditingController();
  final descriptionFC = TextEditingController();
  final locationFC = TextEditingController();
  final dateFC = TextEditingController();
  final timeFC = TextEditingController();

  @override
  void onInit() async {
    onGetDataEvent(Get.arguments);
    super.onInit();
  }

  onCreateEvent(String category) {
    if (this.formKeyEvent.currentState!.validate()) {
      DialogHelper.showLoading();
      String idEvent = "event-" + getRandomString(15).toString();

      try {
        event.doc(idEvent).set({
          "idEvent": idEvent,
          "idUser": auth.currentUser?.uid,
          "name": nameFC.text,
          "category": category,
          "description": descriptionFC.text,
          "location": locationFC.text,
          "date": dateNow,
          "dateEvent": dateFC.text,
          "time": timeFC.text,
        });

        eventMember.doc(idEvent).set({
          "idEvent": idEvent,
          "members": [
            auth.currentUser?.uid,
          ],
          "date": dateNow,
        });
        onGetDataEvent(category);
        Get.back();
        Get.back();
        onClearFC();
      } catch (e) {
        print(e);
      }
    }
  }

  onGetDataEvent(String category) {
    event
        .where("category", isEqualTo: category)
        .orderBy("date", descending: true)
        .get()
        .then((QuerySnapshot snapshot) {
      dataEvent.clear();
      snapshot.docs.forEach((d) {
        eventMember
            .where("idEvent", isEqualTo: d["idEvent"])
            .get()
            .then((QuerySnapshot snapshotMember) {
          snapshotMember.docs.forEach((member) {
            dataEvent.add(EventModel(
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
          });
          dataEvent.sort((a, b) => b.date!.compareTo(a.date!));
        });
      });
      _isLoading.value = false;
    });
  }

  onClearFC() {
    nameFC.clear();
    descriptionFC.clear();
    locationFC.clear();
    dateFC.clear();
    timeFC.clear();
  }

  final _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();
  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  get isLoading => this._isLoading.value;
}
