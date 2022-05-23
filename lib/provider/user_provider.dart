import 'package:flutter/cupertino.dart';
import 'package:koolhabbit/database_connection/auth.dart';
import 'package:koolhabbit/database_connection/firestorePost.dart';
import 'package:koolhabbit/models/user.dart';

class UserProvider with ChangeNotifier {
  Users? _user = Users(
      name: "name",
      uid: 'uid',
      email: 'email',
      username: 'username',
      photourl: 'photourl',
      followers: [],
      following: []);
  final AuthMethod _authMethod = AuthMethod();

  Users get getUser => _user!;

  Future<void> refreshUser() async {
    Users user = await _authMethod.getUserDetails();
    _user = user;
    notifyListeners();
  }
}
