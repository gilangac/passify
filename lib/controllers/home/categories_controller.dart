// ignore_for_file: unused_import, duplicate_ignore, unused_field, unnecessary_this

// ignore: unused_import
import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:passify/controllers/home/home_controller.dart';
import 'package:passify/services/service_preference.dart';

class CategoriesController extends GetxController {
  final HomeController homeController = Get.find();
  final _isChange = true.obs;
  final change = 0.obs;
  final c1 = 0.obs;
  final c2 = 0.obs;
  final c3 = 0.obs;
  final c4 = 0.obs;
  final changeC1 = 0.obs;
  final changeC2 = 0.obs;
  final changeC3 = 0.obs;
  final changeC4 = 0.obs;
  final _isLoading = true.obs;

  final itemsChange = [].obs;
  final otherItemsChange = [].obs;

  @override
  void onInit() async {
    readJson();
    super.onInit();
  }

  readJson() async {
    itemsChange.isNotEmpty ? itemsChange.clear() : null;
    otherItemsChange.isNotEmpty ? otherItemsChange.clear() : null;
    final String response =
        await rootBundle.loadString('assets/json/categories.json');
    final data = await json.decode(response);
    itemsChange.value = data["categories"];

    c1.value = int.parse(PreferenceService.getC1().toString());
    c2.value = int.parse(PreferenceService.getC2().toString());
    c3.value = int.parse(PreferenceService.getC3().toString());
    c4.value = int.parse(PreferenceService.getC4().toString());

    otherItem();
  }

  otherItem() {
    for (int i = 0; i < itemsChange.length; i++) {
      if (itemsChange[i]['id'] != PreferenceService.getC1().toString() &&
          itemsChange[i]['id'] != PreferenceService.getC2().toString() &&
          itemsChange[i]['id'] != PreferenceService.getC3().toString() &&
          itemsChange[i]['id'] != PreferenceService.getC4().toString()) {
        otherItemsChange.add(itemsChange[i]);
        otherItemsChange.refresh();
      }
    }
    _isLoading.value = false;
  }
  
  onMinFav(String id) {
    id == changeC1.value.toString()
        ? changeC1.value = 300
        : id == changeC2.value.toString()
            ? changeC2.value = 300
            : id == changeC3.value.toString()
                ? changeC3.value = 300
                : changeC4.value = 300;
    otherItemsChange.clear();
    for (int i = 0; i < itemsChange.length; i++) {
      if (itemsChange[i]['id'] != changeC1.value.toString() &&
          itemsChange[i]['id'] != changeC2.value.toString() &&
          itemsChange[i]['id'] != changeC3.value.toString() &&
          itemsChange[i]['id'] != changeC4.value.toString()) {
        otherItemsChange.add(itemsChange[i]);
        otherItemsChange.refresh();
        update();
      }
    }
  }

  onAddFav(String id) {
    int id2 = int.parse(id);
    changeC1.value == 300
        ? changeC1.value = id2
        : changeC2.value == 300
            ? changeC2.value = id2
            : changeC3.value == 300
                ? changeC3.value = id2
                : changeC4.value == 300
                    ? changeC4.value = id2
                    : null;
    otherItemsChange.clear();
    for (int i = 0; i < itemsChange.length; i++) {
      if (itemsChange[i]['id'] != changeC1.value.toString() &&
          itemsChange[i]['id'] != changeC2.value.toString() &&
          itemsChange[i]['id'] != changeC3.value.toString() &&
          itemsChange[i]['id'] != changeC4.value.toString()) {
        otherItemsChange.add(itemsChange[i]);
        otherItemsChange.refresh();
        update();
      }
    }
  }

  onCancle() {
    otherItemsChange.clear();
    otherItemsChange.addAll(homeController.otherItems);
    change.value = 0;
  }

  onSaveChange() {
    (changeC1.value == 300 ||
            changeC2.value == 300 ||
            changeC3.value == 300 ||
            changeC4.value == 300)
        ? null
        : PreferenceService.setC1(changeC1.value);
    PreferenceService.setC2(changeC2.value);
    PreferenceService.setC3(changeC3.value);
    PreferenceService.setC4(changeC4.value);

    homeController.readJson();
    change.value = 0;
  }

  get isChange => this._isChange.value;
  get isLoading => this._isLoading.value;
}
