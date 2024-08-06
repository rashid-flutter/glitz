// import 'dart:math';

// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:glitz/glitz/api/apis.dart';
import 'package:glitz/glitz/auth/firebase_auth.dart';
import 'package:glitz/glitz/helper/dialogs.dart';
import 'package:glitz/glitz/screens/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _handleGooglebtnClick();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Login Screen'),
          centerTitle: true,
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
              color: Colors.transparent,
              image: DecorationImage(
                  image: AssetImage('assets/icons/LogoG.png'),
                  fit: BoxFit.contain)),
        ),
        floatingActionButton: Padding(
            padding: const EdgeInsets.only(
              left: 35,
            ),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 50,
              decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 218, 218, 218),
                  borderRadius: BorderRadius.circular(20.0),
                  border: Border.all(color: Colors.black, width: 0.5)),
              clipBehavior: Clip.antiAlias,
              child: ElevatedButton(
                  onPressed: () {
                    FirebaseAuths.signWithGoogle(context).then((user) async {
                      // print('user${user.user}');
                      if (user != null) {
                        if (await APIs.userExists()) {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const HomeScreen()));
                        } else {
                          await APIs.createUser().then((value) {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const HomeScreen()));
                          });
                        }

                        Dialogs.showSnackBar(context, 'Succesfully Sign-In');
                      }
                    });
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.transparent,
                        backgroundImage: AssetImage("assets/images/Google.png"),
                      ),
                      Text(
                        ' Login With Google',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      )
                    ],
                  )),
            )));
  }
}
