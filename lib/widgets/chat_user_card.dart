// import 'package:chat_app/main.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:glitz/api/apis.dart';
import 'package:glitz/chat/model/message.dart';
import 'package:glitz/helper/my_date_util.dart';
import 'package:glitz/models/chat_user.dart';
import 'package:glitz/chat/screen/chat_screen.dart';
import 'package:glitz/profile/widget/profile_dialog.dart';

//? card to represent a single user in home screen
class ChatUserCard extends StatefulWidget {
  final ChatUser user;
  ChatUserCard({super.key, required this.user});

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  // var user = ChatUser();
  Message? message;
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
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: StreamBuilder(
            stream: APIs.getLastMessages(widget.user),
            builder: (context, snapshort) {
              final data = snapshort.data?.docs;
              final list =
                  data?.map((e) => Message.fromJson(e.data())).toList() ?? [];
              if (list.isNotEmpty) {
                message = list[0];
              }
              return ListTile(
                //? user profile image
                leading: InkWell(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (_) => ProfileDialog(user: widget.user));
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                        MediaQuery.of(context).size.height * .3),
                    child: CachedNetworkImage(
                      width: MediaQuery.of(context).size.height * .055,
                      height: MediaQuery.of(context).size.height * .055,
                      imageUrl: widget.user.image.toString(),
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) => const CircleAvatar(
                        backgroundImage: AssetImage('assets/icons/Logo.png'),
                      ),
                    ),
                  ),
                ),
                //* user name
                title: Text(widget.user.name.toString()),
                //* last massage
                subtitle: Text(message != null
                    ? message!.type == Type.image
                        ? 'image'
                        : message!.msg
                    : widget.user.about.toString()),

                //* last massage time
                trailing: message == null
                    ? null //*show nothing when no message is sent
                    : message!.read.isEmpty && message!.formId != APIs.user.uid
                        ? //* show for unread Message
                        Container(
                            width: 15,
                            height: 15,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.greenAccent.shade400),
                          )
                        :
                        //*message sent time
                        Text(
                            MyDateUtil.lastMessageTime(
                                con: context, time: message!.sent),
                            style: const TextStyle(color: Colors.black54),
                          ),
                // trailing: const Text(
                //   "12:00 AM",
                //   style: TextStyle(color: Colors.black54),
                // ),
              );
            },
          )),
    );
  }
}
