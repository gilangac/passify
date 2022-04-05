// ignore_for_file: unused_import, duplicate_ignore, unnecessary_this

// ignore: unused_import
import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:passify/models/user.dart';
import 'package:passify/services/service_preference.dart';

class HomeController extends GetxController {
  final currentCarousel = 0.obs;
  final icon = true.obs;
  final _isLoading = true.obs;
  final items = [].obs;
  final otherItems = [].obs;
  final c1 = 0.obs;
  final c2 = 0.obs;
  final c3 = 0.obs;
  final c4 = 0.obs;

  var dataUser = <UserModel>[].obs;

  final CarouselController carouselController = CarouselController();

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference user = FirebaseFirestore.instance.collection('users');

  @override
  void onInit() async {
    onGetDataUser();
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

  onGetDataUser() {
    // dataUser.clear();
    final User? users = auth.currentUser;
    final String? idUser = users!.uid;
    user
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
      });
      readJson();
    });
  }

  Future<void> onRefreshData() async {
    onGetDataUser();
  }

  get isLoading => this._isLoading.value;
}
