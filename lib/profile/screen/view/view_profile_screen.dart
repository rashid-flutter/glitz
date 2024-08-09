import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:glitz/helper/my_date_util.dart';
import 'package:glitz/models/chat_user.dart';

class ViewProfileScreen extends StatefulWidget {
  final ChatUser user;
  const ViewProfileScreen({super.key, required this.user});

  @override
  State<ViewProfileScreen> createState() => _ViewProfileScreenState();
}

class _ViewProfileScreenState extends State<ViewProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.user.name),
          centerTitle: true,
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * .05),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * .03,
                ),
                //? user profile image
                ClipRRect(
                  borderRadius: BorderRadius.circular(
                      MediaQuery.of(context).size.height * .3),
                  child: CachedNetworkImage(
                    width: MediaQuery.of(context).size.height * .2,
                    height: MediaQuery.of(context).size.height * .2,
                    fit: BoxFit.cover,
                    imageUrl: widget.user.image.toString(),
                    errorWidget: (context, url, error) => const CircleAvatar(
                      backgroundImage: AssetImage('assets/icons/Logo.png'),
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * .03),
                //? user email lable
                Text(
                  widget.user.email.toString(),
                  style: const TextStyle(color: Colors.black54, fontSize: 16),
                ),

                SizedBox(height: MediaQuery.of(context).size.height * .02),
                //?user about
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'About: ',
                      style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                          fontSize: 16),
                    ),
                    Text(
                      widget.user.about.toString(),
                      style:
                          const TextStyle(color: Colors.black54, fontSize: 16),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Joind On: ',
              style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                  fontSize: 15),
            ),
            Text(
              MyDateUtil.lastMessageTime(
                  con: context, time: widget.user.createdAt, showYear: true),
              style: const TextStyle(color: Colors.black54, fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }
}
