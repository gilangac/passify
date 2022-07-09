// ignore: unused_import
// ignore_for_file: avoid_function_literals_in_foreach_calls, unnecessary_this

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:passify/controllers/auth/firebase_auth_controller.dart';
import 'package:passify/helpers/bottomsheet_helper.dart';
import 'package:passify/helpers/dialog_helper.dart';
import 'package:passify/helpers/snackbar_helper.dart';
import 'package:passify/models/community.dart';
import 'package:passify/models/community_member.dart';
import 'package:passify/models/event.dart';
import 'package:passify/models/user.dart';
import 'package:intl/intl.dart';
import 'package:passify/services/service_notification.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfilePersonController extends GetxController {
  var dataUser = <UserModel>[].obs;
  final name = "".obs;
  final hobby = "".obs;
  final idUser = Get.arguments;
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
  CollectionReference report = FirebaseFirestore.instance.collection('reports');
  final _isLoading = true.obs;
  var listMyIdEvent = [].obs;
  var listMyIdCommunity = [].obs;
  var dataEvent = <EventModel>[].obs;
  var myProfile = <UserModel>[].obs;
  var dataCommunity = <CommunityModel>[].obs;
  var communityData = <CommunityModel>[].obs;
  var dataMember = <CommunityMemberModel>[].obs;

  @override
  void onInit() async {
    super.onInit();
    onRefresh();
  }

  onRefresh() async {
    await onGetDataUser();
    await onGetEventMember();
    await onGetCommunityMember();
    await onGetMyProfile();
  }

  Future<void> onGetMyProfile() async {
    await user.doc(auth.currentUser!.uid).get().then((value) {
      myProfile.assign(UserModel(
          name: value["name"],
          username: value["username"],
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
      _isLoading.value = false;
    }).onError((error, stackTrace) {
      Get.snackbar("Terjadi Kesalahan", "Periksa koneksi internet anda!");
    });
  }

  Future<void> onLaunchUrl(String type, String username) async {
    String url = '';
    if (type == 'instagram') {
      url = "https://www.instagram.com/${username}/";
    } else {
      url = "https://twitter.com/${username}/";
    }
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
        headers: <String, String>{'header_key': 'header_value'},
      );
    } else {
      // SnackBarHelper.showError(description: "Tidak dapat menghubungkan");
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
        headers: <String, String>{'header_key': 'header_value'},
      );
      print('Could not launch $url');
    }
  }

  onGetDataUser() async {
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

        name.value = dataUser[0].name.toString();
        for (int i = 0; i < d['hobby'].length; i++) {
          hobby.value = d['hobby'][i];
        }
      });
      onGetMyProfile();
    }).onError((error, stackTrace) {
      Get.snackbar("Terjadi Kesalahan", "Periksa koneksi internet anda!");
    });
  }

  onGetEventMember() async {
    listMyIdEvent.isNotEmpty ? listMyIdEvent.clear() : null;
    await eventMember
        .where("idUser", isEqualTo: idUser)
        .get()
        .then((QuerySnapshot memberEvent) {
      memberEvent.docs.forEach((element) {
        listMyIdEvent.add(element['idEvent']);
      });
      onGetEvent();
    }).onError((error, stackTrace) {
      Get.snackbar("Terjadi Kesalahan", "Periksa koneksi internet anda!");
    });
  }

  onGetCommunityMember() async {
    listMyIdCommunity.isNotEmpty ? listMyIdCommunity.clear() : null;
    await communityMember
        .where("idUser", isEqualTo: idUser)
        .where("status", isEqualTo: "verified")
        .get()
        .then((QuerySnapshot memberCommunity) {
      memberCommunity.docs.forEach((element) {
        listMyIdCommunity.add(element['idCommunity']);
      });
      onGetCommunity();
    }).onError((error, stackTrace) {
      Get.snackbar("Terjadi Kesalahan", "Periksa koneksi internet anda!");
    });
  }

  onGetEvent() async {
    dataEvent.isNotEmpty ? dataEvent.clear() : null;
    for (int i = 0; i < listMyIdEvent.length; i++) {
      await event
          .where('idEvent', isEqualTo: listMyIdEvent[i])
          .get()
          .then((snapshot) {
        snapshot.docs.forEach((d) async {
          await eventMember
              .where("idEvent", isEqualTo: listMyIdEvent[i])
              .get()
              .then((member) async {
            await eventComment
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
      }).onError((error, stackTrace) {
        Get.snackbar("Terjadi Kesalahan", "Periksa koneksi internet anda!");
      });
    }
  }

  onGetCommunity() async {
    dataCommunity.isNotEmpty ? dataCommunity.clear() : null;
    communityData.isNotEmpty ? communityData.clear() : null;
    dataMember.isNotEmpty ? dataMember.clear() : null;
    for (int i = 0; i < listMyIdCommunity.length; i++) {
      community
          .where('idCommunity', isEqualTo: listMyIdCommunity[i].toString())
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
            dataCommunity.assignAll(communityData);
            dataCommunity.sort((a, b) => b.sort!.compareTo(a.sort!));
          });
        });
      }).onError((error, stackTrace) {
        Get.snackbar("Terjadi Kesalahan", "Periksa koneksi internet anda!");
      });
    }
  }

  onReportUser(int problem) async {
    Get.back();
    DialogHelper.showLoading();
    String idReport = DateFormat("yyyyMMddHHmmss").format(DateTime.now()) +
        getRandomString(8).toString();
    await report.doc(idReport).set({
      "idReport": idReport,
      "idFromUser": auth.currentUser?.uid,
      "category": 3,
      "problem": problem,
      "code": dataUser[0].idUser,
      "readAt": null,
      "date": DateTime.now(),
    }).then((_) {
      NotificationService.pushNotifAdmin(
          code: dataUser[0].idUser.toString(),
          type: 3,
          username: myProfile[0].name,
          object: dataUser[0].username.toString());
      Get.back();
      BottomSheetHelper.successReport();
    }).onError((error, stackTrace) {
      Get.back();
      Get.snackbar("Terjadi Kesalahan", "Periksa koneksi internet anda!");
    });
  }

  final _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  final Random _rnd = Random();
  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
  get isLoading => this._isLoading.value;
}
