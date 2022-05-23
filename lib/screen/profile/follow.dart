import 'package:flutter/material.dart';

class FollowBtn extends StatelessWidget {
  final Function()? function;
  final Color backgroundColor;
  final Color boarderColor;
  final String text;
  final Color textColor;
  const FollowBtn(
      {Key? key,
      required this.backgroundColor,
      required this.boarderColor,
      required this.text,
      required this.textColor,
      this.function})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 20),
      child: TextButton(
          onPressed: function,
          child: Container(
            decoration: BoxDecoration(
                color: backgroundColor,
                border: Border.all(color: boarderColor),
                borderRadius: BorderRadius.circular(5)),
            alignment: Alignment.center,
            child: Text(
              text,
              style: TextStyle(color: textColor, fontWeight: FontWeight.w500),
            ),
            width: 250,
            height: 30,
          )),
    );
  }
}
