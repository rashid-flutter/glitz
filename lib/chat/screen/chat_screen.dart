import 'dart:convert';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:glitz/api/apis.dart';
import 'package:glitz/models/chat_user.dart';
import 'package:glitz/chat/model/message.dart';
import 'package:glitz/chat/widgets/message_card.dart';

class ChatScreen extends StatefulWidget {
  final ChatUser user;
  const ChatScreen({super.key, required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<Message> list = [];
  final _textCon = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 234, 248, 255),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          flexibleSpace: appBar(),
          elevation: 10,
        ),
        body: Column(
          children: [
            // chatInput(),
            Expanded(
              child: StreamBuilder(
                  stream: APIs.getAllMessages(widget.user),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      //data is loaded
                      case ConnectionState.waiting:
                      case ConnectionState.none:
                        return const SizedBox();

                      //if all data is loaded then show it
                      case ConnectionState.active:
                      case ConnectionState.done:
                        final data = snapshot.data?.docs;
                        // log('Data: ${jsonEncode(data![0].data())}');
                        list = data
                                ?.map((e) => Message.fromJson(e.data()))
                                .toList() ??
                            [];
                        // final list = ['Hi', 'Hello'];

                        if (list.isNotEmpty) {
                          return ListView.builder(
                            padding: EdgeInsets.only(
                                top: MediaQuery.of(context).size.height * .01),
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              return MessageCard(
                                message: list[index],
                              );
                            },
                            itemCount: list.length,
                          );
                        } else {
                          return const Center(
                              child: Text(
                            'Say Hii! 👋',
                            style: TextStyle(fontSize: 20),
                          ));
                        }
                    }
                  }),
            ),
            chatInput()
          ],
        ),
      ),
    );
  }

  Widget appBar() {
    return InkWell(
      onTap: () {},
      child: Row(
        children: [
          IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.black87,
              )),
          ClipRRect(
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
          const SizedBox(
            width: 10,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.user.name.toString(),
                style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                    fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 2,
              ),
              const Text(
                "Last seen not available",
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.black54,
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget chatInput() {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height * .01,
          horizontal: MediaQuery.of(context).size.width * .01),
      child: Row(
        children: [
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: Row(
                children: [
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.emoji_emotions,
                        color: Colors.blueAccent,
                        size: 25,
                      )),
                  Expanded(
                      child: TextField(
                    controller: _textCon,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: const InputDecoration(
                        hintText: "Type Somethings...",
                        hintStyle: TextStyle(color: Colors.blueAccent),
                        border: InputBorder.none),
                  )),
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.image,
                        color: Colors.blueAccent,
                        size: 26,
                      )),
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.camera_alt_rounded,
                        color: Colors.blueAccent,
                        size: 26,
                      )),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * .02,
                  )
                ],
              ),
            ),
          ),
          //* sent message button
          MaterialButton(
            onPressed: () {
              if (_textCon.text.isNotEmpty) {
                APIs.sendMessage(widget.user, _textCon.text);
                _textCon.text = '';
              }
            },
            padding:
                const EdgeInsets.only(top: 10, bottom: 10, right: 5, left: 10),
            shape: const CircleBorder(),
            color: Colors.green,
            child: const Icon(
              Icons.send,
              color: Colors.white,
              size: 26,
            ),
          )
        ],
      ),
    );
  }
}