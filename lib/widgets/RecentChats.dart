import 'package:connect/Models/RecentChatModel.dart';
import 'package:connect/Models/User.dart';
import 'package:connect/pages/ChatPage.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RecentChatWidget extends StatefulWidget {
  final RecentChatsModel recentChat;
  const RecentChatWidget({super.key, required this.recentChat});

  @override
  State<RecentChatWidget> createState() => _RecentChatWidgetState();
}

class _RecentChatWidgetState extends State<RecentChatWidget> {
  String? date;

  @override
  void initState() {
    DateTime dateTime = DateTime.parse(widget.recentChat.date);

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
      formattedDate = DateFormat.yMd().format(dateTime);
    }
    date = formattedDate;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: InkWell(
        onTap: () {
          if (widget.recentChat.senderId == currentUser.id!) {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (builder) => ChatPage(
                    user: User.user(
                        widget.recentChat.receiverName,
                        widget.recentChat.receiverId,
                        widget.recentChat.relationId,
                        widget.recentChat.receiverProfile))));
          } else {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (builder) => ChatPage(
                    user: User.user(
                        widget.recentChat.senderName,
                        widget.recentChat.senderId,
                        widget.recentChat.relationId,
                        widget.recentChat.senderProfile))));
          }
        },
        child: SizedBox(

          height: 65,
          child: Row(children: [
            //recent chat image profile
            ClipRRect(
              borderRadius: BorderRadius.circular(35),
              child: Image.network(
                'https://eliebarbar.000webhostapp.com/profileImages/${widget.recentChat.senderId == currentUser.id! ? widget.recentChat.receiverProfile : widget.recentChat.senderProfile}',
                height: 65,
                width: 65,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.recentChat.senderId == currentUser.id!
                        ? widget.recentChat.receiverName
                        : widget.recentChat.senderName,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Color(0xFF113953),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  // last message between the users
                  Text(
                    widget.recentChat.senderId==currentUser.id?'You: ${widget.recentChat.content}':widget.recentChat.content,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  )
                ],
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    date!,
                    style:
                        const TextStyle(fontSize: 15, color: Color(0xFF113953)),
                  ),
                  widget.recentChat.unreadedCount != 0
                      ? Container(
                          height: 30,
                          width: 30,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: const Color(0xFF113953),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Text(
                            '${widget.recentChat.unreadedCount}',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      : Container()
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}