// ignore_for_file: prefer_final_fields, unnecessary_this, non_constant_identifier_names, unrelated_type_equality_checks, avoid_print, avoid_function_literals_in_foreach_calls

import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:images_picker/images_picker.dart';
import 'package:passify/controllers/base/service_controller.dart';
import 'package:passify/controllers/home/home_controller.dart';
import 'package:passify/controllers/profile/profile_controller.dart';
import 'package:passify/helpers/dialog_helper.dart';
import 'package:passify/models/community.dart';
import 'package:passify/models/community_member.dart';
import 'package:passify/models/provinsi.dart';
import 'package:intl/intl.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:passify/services/service_provider.dart';

class CommunityController extends GetxController with ServiceController {
  HomeController homeController = Get.find();
  ProfileController profileController = Get.find();
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference community =
      FirebaseFirestore.instance.collection('communities');
  CollectionReference user = FirebaseFirestore.instance.collection('users');
  CollectionReference communityMember =
      FirebaseFirestore.instance.collection('communityMembers');

  final _isLoading = true.obs;
  final formKeyCommunity = GlobalKey<FormState>();
  var dataCommunity = <CommunityModel>[].obs;
  var communityData = <CommunityModel>[].obs;
  var dataMember = <CommunityMemberModel>[].obs;
  var dataCommunityMembers = [].obs;
  var selectedImagePath = ''.obs;
  var progress = 0.0.obs;
  var urlImage = ''.obs;
  File? imageFile;
  List provinsi = [];
  List city = [];
  final provinsiData = [].obs;
  final dataProvinsi = <Provinsi>[];
  final cityData = [].obs;
  final dataCity = <Provinsi>[];
  var category = Get.arguments;

  final nameFC = TextEditingController();
  final descriptionFC = TextEditingController();
  final provinsiFC = TextEditingController();
  final cityFC = TextEditingController();

  @override
  void onInit() async {
    onGetDataCommunity();
    super.onInit();
  }

  onCreateCommunity(String category, String idCommunity) async {
    final dateNow = DateTime.now();
    if (this.formKeyCommunity.currentState!.validate()) {
      try {
        selectedImagePath == ''
            ? await community.doc(idCommunity).set({
                "idCommunity": idCommunity,
                "idUser": auth.currentUser?.uid,
                "photo": "",
                "name": nameFC.text,
                "category": category,
                "description": descriptionFC.text,
                "province": provinsiFC.text,
                "city": cityFC.text,
                "date": dateNow,
              })
            : await community.doc(idCommunity).set({
                "idCommunity": idCommunity,
                "idUser": auth.currentUser?.uid,
                "photo": urlImage.toString(),
                "name": nameFC.text,
                "category": category,
                "description": descriptionFC.text,
                "province": provinsiFC.text,
                "city": cityFC.text,
                "date": dateNow,
              });

        String idMember = DateFormat("yyyyMMddHHmmss").format(DateTime.now()) +
            getRandomString(8).toString();
        await communityMember.doc(idMember).set({
          "idMember": idMember,
          "idCommunity": idCommunity,
          "idUser": auth.currentUser?.uid,
          "status": "verified",
          "date": dateNow,
        }).onError((error, stackTrace) {
          Get.back();
          Get.snackbar("Terjadi Kesalahan", "Periksa koneksi internet anda!");
        });
        homeController.onRefreshData();
        profileController.onRefresh();
        onGetDataCommunity();
        Get.back();
        Get.back();
        onClearFC();
      } catch (e) {
        print(e);
      }
    }
  }

  Future<void> onGetDataCommunity() async {
    _isLoading.value = true;
    try {
      await community
          .where("category", isEqualTo: category)
          .get()
          .then((QuerySnapshot snapshot) {
        if (snapshot.size == 0) {
          _isLoading.value = false;
          dataCommunity.isNotEmpty ? dataCommunity.clear() : null;
        }
        communityData.isNotEmpty ? communityData.clear() : null;
        dataMember.isNotEmpty ? dataMember.clear() : null;
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
              dataMember.length == snapshotMember.size
                  ? _isLoading.value = false
                  : null;
            });
            DateTime a = d['date'].toDate();
            String sort = DateFormat("yyyyMMddHHmmss").format(a);
            communityData.add(CommunityModel(
              name: d["name"],
              photo: d["photo"],
              category: d["category"],
              date: d["date"],
              idUser: d["idUser"],
              idCommunity: d["idCommunity"],
              description: d["description"],
              province: d["province"],
              city: d["city"],
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
    } catch (e) {
      print(e);
      _isLoading.value = false;
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

  onPrepareCreateCommunity() {
    String idCommunity = DateFormat("yyyyMMddHHmmss").format(DateTime.now()) +
        "-cmt-" +
        getRandomString(8).toString();
    if (this.formKeyCommunity.currentState!.validate()) {
      DialogHelper.showLoading();
      if (selectedImagePath == '') {
        onCreateCommunity(category, idCommunity);
      } else {
        uploadImage(idCommunity);
      }
    }
  }

  void uploadImage(String idCommunity) async {
    // String fileName = 'photo/${selectedImagePath.split("/").last}';
    String fileName = 'photo-community/$idCommunity';

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
        onCreateCommunity(category, idCommunity);
      });
    });
  }

  onClearFC() {
    nameFC.clear();
    descriptionFC.clear();
    provinsiFC.clear();
    cityFC.clear();
    selectedImagePath.value = '';
    urlImage.value = '';
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

  final _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();
  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  get isLoading => this._isLoading.value;
}
