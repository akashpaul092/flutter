import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:koolhabbit/database_connection/storage.dart';

import '../models/user.dart';

class AuthMethod {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<Users> getUserDetails() async {
    User currentuser = auth.currentUser!;

    DocumentSnapshot snap =
        await firestore.collection('users').doc(currentuser.uid).get();

    return Users.fromSnap(snap);
  }

  currentUSER() {
    return auth.currentUser!;
  }

  Future<String> signup({
    required String name,
    required String email,
    required String username,
    required String password,
    required Uint8List photo,
  }) async {
    String res = "some error occurred";
    try {
      if (name.isNotEmpty &&
          email.isNotEmpty &&
          username.isNotEmpty &&
          password.isNotEmpty &&
          // ignore: unnecessary_null_comparison
          photo != null) {
        UserCredential cred = await auth.createUserWithEmailAndPassword(
            email: email, password: password);

        String str = await Storage().uploadimage('profilepic', photo, false);

        Users users = Users(
            name: name,
            uid: cred.user!.uid,
            email: email,
            username: username,
            photourl: str,
            followers: [],
            following: []);

        await firestore
            .collection('users')
            .doc(cred.user!.uid)
            .set(users.toJson());
        res = "Success";
      }
    } catch (error) {
      res = error.toString();
    }
    return res;
  }

  Future<String> loginpage(
      {required String email, required String password}) async {
    String res = "Some error occured";
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await auth.signInWithEmailAndPassword(email: email, password: password);
        res = "Success";
      } else {
        res = "Please enter all the fields";
      }
    } catch (error) {
      res = error.toString();
    }
    return res;
  }

  Future<void> signout() async {
    await auth.signOut();
  }
}
