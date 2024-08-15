import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:glitz/api/apis.dart';
import 'package:glitz/chat/model/message.dart';
import 'package:glitz/helper/dialogs.dart';
import 'package:glitz/helper/my_date_util.dart';

class ChatWigets {
//?bottom sheet for modifying messsage ditails

  static void showBottomSheet(
      BuildContext context, Message message, bool isMe) {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (_) {
          return ListView(
            shrinkWrap: true,
            children: [
              //*black divaider
              Container(
                height: 4,
                margin: EdgeInsets.symmetric(
                    vertical: MediaQuery.of(context).size.height * .015,
                    horizontal: MediaQuery.of(context).size.width * .4),
                decoration: BoxDecoration(
                    color: Colors.grey, borderRadius: BorderRadius.circular(8)),
              ),
              //? copy option
              message.type == Type.text
                  ? _OptionItem(
                      icon: const Icon(
                        Icons.copy_all_rounded,
                        color: Colors.blue,
                        size: 26,
                      ),
                      nmae: 'Copy Text',
                      onTap: () async {
                        await Clipboard.setData(
                                ClipboardData(text: message.msg))
                            .then((value) {
                          //?for hiding bottom sheet
                          Navigator.pop(context);

                          Dialogs.showSnackBar(context, 'Text Copied!');
                        });
                      },
                    )
                  : _OptionItem(
                      icon: const Icon(
                        Icons.download_rounded,
                        color: Colors.blue,
                        size: 26,
                      ),
                      nmae: 'Save Image',
                      onTap: () {},
                    ),
              //?;/separator
              Divider(
                color: Colors.black54,
                endIndent: MediaQuery.of(context).size.width * .04,
                indent: MediaQuery.of(context).size.height * .04,
              ),
              //? edit option
              if (message.type == Type.text && isMe)
                _OptionItem(
                  icon: const Icon(
                    Icons.edit,
                    color: Colors.blue,
                    size: 26,
                  ),
                  nmae: 'Edit Message',
                  onTap: () {},
                ),
              if (isMe)
                _OptionItem(
                  icon: const Icon(
                    Icons.delete_forever,
                    color: Colors.red,
                    size: 26,
                  ),
                  nmae: 'Delete Message',
                  onTap: () {
                    APIs.deleteMessage(message).then((value) {
                      //* for hiding bottom sheet
                      Navigator.pop(context);
                    });
                  },
                ),
              //?;/separator
              if (isMe)
                Divider(
                  color: Colors.black54,
                  endIndent: MediaQuery.of(context).size.width * .04,
                  indent: MediaQuery.of(context).size.height * .04,
                ),
              //?sent time
              _OptionItem(
                icon: const Icon(
                  Icons.remove_red_eye,
                  color: Colors.blue,
                ),
                nmae:
                    'Sent AT: ${MyDateUtil.getMessageTime(context: context, time: message.sent)}',
                onTap: () {},
              ),

              //? read time
              _OptionItem(
                icon: const Icon(
                  Icons.remove_red_eye,
                  color: Colors.green,
                ),
                nmae: message.read.isEmpty
                    ? 'Read At: Not seen yet'
                    : 'Read AT: ${MyDateUtil.getFormattedTime(context, message.read)}',
                onTap: () {},
              ),
            ],
          );
        });
  }

//? blue messages or
  static Widget blueMessage(Message message, BuildContext context) {
    //?update last read message if sender and receiver are different
    if (message.read.isEmpty) {
      APIs.updateMessageReadStatus(message);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Container(
            padding: EdgeInsets.all(message.type == Type.image
                ? MediaQuery.of(context).size.width * .03
                : MediaQuery.of(context).size.width * .04),
            margin: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * .04,
                vertical: MediaQuery.of(context).size.height * .01),
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 221, 245, 255),
                border: Border.all(color: Colors.lightBlue),
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                    bottomRight: Radius.circular(30))),
            child: message.type == Type.text
                ? Text(
                    message.msg,
                    style: const TextStyle(fontSize: 15, color: Colors.black87),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: CachedNetworkImage(
                        // fit: BoxFit.cover,
                        placeholder: (context, url) => const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            ),
                        imageUrl: message.msg.toString(),
                        errorWidget: (context, url, error) => const Icon(
                              Icons.image,
                              size: 70,
                            )),
                  ),
          ),
        ),
        Padding(
          padding:
              EdgeInsets.only(right: MediaQuery.of(context).size.width * .04),
          child: Text(
            MyDateUtil.getFormattedTime(context, message.sent),
            style: const TextStyle(fontSize: 13, color: Colors.black87),
          ),
        )
      ],
    );
  }

//? green messages or
  static Widget greenMessage(BuildContext context, Message message) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * .04,
            ),
            if (message.read.isNotEmpty)
              const Icon(
                Icons.done_all_rounded,
                color: Colors.blue,
                size: 20,
              ),
            const SizedBox(
              width: 2,
            ),
            Text(
              MyDateUtil.getFormattedTime(context, message.sent),
              style: const TextStyle(fontSize: 13, color: Colors.black87),
            ),
          ],
        ),
        //? message content
        Flexible(
          child: Container(
            padding: EdgeInsets.all(message.type == Type.image
                ? MediaQuery.of(context).size.width * .03
                : MediaQuery.of(context).size.width * .04),
            margin: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * .04,
                vertical: MediaQuery.of(context).size.height * .01),
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 218, 255, 176),
                border: Border.all(color: Colors.lightGreen),
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30))),
            child: message.type == Type.text
                ? Text(
                    message.msg,
                    style: const TextStyle(fontSize: 15, color: Colors.black87),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: CachedNetworkImage(
                        // fit: BoxFit.cover,
                        placeholder: (context, url) => const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            ),
                        imageUrl: message.msg.toString(),
                        errorWidget: (context, url, error) => const Icon(
                              Icons.image,
                              size: 70,
                            )),
                  ),
          ),
        ),
      ],
    );
  }
}

class _OptionItem extends StatelessWidget {
  final Icon icon;
  final String nmae;
  final VoidCallback onTap;
  const _OptionItem(
      {required this.icon, required this.nmae, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap();
      },
      child: Padding(
        padding: EdgeInsets.only(
            left: MediaQuery.of(context).size.width * .05,
            top: MediaQuery.of(context).size.height * .015,
            bottom: MediaQuery.of(context).size.height * .015),
        child: Row(
          children: [
            icon,
            Flexible(
                child: Text(
              '     $nmae',
              style: const TextStyle(
                  fontSize: 15, color: Colors.black54, letterSpacing: 0.5),
            ))
          ],
        ),
      ),
    );
  }
}
