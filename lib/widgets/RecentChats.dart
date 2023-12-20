import 'dart:convert';
import 'dart:typed_data';

import 'package:connect/Models/User.dart';
import 'package:connect/pages/ChatPage.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RecentChats extends StatelessWidget {
  RecentChats({super.key});
  @override
  Widget build(BuildContext context) {

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 25),
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              blurRadius: 10,
              spreadRadius: 2,
              offset: const Offset(0, 2),
            )
          ]),
      child: ListView(
        children: List.generate(
          12,
          (index) => RecentChatWidget(user: currentUser),
        ),
      ),
    );
  }
}

class RecentChatWidget extends StatelessWidget {
  final User user;
  const RecentChatWidget({required this.user});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: InkWell(
        onTap: () {},
        child: SizedBox(
          height: 65,
          child: Row(children: [
            //recent chat image profile
            ClipRRect(
              borderRadius: BorderRadius.circular(35),
              child: Image.network(
                'https://eliebarbar.000webhostapp.com/profileImages/${user.photo}',
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
                    user.name,
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
                    '',
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
