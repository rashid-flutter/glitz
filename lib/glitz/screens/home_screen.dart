// import 'dart:convert';
// import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:glitz/glitz/api/apis.dart';
import 'package:glitz/glitz/models/chat_user.dart';
import 'package:glitz/glitz/widgets/chat_user_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ChatUser> list = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //app bar
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: const CircleAvatar(
          backgroundColor: Colors.transparent,
          backgroundImage: AssetImage('assets/icons/LogoG.png'),
        ),
        title: const Text(
          "G L I T Z",
          style: TextStyle(fontWeight: FontWeight.w900, color: Colors.black),
        ),
        centerTitle: true,
        actions: [
          //search user button
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),

          //more features button
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: FloatingActionButton(
          onPressed: () {},
          child: const Icon(Icons.add_comment_rounded),
        ),
      ),
      body: StreamBuilder(
          stream: APIs.firestore.collection('Rashi').snapshots(),
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
                list = data?.map((e) => ChatUser.fromJson(e.data())).toList() ??
                    [];
                if (list.isNotEmpty) {
                  return ListView.builder(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * .01),
                    itemBuilder: (context, index) {
                      return ChatUserCard(
                        user: list[index],
                      );
                    },
                    itemCount: list.length,
                  );
                } else {
                  return const Center(child: Text('No Connections found!'));
                }
            }
          }),
    );
  }
}
