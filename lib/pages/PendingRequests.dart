import 'package:connect/Models/User.dart';
import 'package:connect/Querys/UserAction.dart';
import 'package:connect/widgets/FriendsRequest.dart';
import 'package:connect/widgets/Navigator.dart';
import 'package:flutter/material.dart';

class PendingRequests extends StatefulWidget {
  const PendingRequests({super.key});

  @override
  State<PendingRequests> createState() => _PendingRequests();
}

class _PendingRequests extends State<PendingRequests> {
  FriendRequests peopleRequests = FriendRequests();

  @override
  void initState() {
    peopleRequests.loadFriendRequests();

    super.initState();
  }

  @override
  void dispose() {
    peopleRequests.dispose();
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
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: IconButton(onPressed: (){
              setState(() {
                peopleRequests.loadFriendRequests();
              });
            }, icon: const Icon(Icons.refresh))
          ),
        ],
      ),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 25, horizontal: 20),
            child: Text(
              "Friends Request",
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
            child: StreamBuilder<List<User>>(
                stream: peopleRequests.usersStream,
                builder:
                    (BuildContext context, AsyncSnapshot<List<User>> snapshot) {
                  if (snapshot.hasData) {
                    List<User> users = snapshot.data!;
                    List<FriendsRequests> people = [];
                    for (var u in users) {
                      people.add(FriendsRequests(user: u));
                    }
                    return Column(
                      children: people,
                    );
                  }

                  return const Center();
                }),
          ),
        ],
      ),
    );
  }
}
