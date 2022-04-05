// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';

Widget formInput(
    {required String title,
    String? initialValue,
    required String placeholder,
    required controller,
    required TextInputType inputType,
    required TextInputAction inputAction,
    bool secureText = false,
    bool enabled = true,
    bool suffix = false,
    required validator}) {
  return Column(
    children: [
      Container(
        alignment: Alignment.centerLeft,
        child: Text(title, style: Get.textTheme.subtitle2),
      ),
      SizedBox(height: 8),
      TextFormField(
        initialValue: initialValue,
        controller: controller,
        onChanged: (text) => {},
        keyboardType: inputType,
        textInputAction: inputAction,
        obscureText: secureText,
        enabled: enabled,
        decoration: InputDecoration(
            hintText: placeholder,
            suffixIcon: suffix == true ? Icon(Feather.chevron_down) : null),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: validator,
      ),
    ],
  );
}
