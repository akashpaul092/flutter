import 'dart:typed_data';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:koolhabbit/ImagePicker/pickimage.dart';
import 'package:koolhabbit/database_connection/auth.dart';
import 'package:koolhabbit/screen/first_page.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  TextEditingController fullname = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController user = TextEditingController();
  TextEditingController password = TextEditingController();
  Uint8List? photofile;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black26,
        body: Center(
            child: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  width: 300,
                  height: 100,
                  child: Text(
                    "Sign Up",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.blueAccent,
                      fontSize: 50,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Stack(children: [
                  photofile != null
                      ? CircleAvatar(
                          radius: 96,
                          backgroundImage: MemoryImage(photofile!),
                        )
                      : const CircleAvatar(
                          radius: 94,
                          backgroundColor: Color.fromARGB(255, 68, 77, 82),
                          child: Text("Upload Photo"),
                        ),
                  Positioned(
                      bottom: -7,
                      left: 120,
                      child: IconButton(
                        onPressed: selectimage,
                        icon: const Icon(Icons.add_a_photo),
                        color: Colors.blueAccent,
                        iconSize: 50,
                      ))
                ]),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 5),
                  child: TextField(
                    style: const TextStyle(color: Colors.blueAccent),
                    controller: fullname,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.blueAccent, width: 2.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.blueAccent, width: 2.0),
                        ),
                        label: Text(
                          "Full Name",
                          style: TextStyle(color: Colors.blueAccent),
                        )),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 5),
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    style: const TextStyle(color: Colors.blueAccent),
                    controller: email,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.blueAccent, width: 2.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.blueAccent, width: 2.0),
                        ),
                        label: Text(
                          "Email Id",
                          style: TextStyle(color: Colors.blueAccent),
                        )),
                    validator: (value) {
                      if (value != null && !EmailValidator.validate(value)) {
                        return "enter a correct email";
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 5),
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    style: const TextStyle(color: Colors.blueAccent),
                    controller: user,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.blueAccent, width: 2.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.blueAccent, width: 2.0),
                        ),
                        label: Text(
                          "Username",
                          style: TextStyle(color: Colors.blueAccent),
                        )),
                    validator: (value) {},
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 5),
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    style: const TextStyle(color: Colors.blueAccent),
                    obscureText: true,
                    controller: password,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.blueAccent, width: 2.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.blueAccent, width: 2.0),
                        ),
                        label: Text(
                          "Password",
                          style: TextStyle(color: Colors.blueAccent),
                        )),
                    validator: (value) {
                      if (value != null && value.length < 10) {
                        return "password length must be 10 digit";
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
                Container(
                  width: 200,
                  height: 50,
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          isLoading = true;
                        });
                        if (photofile != null) {
                          String res = await AuthMethod().signup(
                            name: fullname.text,
                            email: email.text,
                            username: user.text,
                            password: password.text,
                            photo: photofile!,
                          );
                          setState(() {
                            isLoading = false;
                          });
                          if (res != 'Success') {
                            ScaffoldMessenger.of(context).showMaterialBanner(
                                MaterialBanner(
                                    content: const Text(
                                        'Please enter all the fields'),
                                    actions: [
                                  TextButton(
                                      onPressed: () {
                                        ScaffoldMessenger.of(context)
                                            .hideCurrentMaterialBanner();
                                      },
                                      child: const Text("Dismiss"))
                                ]));
                          } else {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const First_page()));
                          }
                        } else {
                          setState(() {
                            isLoading = false;
                          });
                          ScaffoldMessenger.of(context).showMaterialBanner(
                              MaterialBanner(
                                  content: const Text('Select a profile image'),
                                  actions: [
                                TextButton(
                                    onPressed: () {
                                      ScaffoldMessenger.of(context)
                                          .hideCurrentMaterialBanner();
                                    },
                                    child: const Text("Dismiss"))
                              ]));
                        }
                      },
                      child: isLoading
                          ? const Center(
                              child: LinearProgressIndicator(),
                            )
                          : const Text("Sign Up")),
                ),
              ]),
        )));
  }

  void selectimage() async {
    Uint8List? image = await pickimage(ImageSource.gallery);
    setState(() {
      photofile = image;
    });
    if (photofile == null) {
      ScaffoldMessenger.of(context).showMaterialBanner(MaterialBanner(
          content: const Text("Select a profile image"),
          actions: [
            TextButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
                },
                child: const Text("Dismiss"))
          ]));
    }
  }
}
