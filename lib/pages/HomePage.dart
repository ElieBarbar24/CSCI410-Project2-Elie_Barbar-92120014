import 'package:connect/Models/User.dart';
import 'package:connect/widgets/ActiveChats.dart';
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
  @override
  Widget build(BuildContext context) {
    final double appBarHeight = AppBar().preferredSize.height;

    final double screenHeight = MediaQuery.of(context).size.height;
    final double bodyheigh = screenHeight - appBarHeight;

    print('AppBar Height: $kToolbarHeight');

    return Scaffold(
      drawer: NavigationDrawer(
        email: currentUser.email,
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
      body: ListView(
        physics: NeverScrollableScrollPhysics(),
        children: [
          Container(
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
                  width: MediaQuery.of(context).size.width * 0.7291666666666666,
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
          DefaultTabController(
            length: 2,
            child: Column(
              children: [
                const TabBar(
                  tabs: [
                    Tab(icon: Icon(Icons.person), text: 'Private Chats'),
                    Tab(icon: Icon(Icons.group), text: 'Group Chats'),
                  ],
                ),
                Container(
                  height: (MediaQuery.of(context).size.height),
                  child: TabBarView(
                    children: [

                      RecentChats(),
                      Center(child: Text('HIIIIIIIIIIIIIIII')),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
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
