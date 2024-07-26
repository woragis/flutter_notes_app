// ignore_for_file: avoid_print, use_super_parameters, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:my_notes/views/home_view.dart';
import 'package:my_notes/views/login_view.dart';
import "package:my_notes/views/register_view.dart";
import 'package:my_notes/views/verify_email_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
      initialRoute: "/",
      routes: {
        "/login": (context) => const LoginView(),
        "/register": (context) => const RegisterView(),
        "/verify-email": (context) => const VerifyEmailView(),
      },
      home: const HomeView()));
}

class Main extends StatefulWidget {
  const Main({Key? key}) : super(key: key);

  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
      ),
      body: FutureBuilder(
          future: Firebase.initializeApp(
              // options: DefaultFirebaseOptions.currentPlataform;
              ),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case (ConnectionState.done):
                final user = FirebaseAuth.instance.currentUser;
                if (user?.emailVerified ?? false) {
                  print("You are verified");
                } else {
                  print("You need to verify your email");
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      "/verify-email", (route) => false);
                }
                return const Text("Done");
              default:
                return const Text("Loading...");
            }
          }),
    );
  }
}
