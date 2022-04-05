import 'package:firebase_auth/firebase_auth.dart';

class EventCommentModel {
  String? idUser;
  String? idEvent;
  String? date;
  String? comment;
  String? name;
  String? username;
  String? photo;

  EventCommentModel({
    this.idUser,
    this.idEvent,
    this.date,
    this.comment,
    this.name,
    this.username,
    this.photo,
  });
}
