import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:koolhabbit/database_connection/auth.dart';
import 'package:koolhabbit/database_connection/firestorePost.dart';
import 'package:koolhabbit/screen/first_page.dart';
import 'package:koolhabbit/screen/profile/follow.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({Key? key, required this.uid}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userData = {};
  int postlength = 0;
  int follower = 0;
  int following = 0;
  bool isFollowing = false;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var usersnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();
      var postsnap = await FirebaseFirestore.instance
          .collection('Posts')
          .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();
      postlength = postsnap.docs.length;
      userData = usersnap.data()!;
      follower = usersnap.data()!['follower'].length;
      following = usersnap.data()!['following'].length;
      isFollowing = usersnap
          .data()!['follower']
          .contains(FirebaseAuth.instance.currentUser!.uid);
      setState(() {});
    } catch (e) {
      ScaffoldMessenger.of(context).showMaterialBanner(
          MaterialBanner(content: Text(e.toString()), actions: [
        TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
            },
            child: const Text("Dismiss"))
      ]));
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: SizedBox(
              width: 100,
              child: LinearProgressIndicator(),
            ),
          )
        : Scaffold(
            backgroundColor: Colors.black87,
            appBar: AppBar(
              backgroundColor: Colors.black87,
              title: Text(
                userData['username'].toString(),
                style: const TextStyle(color: Colors.blueAccent),
              ),
              centerTitle: false,
            ),
            body: ListView(children: [
              Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        child: CircleAvatar(
                          backgroundColor: Colors.lightGreenAccent,
                          backgroundImage:
                              NetworkImage(userData['photourl'].toString()),
                          radius: 64,
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Text(
                          userData['username'].toString(),
                          style: const TextStyle(
                              fontWeight: FontWeight.w900,
                              color: Colors.blueAccent,
                              fontSize: 30),
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          buildStateColumn(postlength, "Posts"),
                          const SizedBox(
                            width: 22,
                          ),
                          buildStateColumn(follower, "Follower"),
                          const SizedBox(width: 22),
                          buildStateColumn(following, "Following"),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          FirebaseAuth.instance.currentUser!.uid == widget.uid
                              ? FollowBtn(
                                  backgroundColor: Colors.greenAccent,
                                  boarderColor: Colors.greenAccent,
                                  text: 'Sign Out',
                                  textColor: Colors.black54,
                                  function: () async {
                                    await AuthMethod().signout();
                                    Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const First_page()));
                                  },
                                )
                              : isFollowing
                                  ? FollowBtn(
                                      backgroundColor: Colors.black87,
                                      boarderColor: Colors.greenAccent,
                                      text: 'Unfollow',
                                      textColor: Colors.greenAccent,
                                      function: () async {
                                        await FirestorePost().followUser(
                                            FirebaseAuth
                                                .instance.currentUser!.uid,
                                            userData['uid'].toString());
                                        setState(() {
                                          isFollowing = false;
                                          follower--;
                                        });
                                      },
                                    )
                                  : FollowBtn(
                                      backgroundColor: Colors.greenAccent,
                                      boarderColor: Colors.greenAccent,
                                      text: 'Follow',
                                      textColor: Colors.black54,
                                      function: () async {
                                        await FirestorePost().followUser(
                                            FirebaseAuth
                                                .instance.currentUser!.uid,
                                            userData['uid'].toString());
                                        setState(() {
                                          isFollowing = true;
                                          follower++;
                                        });
                                      },
                                    )
                        ],
                      )
                    ],
                  )),
              const Divider(
                color: Colors.white,
              ),
              FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection('Posts')
                      .where('uid', isEqualTo: widget.uid)
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: SizedBox(
                          width: 100,
                          child: LinearProgressIndicator(),
                        ),
                      );
                    }
                    return GridView.builder(
                        shrinkWrap: true,
                        itemCount: (snapshot.data! as dynamic).docs.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 5,
                                mainAxisSpacing: 2,
                                childAspectRatio: 1),
                        itemBuilder: (context, index) {
                          DocumentSnapshot snap =
                              (snapshot.data! as dynamic).docs[index];
                          return Container(
                            child: Image(
                              image: NetworkImage(snap['postUrl']),
                              fit: BoxFit.cover,
                            ),
                          );
                        });
                  })
            ]),
          );
  }

  Column buildStateColumn(int num, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          num.toString(),
          style: const TextStyle(
              fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        Container(
          margin: const EdgeInsets.only(top: 4),
          child: Text(
            label,
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w900,
                color: Colors.blueAccent),
          ),
        )
      ],
    );
  }
}
