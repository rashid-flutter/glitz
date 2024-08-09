import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:glitz/models/chat_user.dart';
import 'package:glitz/profile/screen/view/view_profile_screen.dart';

class ProfileDialog extends StatelessWidget {
  const ProfileDialog({super.key, required this.user});
  final ChatUser user;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      backgroundColor: Colors.white.withOpacity(.9),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * .6,
        height: MediaQuery.of(context).size.height * .35,
        child: Stack(
          children: [
            //?user profile picture
            Positioned(
              left: MediaQuery.of(context).size.width * .15,
              top: MediaQuery.of(context).size.height * .075,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(
                    MediaQuery.of(context).size.height * .3),
                child: CachedNetworkImage(
                  width: MediaQuery.of(context).size.height * .2,
                  height: MediaQuery.of(context).size.height * .2,
                  fit: BoxFit.fill,
                  imageUrl: user.image.toString(),
                  errorWidget: (context, url, error) => const CircleAvatar(
                    backgroundImage: AssetImage('assets/icons/Logo.png'),
                  ),
                ),
              ),
            ),
            //?user name
            Positioned(
              left: MediaQuery.of(context).size.width * .04,
              top: MediaQuery.of(context).size.height * .02,
              width: MediaQuery.of(context).size.width * .55,
              child: Text(
                user.name,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
              ),
            ),
            //?info button
            Positioned(
                right: 8,
                top: 6,
                child: MaterialButton(
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(0),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => ViewProfileScreen(user: user)));
                  },
                  child: const Icon(
                    Icons.info_outline,
                    color: Colors.blue,
                    size: 30,
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
