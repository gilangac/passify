import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? photo;
  String? username;
  List? fcmToken;
  String? name;
  String? email;
  String? provinsi;
  String? city;
  String? idUser;
  int? status;
  Timestamp? date;
  List? hobby;
  String? instagram;
  String? twitter;

  UserModel({
    this.photo,
    this.username,
    this.fcmToken,
    this.name,
    this.email,
    this.provinsi,
    this.city,
    this.idUser,
    this.status,
    this.date,
    this.hobby,
    this.instagram,
    this.twitter,
  });
}
