import 'package:cloud_firestore/cloud_firestore.dart';

class EventModel {
  String? category;
  String? description;
  String? name;
  String? idEvent;
  String? idUser;
  Timestamp? date;
  String? location;
  String? locationDesc;
  String? latitude;
  String? longitude;
  String? time;
  Timestamp? dateEvent;
  int? member;
  int? comment;
  int? sort;

  EventModel(
      {this.category,
      this.description,
      this.name,
      this.idEvent,
      this.idUser,
      this.date,
      this.location,
      this.locationDesc,
      this.latitude,
      this.longitude,
      this.time,
      this.dateEvent,
      this.member,
      this.comment,
      this.sort});
}
