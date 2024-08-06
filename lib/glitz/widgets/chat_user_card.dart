// import 'package:chat_app/main.dart';
import 'package:flutter/material.dart';
import 'package:glitz/glitz/models/chat_user.dart';

class ChatUserCard extends StatefulWidget {
  final ChatUser user;
  const ChatUserCard({super.key, required this.user});

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  var user = ChatUser();
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Card(
        color: Colors.transparent,
        margin: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * .04, vertical: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: ListTile(
          title: Text(widget.user.name.toString()),
          subtitle: Text(widget.user.about.toString()),
          leading: CircleAvatar(
            backgroundColor: Colors.transparent,
            backgroundImage: AssetImage(user.image.toString()),
          ),
          trailing: const Text(
            "12:00 AM",
            style: TextStyle(color: Colors.black54),
          ),
        ),
      ),
    );
  }
}
