// import 'package:chat_app/main.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:glitz/models/chat_user.dart';
import 'package:glitz/chat/screen/chat_screen.dart';
import 'package:glitz/screens/profile_screen.dart';

//? card to represent a single user in home screen
class ChatUserCard extends StatefulWidget {
  final ChatUser user;
  ChatUserCard({super.key, required this.user});

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  // var user = ChatUser();
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        //? Navigate to chat Screen
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => ChatScreen(
                      user: widget.user,
                    )));
      },
      child: Card(
        borderOnForeground: true,
        color: const Color.fromARGB(255, 236, 224, 224),
        margin: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * .04, vertical: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: ListTile(
          //? user profile image
          leading: ClipRRect(
            borderRadius:
                BorderRadius.circular(MediaQuery.of(context).size.height * .3),
            child: CachedNetworkImage(
              width: MediaQuery.of(context).size.height * .055,
              height: MediaQuery.of(context).size.height * .055,
              imageUrl: widget.user.image.toString(),
              errorWidget: (context, url, error) => const CircleAvatar(
                backgroundImage: AssetImage('assets/icons/Logo.png'),
              ),
            ),
          ),
          //* user name
          title: Text(widget.user.name.toString()),
          //* last massage
          subtitle: Text(widget.user.about.toString()),

          //* last massage time
          trailing: Container(
            width: 15,
            height: 15,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.greenAccent.shade400),
          ),
          // trailing: const Text(
          //   "12:00 AM",
          //   style: TextStyle(color: Colors.black54),
          // ),
        ),
      ),
    );
  }
}
