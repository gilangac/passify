// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:passify/constant/color_constant.dart';

Widget circleAvatar(
    {required String? imageData,
    required String nameData,
    required double size}) {
  return CircleAvatar(
    radius: size,
    backgroundColor: (['', null].contains(imageData))
        ? _avatarBackground[nameData[0].toLowerCase()] ?? AppColors.primaryColor
        : Colors.grey.shade300,
    backgroundImage: NetworkImage(imageData.toString()),
    onBackgroundImageError: (exception, stackTrace) => Text(
        nameData[0].toUpperCase(),
        style: GoogleFonts.poppins(
            fontSize: size / 1.1,
            color: Colors.white,
            fontWeight: FontWeight.w500)),
    child: (['', null].contains(imageData))
        ? Text(nameData[0].toUpperCase(),
            style: GoogleFonts.poppins(
                fontSize: size / 1.1,
                color: Colors.white,
                fontWeight: FontWeight.w500))
        : Container(),
  );
}

Map<String, Color> _avatarBackground = {
  'a': Color(0xfff2c85b),
  'b': Color(0xfffba465),
  'c': Color(0xffee3e38),
  'd': Color(0xff53ccec),
  'e': Color(0xff1974d3),
  'f': Color(0xff000181),
  'g': Color(0xff9db300),
  'h': Color(0xfffccf14),
  'i': Color(0xffffe169),
  'j': Color(0xff1d1e4e),
  'k': Color(0xffa155b9),
  'l': Color(0xffff9001),
  'm': Color(0xffff4200),
  'n': Color(0xff5e2390),
  'o': Color(0xff6b0d88),
  'p': Color(0xffffb900),
  'q': Color(0xfff5ac4e),
  'r': Color(0xff940700),
  's': Color(0xfffc9e5b),
  't': Color(0xff41c8e5),
  'u': Color(0xff9a75fc),
  'v': Color(0xffbf3612),
  'w': Color(0xfff24f09),
  'x': Color(0xfff2c070),
  'y': Color(0xff5073d9),
  'z': Color(0xff044855),
};