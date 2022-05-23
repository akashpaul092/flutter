import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:koolhabbit/database_connection/storage.dart';
import 'package:koolhabbit/models/post.dart';
import 'package:uuid/uuid.dart';

class FirestorePost {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadPost(String caption, Uint8List file, String uid,
      String username, String ProfileImage) async {
    String res = "Some error occurred";
    try {
      String photourl = await Storage().uploadimage('Posts', file, true);
      String postId = const Uuid().v1();
      Posts post = Posts(
          caption: caption,
          uid: uid,
          username: username,
          postId: postId,
          dateOfPublish: DateTime.now(),
          postUrl: photourl,
          profileImage: ProfileImage,
          likes: []);
      _firestore.collection('Posts').doc(postId).set(post.toJson());
      res = "Success";
    } catch (error) {
      res = error.toString();
    }
    return res;
  }

  Future<void> likePost(String postId, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        await _firestore.collection('Posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid]),
        });
      } else {
        await _firestore.collection('Posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid]),
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> postComment(String postId, String text, String uid, String name,
      String profilePic) async {
    try {
      if (text.isNotEmpty) {
        String CommentId = const Uuid().v1();
        await _firestore
            .collection('Posts')
            .doc(postId)
            .collection('Comments')
            .doc(CommentId)
            .set({
          'name': name,
          'profilePic': profilePic,
          'uid': uid,
          'text': text,
          'dateOfPublished': DateTime.now(),
        });
      } else {
        print('Text is empty');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> deletePost(String postId) async {
    try {
      await _firestore.collection('Posts').doc(postId).delete();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> followUser(String uid, String followId) async {
    try {
      DocumentSnapshot snap =
          await _firestore.collection('users').doc(uid).get();
      List following = (snap.data()! as dynamic)['following'];
      if (following.contains(followId)) {
        await _firestore.collection('users').doc(followId).update({
          'follower': FieldValue.arrayRemove([uid])
        });
        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayRemove([followId])
        });
      } else {
        await _firestore.collection('users').doc(followId).update({
          'follower': FieldValue.arrayUnion([uid])
        });
        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayUnion([followId])
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
