// ignore_for_file: non_constant_identifier_names, avoid_function_literals_in_foreach_calls, avoid_print, unnecessary_this

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:passify/helpers/bottomsheet_helper.dart';
import 'package:passify/helpers/dialog_helper.dart';
import 'package:passify/models/post.dart';
import 'package:passify/models/post_comment.dart';
import 'package:passify/models/user.dart';
import 'package:passify/routes/pages.dart';
import 'package:passify/services/service_notification.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as Path;

class DetailPostController extends GetxController {
  // DetailCommunityController detailCommunityController = Get.find();
  var myAccountId = ''.obs;
  var myName = ''.obs;
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference post = FirebaseFirestore.instance.collection('post');
  CollectionReference community =
      FirebaseFirestore.instance.collection('communities');
  CollectionReference communityMember =
      FirebaseFirestore.instance.collection('communityMembers');
  CollectionReference user = FirebaseFirestore.instance.collection('users');
  CollectionReference postComment =
      FirebaseFirestore.instance.collection('postComments');
  CollectionReference notification =
      FirebaseFirestore.instance.collection('notifications');
  CollectionReference report = FirebaseFirestore.instance.collection('reports');

  String dateee = DateFormat("yyyy").format(DateTime.now());
  late final commentText = ''.obs;
  final _isLoadingDetail = true.obs;
  final _isAvailable = true.obs;
  var detailPost = <PostModel>[].obs;
  var userPost = <UserModel>[].obs;
  var myProfile = <UserModel>[].obs;
  var commentPost = <PostCommentModel>[].obs;
  var dataComment = <PostCommentModel>[].obs;
  final commentFC = TextEditingController();
  var idPost = Get.arguments;
  var idCommunity = ''.obs;
  var communityName = ''.obs;
  var isMemberCommunity = false.obs;
  var memberCommunity = [];

  @override
  void onInit() async {
    if (Get.arguments != null) {
      onGetDataDetail();
      onGetMyProfile();
    } else {
      Get.offAndToNamed(AppPages.NOT_FOUND);
    }
    super.onInit();
  }

  Future<void> OnRefresh() async {
    await onGetDataDetail();
  }

  Future<void> onGetMyProfile() async {
    await user.doc(auth.currentUser!.uid).get().then((value) {
      myName.value = value['name'];
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
    });
  }

  Future<void> onGetDataDetail() async {
    final User? users = auth.currentUser;
    final String? myId = users!.uid;
    myAccountId.value = myId.toString();

    try {
      await post
          .where("idPost", isEqualTo: idPost)
          .get()
          .then((QuerySnapshot snapshot) {
        if (snapshot.size == 0) Get.offAndToNamed(AppPages.NOT_FOUND);
        // detailEvent.clear();
        snapshot.docs.forEach((d) {
          detailPost.isNotEmpty ? detailPost.clear() : null;
          detailPost.add(PostModel(
            caption: d["caption"],
            category: d["category"],
            date: d["date"],
            idUser: d["idUser"],
            idCommunity: d["idCommunity"],
            photo: d["photo"],
            idPost: d["idPost"],
            noHp: d["noHp"],
            price: d["price"],
            title: d["title"],
            status: d["status"],
          ));
          idCommunity.value = detailPost[0].idCommunity.toString();
          detailPost[0].status != 'available'
              ? _isAvailable.value = false
              : _isAvailable.value = true;
          onGetDataCommunity();

          user.where("idUser", isEqualTo: d["idUser"]).get().then((value) {
            value.docs.forEach((u) {
              userPost.assign(UserModel(
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

              onGetComment(Get.arguments);
            });
          });
        });
      });
    } catch (e) {
      print(e);
    }
  }

  onGetDataCommunity() {
    memberCommunity.isNotEmpty ? memberCommunity.clear() : null;
    community.doc(detailPost[0].idCommunity).get().then((value) {
      communityName.value = value['name'];
    });
    communityMember
        .where("idCommunity", isEqualTo: detailPost[0].idCommunity)
        .where("status", isEqualTo: "verified")
        .get()
        .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((element) {
        memberCommunity.add(element['idUser']);
        if (element['idUser'] == auth.currentUser!.uid) {
          isMemberCommunity.value = true;
        }
      });
    });
  }

  onGetComment(String idPost) {
    dataComment.isNotEmpty ? dataComment.clear() : null;
    // userComment.clear();

    postComment.where("idPost", isEqualTo: idPost).get().then((value) {
      value.size == 0 ? _isLoadingDetail.value = false : null;
      value.size > 0
          ? value.docs.forEach((u) {
              user.where("idUser", isEqualTo: u["idUser"]).get().then((value) {
                value.docs.forEach((user) {
                  DateTime a = u['date'].toDate();
                  String sort = DateFormat("yyyyMMddHHmmss").format(a);
                  dataComment.add(PostCommentModel(
                      date: u["date"],
                      idUser: u["idUser"],
                      idPost: u["idPost"],
                      idCommunity: u["idCommunity"],
                      comment: u["comment"],
                      name: user["name"],
                      username: user["username"],
                      photo: user["photoUser"],
                      sort: int.parse(sort)));
                });
                commentPost.assignAll(dataComment);
                commentPost.sort((a, b) => a.sort!.compareTo(b.sort!));
                dataComment.length == value.size
                    ? _isLoadingDetail.value = false
                    : null;
              });
            })
          : _isLoadingDetail.value = false;
    });
  }

  void onConfirmDelete() {
    Get.back();
    DialogHelper.showConfirm(
        title: "Hapus Postingan",
        description: "Anda yakin akan menghapus postingan ini?",
        titlePrimary: "Hapus",
        titleSecondary: "Batal",
        action: () {
          Get.back();
          onDeletePost();
        });
  }

  onDeletePost() async {
    DialogHelper.showLoading();
    var fileUrl = Uri.decodeFull(Path.basename(detailPost[0].photo.toString()))
        .replaceAll(new RegExp(r'(\?alt).*'), '');
    if (detailPost[0].photo != "") {
      final firebase_storage.Reference firebaseStorageRef =
          firebase_storage.FirebaseStorage.instance.ref().child(fileUrl);
      await firebaseStorageRef.delete();
    }

    await post.doc(detailPost[0].idPost).delete().then((value) {
      postComment
          .where("idPost", isEqualTo: detailPost[0].idPost)
          .get()
          .then((snapPost) {
        snapPost.docs.forEach((element) {
          postComment.doc(element["idComment"]).delete();
        });
        notification
            .where("code", isEqualTo: detailPost[0].idPost)
            .get()
            .then((snapshotNotif) {
          snapshotNotif.docs.forEach((element) {
            notification.doc(element['idNotification']).delete();
          });
        });
        report
            .where("code", isEqualTo: detailPost[0].idPost)
            .get()
            .then((snapshotReport) {
          snapshotReport.docs.forEach((element) {
            notification.doc(element['idReport']).delete();
          });
        });
        // detailCommunityController.onGetData();
        Get.back();
        Get.back();
      });
    });
  }

  onPostComment() async {
    Timestamp dateNow = Timestamp.fromDate(DateTime.now());
    String idComment = DateFormat("yyyyMMddHHmmss").format(DateTime.now()) +
        getRandomString(8).toString();
    List tokenUser = [];
    List idUserComment = [];
    List idUserCommentFilter = [];
    List listAllTokenComment = [];
    commentPost.add(PostCommentModel(
        date: Timestamp.fromDate(DateTime.now()),
        idUser: auth.currentUser?.uid,
        idPost: Get.arguments,
        idCommunity: idCommunity.value,
        comment: commentFC.text,
        name: myName.value,
        username: myProfile[0].username,
        photo: myProfile[0].photo,
        sort: 0));

    if (commentText.isNotEmpty || commentText.value != '') {
      try {
        await postComment.doc(idComment).set({
          "idComment": idComment,
          "idPost": Get.arguments,
          "idUser": auth.currentUser?.uid,
          "idCommunity": idCommunity.value,
          "comment": commentFC.text,
          "date": DateTime.now(),
        }).then((value) async {
          commentFC.clear();
          commentText.value = '';
          int i = 0;
          int j = 0;
          if (auth.currentUser!.uid != userPost[0].idUser &&
              memberCommunity.contains(userPost[0].idUser)) {
            String idNotif =
                DateFormat("yyyyMMddHHmmss").format(DateTime.now()) +
                    getRandomString(8).toString();
            await user.doc(userPost[0].idUser).get().then((userpost) {
              NotificationService.pushNotif(
                  code: Get.arguments,
                  registrationId: userpost['fcmToken'],
                  type: 2,
                  username: myName.value);
            });
            await notification.doc(idNotif).set({
              "idNotification": idNotif,
              "idUser": userPost[0].idUser,
              "code": Get.arguments,
              "idFromUser": auth.currentUser?.uid,
              "category": 2,
              "readAt": null,
              "date": DateTime.now(),
            });
          }
          await postComment
              .where("idPost", isEqualTo: Get.arguments)
              .get()
              .then((QuerySnapshot snapshot) {
            snapshot.docs.forEach((element) async {
              i++;
              // idUserComment.add(element['idUser']);
              if (memberCommunity.contains(element['idUser'])) {
                idUserComment.add(element['idUser']);
              }
              if (snapshot.size == i) {
                idUserCommentFilter = idUserComment.toSet().toList();
                print(idUserCommentFilter);
                idUserCommentFilter.removeWhere(
                    (idUserFilter) => idUserFilter == auth.currentUser!.uid);
                idUserCommentFilter.removeWhere(
                    (idUserFilter) => idUserFilter == userPost[0].idUser);
                // print(idUserCommentFilter);
                await Future.forEach(idUserCommentFilter, (idUser) async {
                  await user
                      .doc(idUser.toString())
                      .get()
                      .then((datauser) async {
                    tokenUser.addAll(datauser['fcmToken']);
                    if (idUserCommentFilter.length == tokenUser.length) {
                      await Future.forEach(tokenUser, (token) async {
                        j++;
                        listAllTokenComment.add(token);
                        if (tokenUser.length == j) {
                          print(listAllTokenComment);
                          NotificationService.pushNotif(
                              code: Get.arguments,
                              registrationId: listAllTokenComment,
                              type: 3,
                              username: myName.value,
                              object: detailPost[0].title);
                        }
                      });
                    }
                  });
                  String idNotif =
                      DateFormat("yyyyMMddHHmmss").format(DateTime.now()) +
                          getRandomString(8).toString();
                  await notification.doc(idNotif).set({
                    "idNotification": idNotif,
                    "idUser": idUser,
                    "code": Get.arguments,
                    "idFromUser": auth.currentUser?.uid,
                    "category": 3,
                    "readAt": null,
                    "date": DateTime.now(),
                  });
                });
              }
            });
          });
        });

        OnRefresh();
      } catch (e) {
        print(e);
      }
    }
  }

  onChangeStatus(String status) async {
    status == 'available'
        ? _isAvailable.value = true
        : _isAvailable.value = false;
    Get.back();
    DocumentReference editPost = firestore.collection("post").doc(idPost);
    try {
      await editPost.update({
        "status": status,
      });
    } catch (e) {
      print(e);
    }
  }

  onReportPost() async {
    Get.back();
    DialogHelper.showLoading();
    String idReport = DateFormat("yyyyMMddHHmmss").format(DateTime.now()) +
        getRandomString(8).toString();
    await report.doc(idReport).set({
      "idReport": idReport,
      "idFromUser": auth.currentUser?.uid,
      "category": 2,
      "code": idPost,
      "readAt": null,
      "date": DateTime.now(),
    }).then((_) {
      NotificationService.pushNotifAdmin(
          code: idPost,
          type: 2,
          username: myProfile[0].name,
          object: detailPost[0].title);
      Get.back();
      BottomSheetHelper.successReport();
    });
  }

  Future<void> onLaunchUrl(String number) async {
    String url = "https://wa.me/+62$number-?text=";
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
        headers: <String, String>{'header_key': 'header_value'},
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  final _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  final Random _rnd = Random();
  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  get isLoadingDetail => this._isLoadingDetail.value;
  get isAvailable => this._isAvailable.value;
}
