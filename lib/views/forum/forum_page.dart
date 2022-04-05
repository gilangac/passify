// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:passify/widgets/general/app_bar.dart';
import 'package:passify/widgets/general/post_card_widget.dart';

List post = [
  {'foto': "", 'name': 'Taesei Marukawa'},
  {'foto': "ada", 'name': 'Gilang Ahmad Chaeral'},
  {'foto': "", 'name': 'Leonel Messi'},
  {'foto': "ada", 'name': 'Adama Traore'},
  {'foto': "", 'name': 'Mark Marques'},
  {'foto': "ada", 'name': 'Valentino Jebret'}
];

class ForumPage extends StatelessWidget {
  const ForumPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: _body(),
      backgroundColor: Colors.white,
    );
  }

  PreferredSizeWidget _appBar() {
    return appBar(title: "Forum Komunitas", canBack: false);
  }

  Widget _body() {
    return ListView.builder(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.all(25),
        itemCount: post.length,
        itemBuilder: (context, index) {
          return postCard(post[index]);
        });
  }
}
