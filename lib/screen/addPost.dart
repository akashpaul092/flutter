import 'dart:ffi';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:koolhabbit/ImagePicker/pickimage.dart';
import 'package:koolhabbit/database_connection/firestorePost.dart';
import 'package:koolhabbit/models/user.dart';
import 'package:koolhabbit/provider/user_provider.dart';
import 'package:provider/provider.dart';

class AddPost extends StatefulWidget {
  const AddPost({Key? key}) : super(key: key);

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  Uint8List? _file;
  final TextEditingController _caption = TextEditingController();
  bool _isLoading = false;

  void postImage(String uid, String username, String profileImage) async {
    setState(() {
      _isLoading = true;
    });
    try {
      String res = await FirestorePost()
          .uploadPost(_caption.text, _file!, uid, username, profileImage);
      if (res == "Success") {
        setState(() {
          _isLoading = false;
        });
        Fluttertoast.showToast(
            msg: "Posted..",
            gravity: ToastGravity.CENTER,
            toastLength: Toast.LENGTH_SHORT,
            timeInSecForIosWeb: 2,
            textColor: Colors.blueAccent,
            backgroundColor: Colors.greenAccent);
        clearImage();
      } else {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showMaterialBanner(MaterialBanner(
            content: const Text('some error occurred'),
            actions: [
              TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
                  },
                  child: const Text("Dismiss"))
            ]));
      }
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
  }

  void _selectImage(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text('create a post'),
            children: [
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text(
                  'take a photo',
                  style: TextStyle(color: Colors.blueAccent),
                ),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickimage(ImageSource.camera);
                  setState(() {
                    _file = file;
                  });
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text(
                  'choose from gallery',
                  style: TextStyle(color: Colors.blueAccent),
                ),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickimage(ImageSource.gallery);
                  setState(() {
                    _file = file;
                  });
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text(
                  'cancel',
                  style: TextStyle(color: Colors.blueAccent),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  void clearImage() {
    setState(() {
      _file = null;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _caption.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Users user =
        Provider.of<UserProvider>(context, listen: false).getUser;

    return _file == null
        ? Center(
            child: IconButton(
              icon: const Icon(
                Icons.upload,
                color: Colors.blueAccent,
                size: 64,
              ),
              onPressed: () => _selectImage(context),
            ),
          )
        : Scaffold(
            backgroundColor: Colors.black87,
            appBar: AppBar(
              backgroundColor: Colors.black87,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: clearImage,
              ),
              title: const Text(
                "Post to",
                style: TextStyle(color: Colors.blueAccent),
              ),
              centerTitle: false,
              actions: [
                TextButton(
                    onPressed: () =>
                        postImage(user.uid, user.username, user.photourl),
                    child: const Text(
                      "Post",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.greenAccent,
                          fontSize: 20),
                    ))
              ],
            ),
            body: Column(children: [
              _isLoading
                  ? const LinearProgressIndicator()
                  : const Padding(padding: EdgeInsets.only(top: 0)),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(user.photourl),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: TextField(
                      controller: _caption,
                      decoration: const InputDecoration(
                          hintText: 'Write a caption......',
                          hintStyle: TextStyle(color: Colors.blueAccent),
                          border: InputBorder.none),
                      maxLines: 5,
                      style: const TextStyle(color: Colors.blueAccent),
                    ),
                  ),
                  SizedBox(
                    height: 45,
                    width: 45,
                    child: AspectRatio(
                      aspectRatio: 600 / 600,
                      child: Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: MemoryImage(_file!),
                                  fit: BoxFit.fill,
                                  alignment: FractionalOffset.topCenter))),
                    ),
                  ),
                  const Divider()
                ],
              )
            ]),
          );
  }
}
