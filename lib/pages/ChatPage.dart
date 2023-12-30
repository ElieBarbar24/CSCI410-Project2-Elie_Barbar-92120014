import 'dart:async';

import 'package:connect/Models/Messages.dart';
import 'package:connect/Models/User.dart';
import 'package:connect/Querys/UserAction.dart';
import 'package:connect/widgets/ChatSample.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final User user;

  const ChatPage({Key? key, required this.user}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final ScrollController _scroller = ScrollController();
  final TextEditingController _chatTextController = TextEditingController();
  final SignalService _signalService = SignalService();
  late Timer _timer;
  final MessageStream _messageStream = MessageStream();

  @override
  void initState() {
    _messageStream.loadMessages(widget.user.relationID!);

    MakeUnreadedMessagesReaded(currentUser.id!, widget.user.relationID!);

    _timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      _signalService.roomSignalCheck(widget.user.relationID!);
    });

    _signalService.signalStream.listen((int? result) async {
      if (result == 1) {
        MakeUnreadedMessagesReaded(currentUser.id!, widget.user.relationID!);

        _messageStream.loadMessages(widget.user.relationID!);

        roomSignalChangeTo0(widget.user.relationID!);
      } else {}
    }, onError: (error) {});

    super.initState();
  }

  @override
  void dispose() {
    _scroller.dispose();
    _chatTextController.dispose();
    _timer.cancel();
    _signalService.dispose();
    _messageStream.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
                style: TextStyle(color: Color(0xFF113953)),
              ),
            )
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: StreamBuilder(
                stream: _messageStream.messagesStream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<Messages> messages = snapshot.data!;

                    messages.sort((a, b) => a.date.compareTo(b.date));

                    WidgetsBinding.instance!.addPostFrameCallback((_) {
                      _scroller.jumpTo(_scroller.position.maxScrollExtent);
                    });

                    return ListView.builder(
                      controller: _scroller,
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        return ChatSample(message: messages[index]);
                      },
                    );
                  } else {
                    return Center();
                  }
                },
              ),
            ),
          ),
          ListTile(
            title: TextFormField(
              controller: _chatTextController,
              decoration: InputDecoration(
                hintText: "Enter Message",
                border: InputBorder.none,
              ),
            ),
            trailing: IconButton(
              onPressed: () async {
                if (_chatTextController.text.isEmpty) {
                  return;
                }

                Messages message = Messages(
                  _chatTextController.text,
                  'unreaded',
                  currentUser.id!,
                  widget.user.id!,
                  DateTime.now(),
                  widget.user.relationID,
                );

                print(message.toSend());
                await sendMessage(message);
                roomSignalChangeTo1(widget.user.relationID!);
                RecentChatSignalChange1(currentUser.id!);
                RecentChatSignalChange1(widget.user.id!);

                setState(() {
                  _chatTextController.clear();
                });
              },
              icon: Icon(
                Icons.send,
                color: Color(0xFF113953),
                size: 30,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
