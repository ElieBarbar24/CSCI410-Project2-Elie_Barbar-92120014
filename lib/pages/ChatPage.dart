import 'package:connect/Models/User.dart';
import 'package:connect/widgets/ChatSample.dart';

import 'package:flutter/material.dart';


class ChatPage extends StatefulWidget {
  final User user;

  const ChatPage({super.key, required this.user});

  @override
  // ignore: no_logic_in_create_state
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final ScrollController scroller = ScrollController();
  final TextEditingController chatTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    scroller.dispose();
    chatTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70.0),
        child: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: AppBar(
            backgroundColor: Colors.white,
            leadingWidth: 30,
            title: Row(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.of(context).pushReplacementNamed('homepage');
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: const Icon(
                      Icons.arrow_back,
                      color: Color(0xFF113953),
                    ),
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Image.network(
                    'https://eliebarbar.000webhostapp.com/profileImages/${widget.user.photo}',
                    height: 45,
                    width: 45,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    widget.user.name,
                    style: const TextStyle(color: Color(0xFF113953)),
                  ),
                )
              ],
            ),
            actions: [
              InkWell(
                onTap: () {
                  showMenu(
                    context: context,
                    position: RelativeRect.fromLTRB(100, 100, 0,
                        0), // position where you want to show the menu
                    items: [
                      const PopupMenuItem(
                        child: ListTile(
                          leading: Icon(Icons.block),
                          title: Text('Block'),
                        ),
                        value: 1,
                      ),
                      // add more options here
                    ],
                  ).then((value) {});

                  Navigator.of(context).pushReplacementNamed('homepage');
                },
                child: const Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: Icon(
                    Icons.more_vert,
                    color: Color(0xFF113953),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        controller: scroller,
        padding:
            const EdgeInsets.only(top: 20, left: 20, bottom: 80, right: 20),
        child: Center(),
      ),
      bottomSheet: Container(
        height: 65,
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 3),
          )
        ]),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Container(
                alignment: Alignment.center,
                width: 350,
                child: TextFormField(
                  controller: chatTextController,
                  decoration: const InputDecoration(
                    hintText: "Enter Message",
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            const Spacer(),
            Container(
                padding: const EdgeInsets.only(right: 8),
                child: InkWell(
                  highlightColor: Colors.grey[200],
                  onTap: () {},
                  child: const Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Icon(
                      Icons.send,
                      color: Color(0xFF113953),
                      size: 30,
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
