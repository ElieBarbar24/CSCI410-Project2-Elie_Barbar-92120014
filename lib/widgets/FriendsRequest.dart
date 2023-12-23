import 'package:connect/Models/User.dart';
import 'package:connect/Querys/UserAction.dart';
import 'package:flutter/material.dart';

class FriendsRequests extends StatelessWidget {
  final User user;
  const FriendsRequests({super.key, required this.user});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: SizedBox(
        height: 65,
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(35),
            child: Image.network(
              'https://eliebarbar.000webhostapp.com/profileImages/${user.photo}',
              height: 65,
              width: 65,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Friend Name
                Text(
                  user.name,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Color(0xFF113953),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  user.status!,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                )
              ],
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Container(
                child: InkWell(
              onTap: () async{
                await acceptFriendRequest(user.id!);
              },
              child: Container(
                  height: 45,
                  width: 45,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color(0xFF113953),
                    borderRadius: BorderRadius.circular(25),
                  ),
                      child: const Icon(
                        Icons.done,
                        color: Colors.white,
                      )),
            )),
          ),
        ]),
      ),
    );
  }
}
