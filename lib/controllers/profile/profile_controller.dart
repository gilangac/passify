// ignore: unused_import
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:passify/models/user.dart';

class ProfileController extends GetxController {
  var dataUser = <UserModel>[].obs;
  final name = "".obs;

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference user = FirebaseFirestore.instance.collection('users');

  @override
  void onInit() async {
    onGetDataUser();
    super.onInit();
  }

  onGetDataUser() {
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

        name.value = dataUser[0].name.toString();
      });
    });
  }
}
