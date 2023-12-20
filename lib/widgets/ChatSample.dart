import 'package:custom_clippers/custom_clippers.dart';
import 'package:flutter/material.dart';

class ChatSample extends StatelessWidget {
  final String message;
  final bool isSender;
  final String isSeen;
  final String date;
  const ChatSample(
      {super.key,
      required this.message,
      required this.isSender,
      required this.isSeen,
      required this.date});
  @override
  Widget build(BuildContext context) {
    if (isSender) {
      return Container(
        alignment: Alignment.centerRight,
        child: Padding(
          padding: const EdgeInsets.only(top: 20, left: 80),
          child: ClipPath(
            clipper: LowerNipMessageClipper(MessageType.send),
            child: Container(
              padding: const EdgeInsets.only(
                  left: 20, top: 10, bottom: 20, right: 20),
              decoration: const BoxDecoration(
                color: Color(0xFF113953),
              ),
              child: Wrap(
                // crossAxisAlignment: CrossAxisAlignment.start
                children: [
                  Text(
                    message,
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    date,
                    style: const TextStyle(fontSize: 13, color: Colors.white70),
                  ),
                  Icon(
                    isSeen == 'unreaded' ? Icons.done : Icons.done_all,
                    color: Colors.white70,
                    size: 15,
                  )
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(right: 80),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ClipPath(
          clipper: UpperNipMessageClipper(MessageType.receive),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration:
                BoxDecoration(color: const Color(0xFFE1E1E2), boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 10,
                offset: const Offset(3, 3),
              )
            ]),
            child: Wrap(

              children: [
                Text(
                  message,
                  style: const TextStyle(fontSize: 16),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  date,
                  style: const TextStyle(fontSize: 13, color: Color(0xFF113953)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
