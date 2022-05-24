// ignore: unused_import
// ignore_for_file: unnecessary_overrides, prefer_final_fields, prefer_const_constructors, avoid_print, unnecessary_this

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:passify/extension/title_case.dart';
import 'package:passify/models/community.dart';
import 'package:passify/models/community_member.dart';
import 'package:passify/models/event.dart';
import 'package:passify/models/user.dart';

class SearchController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference user = FirebaseFirestore.instance.collection('users');
  CollectionReference event = FirebaseFirestore.instance.collection('events');
  CollectionReference community =
      FirebaseFirestore.instance.collection('communities');
  CollectionReference eventMember =
      FirebaseFirestore.instance.collection('eventMembers');
  CollectionReference communityMember =
      FirebaseFirestore.instance.collection('communityMembers');
  CollectionReference eventComment =
      FirebaseFirestore.instance.collection('eventComments');
  late final searchText = ''.obs;
  final currentCarousel = 0.obs;
  final searchView = false.obs;
  var _isLoadingPerson = true.obs;
  var _isLoadingEvent = true.obs;
  var _isLoadingCommunity = true.obs;
  final personData = [].obs;
  final eventData = [].obs;
  final communityData = [].obs;
  var dataMember = <CommunityMemberModel>[].obs;

  final searchFC = TextEditingController();

  @override
  void onInit() {
    ever(searchText, (_) {
      _isLoadingPerson.value = true;
      _isLoadingEvent.value = true;
      _isLoadingCommunity.value = true;
    });
    debounce(searchText, (_) {
      onGetPerson();
      onGetEvent();
      onGetCommunity();
    }, time: Duration(milliseconds: 900));
    super.onInit();
  }

  onGetPerson() async {
    // print(capitalize(searchText.value));
    personData.isNotEmpty ? personData.clear() : null;
    print(searchText.value.toTitleCase());
    if (searchText.value != '') {
      await user
          .where("name".toLowerCase(),
              isGreaterThanOrEqualTo: searchText.value.toTitleCase())
          // .orderBy("date", descending: true)
          .get()
          .then((QuerySnapshot snapshot) {
        snapshot.docs.forEach((d) {
          personData.add(UserModel(
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
          print(d["name"]);
        });
        print(personData.length);
        _isLoadingPerson.value = false;
      });
    }
  }

  onGetEvent() async {
    // print(capitalize(searchText.value));
    eventData.isNotEmpty ? personData.clear() : null;
    print(searchText.value.toTitleCase());
    if (searchText.value != '') {
      event
          .where('name', isGreaterThanOrEqualTo: searchText.value.toTitleCase())
          .get()
          .then((snapshot) {
        snapshot.docs.forEach((d) async {
          await eventMember
              .where("idEvent", isEqualTo: d['idEvent'])
              .get()
              .then((member) async {
            await eventComment
                .where('idEvent', isEqualTo: d['idEvent'])
                .get()
                .then((comment) {
              eventData.add(EventModel(
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

  onGetCommunity() async {
    // print(capitalize(searchText.value));
    communityData.isNotEmpty ? personData.clear() : null;
    print(searchText.value.toTitleCase());
    if (searchText.value != '') {
      community
          .where('name', isGreaterThanOrEqualTo: searchText.value.toTitleCase())
          .get()
          .then((snapshot) {
        snapshot.docs.forEach((d) {
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
            ));
          });
        });
      });
    }
  }

  get isLoadingPerson => this._isLoadingPerson.value;
  get isLoadingEvent => this._isLoadingEvent.value;
  get isLoadingCommunity => this._isLoadingCommunity.value;
}
