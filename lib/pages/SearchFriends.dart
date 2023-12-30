import 'package:connect/Models/User.dart';
import 'package:connect/Querys/UserAction.dart';
import 'package:connect/widgets/Navigator.dart';
import 'package:connect/widgets/SearchedFriend.dart';
import 'package:flutter/material.dart';

class SearchFriends extends StatefulWidget {
  const SearchFriends({super.key});
  @override
  State<SearchFriends> createState() => _SearchFriendsState();
}

class _SearchFriendsState extends State<SearchFriends> {
  searchPeopleStream peopleStream = searchPeopleStream();
  filterPeopleStream filterStream = filterPeopleStream();
  @override
  void initState() {
    peopleStream.searchUsers();
    super.initState();
  }

  @override
  void dispose() {
    peopleStream.dispose();
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
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: IconButton(
                  onPressed: () {
                    setState(() {
                      peopleStream.searchUsers();
                    });
                  },
                  icon: Icon(Icons.refresh))),
        ],
      ),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 25, horizontal: 20),
            child: Text(
              "Search",
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
                        onChanged: (String s) {
                          if(s.compareTo('')==0){
                            filterStream.pauseStream();
                            peopleStream.resumeStream();
                          }
                          else{
                            filterStream.resumeStream();
                            peopleStream.pauseStream();
                            filterStream.filterPeople(s);
                          }
                        },
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
            child: !peopleStream.isStreamPaused()
                ? StreamBuilder<List<User>>(
                    stream: peopleStream.usersStream,
                    builder: (BuildContext context,
                        AsyncSnapshot<List<User>> snapshot) {
                      if (snapshot.hasData) {
                        List<User> users = snapshot.data!;
                        List<SearchedFriend> people = [];
                        for (var u in users) {
                          people.add(SearchedFriend(user: u));
                        }
                        return Column(
                          children: people,
                        );
                      }
                      return const Center(
                        child: Text('No Friends! Try to Make Some.'),
                      );
                    })
                : StreamBuilder<List<User>>(
                    stream: filterStream.usersStream,
                    builder: (BuildContext context,
                        AsyncSnapshot<List<User>> snapshot) {
                      if (snapshot.hasData) {
                        List<User> users = snapshot.data!;
                        List<SearchedFriend> people = [];
                        for (var u in users) {
                          people.add(SearchedFriend(user: u));
                        }
                        return Column(
                          children: people,
                        );
                      }
                      return const Center(
                        child: Text('No Friends! Try to Make Some.'),
                      );
                    }),
          )
        ],
      ),
    );
  }
}
