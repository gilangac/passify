// ignore_for_file: deprecated_member_use, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';

class SnackBarHelper {
  static showError({required String description}) {
    Get.showSnackbar(
      GetBar(
        icon: Icon(Feather.alert_circle, color: Colors.white),
        title: "Gagal",
        message: description,
        backgroundColor: Colors.red.shade600.withOpacity(0.95),
        duration: Duration(seconds: 4),
        snackStyle: SnackStyle.FLOATING,
        snackPosition: SnackPosition.TOP,
        margin: EdgeInsets.symmetric(horizontal: 12),
        borderRadius: 12,
      ),
    );
  }

  static showSucces({required String description, SnackPosition? position}) {
    Get.showSnackbar(
      GetBar(
        icon: Icon(Feather.check_circle,
            color: Color.fromARGB(255, 243, 237, 237)),
        backgroundColor: Colors.green.shade600.withOpacity(0.95),
        title: "Berhasil",
        message: description,
        duration: Duration(seconds: 4),
        snackStyle: SnackStyle.FLOATING,
        snackPosition: position ?? SnackPosition.TOP,
        margin: EdgeInsets.symmetric(horizontal: 12),
        borderRadius: 12,
      ),
    );
  }
}
