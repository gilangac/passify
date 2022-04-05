// ignore_for_file: unnecessary_this, unrelated_type_equality_checks, avoid_print, unused_field

import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:images_picker/images_picker.dart';
import 'package:passify/helpers/dialog_helper.dart';
import 'package:passify/models/provinsi.dart';
import 'package:passify/routes/pages.dart';
import 'package:passify/services/service_exception.dart';
import 'package:passify/services/service_provider.dart';
import 'package:passify/services/service_preference.dart';
import 'package:intl/intl.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class RegisterController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference user = FirebaseFirestore.instance.collection('users');

  var selectedImagePath = ''.obs;
  var urlImage = ''.obs;
  var progress = 0.0.obs;
  final dataHobies = [].obs;
  final dateNow = DateFormat("dd-MM-yyyy h:mma").format(DateTime.now());
  final formKeReg = GlobalKey<FormState>();
  File? imageFile;
  final provinsiData = [].obs;
  final dataProvinsi = <Provinsi>[];
  List provinsi = [];
  final cityData = [].obs;
  final dataCity = <Provinsi>[];
  List city = [];

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
    super.onInit();
  }

  onRegister() {
    if (this.formKeReg.currentState!.validate()) {
      DialogHelper.showLoading();

      try {
        selectedImagePath != ""
            ? user.doc(auth.currentUser?.uid).set({
                "email": auth.currentUser?.email,
                "name": nameFC.text,
                "idUser": auth.currentUser?.uid,
                "photoUser": urlImage.toString(),
                "username": usernameFC.text.toLowerCase(),
                "city": cityFC.text,
                "hobby": hobbyFC.text,
                "instagram": instagramFC.text.toLowerCase(),
                "twitter": twitterFC.text.toLowerCase(),
                "date": dateNow
              })
            : user.doc(auth.currentUser?.uid).set({
                "email": auth.currentUser?.email,
                "name": nameFC.text,
                "idUser": auth.currentUser?.uid,
                "photoUser": auth.currentUser?.photoURL,
                "username": usernameFC.text.toLowerCase(),
                "city": cityFC.text,
                "hobby": hobbyFC.text,
                "instagram": instagramFC.text.toLowerCase(),
                "twitter": twitterFC.text.toLowerCase(),
                "date": dateNow
              });
        Get.back();
        PreferenceService.setStatus("logged");
        Get.offAllNamed(AppPages.NAVIGATOR);
      } catch (e) {
        Get.back();
      }
    }
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
    if (dataProvinsi.length <= 0) {
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

  onReadJson() async {
    dataHobies.clear();
    final String response =
        await rootBundle.loadString('assets/json/categories.json');
    final data = await json.decode(response);
    dataHobies.value = data["categories"];
    print(dataHobies.length);
  }

  void handleError(error) {
    if (error is BadRequestException) {
      Get.back();

      var message = error.message;
      var url = error.url;

      if (url == '/provinsi') {
        print(message);
      } else {}
    } else if (error is ApiNotRespondingException) {
      var message = error.message;
      print(message);
    } else if (error is UnauthorizedException) {
      var message = error.message;
      print(message);
    } else if (error is FetchDataException) {
      var message = error.message;
      DialogHelper.showError(description: message);
    }
  }

  static final _errorMessages = {
    '/provinsi': {
      'title': 'Gagal',
      'description':
          'Waduh sepertinya ada masalah saat melakukan load Provinsi. Pastikan koneksi anda stabil dan silahkan coba lagi.',
    },
  };
}
