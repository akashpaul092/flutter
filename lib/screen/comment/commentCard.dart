import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CommentCard extends StatefulWidget {
  final snap;
  const CommentCard({Key? key, required this.snap}) : super(key: key);

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(widget.snap['profilePic']),
            radius: 18,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(children: [
                        TextSpan(children: [
                          TextSpan(
                              text: '${widget.snap['name']}  ',
                              style: const TextStyle(
                                  fontWeight: FontWeight.w900,
                                  color: Colors.blueAccent)),
                          TextSpan(
                              text: widget.snap['text'],
                              style: const TextStyle(color: Colors.blueAccent)),
                        ])
                      ]),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                          DateFormat.yMMMd()
                              .format(widget.snap['dateOfPublished'].toDate()),
                          style: const TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                              color: Colors.blueAccent)),
                    )
                  ]),
            ),
          ),
          Container(),
        ],
      ),
    );
  }
}
