// ignore_for_file: unnecessary_this, unrelated_type_equality_checks, avoid_print, unnecessary_brace_in_string_interps, avoid_function_literals_in_foreach_calls

import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:images_picker/images_picker.dart';
import 'package:passify/controllers/base/service_controller.dart';
import 'package:passify/controllers/forum/community_controller.dart';
import 'package:passify/helpers/dialog_helper.dart';
import 'package:passify/helpers/snackbar_helper.dart';
import 'package:passify/models/community.dart';
import 'package:passify/models/post.dart';
import 'package:passify/models/provinsi.dart';
import 'package:passify/models/user.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:intl/intl.dart';
import 'package:passify/services/service_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailCommunityController extends GetxController with ServiceController {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference community =
      FirebaseFirestore.instance.collection('communities');
  CollectionReference user = FirebaseFirestore.instance.collection('users');
  CollectionReference communityMember =
      FirebaseFirestore.instance.collection('communityMembers');
  CollectionReference post = FirebaseFirestore.instance.collection('post');
  CollectionReference postComment =
      FirebaseFirestore.instance.collection('postComments');

  ScrollController? controller;
  var isExtends = true.obs;
  var isDiscusion = true.obs;
  var isMember = false.obs;
  var isCreator = false.obs;
  var isRequestJoin = false.obs;
  var nameUser = "".obs;
  final isLoadingDetail = true.obs;
  var selectedImagePath = ''.obs;
  var selectedImagePathEdit = ''.obs;
  var progress = 0.0.obs;
  var urlImage = ''.obs;
  var urlImageEdit = ''.obs;
  var myAccountId = ''.obs;
  String idCommunity = Get.arguments;
  File? imageFile;
  var detailCommunity = <CommunityModel>[].obs;
  var userCommunity = <UserModel>[].obs;
  var memberCommunity = <UserModel>[].obs;
  var memberWaiting = <UserModel>[].obs;
  var dataDisccusion = <PostModel>[].obs;
  var dataFjb = <PostModel>[].obs;
  var disccusionData = <PostModel>[].obs;
  var fjbData = <PostModel>[].obs;
  List provinsi = [];
  List city = [];
  final provinsiData = [].obs;
  final dataProvinsi = <Provinsi>[];
  final cityData = [].obs;
  final dataCity = <Provinsi>[];
  final formKeyPost = GlobalKey<FormState>();
  final formKeyEdit = GlobalKey<FormState>();

  final titleFC = TextEditingController();
  final captionFC = TextEditingController();
  final priceFC = TextEditingController();
  final noHpFC = TextEditingController();

  final nameFC = TextEditingController();
  final provinsiFC = TextEditingController();
  final cityFC = TextEditingController();
  final descriptionFC = TextEditingController();

  @override
  void onInit() {
    onGetData();
    onScrollControlled();
    super.onInit();
  }

  onScrollControlled() {
    controller = ScrollController();
    controller?.addListener(() {
      if (controller!.position.pixels == controller!.position.minScrollExtent) {
        isExtends.value = true;
      } else if (controller!.position.userScrollDirection ==
          ScrollDirection.reverse) {
        isExtends.value = false;
      }
    });
  }

  onGetData() async {
    final User? users = auth.currentUser;
    final String? myId = users!.uid;
    myAccountId.value = myId.toString();
    try {
      await community
          .where("idCommunity", isEqualTo: idCommunity)
          .get()
          .then((QuerySnapshot snapshot) {
        // detailEvent.clear();
        memberCommunity.isNotEmpty ? memberCommunity.clear() : null;
        memberWaiting.isNotEmpty ? memberWaiting.clear() : null;
        snapshot.docs.forEach((d) {
          communityMember
              .where("idCommunity", isEqualTo: d["idCommunity"])
              .get()
              .then((QuerySnapshot snapshotMember) {
            snapshotMember.docs.forEach((member) {
              detailCommunity.isNotEmpty ? detailCommunity.clear() : null;
              detailCommunity.add(CommunityModel(
                name: d["name"],
                category: d["category"],
                date: d["date"],
                idUser: d["idUser"],
                idCommunity: d["idCommunity"],
                description: d["description"],
                city: d["city"],
                province: d["province"],
                photo: d["photo"],
              ));

              if (d['idUser'] == myId) {
                isCreator.value = true;
              }

              if (member["status"] == "verified") {
                user
                    .where("idUser", isEqualTo: member["idUser"])
                    .get()
                    .then((QuerySnapshot value) {
                  value.docs.forEach((u) {
                    memberCommunity.add(UserModel(
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
                    memberCommunity.sort((a, b) =>
                        a.name!.toString().compareTo(b.name!.toString()));

                    u["idUser"] == d["idUser"]
                        ? nameUser.value = u["name"]
                        : null;
                  });
                });
              }
              if (member["status"] == "waiting") {
                user
                    .where("idUser", isEqualTo: member["idUser"])
                    .get()
                    .then((QuerySnapshot value) {
                  value.docs.forEach((u) {
                    memberWaiting.add(UserModel(
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

                    memberWaiting.sort((a, b) => b.name!.compareTo(a.name!));
                  });
                });
              }
              if (member["idUser"] == myId) {
                if (member["status"] == "verified") {
                  isMember.value = true;
                } else {
                  isMember.value = false;
                }
                if (member["status"] == "waiting") {
                  print("ada saya");
                  isRequestJoin.value = true;
                } else {
                  isRequestJoin.value = false;
                }
              }
              isLoadingDetail.value = false;
            });
            onGetPost();
          });
        });
      });
    } catch (e) {
      print(e);
    }
  }

  onGetPost() async {
    try {
      await post
          .where("idCommunity", isEqualTo: idCommunity)
          .get()
          .then((QuerySnapshot snapshot) {
        snapshot.docs.forEach((post) {
          user
              .where("idUser", isEqualTo: post["idUser"])
              .get()
              .then((QuerySnapshot userSnapshot) {
            dataDisccusion.isNotEmpty ? dataDisccusion.clear() : null;
            dataFjb.isNotEmpty ? dataFjb.clear() : null;
            userSnapshot.docs.forEach((user) {
              postComment
                  .where("idPost", isEqualTo: post["idPost"])
                  .get()
                  .then((QuerySnapshot snapshotComment) {
                if (post["category"] == "disccusion") {
                  DateTime a = post['date'].toDate();
                  String sort = DateFormat("yyyyMMddHHmmss").format(a);
                  dataDisccusion.add(PostModel(
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
                  dataDisccusion.sort((a, b) => b.sort!.compareTo(a.sort!));
                } else if (post["category"] == "fjb") {
                  DateTime a = post['date'].toDate();
                  String sort = DateFormat("yyyyMMddHHmmss").format(a);
                  dataFjb.add(PostModel(
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
                  // dataFjb.assignAll(fjbData);
                  dataFjb.sort((a, b) => b.sort!.compareTo(a.sort!));
                }
              });
            });
          });
        });
      });
    } catch (e) {
      print(e);
    }
  }

  onCreatePost(String idPost) async {
    String category = isDiscusion.value ? "disccusion" : "fjb";
    final dateNow = DateTime.now();
    if (this.formKeyPost.currentState!.validate()) {
      try {
        selectedImagePath == ''
            ? await post.doc(idPost).set({
                "idPost": idPost,
                "idCommunity": idCommunity,
                "idUser": auth.currentUser?.uid,
                "photo": "",
                "caption": captionFC.text,
                "title": titleFC.text,
                "category": category,
                "price": priceFC.text,
                "noHp": noHpFC.text,
                "status": "available",
                "date": dateNow,
              })
            : await post.doc(idPost).set({
                "idPost": idPost,
                "idCommunity": idCommunity,
                "idUser": auth.currentUser?.uid,
                "photo": urlImage.toString(),
                "caption": captionFC.text,
                "title": titleFC.text,
                "category": category,
                "price": priceFC.text,
                "noHp": noHpFC.text,
                "status": "available",
                "date": dateNow,
              });

        onGetData();
        Get.back();
        Get.back();
        onClearFC();
      } catch (e) {
        print(e);
      }
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

  void pickImageEdit() async {
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
        selectedImagePathEdit.value = value.first.path;
      }
    });
  }

  onPrepareCreatePost() {
    if (this.formKeyPost.currentState!.validate()) {
      DialogHelper.showLoading();
      String idPost = "post-" + getRandomString(15).toString();
      if (selectedImagePath == '') {
        onCreatePost(idPost);
      } else {
        uploadImage(idPost);
      }
    }
  }

  void uploadImage(String idPost) async {
    // String fileName = 'photo/${selectedImagePath.split("/").last}';
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
        onCreatePost(idPost);
      });
    });
  }

  void editImage() async {
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
        urlImageEdit.value = url;
        onEditCommunity();
      });
    });
  }

  void onDeleteImage() {
    void _action() async {
      Get.back();
      DialogHelper.showLoading();
      DocumentReference dataPhoto =
          firestore.collection("communities").doc(idCommunity);

      try {
        await dataPhoto.update({
          "photo": "",
        }).then((value) {
          Get.back();
          Get.back();
          onGetData();
          // comunityC.onGetDataCommunity();
        });
      } catch (e) {}
    }

    DialogHelper.showConfirm(
        title: "Hapus Foto Komunitas",
        description: "Apa anda yakin mau hapus foto komunitas?",
        action: _action);
  }

  onPrepareEditCommunity() {
    if (this.formKeyEdit.currentState!.validate()) {
      DialogHelper.showLoading();
      if (selectedImagePathEdit == '') {
        onEditCommunity();
      } else {
        editImage();
      }
    }
  }

  onEditCommunity() async {
    DocumentReference editCommunity =
        firestore.collection("communities").doc(idCommunity);

    try {
      selectedImagePathEdit == ''
          ? await editCommunity.update({
              "name": nameFC.text,
              "description": descriptionFC.text,
              "province": provinsiFC.text,
              "city": cityFC.text,
            }).then((value) {
              Get.back();
              Get.back();
              onClearFC();
              onGetData();
              // comunityC.onGetDataCommunity();
            })
          : await editCommunity.update({
              "photo": urlImageEdit.toString(),
              "name": nameFC.text,
              "description": descriptionFC.text,
              "province": provinsiFC.text,
              "city": cityFC.text,
            }).then((value) {
              Get.back();
              Get.back();
              onClearFC();
              onGetData();
              // comunityC.onGetDataCommunity();
            });
    } catch (e) {}
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

  onJoinCommunity() async {
    final dateNow = DateTime.now();
    var idMember = getRandomString(20);
    isRequestJoin.value = true;
    await communityMember.doc(idMember).set({
      "idMember": idMember,
      "idCommunity": idCommunity,
      "idUser": auth.currentUser?.uid,
      "status": "waiting",
      "date": dateNow,
    });
  }

  onLeaveCommunity(String? type) async {
    DialogHelper.showConfirm(
        title: type == "cancel" ? "Batal Bergabung" : 'Keluar komunitas',
        description: type == "cancel"
            ? "Batal bergabung dengan komunitas?"
            : 'Apa anda yakin akan meinggalkan komunitas?',
        action: () async {
          Get.back();
          isRequestJoin.value = false;
          isMember.value = false;
          await communityMember
              .where("idUser", isEqualTo: auth.currentUser!.uid)
              .where("idCommunity", isEqualTo: idCommunity)
              .get()
              .then((value) {
            value.docs.forEach((element) {
              communityMember.doc(element["idMember"]).delete();
              onGetData();
              // comunityC.onGetDataCommunity();
            });
          });
        });
  }

  onAccMember(String idUser) async {
    Get.back();
    await communityMember
        .where("idUser", isEqualTo: idUser)
        .where("idCommunity", isEqualTo: idCommunity)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        communityMember.doc(element["idMember"]).update({"status": "verified"});
        // comunityC.onGetDataCommunity();
      });
    });
    onGetData();
  }

  onRejectMember(String idUser) async {
    Get.back();
    await communityMember
        .where("idUser", isEqualTo: idUser)
        .where("idCommunity", isEqualTo: idCommunity)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        communityMember.doc(element["idMember"]).delete();
      });
    });
    onGetData();
  }

  void onConfirmDelete(String idPost) {
    Get.back();
    DialogHelper.showConfirm(
        title: "Hapus Postingan",
        description: "Anda yakin akan menghapus postingan ini?",
        action: () {
          Get.back();
          onDeletePost(idPost);
        });
  }

  onDeletePost(String idPost) async {
    DialogHelper.showLoading();
    await post.doc(idPost).delete().then((value) {
      postComment.where("idPost", isEqualTo: idPost).get().then((snapPost) {
        snapPost.docs.forEach((element) {
          postComment.doc(element["idComment"]).delete();
        });
        onGetData();
        Get.back();
      });
    });
  }

  onClearFC() {
    titleFC.clear();
    captionFC.clear();
    noHpFC.clear();
    priceFC.clear();
    selectedImagePath.value = '';
    selectedImagePathEdit.value = '';
    urlImage.value = '';
    urlImageEdit.value = '';
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
      SnackBarHelper.showError(description: "Tidak dapat menghubungkan");
    }
  }

  final _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  final Random _rnd = Random();
  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
}