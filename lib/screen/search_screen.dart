import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:koolhabbit/screen/profile/profilepage.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  bool isShow = false;
  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: TextFormField(
          controller: searchController,
          decoration: const InputDecoration(
              hintText: 'Search here...',
              hintStyle: TextStyle(color: Colors.blueAccent)),
          style: const TextStyle(color: Colors.blueAccent),
          onFieldSubmitted: (String _) {
            setState(() {
              isShow = true;
            });
          },
        ),
      ),
      body: isShow
          ? FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .where('username',
                      isGreaterThanOrEqualTo: searchController.text)
                  .get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: LinearProgressIndicator(),
                  );
                }
                return ListView.builder(
                  itemCount: (snapshot.data! as dynamic).docs.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ProfileScreen(
                              uid: (snapshot.data! as dynamic).docs[index]
                                  ['uid']))),
                      child: ListTile(
                          leading: CircleAvatar(
                              backgroundImage: NetworkImage(
                                  (snapshot.data! as dynamic).docs[index]
                                      ['photourl'])),
                          title: Text(
                            (snapshot.data! as dynamic).docs[index]['name'],
                            style: const TextStyle(color: Colors.blueAccent),
                          )),
                    );
                  },
                );
              },
            )
          : const Center(
              child: Text(
                'No search result....',
                style: TextStyle(color: Colors.blueAccent),
              ),
            ),
    );
  }
}
