// import 'dart:convert';
// import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:glitz/api/apis.dart';
import 'package:glitz/auth/firebase_auth.dart';
import 'package:glitz/glitz_ai/screen/ai_screen.dart';
import 'package:glitz/models/chat_user.dart';
import 'package:glitz/profile/screen/profile_screen.dart';
import 'package:glitz/screens/splash_screen.dart';
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
                        if (i.name!.toLowerCase().contains(val.toLowerCase()) ||
                            i.email!
                                .toLowerCase()
                                .contains(val.toLowerCase())) {
                          _searchList.add(i);
                        }
                        setState(() {
                          _searchList;
                        });
                      }
                    },
                    style: TextStyle(fontSize: 17, letterSpacing: 0.5),
                    autofocus: true,
                    decoration: InputDecoration(
                        border: InputBorder.none, hintText: "Name, Email, ..."),
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
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: FloatingActionButton(
                backgroundColor: Colors.white,
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const AiScreen()));
                },
                child: Lottie.asset('assets/lottie/ai.json', width: 40)),
          ),

          body: StreamBuilder(
              stream: APIs.getAllUsers(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  //data is loaded
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return const Center(
                      child: CircularProgressIndicator(),
                    );

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
                            top: MediaQuery.of(context).size.height * .01),
                        itemBuilder: (context, index) {
                          return ChatUserCard(
                            user:
                                _isSearching ? _searchList[index] : list[index],
                          );
                        },
                        itemCount:
                            _isSearching ? _searchList.length : list.length,
                      );
                    } else {
                      return const Center(child: Text('No Connections found!'));
                    }
                }
              }),
        ),
      ),
    );
  }
}
