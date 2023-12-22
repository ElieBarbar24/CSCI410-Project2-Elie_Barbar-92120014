import 'dart:async';

import 'package:connect/Models/Messages.dart';
import 'package:connect/Models/User.dart';
import 'package:connect/Querys/UserAction.dart';
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
  SignalService signalService = SignalService();
  late Timer timer;
  List<Messages>? messages =[];
  @override
  void initState() {
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      signalService.roomSignalCheck(widget.user.relationID!);
    });

    signalService.signalStream.listen((int? result) async{
      if (result == 1) {
        messages = await loadMessages(widget.user.relationID!);
        roomSignalChangeTo0(widget.user.relationID!);
      } else {
        print(messages!.length);
      }
    }, onError: (error) {
    }
    );
    super.initState();
  }

  @override
  void dispose() {
    scroller.dispose();
    chatTextController.dispose();
    timer.cancel();
    signalService.dispose();
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
        body: Center(),

        /*ListView.builder(
          controller: scroller,
          padding:
              const EdgeInsets.only(top: 20, left: 20, bottom: 80, right: 20),
          itemCount: messages!.length,
          itemBuilder: (BuildContext context, int index) {
            return ChatSample(message: messages![index]);
          },
        ),*/
        bottomSheet: ListTile(
          title: TextFormField(
            controller: chatTextController,
            decoration: const InputDecoration(
              hintText: "Enter Message",
              border: InputBorder.none,
            ),
          ),
          trailing: IconButton(
            onPressed: () async{
              Messages message = Messages(chatTextController.text, 'message',
                  currentUser.id!, widget.user.id!, DateTime.now(),widget.user.relationID);

              print(message.toSend());
              await sendMessage(message);
              roomSignalChangeTo1(widget.user.relationID!);
            },
            icon: Icon(
              Icons.send,
              color: Color(0xFF113953),
              size: 30,
            ),
          ),
        ));
  }
}
