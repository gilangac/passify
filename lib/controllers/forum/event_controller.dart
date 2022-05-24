// ignore: unused_import
// ignore_for_file: non_constant_identifier_names, prefer_final_fields, unused_local_variable, unnecessary_this, avoid_print, unused_import, duplicate_ignore, avoid_function_literals_in_foreach_calls

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
  CollectionReference eventComment =
      FirebaseFirestore.instance.collection('eventComments');

  final formKeyEvent = GlobalKey<FormState>();
  var dataEvent = <EventModel>[].obs;
  var eventData = <EventModel>[].obs;
  var userEvent = <UserModel>[].obs;
  var dataEventMembers = [].obs;
  final _isLoading = true.obs;
  var selectedDropdown = 'WIB'.obs;
  var selectedTime = '00.00 '.obs;
  DateTime dateEvent = DateTime.now();
  var category = Get.arguments;

  final nameFC = TextEditingController();
  final descriptionFC = TextEditingController();
  final locationFC = TextEditingController();
  final dateFC = TextEditingController();
  final timeFC = TextEditingController();

  @override
  void onInit() async {
    onGetDataEvent();
    super.onInit();
  }

  onCreateEvent() async {
    final dateNow = DateTime.now();
    if (this.formKeyEvent.currentState!.validate()) {
      DialogHelper.showLoading();
      String idEvent = "event-" + getRandomString(15).toString();

      try {
        await event.doc(idEvent).set({
          "idEvent": idEvent,
          "idUser": auth.currentUser?.uid,
          "name": nameFC.text,
          "category": category,
          "description": descriptionFC.text,
          "location": locationFC.text,
          "date": dateNow,
          "dateEvent": dateEvent,
          "time": timeFC.text,
        });

        var idMember = getRandomString(20);
        await eventMember.doc(idMember).set({
          "idEvent": idEvent,
          "idUser": auth.currentUser?.uid,
          "idMember": idMember,
          "date": dateNow,
        });
        onGetDataEvent();
        Get.back();
        Get.back();
        onClearFC();
      } catch (e) {
        print(e);
      }
    }
  }

  Future<void> onGetDataEvent() async {
    await event
        .where("category", isEqualTo: category)
        .orderBy("date", descending: true)
        .get()
        .then((QuerySnapshot snapshot) {
      eventData.clear();
      snapshot.docs.forEach((d) {
        dataEvent.isNotEmpty ? dataEvent.clear() : null;
        eventMember
            .where("idEvent", isEqualTo: d["idEvent"])
            .get()
            .then((QuerySnapshot snapshotMember) {
          eventComment
              .where("idEvent", isEqualTo: d["idEvent"])
              .get()
              .then((QuerySnapshot snapshotComment) {
            DateTime a = d['date'].toDate();
            String sort = DateFormat("yyyyMMddHHmmss").format(a);
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
                sort: int.parse(sort),
                member: snapshotMember.size,
                comment: snapshotComment.size));
            dataEvent.sort((a, b) => b.sort!.compareTo(a.sort!));
          });
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
