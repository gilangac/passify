import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? photo;
  String? username;
  String? name;
  String? email;
  String? provinsi;
  String? city;
  String? idUser;
  Timestamp? date;
  List? hobby;
  String? instagram;
  String? twitter;

  UserModel({
    this.photo,
    this.username,
    this.name,
    this.email,
    this.provinsi,
    this.city,
    this.idUser,
    this.date,
    this.hobby,
    this.instagram,
    this.twitter,
  });
}