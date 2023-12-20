import 'dart:async';
import 'package:connect/Models/User.dart';
import 'package:connect/widgets/FriendsModel.dart';
import 'package:connect/Querys/UserAction.dart';
import 'package:flutter/material.dart';

class Friends extends StatefulWidget {
  const Friends({super.key});

  @override
  State<Friends> createState() => _FriendsState();
}

class _FriendsState extends State<Friends> {
  SFriends friendsStream = SFriends();

  @override
  void initState() {
    friendsStream.searchUsers(currentUser.id!);
    super.initState();
  }

  @override
  void dispose() {
    friendsStream.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavigationDrawer(
        email: currentUser.email,
        name: currentUser.name,
      ),
      appBar: AppBar(
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: IconButton(onPressed: (){
              setState(() {
                friendsStream.searchUsers(currentUser.id!);
              });
            }, icon: Icon(Icons.refresh))
          ),
        ],
      ),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 25, horizontal: 20),
            child: Text(
              "Friends",
              style: TextStyle(
                color: Color(0xFF113953),
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    blurRadius: 10,
                    spreadRadius: 2,
                    offset: const Offset(0, 3),
                  )
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 300,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          hintText: "Search",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.search,
                    color: Color(0xFF113953),
                  )
                ],
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 20),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 25),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(35),
                  topLeft: Radius.circular(35),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    blurRadius: 10,
                    spreadRadius: 2,
                    offset: const Offset(0, 2),
                  )
                ]),
            child: Column(
              children: [
                StreamBuilder<List<User>>(
                    stream: friendsStream.usersStream,
                    builder: (BuildContext context,
                        AsyncSnapshot<List<User>> snapshot) {
                      if (snapshot.hasData) {
                        List<User> users = snapshot.data!;
                        List<FriendsModels> people = [];
                        for (var u in users) {
                          people.add(FriendsModels(user: u));
                        }
                        return Column(
                          children: people,
                        );
                      }

                      return const Center(
                        child: Text('No Friends! Try to Make Some.'),
                      );
                    }),
              ],
            ),
          ),
        ],
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
