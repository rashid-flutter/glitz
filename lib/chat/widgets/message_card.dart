import 'package:flutter/material.dart';
import 'package:glitz/api/apis.dart';
import 'package:glitz/chat/model/message.dart';
import 'package:glitz/chat/widgets/message_chat_wigets.dart';

class MessageCard extends StatefulWidget {
  final Message message;
  const MessageCard({super.key, required this.message});

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    bool isMe = APIs.user.uid == widget.message.formId;
    return InkWell(
      onLongPress: () {
        ChatWigets.showBottomSheet(context, widget.message, isMe);
      },
      child: isMe
          ? ChatWigets.greenMessage(context, widget.message)
          : ChatWigets.blueMessage(widget.message, context),
    );
  }
}
