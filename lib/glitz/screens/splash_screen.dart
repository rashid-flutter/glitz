// import 'package:chat_app/screens/home_screen.dart';
// import 'package:chat_app/screens/home_screen.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:glitz/glitz/screens/login%20Screens/login_screen.dart';
// import 'package:google_sign_in/google_sign_in.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('WELCOME TO G L I T Z'),
        centerTitle: true,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
            color: Colors.white,
            image: DecorationImage(
                image: AssetImage('assets/icons/LogoG.png'),
                fit: BoxFit.contain)),
      ),
      floatingActionButton: TextButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => const LoginScreen()));
          },
          child: const Text(
            'Skip',
            style: TextStyle(fontSize: 15),
          )),
    );
  }
}
