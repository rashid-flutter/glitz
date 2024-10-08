// import 'dart:convert';
// import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:glitz/api/apis.dart';
import 'package:glitz/glitz_ai/screen/ai_screen.dart';
import 'package:glitz/helper/dialogs.dart';
import 'package:glitz/models/chat_user.dart';
import 'package:glitz/profile/screen/profile_screen.dart';
import 'package:glitz/widgets/chat_user_card.dart';
import 'package:lottie/lottie.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ChatUser> list = [];
  final List<ChatUser> _searchList = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    APIs.getSelfInfo();

    //*for updating user active status according to lifecycle events
    //*resume --active or online
    //*pause --inactive or offline
    SystemChannels.lifecycle.setMessageHandler((message) {
      if (APIs.auth.currentUser != null) {
        if (message.toString().contains('resume')) {
          APIs.updateActiveStatus(true);
        }
        if (message.toString().contains('pause')) {
          APIs.updateActiveStatus(false);
        }
      }

      return Future.value(message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      // ignore: deprecated_member_use
      child: WillPopScope(
        //*if search on back button is pressed then close search
        //*or else simple clos curent scren on back button click
        onWillPop: () {
          if (_isSearching) {
            setState(() {
              _isSearching = !_isSearching;
            });
            return Future.value(false);
          } else {
            return Future.value(true);
          }
        },
        child: Scaffold(
            //app bar
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              leading: const CircleAvatar(
                backgroundColor: Colors.transparent,
                backgroundImage: AssetImage('assets/icons/LogoG.png'),
              ),
              //? when search text changes then updated search list
              title: _isSearching
                  ? TextField(
                      onChanged: (val) {
                        //? search logic
                        _searchList.clear();
                        for (var i in list) {
                          if (i.name
                                  .toLowerCase()
                                  .contains(val.toLowerCase()) ||
                              i.email
                                  .toLowerCase()
                                  .contains(val.toLowerCase())) {
                            _searchList.add(i);
                          }
                          setState(() {
                            _searchList;
                          });
                        }
                      },
                      style: const TextStyle(fontSize: 17, letterSpacing: 0.5),
                      autofocus: true,
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Name, Email, ..."),
                    )
                  : const Text(
                      "G L I T Z",
                      style: TextStyle(
                          fontWeight: FontWeight.w900, color: Colors.black),
                    ),
              centerTitle: true,
              actions: [
                //search user button
                IconButton(
                    onPressed: () {
                      setState(() {
                        _isSearching = !_isSearching;
                      });
                    },
                    icon: Icon(_isSearching ? Icons.clear : Icons.search)),

                //more features button

                IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => ProfileScreen(user: APIs.me)));
                    },
                    icon: const Icon(Icons.more_vert)),
              ],
            ),
            // floatingActionButton: Padding(
            //   padding: const EdgeInsets.only(bottom: 10),
            //   child: FloatingActionButton(
            //       backgroundColor: Colors.white,
            //       onPressed: () {
            //         Navigator.push(context,
            //             MaterialPageRoute(builder: (_) => const AiScreen()));
            //       },
            //       child: Lottie.asset('assets/lottie/ai.json', width: 40)),
            // ),
            floatingActionButton: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                    // backgroundColor: Colors.white,
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => const AiScreen()));
                    },
                    child: Lottie.asset(
                      'assets/lottie/ai.json',
                      width: 20,
                    )),
                const SizedBox(height: 10),
                ElevatedButton(
                    // backgroundColor: Colors.white,
                    onPressed: () {
                      _showAddUserDialog();
                    },
                    child: const Icon(
                      Icons.add,
                      color: Colors.blue,
                    )),
              ],
            ),
            body: StreamBuilder(
              stream: APIs.getMyUserId(),
              //?get id for only known users
              builder: (context, snapshort) {
                switch (snapshort.connectionState) {
                  //data is loaded
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return const Center(
                      child: CircularProgressIndicator(),
                    );

                  //if all data is loaded then show it
                  case ConnectionState.active:
                  case ConnectionState.done:
                    return StreamBuilder(
                        stream: APIs.getAllUsers(
                            snapshort.data?.docs.map((e) => e.id).toList() ??
                                []),
                        //? get only those user who's ids are provided
                        builder: (context, snapshot) {
                          switch (snapshot.connectionState) {
                            //data is loaded
                            case ConnectionState.waiting:
                            case ConnectionState.none:
                            // return const Center(
                            //   child: CircularProgressIndicator(),
                            // );

                            //if all data is loaded then show it
                            case ConnectionState.active:
                            case ConnectionState.done:
                              // if (snapshot.hasData) {
                              final data = snapshot.data?.docs;
                              list = data
                                      ?.map((e) => ChatUser.fromJson(e.data()))
                                      .toList() ??
                                  [];
                              if (list.isNotEmpty) {
                                return ListView.builder(
                                  padding: EdgeInsets.only(
                                      top: MediaQuery.of(context).size.height *
                                          .01),
                                  itemBuilder: (context, index) {
                                    return ChatUserCard(
                                      user: _isSearching
                                          ? _searchList[index]
                                          : list[index],
                                    );
                                  },
                                  itemCount: _isSearching
                                      ? _searchList.length
                                      : list.length,
                                );
                              } else {
                                return const Center(
                                    child: Text('No Connections found!'));
                              }
                          }
                        });
                }
              },
            )),
      ),
    );
  }

  //? for adding new chat user
  void _showAddUserDialog() {
    String email = '';

    FocusNode _focusNode = FocusNode();
    showDialog(
        context: context,
        builder: (BuildContext con) => AlertDialog(
              contentPadding: const EdgeInsets.only(
                  left: 24, right: 24, top: 20, bottom: 10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              //* Title
              title: const Row(
                children: [
                  Icon(
                    Icons.person_add,
                    color: Colors.blue,
                    size: 28,
                  ),
                  Text(' Add User')
                ],
              ),
              //*content
              content: TextFormField(
                focusNode: _focusNode,
                onChanged: (value) => email = value,
                maxLines: null,
                decoration: InputDecoration(
                  hintText: 'Email Id',
                  prefixIcon: const Icon(
                    Icons.email,
                    color: Colors.blue,
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15)),
                ),
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    //? Hide alert dialog
                    Navigator.pop(con);
                  },
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.blue, fontSize: 16),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    //? Hide alert dialog
                    Navigator.pop(con);
                    if (email.isNotEmpty) {
                      await APIs.addChatUser(email).then((value) {
                        if (!value) {
                          Dialogs.showSnackBar(
                              context, 'User does not Exists!');
                        }
                      });
                    }
                  },
                  child: const Text(
                    'Add',
                    style: TextStyle(color: Colors.blue, fontSize: 16),
                  ),
                )
              ],
            ));
  }
}
