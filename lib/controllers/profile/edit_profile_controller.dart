// ignore_for_file: unnecessary_this, unrelated_type_equality_checks

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:passify/controllers/home/home_controller.dart';
import 'package:passify/controllers/profile/profile_controller.dart';
import 'package:passify/helpers/dialog_helper.dart';
import 'package:passify/helpers/snackbar_helper.dart';
import 'package:passify/models/user.dart';
import 'package:images_picker/images_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class EditProfileController extends GetxController {
  var dataUser = <UserModel>[].obs;
  final _isLoading = true.obs;
  var selectedImagePath = ''.obs;
  var progress = 0.0.obs;
  var urlImage = ''.obs;
  File? imageFile;

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference user = FirebaseFirestore.instance.collection('users');
  HomeController homeC = Get.find();
  ProfileController profileC = Get.find();

  final nameFC = TextEditingController();
  final usernameFC = TextEditingController();
  final cityFC = TextEditingController();
  final hobbyFC = TextEditingController();
  final instagramFC = TextEditingController();
  final twitterFC = TextEditingController();

  final formKeyEditProfile = GlobalKey<FormState>();
  @override
  void onInit() async {
    onGetDataUser();
    super.onInit();
  }

  onGetDataUser() {
    // dataUser.clear();
    final User? users = auth.currentUser;
    final String? idUser = users!.uid;
    user
        .where("idUser", isEqualTo: idUser)
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
      dataUser.isNotEmpty ? _isLoading.value = false : _isLoading.value = true;
    });
  }

  void pickImage(String source) async {
    source == 'camera'
        ? ImagesPicker.openCamera(
            language: Language.English,
            maxSize: 50,
            pickType: PickType.image,
            quality: 0.5,
            cropOpt: CropOption(
              aspectRatio: CropAspectRatio.custom,
              cropType: CropType.rect,
            )).then((value) {
            if (value != null) {
              imageFile = File(value.first.path);
              selectedImagePath.value = value.first.path;
            }
          })
        : ImagesPicker.pick(
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

  void onDeleteImage() {
    void _action() async {
      Get.back();
      DialogHelper.showLoading();
      final User? users = auth.currentUser;
      final String? idUser = users!.uid;
      DocumentReference dataUser = firestore.collection("users").doc(idUser);

      try {
        await dataUser.update({
          "photoUser": '',
        }).then((value) {
          Get.back();
          Get.back();
          Get.back();
          homeC.onRefreshData();
          profileC.onGetDataUser();
          SnackBarHelper.showSucces(
              description: "Berhasil. Foto profile berhasil dihapus");
        });
      } catch (e) {
        SnackBarHelper.showError(
            description: "Gagal. Foto profile gagal dihapus");
      }
    }

    DialogHelper.showConfirm(
        title: "Hapus Foto Profil",
        description: "Apa anda yakin mau hapus foto profil?",
        action: _action);
  }

  void uploadImage() async {
    // String fileName = 'photo/${selectedImagePath.split("/").last}';
    String fileName = 'photo/${auth.currentUser!.uid}';

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
        onEditData();
      });
    });
  }

  onEditData() async {
    DialogHelper.showLoading();
    final User? users = auth.currentUser;
    final String? idUser = users!.uid;
    DocumentReference dataUser = firestore.collection("users").doc(idUser);

    try {
      selectedImagePath != ""
          ? await dataUser.update({
              "photoUser": urlImage.toString(),
              "username": usernameFC.text,
              "name": nameFC.text,
              "twitter": twitterFC.text,
              "hobby": hobbyFC.text,
              "city": cityFC.text,
              "instagram": instagramFC.text
            })
          : await dataUser.update({
              "username": usernameFC.text,
              "name": nameFC.text,
              "twitter": twitterFC.text,
              "hobby": hobbyFC.text,
              "city": cityFC.text,
              "instagram": instagramFC.text
            });
      homeC.onRefreshData();
      Get.back();
      Get.back();
      SnackBarHelper.showSucces(description: "Berhasil mengubah profile");
      homeC.onRefreshData();
      profileC.onGetDataUser();
    } catch (e) {
      Get.back();
      SnackBarHelper.showError(description: "Gagal mengubah profile");
    }
  }

  get isLoading => this._isLoading.value;
}
