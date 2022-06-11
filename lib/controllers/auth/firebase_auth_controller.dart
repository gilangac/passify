// ignore_for_file: prefer_final_fields, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:passify/helpers/dialog_helper.dart';
import 'package:passify/routes/pages.dart';
import 'package:passify/services/service_notification.dart';
import 'package:passify/services/service_preference.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseAuthController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  GoogleSignIn _googleSignIn = GoogleSignIn();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference user = FirebaseFirestore.instance.collection('users');
  List dataUser = [];
  List listFcmToken = [];

  Stream<User?> authStatus() {
    return auth.authStateChanges();
  }

  Future<UserCredential> signInWithGoogle() async {
    DialogHelper.showLoading();
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

    try {
      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      Get.back();
      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      return await FirebaseAuth.instance.signInWithCredential(credential);
    }

    // Once signed in, return the UserCredential
  }

  onSuccessLogin() async {
    List listFcmToken = [];
    final fcmToken = await NotificationService.getFcmToken();
    listFcmToken.add(fcmToken);
    user.doc(auth.currentUser?.uid).update({
      "fcmToken": listFcmToken,
    });
  }

  onGetUser() async {
    final fcmToken = await NotificationService.getFcmToken();
    final email = auth.currentUser?.email;
    final userId = auth.currentUser?.uid;
    user
        .where("email", isEqualTo: email)
        .get()
        .then((QuerySnapshot snapshot) async {
      print("jumlah : " + snapshot.size.toString());
      if (snapshot.size == 1) {
        snapshot.docs.forEach((element) {
          listFcmToken.add(element['fcmToken']);
        });
        listFcmToken.add(fcmToken);
        user.doc(auth.currentUser?.uid).update({
          "fcmToken": listFcmToken,
        });
        print(listFcmToken);
        print("token : $fcmToken");
        PreferenceService.setUserId(userId!);
        PreferenceService.setFcmToken(fcmToken!);
        PreferenceService.setStatus("logged");
        // onSuccessLogin();
        Get.offNamed(AppPages.NAVIGATOR);
      } else {
        onSuccessLogin();
        await user.doc(auth.currentUser?.uid).set({
          "email": auth.currentUser?.email,
          "idUser": auth.currentUser?.uid,
          "fcmToken": [],
        });
        Get.toNamed(AppPages.REGISTER);
      }
    });
  }

  void logout() async {
    var myToken = PreferenceService.getFcmToken();
    List fcmTokenList = [];
    user.doc(auth.currentUser?.uid).get().then((value) {
      fcmTokenList.assignAll(value['fcmToken']);
      fcmTokenList.removeWhere((token) => token == myToken);
      user.doc(auth.currentUser?.uid).update({
        "fcmToken": fcmTokenList,
      }).then((value) async {
        FirebaseMessaging.instance.deleteToken();
        await auth.signOut();
        PreferenceService.clear();
        PreferenceService.setStatus("unlog");
        await _googleSignIn.signOut().then((value) {
          Get.offAllNamed(AppPages.LOGIN);
          super.dispose();
        });
      });
    });
  }

  @override
  Future<void> onInit() async {
    super.onInit();
  }
}
