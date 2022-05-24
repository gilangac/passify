import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:passify/models/community_member.dart';

class CommunityModel {
  String? category;
  String? description;
  String? name;
  String? photo;
  String? idCommunity;
  String? idUser;
  Timestamp? date;
  String? province;
  String? city;
  List<CommunityMemberModel>? member;
  int? sort;

  CommunityModel(
      {this.category,
      this.description,
      this.name,
      this.photo,
      this.idCommunity,
      this.idUser,
      this.date,
      this.province,
      this.city,
      this.member,
      this.sort});
}
