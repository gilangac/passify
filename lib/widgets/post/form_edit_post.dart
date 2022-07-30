// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:passify/constant/color_constant.dart';
import 'package:passify/controllers/forum/detail_event_controller.dart';
import 'package:intl/intl.dart';
import 'package:passify/views/forum/maps_new_event_page.dart';

DetailEventController controller = Get.find();

void formCreateEvent() {
  Get.bottomSheet(
    SafeArea(
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Container(
          height: Get.height * 0.92,
          child: Column(
            children: [
              _actionBar("Event"),
              Expanded(
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Form(
                    key: controller.formKeyEditEvent,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: 20),
                        _formEventName(),
                        _formEventDate(),
                        _formEventTime(),
                        _formEventPickLocation(),
                        _formEventLocation(),
                        _formEventDesc(),
                        SizedBox(height: 50),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20))),
    isDismissible: false,
    enableDrag: false,
    isScrollControlled: true,
  );
}

Widget _formEventName() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    child: TextFormField(
      onChanged: (text) => {},
      keyboardType: TextInputType.name,
      textInputAction: TextInputAction.next,
      enabled: true,
      decoration: InputDecoration(hintText: "Nama Event"),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Masukkan Nama Event terlebih dahulu';
        }
        return null;
      },
      controller: controller.nameFC
        ..text = controller.detailEvent[0].name.toString(),
    ),
  );
}

Widget _formEventPickLocation() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    child: GestureDetector(
      onTap: () {
        Get.to(() => MapsPageNewEvent(), arguments: "edit");
      },
      child: TextFormField(
        onChanged: (text) => {},
        keyboardType: TextInputType.name,
        textInputAction: TextInputAction.next,
        enabled: false,
        onTap: () {
          Get.to(() => MapsPageNewEvent(), arguments: "edit");
        },
        decoration: InputDecoration(
            hintText: "Lokasi",
            suffixIcon: Icon(
              Feather.map_pin,
              color: Colors.grey.shade300,
            )),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Masukkan Nama Event terlebih dahulu';
          }
          return null;
        },
        controller: controller.addressFC
          ..text = controller.detailEvent[0].location.toString(),
      ),
    ),
  );
}

Widget _formEventLocation() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    child: TextFormField(
        onChanged: (text) => {},
        keyboardType: TextInputType.name,
        textInputAction: TextInputAction.newline,
        enabled: true,
        maxLines: 4,
        minLines: 2,
        decoration: InputDecoration(hintText: "Deskripsi Lokasi"),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Masukkan Lokasi terlebih dahulu';
          }
          return null;
        },
        controller: controller.locationFC
          ..text = controller.detailEvent[0].locationDesc.toString()),
  );
}

Widget _formEventDate() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    child: GestureDetector(
      onTap: () {
        Get.bottomSheet(
            SafeArea(
              child: Container(
                height: 250,
                width: Get.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      alignment: Alignment.bottomRight,
                      width: Get.width,
                      color: Colors.white,
                      child: GestureDetector(
                        onTap: () => Get.back(),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 7),
                          child: Text("Selesai",
                              style: GoogleFonts.poppins(
                                  color: Colors.blue.shade700,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400)),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 15),
                      height: 200,
                      child: CupertinoDatePicker(
                        mode: CupertinoDatePickerMode.date,
                        use24hFormat: true,
                        dateOrder: DatePickerDateOrder.dmy,
                        minimumDate: DateTime.now(),
                        onDateTimeChanged: (DateTime newDateTime) {
                          controller.dateEvent = newDateTime;
                          controller.dateFC.text =
                              DateFormat("EEEE, dd MMMM yyyy", "id")
                                  .format(newDateTime)
                                  .toString();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            backgroundColor: Colors.grey.shade200,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20))),
            isDismissible: true,
            enableDrag: false,
            isScrollControlled: true);
      },
      child: TextFormField(
          onChanged: (text) => {},
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          enabled: false,
          decoration: InputDecoration(
              hintText: "Tanggal",
              suffixIcon: Icon(
                Feather.calendar,
                color: Colors.grey.shade300,
              )),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Masukkan Tanggal terlebih dahulu';
            }
            return null;
          },
          controller: controller.dateFC
            ..text = DateFormat("EEEE, dd MMMM yyyy", "id")
                .format(controller.detailEvent[0].dateEvent!.toDate())
                .toString()),
    ),
  );
}

Widget _formEventTime() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    child: GestureDetector(
      onTap: () {
        Get.bottomSheet(
            SafeArea(
              child: Container(
                height: 250,
                width: Get.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      alignment: Alignment.bottomRight,
                      width: Get.width,
                      color: Colors.white,
                      child: GestureDetector(
                        onTap: () => Get.back(),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 7),
                          child: Text("Selesai",
                              style: GoogleFonts.poppins(
                                  color: Colors.blue.shade700,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400)),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 15),
                      height: 200,
                      child: Row(
                        children: [
                          Container(
                            width: Get.width * 0.7,
                            child: CupertinoDatePicker(
                              mode: CupertinoDatePickerMode.time,
                              initialDateTime: DateTime.now(),
                              use24hFormat: true,
                              dateOrder: DatePickerDateOrder.dmy,
                              minimumDate: DateTime(2022),
                              onDateTimeChanged: (DateTime newDateTime) {
                                controller.selectedTime.value =
                                    DateFormat("HH.mm ", "id")
                                        .format(newDateTime)
                                        .toString();
                                controller.timeFC.text =
                                    DateFormat("HH.mm ", "id")
                                            .format(newDateTime)
                                            .toString() +
                                        controller.selectedDropdown.value;
                              },
                            ),
                          ),
                          Spacer(),
                          Obx(() => Container(
                                child: DropdownButton<String>(
                                  elevation: 0,
                                  hint: Text(controller.selectedDropdown.value,
                                      style: GoogleFonts.poppins(
                                          color: AppColors.textColor,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400)),
                                  items: <String>['WIB', 'WITA', 'WIT']
                                      .map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    controller.selectedDropdown.value =
                                        value.toString();
                                    controller.timeFC.text =
                                        controller.selectedTime.value +
                                            controller.selectedDropdown.value;
                                  },
                                ),
                              )),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            backgroundColor: Colors.grey.shade200,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20))),
            isDismissible: true,
            enableDrag: false,
            isScrollControlled: true);
      },
      child: TextFormField(
          onChanged: (text) => {},
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          enabled: false,
          decoration: InputDecoration(
              hintText: "Waktu",
              suffixIcon: Icon(
                Feather.clock,
                color: Colors.grey.shade300,
              )),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Masukkan Waktu terlebih dahulu';
            }
            return null;
          },
          controller: controller.timeFC
            ..text = controller.detailEvent[0].time.toString()),
    ),
  );
}

Widget _formEventDesc() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    child: TextFormField(
        onChanged: (text) => {},
        keyboardType: TextInputType.text,
        maxLines: 6,
        minLines: 5,
        textInputAction: TextInputAction.done,
        enabled: true,
        decoration: InputDecoration(hintText: "Deskripsi"),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Masukkan Deskripsi terlebih dahulu';
          }
          return null;
        },
        controller: controller.descriptionFC
          ..text = controller.detailEvent[0].description.toString()),
  );
}

Widget _actionBar(String tab) {
  return Container(
    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
    alignment: Alignment.center,
    child: Row(
      children: [
        GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Container(
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.shade100,
                      blurRadius: 4,
                      spreadRadius: 6)
                ],
              ),
              child: Icon(Feather.x, size: 24)),
        ),
        Spacer(),
        Text(
          "Edit Event",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Spacer(),
        GestureDetector(
          onTap: () {
            //  controller.onCreateEvent(label)
            controller.onEditEvent();
          },
          child: Container(
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.shade100,
                      blurRadius: 4,
                      spreadRadius: 6)
                ],
              ),
              child: Icon(Feather.check, size: 24)),
        ),
      ],
    ),
  );
}
