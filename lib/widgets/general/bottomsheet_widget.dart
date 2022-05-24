// ignore_for_file: unused_element, prefer_const_constructors, sized_box_for_whitespace, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';

void BottomSheetList(Widget content, String type) {
  Get.bottomSheet(
    SafeArea(
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Container(
          height: Get.height * 0.92,
          child: Column(
            children: [
              _actionBar(type),
              Expanded(child: content),
            ],
          ),
        ),
      ),
    ),
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20))),
    isDismissible: true,
    enableDrag: false,
    isScrollControlled: true,
  );
}

Widget _actionBar(String type) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
    alignment: Alignment.center,
    child: Row(
      children: [
        GestureDetector(
          onTap: () {
            // eventC.onClearFC();
            Get.back();
          },
          child: Container(
              width: 35,
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.shade100,
                      blurRadius: 4,
                      spreadRadius: 2)
                ],
              ),
              child: Icon(Feather.x, size: 24)),
        ),
        Spacer(),
        Text(
          "Pilih " + type,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Spacer(),
        Container(
          width: 35,
        ),
      ],
    ),
  );
}
