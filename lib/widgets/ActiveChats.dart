import 'dart:convert';
import 'dart:typed_data';

import 'package:connect/pages/ChatPage.dart';

import 'package:flutter/material.dart';

class ActiveChats extends StatelessWidget {
  const ActiveChats({super.key});



  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 25),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Center(),
      )
    );
  }
}

class CircleProfileActiveChat extends StatelessWidget {
  const CircleProfileActiveChat({super.key});


  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  width: 65,
                  height: 65,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(35),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        blurRadius: 10,
                        spreadRadius: 2,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  // child: ClipRRect(
                  //   borderRadius: BorderRadius.circular(35),
                  //   child: Image.memory(),
                  // ),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 20, // Adjust as needed
                    height: 20, // Adjust as needed
                    decoration: BoxDecoration(
                      color: Colors.black, // Choose your color
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
            Text(
              '',
              style: TextStyle(
                fontSize: 15,
                color: Color(0xFF113953),
                fontWeight: FontWeight.bold
              ),
            ),
          ],
        ),
      ),
    );
  }
}