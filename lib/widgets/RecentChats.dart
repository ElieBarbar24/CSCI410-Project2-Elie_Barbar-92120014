import 'dart:async';

import 'package:connect/Models/RecentChatModel.dart';
import 'package:connect/Models/User.dart';
import 'package:connect/Querys/UserAction.dart';
import 'package:connect/pages/ChatPage.dart';

import 'package:flutter/material.dart';

class RecentChatWidget extends StatelessWidget {
  final RecentChatsModel recentChat;
  const RecentChatWidget({required this.recentChat});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: InkWell(
        onTap: () {
          if(recentChat.senderId==currentUser.id!){
            Navigator.of(context).push(MaterialPageRoute(builder: (builder)=>ChatPage(user: User.user(recentChat.receiverName, recentChat.receiverId, recentChat.relationId,recentChat.receiverProfile))));
          }else{
            Navigator.of(context).push(MaterialPageRoute(builder: (builder)=>ChatPage(user: User.user(recentChat.senderName, recentChat.senderId, recentChat.relationId,recentChat.senderProfile))));
          }
        },
        child: SizedBox(
          height: 65,
          child: Row(children: [
            //recent chat image profile
            ClipRRect(
              borderRadius: BorderRadius.circular(35),
              child: Image.network(
                'https://eliebarbar.000webhostapp.com/profileImages/${recentChat.senderId == currentUser.id!?recentChat.receiverProfile:recentChat.senderProfile}',
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
                    recentChat.senderId == currentUser.id!?recentChat.receiverName:recentChat.senderName,
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
                    recentChat.content,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  )
                ],
              ),
            ),
            const Spacer(),
            /*Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    cdate,
                    style:
                        const TextStyle(fontSize: 15, color: Color(0xFF113953)),
                  ),
                  nbunreaded!='0'? Container(
                    height: 30,
                    width: 30,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color(0xFF113953),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Text(
                      nbunreaded,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ):Container()
                ],
              ),
            ),*/
          ]),
        ),
      ),
    );
  }
}
