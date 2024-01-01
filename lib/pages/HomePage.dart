import 'dart:async';

import 'package:connect/Models/RecentChatModel.dart';
import 'package:connect/Models/User.dart';
import 'package:connect/Querys/UserAction.dart';
import 'package:connect/widgets/Navigator.dart';
import 'package:flutter/material.dart';

import '../widgets/RecentChats.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  late Timer timer;
  RecentChatSignal recentChatSignal = RecentChatSignal();
  RecentChatsStream recentChatsStream = RecentChatsStream();

  @override
  void initState() {
    recentChatsStream.loadRecentChats(currentUser.id!);

    recentChatSignal.RecentChatSignalCheck(currentUser.id!);

    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      recentChatSignal.RecentChatSignalCheck(currentUser.id!);
    });
    recentChatSignal.signalStream.listen((int? result) async {
      if (result == 1) {
        print(result);
        recentChatsStream.loadRecentChats(currentUser.id!);

        RecentChatSignalChange0(currentUser.id!);
      } else {}
    }, onError: (error) {print(error);});

    super.initState();
  }

  @override
void dispose() {
  timer.cancel(); // Cancel the timer to stop periodic updates
  recentChatsStream.dispose(); // Close the stream controller

  super.dispose();
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavigatorDrawer(
        email: currentUser.email!,
        name: currentUser.name,
      ),
      appBar: AppBar(
        actions: const [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Icon(Icons.notifications),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 25),
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 2),
          )
        ]),
        child: StreamBuilder(
          stream: recentChatsStream.recentChatsStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<RecentChatsModel> recentChats = snapshot.data!;

              recentChats.sort((a, b) => b.date.compareTo(a.date));

              return ListView.builder(
                itemCount: recentChats.length,
                  itemBuilder: (context, index) {
                return RecentChatWidget(
                  recentChat: recentChats[index],
                );
              });
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
        },
        backgroundColor: const Color(0xFF113953),
        child: const Icon(
          Icons.message,
          color: Colors.white,
        ),
      ),
    );
  }
}