import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Posts {
  final String caption;
  final String uid;
  final String username;
  final String postId;
  final dateOfPublish;
  final String postUrl;
  final String profileImage;
  final likes;

  const Posts(
      {required this.caption,
      required this.uid,
      required this.username,
      required this.postId,
      required this.dateOfPublish,
      required this.postUrl,
      required this.profileImage,
      required this.likes});

  Map<String, dynamic> toJson() => {
        'description': caption,
        'uid': uid,
        'username': username,
        'postId': postId,
        'dateOfPublish': dateOfPublish,
        'postUrl': postUrl,
        'profileImage': profileImage,
        'likes': likes
      };

  static Posts fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Posts(
        caption: snapshot['description'],
        uid: snapshot['uid'],
        username: snapshot['username'],
        postId: snapshot['postId'],
        dateOfPublish: snapshot['dateOfPublish'],
        postUrl: snapshot['postUrl'],
        profileImage: snapshot['profileImage'],
        likes: snapshot['likes']);
  }
}
