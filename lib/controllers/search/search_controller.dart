// ignore: unused_import
// ignore_for_file: unnecessary_overrides, prefer_final_fields, prefer_const_constructors, avoid_print, unnecessary_this, unused_field, avoid_function_literals_in_foreach_calls

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:passify/extension/title_case.dart';
import 'package:passify/models/community.dart';
import 'package:passify/models/community_member.dart';
import 'package:passify/models/event.dart';
import 'package:passify/models/post.dart';
import 'package:passify/models/user.dart';
import 'package:intl/intl.dart';

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
  CollectionReference post = FirebaseFirestore.instance.collection('post');
  CollectionReference eventComment =
      FirebaseFirestore.instance.collection('eventComments');
  CollectionReference postComment =
      FirebaseFirestore.instance.collection('postComments');
  late final searchText = ''.obs;
  final currentCarousel = 0.obs;
  final searchView = false.obs;
  var _isLoading = true.obs;
  var _isLoadingPerson = true.obs;
  var _isLoadingEvent = true.obs;
  var _isLoadingCommunity = true.obs;
  final personData = <UserModel>[].obs;
  final eventData = <EventModel>[].obs;
  final communityData = <CommunityModel>[].obs;
  final personDataSearch = <UserModel>[].obs;
  final eventDataSearch = <EventModel>[].obs;
  final communityDataSearch = <CommunityModel>[].obs;
  var dataMember = <CommunityMemberModel>[].obs;
  var dataUser = <UserModel>[].obs;
  var dataPost = <PostModel>[].obs;
  var listMyIdCommunity = [].obs;
  var dataHashtag = [].obs;

  final searchFC = TextEditingController();

  @override
  void onInit() {
    onGetCommunityMember();
    ever(searchText, (_) {
      _isLoadingPerson.value = true;
      _isLoadingEvent.value = true;
      _isLoadingCommunity.value = true;
    });
    debounce(searchText, (_) {
      onSearch();
      _isLoadingPerson.value = false;
      _isLoadingEvent.value = false;
      _isLoadingCommunity.value = false;
    }, time: Duration(milliseconds: 1100));
    super.onInit();
  }

  onRefresh() async {
    onGetPerson();
    onGetEvent();
    onGetCommunity();
  }

  onSearch() {
    personDataSearch.isNotEmpty ? personDataSearch.clear() : null;
    eventDataSearch.isNotEmpty ? eventDataSearch.clear() : null;
    communityDataSearch.isNotEmpty ? communityDataSearch.clear() : null;
    if (searchText.value != '') {
      personData.removeWhere((element) => element.name == "");
      personData.sort(
        (a, b) => a.name!.compareTo(b.name!),
      );
      personDataSearch.value = personData
          .where((data) =>
              data.name!
                  .toLowerCase()
                  .contains(searchText.value.toLowerCase()) ||
              data.username!
                  .toString()
                  .toLowerCase()
                  .contains(searchText.value.toLowerCase()))
          .toList();
      personDataSearch.removeWhere(
          (data) => data.idUser.toString() == auth.currentUser!.uid);
      eventDataSearch.value = eventData
          .where((data) =>
              data.name!
                  .toLowerCase()
                  .contains(searchText.value.toLowerCase()) ||
              data.location!
                  .toString()
                  .toLowerCase()
                  .contains(searchText.value.toLowerCase()))
          .toList();
      communityDataSearch.value = communityData
          .where((data) =>
              data.name!
                  .toLowerCase()
                  .contains(searchText.value.toLowerCase()) ||
              data.city!
                  .toString()
                  .toLowerCase()
                  .contains(searchText.value.toLowerCase()))
          .toList();
    }
  }

  onGetCommunityMember() async {
    listMyIdCommunity.isNotEmpty ? listMyIdCommunity.clear() : null;
    await communityMember
        .where("idUser", isEqualTo: auth.currentUser!.uid)
        .where("status", isEqualTo: "verified")
        .get()
        .then((QuerySnapshot memberCommunity) {
      memberCommunity.docs.forEach((element) {
        listMyIdCommunity.add(element['idCommunity']);
      });
      onGetPost();
    }).onError((error, stackTrace) {
      Get.snackbar("Terjadi Kesalahan", "Periksa koneksi internet anda!");
    });
  }

  onGetPost() async {
    dataPost.isNotEmpty ? dataPost.clear() : null;
    try {
      int j = 0;
      int k = 0;
      for (int i = 0; i < listMyIdCommunity.length; i++) {
        await post
            .where('idCommunity', isEqualTo: listMyIdCommunity[i])
            .get()
            .then((QuerySnapshot snapshot) {
          k++;
          j += snapshot.size;
          if (snapshot.size == 0 && k == listMyIdCommunity.length) {
            onFilterHashtag();
          }
          // if (snapshot.size == 0 && i + 1 == listMyIdCommunity.length) {
          //   onFilterHashtag();
          // }
          snapshot.docs.forEach((post) {
            user.doc(post["idUser"]).get().then((user) {
              postComment
                  .where("idPost", isEqualTo: post["idPost"])
                  .get()
                  .then((QuerySnapshot snapshotComment) {
                DateTime a = post['date'].toDate();
                String sort = DateFormat("yyyyMMddHHmmss").format(a);
                dataPost.add(PostModel(
                    caption: post["caption"],
                    category: post["category"],
                    date: post["date"],
                    idUser: post["idUser"],
                    idCommunity: post["idCommunity"],
                    photo: post["photo"],
                    idPost: post["idPost"],
                    title: post["title"],
                    noHp: post["noHp"],
                    price: post["price"],
                    status: post["status"],
                    name: user["name"],
                    username: user["username"],
                    photoUser: user["photoUser"],
                    comment: snapshotComment.size,
                    sort: int.parse(sort)));
                if (j == dataPost.length && k == listMyIdCommunity.length) {
                  onFilterHashtag();
                }
                // dataDisccusion = (disccusionData);
                dataPost.sort((a, b) => b.sort!.compareTo(a.sort!));
              });
            });
          });
        });
      }
    } finally {
      _isLoading.value = false;
    }
  }

  onFilterHashtag() {
    var allHashtag = [];
    var allHashtagLowwer = [];
    var hastag = [];
    dataHashtag.isNotEmpty ? dataHashtag.clear() : null;
    allHashtag.isNotEmpty ? allHashtag.clear() : null;
    allHashtagLowwer.isNotEmpty ? allHashtagLowwer.clear() : null;
    hastag.isNotEmpty ? hastag.clear() : null;

    dataPost.value =
        dataPost.where((data) => data.caption!.contains("#")).toList();
    dataPost.forEach((element) {
      // final RegExp regExp = new RegExp(r"[\w-._]+");
      // String value =
      //     (element.caption.toString().replaceAll(new RegExp(r'[^\w\s]+'), ''));
      // print(value);
      var caption = element.caption.toString().replaceAll("\n", " ");
      // print(caption);
      List<String> matches = (caption.split(
        " ",
      ));
      // print(matches);
      matches = matches.where(((data) => data.contains("#"))).toList();
      matches = matches.where(((data) => data[0].contains("#"))).toList();
      // print(matches);
      matches.forEach((data) {
        allHashtag.add(data);
        allHashtagLowwer.add(data.toString().toLowerCase());
      });
    });
    // print(allHashtag);
    allHashtagLowwer.forEach((data) {
      if (!hastag.contains(data.toString().toLowerCase())) {
        hastag.add(data);
      }
    });
    // hastag = allHashtag.toSet().toList();

    for (int i = 0; i < hastag.length; i++) {
      int j = 0;
      allHashtag.forEach((data) {
        if (data.toString().toLowerCase() == hastag[i]) {
          j++;
        }
      });
      dataHashtag.add({"hashtag": hastag[i], "total": j});
    }
    dataHashtag.sort((a, b) => b['total'].compareTo(a['total']));
    print(dataHashtag);
  }

  onGetPerson() async {
    // print(capitalize(searchText.value));
    personData.isNotEmpty ? personData.clear() : null;
    print(searchText.value.toTitleCase());
    // if (searchText.value != '') {
    await user
        .where("username", isNotEqualTo: "")
        // .where("name".toLowerCase(),
        //     isGreaterThanOrEqualTo: searchText.value.toTitleCase())
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
        personData.removeWhere((element) => element.name == "");
      });
      _isLoadingPerson.value = false;
    }).onError((error, stackTrace) {
      Get.snackbar("Terjadi Kesalahan", "Periksa koneksi internet anda!");
    });
    // }
  }

  onGetEvent() async {
    // print(capitalize(searchText.value));
    eventData.isNotEmpty ? eventData.clear() : null;
    print(searchText.value.toTitleCase());
    // if (searchText.value != '') {
    event
        // .where('name', isGreaterThanOrEqualTo: searchText.value.toTitleCase())
        .get()
        .then((snapshot) {
      print("jumlah event adal;ah : ${snapshot.size}");
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
      _isLoadingEvent.value = false;
    }).onError((error, stackTrace) {
      Get.snackbar("Terjadi Kesalahan", "Periksa koneksi internet anda!");
    });
    // }
  }

  onGetCommunity() async {
    // print(capitalize(searchText.value));
    communityData.isNotEmpty ? communityData.clear() : null;
    dataMember.isNotEmpty ? dataMember.clear() : null;
    print(searchText.value.toTitleCase());
    // if (searchText.value != '') {
    community
        // .where('name', isGreaterThanOrEqualTo: searchText.value.toTitleCase())
        .get()
        .then((snapshot) {
      print("jumlah komunitas adal;ah : ${snapshot.size}");
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
      _isLoadingCommunity.value = false;
    }).onError((error, stackTrace) {
      Get.snackbar("Terjadi Kesalahan", "Periksa koneksi internet anda!");
    });
    // }
  }

  get isLoading => this._isLoading.value;
  get isLoadingPerson => this._isLoadingPerson.value;
  get isLoadingEvent => this._isLoadingEvent.value;
  get isLoadingCommunity => this._isLoadingCommunity.value;
}
