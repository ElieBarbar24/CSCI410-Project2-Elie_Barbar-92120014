import 'package:connect/Models/Messages.dart';
import 'package:connect/Models/User.dart';
import 'package:custom_clippers/custom_clippers.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatSample extends StatefulWidget {
  final Messages message;
  const ChatSample({super.key, required this.message});

  @override
  State<ChatSample> createState() => _ChatSampleState();
}

class _ChatSampleState extends State<ChatSample> {
  String? date;

  @override
  void initState() {
    DateTime dateTime = widget.message.date;

  // Get the current DateTime
  DateTime now = DateTime.now();

  // Calculate the difference between now and the parsed DateTime
  Duration difference = now.difference(dateTime);

  // Format the result based on conditions
  String formattedDate = '';

  if (difference.inHours < 24) {
    // If it's within the last 24 hours, show the hour and minute
    formattedDate = DateFormat.Hm().format(dateTime);
  } else if (difference.inDays == 1) {
    // If it's yesterday, show 'Yesterday'
    formattedDate = 'Yesterday';
  } else {
    // Otherwise, show the year, month, and day
    formattedDate = DateFormat.yMMMMd().format(dateTime);
  }


  date = formattedDate;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
      return widget.message.Sid == currentUser.id! ? Container(
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
                    widget.message.content,
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                   date!,
                    style: const TextStyle(fontSize: 13, color: Colors.white70),
                  ),
                  widget.message.type.compareTo('unreaded')==0?const Icon(Icons.done,color: Colors.white,):const Icon(Icons.done_all,color: Colors.white,)
                ],
              ),
            ),
          ),
        ),
      ):

      Container(
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
                  widget.message.content,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  date!,
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
