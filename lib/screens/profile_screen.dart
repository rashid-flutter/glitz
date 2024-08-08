import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:glitz/api/apis.dart';
import 'package:glitz/auth/firebase_auth.dart';
import 'package:glitz/helper/dialogs.dart';
import 'package:glitz/models/chat_user.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  final ChatUser user;
  ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final formKy = GlobalKey<FormState>();
  String? _image;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Profile Screen'),
          centerTitle: true,
        ),
        body: Form(
          key: formKy,
          child: Padding(
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
                  Stack(
                    children: [
                      _image != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(
                                  MediaQuery.of(context).size.height * .3),
                              child: Image.file(
                                width: MediaQuery.of(context).size.height * .2,
                                height: MediaQuery.of(context).size.height * .2,
                                File(_image!),
                                fit: BoxFit.cover,
                              ),
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(
                                  MediaQuery.of(context).size.height * .3),
                              child: CachedNetworkImage(
                                width: MediaQuery.of(context).size.height * .2,
                                height: MediaQuery.of(context).size.height * .2,
                                fit: BoxFit.cover,
                                imageUrl: widget.user.image.toString(),
                                errorWidget: (context, url, error) =>
                                    const CircleAvatar(
                                  backgroundImage:
                                      AssetImage('assets/icons/Logo.png'),
                                ),
                              ),
                            ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: MaterialButton(
                          onPressed: () {
                            showBottomSheet();
                          },
                          shape: const CircleBorder(),
                          color: Colors.white,
                          child: const Icon(Icons.edit),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * .03),
                  //? user email lable
                  Text(
                    widget.user.email.toString(),
                    style: const TextStyle(color: Colors.black54, fontSize: 16),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * .03),

                  //? name input field
                  TextFormField(
                    initialValue: widget.user.name,
                    onSaved: (val) => APIs.me.name = val ?? '',
                    validator: (value) => value != null && value.isNotEmpty
                        ? null
                        : 'Required Field',
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                        prefixIcon: const Icon(
                          Icons.person,
                          color: Colors.blue,
                        ),
                        hintText: "'eg. Happy Singh",
                        label: const Text("Name")),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * .03),

                  //? about input field
                  TextFormField(
                    initialValue: widget.user.about,
                    onSaved: (val) => APIs.me.about = val ?? '',
                    validator: (value) => value != null && value.isNotEmpty
                        ? null
                        : 'Required Field',
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                        prefixIcon: const Icon(
                          Icons.info_outline,
                          color: Colors.blue,
                        ),
                        hintText: "'eg. Feeling Happy",
                        label: const Text("About")),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * .05),

                  //?update profile button
                  TextButton.icon(
                    style: ElevatedButton.styleFrom(
                        shape: const StadiumBorder(),
                        minimumSize: Size(
                            MediaQuery.of(context).size.width * .4,
                            MediaQuery.of(context).size.height * .055)),
                    onPressed: () {
                      if (formKy.currentState!.validate()) {
                        formKy.currentState!.save();
                        APIs.updateUserInfo().then((value) {
                          Dialogs.showSnackBar(
                              context, "Profile Updated Successfully");
                        });
                        Navigator.of(context).pop();

                        log('Inside Validator');
                      }
                    },
                    icon: const Icon(
                      Icons.edit,
                      size: 30,
                    ),
                    label: const Text(
                      "UPDATE",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  TextButton.icon(
                    style: ElevatedButton.styleFrom(
                        shape: const StadiumBorder(),
                        minimumSize: Size(
                            MediaQuery.of(context).size.width * .4,
                            MediaQuery.of(context).size.height * .055)),
                    onPressed: () {
                      Navigator.of(context).pop();
                      log('Inside Validator');
                    },
                    icon: const Icon(
                      Icons.cancel_rounded,
                      size: 30,
                    ),
                    label: const Text(
                      "Cancel",
                      style: TextStyle(fontSize: 16),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: FloatingActionButton.extended(
            backgroundColor: Colors.red,
            onPressed: () async {
              Dialogs.showProgressBar(context);
              FirebaseAuths.signOut(context);
            },
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
            label: const Text(
              "Logout",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  void showBottomSheet() {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (_) {
          return ListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * .02,
                bottom: MediaQuery.of(context).size.height * .05),
            children: [
              const Text(
                'Pick Profile Picture',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * .02),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  //? image pick in gallery
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          fixedSize: Size(
                              MediaQuery.of(context).size.width * .3,
                              MediaQuery.of(context).size.height * .15)),
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
                        //pick an image
                        final XFile? image =
                            await picker.pickImage(source: ImageSource.gallery);
                        if (image != null) {
                          log('Image path:${image.path}-- MimeType${image.mimeType}');
                          setState(() {
                            _image = image.path;
                          });
                        }
                        APIs.updateProfilePicture(File(_image!));

                        Navigator.of(context).pop();
                      },
                      child: Image.asset('assets/images/iconimage.png')),
                  //?image pick in camera
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          fixedSize: Size(
                              MediaQuery.of(context).size.width * .3,
                              MediaQuery.of(context).size.height * .15)),
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
                        //pick an image
                        final XFile? image =
                            await picker.pickImage(source: ImageSource.camera);
                        if (image != null) {
                          log('Image path:${image.path}');
                          setState(() {
                            _image = image.path;
                          });
                        }
                        APIs.updateProfilePicture(File(_image!));
                        Navigator.of(context).pop();
                      },
                      child: Image.asset('assets/images/iconcamera.png'))
                ],
              )
            ],
          );
        });
  }
}
