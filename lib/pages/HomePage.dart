import 'dart:async';

import 'package:connect/Models/RecentChatModel.dart';
import 'package:connect/Models/User.dart';
import 'package:connect/Querys/UserAction.dart';
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
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
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
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavigationDrawer(
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
              return Center();
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await LoadRecentChats(currentUser.id!);
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

class NavigationDrawer extends StatelessWidget {
  final String name, email;
  NavigationDrawer({
    super.key,
    required this.email,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            buildHeader(context),
            buildMenuItems(context),
          ],
        ),
      ),
    );
  }

  Widget buildHeader(BuildContext context) {
    return Container(
      color: const Color(0xFF113953),
      padding: const EdgeInsets.only(
        top: 50,
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: Image.network(
              'https://eliebarbar.000webhostapp.com/profileImages/${currentUser.photo}',
              height: 150,
              width: 150,
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          Text(
            name,
            style: const TextStyle(fontSize: 28, color: Colors.white),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            email,
            style: const TextStyle(fontSize: 16, color: Colors.white),
          ),
          const SizedBox(
            height: 12,
          ),
        ],
      ),
    );
  }

  Widget buildMenuItems(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Wrap(
        runSpacing: 16,
        children: [
          ListTile(
            titleTextStyle: const TextStyle(color: Color(0xFF113953)),
            leading: const Icon(
              Icons.home_outlined,
              color: Color(0xFF113953),
            ),
            title: const Text('Home'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed("homepage");
            },
          ),
          ListTile(
            titleTextStyle: const TextStyle(color: Color(0xFF113953)),
            leading: const Icon(
              Icons.person,
              color: Color(0xFF113953),
            ),
            title: const Text('Friends'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed("Friends");
            },
          ),
          ListTile(
            titleTextStyle: const TextStyle(color: Color(0xFF113953)),
            leading: const Icon(
              Icons.pending,
              color: Color(0xFF113953),
            ),
            title: const Text('Pending Friend Request'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed("FriendsRequests");
            },
          ),
          ListTile(
            titleTextStyle: const TextStyle(color: Color(0xFF113953)),
            leading: const Icon(
              Icons.search,
              color: Color(0xFF113953),
              weight: 500,
            ),
            title: const Text('Search People'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed("searchFriends");
            },
          ),
          ListTile(
            titleTextStyle: const TextStyle(color: Color(0xFF113953)),
            leading: const Icon(
              Icons.settings,
              color: Color(0xFF113953),
            ),
            title: const Text('Settings'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed("setting");
            },
          ),
          const Divider(color: Color(0xFF113953)),
          ListTile(
            titleTextStyle: const TextStyle(color: Color(0xFF113953)),
            leading: const Icon(
              Icons.logout,
              color: Color(0xFF113953),
            ),
            title: const Text('Logout'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('LoginPage');
            },
          ),
        ],
      ),
    );
  }
}
