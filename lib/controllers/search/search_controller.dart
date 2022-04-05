// ignore: unused_import
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchController extends GetxController {
  late final searchText = ''.obs;
  final currentCarousel = 0.obs;
  final searchView = false.obs;

  final searchFC = TextEditingController();
}
