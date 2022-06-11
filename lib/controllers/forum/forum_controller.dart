// ignore_for_file: curly_braces_in_flow_control_structures

// ignore: unused_import
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:passify/models/community.dart';
import 'package:passify/models/post.dart';
import 'package:passify/models/user.dart';
import 'package:intl/intl.dart';

class ForumController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference user = FirebaseFirestore.instance.collection('users');
  CollectionReference community =
      FirebaseFirestore.instance.collection('communities');
  CollectionReference post = FirebaseFirestore.instance.collection('post');
  CollectionReference postComment =
      FirebaseFirestore.instance.collection('postComments');
  CollectionReference communityMember =
      FirebaseFirestore.instance.collection('communityMembers');

  final _isLoading = true.obs;
  var dataUser = <UserModel>[].obs;
  var dataPost = <PostModel>[].obs;
  var listMyIdCommunity = [].obs;
  var dataNameCommunity = [].obs;

  @override
  void onInit() {
    onGetCommunityMember();
    super.onInit();
  }

  onGetCommunityMember() async {
    listMyIdCommunity.isNotEmpty ? listMyIdCommunity.clear() : null;
    await communityMember
        .where("idUser", isEqualTo: auth.currentUser!.uid)
        .where("status", isEqualTo: "verified")
        .get()
        .then((QuerySnapshot memberCommunity) {
      if (memberCommunity.size == 0) _isLoading.value = false;
      memberCommunity.docs.forEach((element) {
        listMyIdCommunity.add(element['idCommunity']);
      });
      onGetPost();
    });
  }

  onGetPost() {
    dataNameCommunity.isNotEmpty ? dataNameCommunity.clear() : null;
    dataPost.isNotEmpty ? dataPost.clear() : null;
    for (int i = 0; i < listMyIdCommunity.length; i++) {
      post
          .where('idCommunity', isEqualTo: listMyIdCommunity[i])
          .get()
          .then((QuerySnapshot snapshot) {
        snapshot.docs.forEach((post) {
          if (snapshot.size == 0) _isLoading.value = false;
          user
              .where("idUser", isEqualTo: post["idUser"])
              .get()
              .then((QuerySnapshot userSnapshot) {
            userSnapshot.docs.forEach((user) {
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
                // dataDisccusion = (disccusionData);
                dataPost.sort((a, b) => b.sort!.compareTo(a.sort!));
              });
            });
          });
        });
        _isLoading.value = false;
      });
    }
  }

  get isLoading => this._isLoading.value;
}
