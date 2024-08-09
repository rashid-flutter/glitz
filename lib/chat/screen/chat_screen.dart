import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:glitz/api/apis.dart';
import 'package:glitz/helper/my_date_util.dart';
import 'package:glitz/models/chat_user.dart';
import 'package:glitz/chat/model/message.dart';
import 'package:glitz/chat/widgets/message_card.dart';
import 'package:image_picker/image_picker.dart';

class ChatScreen extends StatefulWidget {
  final ChatUser user;
  const ChatScreen({super.key, required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<Message> list = [];
  final _textCon = TextEditingController();
  bool showEmogi = false, isUploading = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: SafeArea(
        // ignore: deprecated_member_use
        child: WillPopScope(
          onWillPop: () {
            if (showEmogi) {
              setState(() {
                showEmogi = !showEmogi;
              });
              return Future.value(false);
            } else {
              return Future.value(true);
            }
          },
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
                                reverse: true,
                                padding: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.height *
                                        .01),
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
                if (isUploading)
                  const Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )),
                chatInput(),
                if (showEmogi)
                  SizedBox(
                    height: MediaQuery.of(context).size.height * .35,
                    child: EmojiPicker(
                        textEditingController: _textCon,
                        config: Config(
                          // height: 256,

                          checkPlatformCompatibility: true,

                          emojiViewConfig: EmojiViewConfig(
                            columns: 8,
                            backgroundColor:
                                const Color.fromARGB(255, 234, 248, 255),
                            emojiSizeMax: 32 * (Platform.isIOS ? 1.20 : 1.0),
                          ),
                        )),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget appBar() {
    return InkWell(
        onTap: () {},
        child: StreamBuilder(
          stream: APIs.getUserInfo(widget.user),
          builder: (context, snapshot) {
            final data = snapshot.data?.docs;
            final list =
                data?.map((e) => ChatUser.fromJson(e.data())).toList() ?? [];

            return Row(
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
                  borderRadius: BorderRadius.circular(
                      MediaQuery.of(context).size.height * .3),
                  child: CachedNetworkImage(
                    width: MediaQuery.of(context).size.height * .055,
                    height: MediaQuery.of(context).size.height * .055,
                    imageUrl: list.isNotEmpty
                        ? list[0].image
                        : widget.user.image.toString(),
                    fit: BoxFit.cover,
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
                    Text(
                      list.isNotEmpty
                          ? list[0].isOnline
                              ? 'Online'
                              : MyDateUtil.getLastActiveTime(
                                  context: context,
                                  lastActive: list[0].lastActive)
                          : MyDateUtil.getLastActiveTime(
                              context: context,
                              lastActive: widget.user.lastActive),
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.black54,
                      ),
                    )
                  ],
                )
              ],
            );
          },
        ));
  }

  //?emoji
  emoji() {
    if (showEmogi) {
      SizedBox(
        height: MediaQuery.of(context).size.height * .35,
        child: EmojiPicker(
            textEditingController: _textCon,
            config: Config(
              // height: 256,

              checkPlatformCompatibility: true,

              emojiViewConfig: EmojiViewConfig(
                columns: 8,
                backgroundColor: const Color.fromARGB(255, 234, 248, 255),
                emojiSizeMax: 32 * (Platform.isIOS ? 1.20 : 1.0),
              ),
            )),
      );
    }
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
                      onPressed: () {
                        FocusScope.of(context).unfocus();

                        setState(() => showEmogi = !showEmogi);
                        emoji();
                      },
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
                    onTap: () {
                      if (showEmogi) {
                        setState(() {
                          showEmogi = !showEmogi;
                        });
                      }
                    },
                    decoration: const InputDecoration(
                        hintText: "Type Somethings...",
                        hintStyle: TextStyle(color: Colors.blueAccent),
                        border: InputBorder.none),
                  )),
                  //?pick image from gallery button
                  IconButton(
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
                        //picking amultiple image
                        final List<XFile> images = await picker.pickMultiImage(
                          imageQuality: 70,
                        );
                        //?uploading and  sending image one by one
                        for (var i in images) {
                          log('Image path:${i.path}');
                          setState(() => isUploading = true);

                          await APIs.sendChatImage(widget.user, File(i.path));
                          setState(() => isUploading = false);
                        }
                      },
                      icon: const Icon(
                        Icons.image,
                        color: Colors.blueAccent,
                        size: 26,
                      )),
                  //?Take image from camera button
                  IconButton(
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
                        //pick an image
                        final XFile? image = await picker.pickImage(
                            source: ImageSource.camera, imageQuality: 70);
                        if (image != null) {
                          log('Image path:${image.path}');
                          setState(() => isUploading = true);

                          await APIs.sendChatImage(
                              widget.user, File(image.path));
                          setState(() => isUploading = false);
                        }

                        // Navigator.of(context).pop();
                      },
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
                APIs.sendMessage(widget.user, _textCon.text, Type.text);
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
