import 'package:cloud_firestore/cloud_firestore.dart';

class CommunityMemberModel {
  String? idUser;
  String? idCommunity;
  Timestamp? date;
  String? status;

  CommunityMemberModel(
      {this.idUser,
      this.idCommunity,
      this.date,
      this.status,});
}
