// ignore_for_file: unnecessary_this, unrelated_type_equality_checks, unused_field, avoid_print, implementation_imports, avoid_function_literals_in_foreach_calls

import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/services/asset_bundle.dart';
import 'package:get/get.dart';
import 'package:passify/controllers/base/service_controller.dart';
import 'package:passify/controllers/home/home_controller.dart';
import 'package:passify/controllers/profile/profile_controller.dart';
import 'package:passify/extension/title_case.dart';
import 'package:passify/helpers/dialog_helper.dart';
import 'package:passify/helpers/snackbar_helper.dart';
import 'package:passify/models/provinsi.dart';
import 'package:passify/models/user.dart';
import 'package:images_picker/images_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:passify/services/service_provider.dart';

class EditProfileController extends GetxController with ServiceController {
  var dataUser = <UserModel>[].obs;
  final _isLoading = true.obs;
  var selectedImagePath = ''.obs;
  var progress = 0.0.obs;
  var urlImage = ''.obs;
  final dataHobies = [].obs;
  final selectedHoby = [].obs;
  File? imageFile;
  List provinsi = [];
  List city = [];
  final provinsiData = [].obs;
  final dataProvinsi = <Provinsi>[];
  final cityData = [].obs;
  final dataCity = <Provinsi>[];

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference user = FirebaseFirestore.instance.collection('users');
  HomeController homeC = Get.find();
  ProfileController profileC = Get.find();

  final nameFC = TextEditingController();
  final usernameFC = TextEditingController();
  final provinsiFC = TextEditingController();
  final cityFC = TextEditingController();
  final hobbyFC = TextEditingController();
  final instagramFC = TextEditingController();
  final twitterFC = TextEditingController();

  final formKeyEditProfile = GlobalKey<FormState>();
  @override
  void onInit() async {
    onGetDataUser();
    onGetProvince();
    onReadJson();
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
            provinsi: d["province"],
            instagram: d["instagram"]));

        selectedHoby.value = d['hobby'];
      });
      dataUser.isNotEmpty ? _isLoading.value = false : _isLoading.value = true;
    });
  }

  void pickImage(String source) async {
    source == 'camera'
        ? ImagesPicker.openCamera(
            language: Language.English,
            maxSize: 20,
            pickType: PickType.image,
            quality: 0.3,
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
            quality: 0.3,
            maxSize: 20,
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
    void onEdit() async {
      final User? users = auth.currentUser;
      final String? idUser = users!.uid;
      DocumentReference dataUser = firestore.collection("users").doc(idUser);
      try {
        selectedImagePath != ""
            ? await dataUser.update({
                "photoUser": urlImage.toString(),
                "username": usernameFC.text,
                "name": nameFC.text.toTitleCase(),
                "twitter": twitterFC.text,
                "hobby": selectedHoby,
                "province": provinsiFC.text,
                "city": cityFC.text,
                "instagram": instagramFC.text
              })
            : await dataUser.update({
                "username": usernameFC.text,
                "name": nameFC.text.toTitleCase(),
                "twitter": twitterFC.text,
                "hobby": selectedHoby,
                "province": provinsiFC.text,
                "city": cityFC.text,
                "instagram": instagramFC.text
              });
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

    if (this.formKeyEditProfile.currentState!.validate()) {
      final User? users = auth.currentUser;
      final String? idUser = users!.uid;
      DialogHelper.showLoading();
      user
          .where('username', isEqualTo: usernameFC.text)
          .get()
          .then((QuerySnapshot snapshot) async {
        print(snapshot.size);
        if (snapshot.size == 0) {
          onEdit();
        } else {
          snapshot.docs.forEach((value) {
            if (value['idUser'].contains(idUser)) {
              onEdit();
            } else {
              Get.back();
              SnackBarHelper.showError(description: "Username sudah digunakan");
            }
          });
        }
      });
    }
  }

  onGetProvince() async {
    try {
      var response =
          await ServiceProvider.getData('/provinsi').catchError(handleError);

      if (response == null) return;

      if (response != null) {
        provinsi.clear();
        provinsiData.assignAll(response['provinsi']);

        final _provinsi = List<Provinsi>.from((response['provinsi'])
            .map((item) => Provinsi.fromJson(item))
            .toList());
        _provinsi.sort((a, b) => a.nama!.compareTo(b.nama!));
        dataProvinsi.assignAll(_provinsi);
        update();
      }
      for (int i = 0; i < provinsiData.length; i++) {
        provinsi.add(provinsiData[i]['nama']);
      }
    } finally {
      print(dataProvinsi.length);
    }
  }

  onGetCity(String idProvinsi) async {
    try {
      var response =
          await ServiceProvider.getData('/kota?id_provinsi=$idProvinsi')
              .catchError(handleError);

      if (response == null) return;

      if (response != null) {
        city.clear();
        cityData.assignAll(response['kota_kabupaten']);

        final _city = List<Provinsi>.from((response['kota_kabupaten'])
            .map((item) => Provinsi.fromJson(item))
            .toList());
        _city.sort((a, b) => a.nama!.compareTo(b.nama!));
        dataCity.assignAll(_city);
        update();
      }
      for (int i = 0; i < cityData.length; i++) {
        city.add(cityData[i]['nama']);
      }
    } finally {
      print(dataCity.length);
    }
  }

  onUpdateProvince() async {
    if (dataProvinsi.isEmpty) {
      try {
        final result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          onGetProvince();
        }
      } on SocketException catch (_) {
        print('not connected');
      }
    }
  }

  onSelectHoby(int index) {
    var a = 0;
    if (selectedHoby.isNotEmpty) {
      for (int i = 0; i < selectedHoby.length; i++) {
        if (dataHobies[index]['name'].toString() ==
            selectedHoby[i].toString()) {
          a = 1;
        }
      }
      if (a != 1) {
        if (selectedHoby.length < 3) {
          selectedHoby.add(dataHobies[index]['name'].toString());
        }
      }
    } else {
      selectedHoby.add(dataHobies[index]['name'].toString());
    }
    Get.back();
  }

  onReadJson() async {
    dataHobies.isNotEmpty ? dataHobies.clear() : null;
    final String response =
        await rootBundle.loadString('assets/json/categories.json');
    final data = await json.decode(response);
    dataHobies.value = data["categories"];
    print(dataHobies.length);
  }

  get isLoading => this._isLoading.value;
}
