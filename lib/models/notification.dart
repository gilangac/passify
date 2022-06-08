import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  String? idNotification;
  String? idUser;
  Timestamp? date;
  String? idFromUser;
  String? code;
  int? category;
  Timestamp? readAt;
  int? sort;

  NotificationModel(
      {this.idNotification,
      this.idUser,
      this.date,
      this.idFromUser,
      this.code,
      this.category,
      this.readAt,
      this.sort});
}

