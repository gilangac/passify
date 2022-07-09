// ignore_for_file: unnecessary_this, unrelated_type_equality_checks, avoid_print, unused_field, unused_import

import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:images_picker/images_picker.dart';
import 'package:passify/controllers/base/service_controller.dart';
import 'package:passify/extension/title_case.dart';
import 'package:passify/helpers/dialog_helper.dart';
import 'package:passify/helpers/snackbar_helper.dart';
import 'package:passify/models/provinsi.dart';
import 'package:passify/routes/pages.dart';
import 'package:passify/services/service_exception.dart';
import 'package:passify/services/service_notification.dart';
import 'package:passify/services/service_provider.dart';
import 'package:passify/services/service_preference.dart';
import 'package:intl/intl.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class RegisterController extends GetxController with ServiceController {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference user = FirebaseFirestore.instance.collection('users');

  var selectedImagePath = ''.obs;
  var urlImage = ''.obs;
  var progress = 0.0.obs;
  var isChecked = false.obs;
  final dataHobies = [].obs;
  final selectedHoby = [].obs;
  final dateNow = DateTime.now();
  final formKeReg = GlobalKey<FormState>();
  File? imageFile;
  final provinsiData = [].obs;
  final dataProvinsi = <Provinsi>[];
  List provinsi = [];
  final cityData = [].obs;
  final dataCity = <Provinsi>[];
  List city = [];
  List listFcmToken = [];

  final nameFC = TextEditingController();
  final usernameFC = TextEditingController();
  final provinceFC = TextEditingController();
  final cityFC = TextEditingController();
  final hobbyFC = TextEditingController();
  final instagramFC = TextEditingController();
  final twitterFC = TextEditingController();

  @override
  void onInit() async {
    onReadJson();
    onGetProvince();
    final fcmToken = await NotificationService.getFcmToken();
    listFcmToken.add(fcmToken);
    super.onInit();
  }

  onRegister() async {
    final fcmToken = await NotificationService.getFcmToken();
    onSend() {
      try {
        selectedImagePath != ""
            ? user.doc(auth.currentUser?.uid).set({
                "email": auth.currentUser?.email,
                "name": nameFC.text.toTitleCase(),
                "idUser": auth.currentUser?.uid,
                "fcmToken": listFcmToken,
                "photoUser": urlImage.toString(),
                "username": usernameFC.text.toLowerCase(),
                "city": cityFC.text,
                "province": provinceFC.text,
                "status": 1,
                "hobby": selectedHoby,
                "instagram": instagramFC.text.toLowerCase(),
                "twitter": twitterFC.text.toLowerCase(),
                "date": dateNow
              })
            : user.doc(auth.currentUser?.uid).set({
                "email": auth.currentUser?.email,
                "name": nameFC.text.toTitleCase(),
                "idUser": auth.currentUser?.uid,
                "fcmToken": listFcmToken,
                "photoUser": auth.currentUser?.photoURL,
                "username": usernameFC.text.toLowerCase(),
                "city": cityFC.text,
                "province": provinceFC.text,
                "status": 1,
                "hobby": selectedHoby,
                "instagram": instagramFC.text.toLowerCase(),
                "twitter": twitterFC.text.toLowerCase(),
                "date": dateNow
              });
        PreferenceService.setFcmToken(fcmToken!);
        Get.back();
        PreferenceService.setStatus("logged");
        Get.offAllNamed(AppPages.NAVIGATOR);
      } catch (e) {
        Get.back();
      }
    }

    if (this.formKeReg.currentState!.validate()) {
      DialogHelper.showLoading();
      user
          .where('username', isEqualTo: usernameFC.text)
          .get()
          .then((QuerySnapshot snapshot) async {
        print(snapshot.size);
        if (snapshot.size == 0) {
          onSend();
        } else {
          snapshot.docs.forEach((value) {
            Get.back();
            SnackBarHelper.showError(description: "Username sudah digunakan");
          });
        }
      });
    }
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
    selectedImagePath.value = "";
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
    });
    task.then((_) {
      ref.getDownloadURL().then((url) {
        urlImage.value = url;
        onRegister();
      });
    });
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
    dataHobies.clear();
    final String response =
        await rootBundle.loadString('assets/json/categories.json');
    final data = await json.decode(response);
    dataHobies.value = data["categories"];
    print(dataHobies.length);
  }
}
