// ignore_for_file: non_constant_identifier_names, avoid_function_literals_in_foreach_calls, avoid_print, unnecessary_this

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:passify/controllers/forum/detail_community_controller.dart';
import 'package:passify/helpers/dialog_helper.dart';
import 'package:passify/models/post.dart';
import 'package:passify/models/post_comment.dart';
import 'package:passify/models/user.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailPostController extends GetxController {
  // DetailCommunityController detailCommunityController = Get.find();
  var myAccountId = ''.obs;
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference post = FirebaseFirestore.instance.collection('post');
  CollectionReference user = FirebaseFirestore.instance.collection('users');
  CollectionReference postComment =
      FirebaseFirestore.instance.collection('postComments');

  String dateee = DateFormat("yyyy").format(DateTime.now());
  late final commentText = ''.obs;
  final _isLoadingDetail = true.obs;
  final _isAvailable = true.obs;
  var detailPost = <PostModel>[].obs;
  var userPost = <UserModel>[].obs;
  var commentPost = <PostCommentModel>[].obs;
  var dataComment = <PostCommentModel>[].obs;
  final commentFC = TextEditingController();
  var idPost = Get.arguments;
  var idCommunity = ''.obs;

  @override
  void onInit() async {
    onGetDataDetail();
    super.onInit();
  }

  Future<void> OnRefresh() async {
    await onGetDataDetail();
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
        action: () {
          Get.back();
          onDeletePost();
        });
  }

  onDeletePost() async {
    DialogHelper.showLoading();
    await post.doc(detailPost[0].idPost).delete().then((value) {
      postComment
          .where("idPost", isEqualTo: detailPost[0].idPost)
          .get()
          .then((snapPost) {
        snapPost.docs.forEach((element) {
          postComment.doc(element["idComment"]).delete();
        });
        // detailCommunityController.onGetData();
        Get.back();
        Get.back();
      });
    });
  }

  onPostComment() {
    Timestamp dateNow = Timestamp.fromDate(DateTime.now());
    String idComment = getRandomString(15).toString();

    if (commentText.isNotEmpty || commentText.value != '') {
      try {
        postComment.doc(idComment).set({
          "idComment": idComment,
          "idPost": Get.arguments,
          "idUser": auth.currentUser?.uid,
          "idCommunity": idCommunity.value,
          "comment": commentFC.text,
          "date": dateNow,
        });
        commentFC.clear();
        commentText.value = '';
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
