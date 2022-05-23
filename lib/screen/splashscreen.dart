import 'package:flutter/material.dart';
import 'package:koolhabbit/screen/first_page.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    delay();
    super.initState();
  }

  void delay() {
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const First_page()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black38,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          Text(
            "KOOLHABBIT",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 61,
                fontWeight: FontWeight.w800,
                color: Colors.blueAccent),
          ),
          Center(
            child: LinearProgressIndicator(),
          )
        ],
      ),
    );
  }
}
