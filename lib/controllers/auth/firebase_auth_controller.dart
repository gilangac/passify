// ignore_for_file: prefer_final_fields

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:passify/helpers/dialog_helper.dart';
import 'package:passify/routes/pages.dart';
import 'package:passify/services/service_preference.dart';

class FirebaseAuthController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  GoogleSignIn _googleSignIn = GoogleSignIn();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference user = FirebaseFirestore.instance.collection('users');
  List dataUser = [];

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
    user.doc(auth.currentUser?.uid).set({
      "name": auth.currentUser?.displayName,
      "idUser": auth.currentUser?.uid,
      "photoUser": auth.currentUser?.photoURL,
    });
    FirebaseMessaging.instance.subscribeToTopic("all");
  }

  onGetUser() async {
    final email = auth.currentUser?.email;
    user.where("email", isEqualTo: email).get().then((QuerySnapshot snapshot) {
      print("jumlah : " + snapshot.size.toString());
      if (snapshot.size == 1) {
        PreferenceService.setStatus("logged");
        Get.offNamed(AppPages.NAVIGATOR);
      } else {
        Get.toNamed(AppPages.REGISTER);
      }
    });
  }

  void logout() async {
    FirebaseMessaging.instance.deleteToken();
    await auth.signOut();
    PreferenceService.setStatus("unlog");
    await _googleSignIn.signOut().then((value) {
      Get.offAllNamed(AppPages.LOGIN);
      dispose();
    });
  }

  @override
  Future<void> onInit() async {
    super.onInit();
  }
}
