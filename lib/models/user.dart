import 'package:cloud_firestore/cloud_firestore.dart';

class Users {
  final String name;
  final String uid;
  final String email;
  final String username;
  final String photourl;
  final List followers;
  final List following;

  Users({
    required this.name,
    required this.uid,
    required this.email,
    required this.username,
    required this.photourl,
    required this.followers,
    required this.following,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'uid': uid,
        'email': email,
        'username': username,
        'follower': [],
        'following': [],
        'photourl': photourl,
      };

  static Users fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Users(
        name: snapshot['name'],
        uid: snapshot['uid'],
        email: snapshot['email'],
        username: snapshot['username'],
        photourl: snapshot['photourl'],
        followers: snapshot['followrs'] ?? [],
        following: snapshot['following']);
  }
}
