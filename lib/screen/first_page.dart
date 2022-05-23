// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:koolhabbit/database_connection/auth.dart';
import 'package:koolhabbit/screen/signup.dart';
import 'package:email_validator/email_validator.dart';
import 'package:koolhabbit/screen/ui.dart';

class First_page extends StatefulWidget {
  const First_page({Key? key}) : super(key: key);

  @override
  State<First_page> createState() => _First_pageState();
}

class _First_pageState extends State<First_page> {
  @override
  Widget build(BuildContext context) {
    TextEditingController password = TextEditingController();
    TextEditingController email = TextEditingController();
    bool isloading = false;
    return Scaffold(
        backgroundColor: Colors.black26,
        body: Center(
            child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                width: 500,
                height: 200,
                child: Text(
                  "Welcome to Koolhabbit",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.blueAccent,
                    fontSize: 50,
                    fontWeight: FontWeight.w700,
                  ),
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
                        "Email",
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
                  obscureText: true,
                  controller: password,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.blueAccent, width: 2.0)),
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.blueAccent, width: 2.0)),
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
                        isloading = true;
                      });
                      String res = await AuthMethod().loginpage(
                          email: email.text, password: password.text);

                      if (res != "Success") {
                        ScaffoldMessenger.of(context).showMaterialBanner(
                            MaterialBanner(
                                content:
                                    const Text('check your email or password'),
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
                                builder: (context) => const Ui()));
                      }
                      setState(() {
                        isloading = false;
                      });
                    },
                    child: isloading
                        ? const Center(
                            child: LinearProgressIndicator(),
                          )
                        : const Text("Sign In")),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text("Does not have an account?",
                      style: TextStyle(color: Colors.blueAccent)),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Signup()));
                      },
                      child: const Text(
                        "Create one",
                        style: TextStyle(color: Colors.greenAccent),
                      ))
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text("forgot password?",
                      style: TextStyle(color: Colors.blueAccent)),
                  TextButton(
                      onPressed: () {},
                      child: const Text(
                        "Click here",
                        style: TextStyle(color: Colors.greenAccent),
                      ))
                ],
              )
            ],
          ),
        )));
  }
}
