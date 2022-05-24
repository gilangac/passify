import 'package:cloud_firestore/cloud_firestore.dart';

class PostCommentModel {
  String? idUser;
  String? idPost;
  String? idCommunity;
  Timestamp? date;
  String? comment;
  String? name;
  String? username;
  String? photo;
  int? sort;

  PostCommentModel(
      {this.idUser,
      this.idPost,
      this.idCommunity,
      this.date,
      this.comment,
      this.name,
      this.username,
      this.photo,
      this.sort});
}
