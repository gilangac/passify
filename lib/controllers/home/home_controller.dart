// ignore_for_file: unused_import, duplicate_ignore, unnecessary_this, prefer_const_constructors, avoid_function_literals_in_foreach_calls

// ignore: unused_import
import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:passify/models/community.dart';
import 'package:passify/models/community_member.dart';
import 'package:passify/models/event.dart';
import 'package:passify/models/user.dart';
import 'package:passify/services/service_preference.dart';
import 'package:intl/intl.dart';

class HomeController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference user = FirebaseFirestore.instance.collection('users');
  CollectionReference community =
      FirebaseFirestore.instance.collection('communities');
  CollectionReference event = FirebaseFirestore.instance.collection('events');
  CollectionReference eventMember =
      FirebaseFirestore.instance.collection('eventMembers');
  CollectionReference communityMember =
      FirebaseFirestore.instance.collection('communityMembers');
  CollectionReference eventComment =
      FirebaseFirestore.instance.collection('eventComments');

  final currentCarousel = 0.obs;
  final icon = true.obs;
  final _isLoading = true.obs;
  final items = [].obs;
  final otherItems = [].obs;
  final c1 = 0.obs;
  final c2 = 0.obs;
  final c3 = 0.obs;
  final c4 = 0.obs;
  var communityLength = 0.obs;
  var listMyIdEvent = [].obs;
  var listMyHobby = [].obs;
  var myCity = ''.obs;
  var city = ''.obs;
  var myProvince = ''.obs;
  var dataEvent = <EventModel>[].obs;
  var dataUser = <UserModel>[].obs;
  var dataCommunity = <CommunityModel>[].obs;
  var communityData = <CommunityModel>[].obs;
  var dataMember = <CommunityMemberModel>[].obs;

  final CarouselController carouselController = CarouselController();

  @override
  void onInit() async {
    onRefreshData();
    super.onInit();
  }

  readJson() async {
    items.clear();
    otherItems.clear();
    final String response =
        await rootBundle.loadString('assets/json/categories.json');
    final data = await json.decode(response);
    items.value = data["categories"];

    c1.value = int.parse(PreferenceService.getC1().toString());
    c2.value = int.parse(PreferenceService.getC2().toString());
    c3.value = int.parse(PreferenceService.getC3().toString());
    c4.value = int.parse(PreferenceService.getC4().toString());

    otherItem();
    _isLoading.value = false;
  }

  otherItem() {
    for (int i = 0; i < items.length; i++) {
      if (items[i]['id'] != PreferenceService.getC1().toString() &&
          items[i]['id'] != PreferenceService.getC2().toString() &&
          items[i]['id'] != PreferenceService.getC3().toString() &&
          items[i]['id'] != PreferenceService.getC4().toString()) {
        otherItems.add(items[i]);
        otherItems.refresh();
      }
    }
  }

  Future<void> onGetDataUser() async {
    // dataUser.clear();
    listMyHobby.isNotEmpty ? listMyHobby.clear() : null;
    final User? users = auth.currentUser;
    final String? idUser = users!.uid;
    await user
        .where("idUser", isEqualTo: idUser)
        // .orderBy("date", descending: true)
        .get()
        .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((d) {
        dataUser.assign(UserModel(
            name: d["name"],
            username: d["username"],
            date: d["date"],
            idUser: d["idUser"],
            email: d["email"],
            photo: d["photoUser"],
            twitter: d["twitter"],
            hobby: d["hobby"],
            city: d["city"],
            instagram: d["instagram"]));
        listMyHobby.value = d['hobby'];
        myCity.value = d['city'];
        myProvince.value = d['province'];
      });
      readJson();
      onGetCommunity();
    });
  }

  onGetCommunity() async {
    if (myCity.value.isNotEmpty) {
      int aa = myCity.value.indexOf(" ") + 1;
      city.value = myCity.value.substring(aa).toLowerCase();
    }

    dataCommunity.isNotEmpty ? dataCommunity.clear() : null;
    communityData.isNotEmpty ? communityData.clear() : null;
    dataMember.isNotEmpty ? dataMember.clear() : null;
    for (int i = 0; i < listMyHobby.length; i++) {
      community
          .where('category', isEqualTo: listMyHobby[i].toString())
          .where('province'.toString().toLowerCase(),
              isGreaterThanOrEqualTo: myProvince.value,
              isLessThan: myProvince.value + 'z')
          .get()
          .then((snapshot) {
        communityLength.value = 0;
        snapshot.docs.forEach((d) {
          communityLength++;
          communityMember
              .where("idCommunity", isEqualTo: d["idCommunity"])
              .where("status", isEqualTo: "verified")
              .get()
              .then((QuerySnapshot snapshotMember) {
            snapshotMember.docs.forEach((member) {
              dataMember.add(CommunityMemberModel(
                date: member["date"],
                idCommunity: member["idCommunity"],
                idUser: member["idUser"],
                status: member["status"],
              ));
            });
            DateTime a = d['date'].toDate();
            String sort = DateFormat("yyyyMMddHHmmss").format(a);
            communityData.add(CommunityModel(
              name: d["name"],
              category: d["category"],
              date: d["date"],
              idUser: d["idUser"],
              idCommunity: d["idCommunity"],
              description: d["description"],
              city: d["city"],
              province: d["province"],
              photo: d["photo"],
              member: dataMember
                  .where((data) => data.idCommunity == d["idCommunity"])
                  .toList(),
              sort: int.parse(sort),
            ));
            dataCommunity.assignAll(communityData.where(
                (data) => (data.city!.toLowerCase()).contains(city.value)));
            if (dataCommunity.length < 5) {
              dataCommunity.addAll(communityData.where(
                  (data) => !(data.city!.toLowerCase()).contains(city.value)));
            }
            // dataCommunity.sort((a, b) => b.city!.compareTo(a.name!));
          });
        });
      });
    }
  }

  onGetEventMember() async {
    listMyIdEvent.isNotEmpty ? listMyIdEvent.clear() : null;
    await eventMember
        .where("idUser", isEqualTo: auth.currentUser!.uid)
        .get()
        .then((QuerySnapshot memberEvent) {
      memberEvent.docs.forEach((element) {
        listMyIdEvent.add(element['idEvent']);
      });
      onGetEvent();
    });
  }

  onGetEvent() async {
    dataEvent.isNotEmpty ? dataEvent.clear() : null;
    for (int i = 0; i < listMyIdEvent.length; i++) {
      await event
          .where(
            'idEvent',
            isEqualTo: listMyIdEvent[i],
          )
          .where("dateEvent",
              isGreaterThan: DateTime.now().subtract(Duration(days: 1)))
          .get()
          .then((snapshot) {
        snapshot.docs.forEach((d) {
          eventMember
              .where("idEvent", isEqualTo: listMyIdEvent[i])
              .get()
              .then((member) {
            eventComment
                .where('idEvent', isEqualTo: d['idEvent'])
                .get()
                .then((comment) {
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
                  comment: comment.size,
                  member: member.size));
            });
          });
        });
      });
    }
  }

  Future<void> onRefreshData() async {
    await onGetDataUser();
    await onGetEventMember();
  }

  get isLoading => this._isLoading.value;
}
