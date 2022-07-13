// ignore_for_file: unnecessary_overrides, avoid_print, unrelated_type_equality_checks, unnecessary_this, unnecessary_brace_in_string_interps, unused_local_variable

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:images_picker/images_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:passify/controllers/forum/detail_community_controller.dart';
import 'package:passify/controllers/forum/forum_controller.dart';
import 'package:path/path.dart' as Path;
import 'package:passify/controllers/forum/detail_post_controller.dart';
import 'package:passify/helpers/dialog_helper.dart';
import 'package:passify/models/post.dart';

class EditPostController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference user = FirebaseFirestore.instance.collection('users');
  CollectionReference post = FirebaseFirestore.instance.collection('post');
  File? imageFile;
  var isDiscusion = true.obs;
  var isLoading = true.obs;
  var idPost = Get.arguments[0];
  var isFrom = Get.arguments[1];
  var idCommunity = ''.obs;
  var progress = 0.0.obs;
  var urlImage = ''.obs;
  var dataPost = <PostModel>[].obs;

  final formKeyEdit = GlobalKey<FormState>();
  final titleFC = TextEditingController();
  final captionFC = TextEditingController();
  final priceFC = TextEditingController();
  final noHpFC = TextEditingController();

  var selectedImagePath = ''.obs;

  @override
  void onInit() {
    super.onInit();
    onGetData();
  }

  onGetData() async {
    try {
      await post
          .where("idPost", isEqualTo: idPost)
          .get()
          .then((QuerySnapshot snapshot) {
        snapshot.docs.forEach((d) {
          dataPost.add(PostModel(
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
          dataPost[0].category.toString() == "fjb"
              ? isDiscusion.value = false
              : isDiscusion.value = true;
          isLoading.value = false;
          idCommunity.value = dataPost[0].idCommunity.toString();
        });
      });
    } catch (e) {
      print(e);
    }
  }

  void pickImage() async {
    ImagesPicker.pick(
      count: 1,
      language: Language.English,
      pickType: PickType.image,
      quality: 0.5,
      maxSize: 50,
      cropOpt: CropOption(
        aspectRatio: CropAspectRatio.custom,
        cropType: CropType.rect,
      ),
    ).then((value) {
      if (value != null) {
        imageFile = File(value.first.path);
        selectedImagePath.value = value.first.path;
      }
    });
  }

  onPrepareEditePost() {
    if (this.formKeyEdit.currentState!.validate()) {
      DialogHelper.showLoading();
      if (selectedImagePath == '') {
        onEditPost();
      } else {
        uploadImage();
      }
    }
  }

  void uploadImage() async {
    String fileName = 'photo-community/${idCommunity}/${idPost}';

    firebase_storage.Reference ref =
        firebase_storage.FirebaseStorage.instance.ref().child(fileName);
    firebase_storage.UploadTask task = ref.putFile(imageFile!);
    task.snapshotEvents.listen((event) {
      progress.value =
          event.bytesTransferred.toDouble() / event.totalBytes.toDouble();
      print(progress.toString());
    });
    task.then((_) {
      ref.getDownloadURL().then((url) {
        urlImage.value = url;
        onEditPost();
      });
    });
  }

  void onDeleteImage() {
    void _action() async {
      var fileUrl = Uri.decodeFull(Path.basename(dataPost[0].photo.toString()))
          .replaceAll(new RegExp(r'(\?alt).*'), '');

      final firebase_storage.Reference firebaseStorageRef =
          firebase_storage.FirebaseStorage.instance.ref().child(fileUrl);
      await firebaseStorageRef.delete();
      Get.back();
      DialogHelper.showLoading();
      DocumentReference dataPhoto = firestore.collection("post").doc(idPost);

      try {
        await dataPhoto.update({
          "photo": "",
        }).then((value) {
          _afterAction();
        });
      } catch (e) {}
    }

    DialogHelper.showConfirm(
        title: "Hapus Foto",
        description: "Apa anda yakin mau hapus foto?",
        action: _action);
  }

  onEditPost() async {
    DocumentReference editPost = firestore.collection("post").doc(idPost);

    try {
      selectedImagePath == ''
          ? await editPost.update({
              "title": titleFC.text,
              "caption": captionFC.text,
              "price": priceFC.text,
              "noHp": noHpFC.text,
            }).then((value) {
              _afterAction();
            })
          : await editPost.update({
              "photo": urlImage.toString(),
              "title": titleFC.text,
              "caption": captionFC.text,
              "price": priceFC.text,
              "noHp": noHpFC.text,
            }).then((value) {
              _afterAction();
            });
    } catch (e) {
      print(e);
    }
  }

  void _afterAction() {
    if (isFrom == "detail") {
      DetailPostController detailPostC = Get.find();
      ForumController forumController = Get.find();
      // DetailCommunityController detailCommunityC = Get.find();
      // detailCommunityC.onGetData();
      detailPostC.OnRefresh();
      forumController.onGetPost();
      detailPostC.onGetDataDetail();
    } else if (isFrom == "community") {
      DetailCommunityController detailCommunityC = Get.find();
      detailCommunityC.onGetData();
    }
    Get.back();
    Get.back();
  }
}
