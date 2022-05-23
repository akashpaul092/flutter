import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:koolhabbit/database_connection/auth.dart';
import 'package:koolhabbit/models/user.dart';
import 'package:koolhabbit/provider/user_provider.dart';
import 'package:koolhabbit/screen/addPost.dart';
import 'package:koolhabbit/screen/feed_design/feed.dart';
import 'package:koolhabbit/screen/profile/profilepage.dart';
import 'package:koolhabbit/screen/search_screen.dart';
import 'package:provider/provider.dart';

class Ui extends StatefulWidget {
  const Ui({Key? key}) : super(key: key);

  @override
  State<Ui> createState() => _UiState();
}

class _UiState extends State<Ui> {
  int _page = 0;
  late PageController pageController;
  @override
  void initState() {
    super.initState();
    addData();
    pageController = PageController();
  }

  addData() async {
    UserProvider _userProvider = Provider.of(context, listen: false);
    await _userProvider.refreshUser();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  void onPagechange(int page) {
    setState(() {
      _page = page;
    });
  }

  void navigationtapped(int page) {
    pageController.jumpToPage(page);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: PageView(
        children: [
          const Feed(),
          const SearchScreen(),
          const AddPost(),
          const Text("notyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy",
              style: TextStyle(fontSize: 50, color: Colors.blueAccent)),
          ProfileScreen(
            uid: FirebaseAuth.instance.currentUser!.uid,
          ),
        ],
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        onPageChanged: onPagechange,
      ),
      bottomNavigationBar: CupertinoTabBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: _page == 0 ? Colors.blueAccent : Colors.white,
            ),
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.search,
                  color: _page == 1 ? Colors.blueAccent : Colors.white)),
          BottomNavigationBarItem(
              icon: Icon(Icons.add_circle,
                  color: _page == 2 ? Colors.blueAccent : Colors.white)),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite,
                  color: _page == 3 ? Colors.blueAccent : Colors.white)),
          BottomNavigationBarItem(
              icon: Icon(Icons.person,
                  color: _page == 4 ? Colors.blueAccent : Colors.white)),
        ],
        onTap: navigationtapped,
        backgroundColor: Colors.black45,
      ),
    );
  }
}
