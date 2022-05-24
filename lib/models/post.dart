import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  String? idUser;
  String? idPost;
  String? idCommunity;
  String? name;
  String? username;
  Timestamp? date;
  String? caption;
  String? category;
  String? title;
  String? price;
  String? noHp;
  String? photo;
  String? photoUser;
  String? status;
  int? comment;
  int? sort;

  PostModel(
      {this.idUser,
      this.idPost,
      this.idCommunity,
      this.name,
      this.username,
      this.date,
      this.caption,
      this.category,
      this.title,
      this.price,
      this.noHp,
      this.photo,
      this.photoUser,
      this.status,
      this.comment,
      this.sort});
}
